package com.example.ttltw_project.dao.user;

import com.example.ttltw_project.model.user.CartItem;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Optional;

public class CartDAO {
    private static final Jdbi jdbi = DBDAO.get();

    public List<CartItem> getCartByUserId(int userId) {
        String sql = "SELECT " +
                "cd.id AS detailId, " +
                "cd.variant_id AS variantId, " +
                "p.id AS productId, " +
                "p.product_name AS productName, " +
                "v.variant_code AS code, " +
                "v.color, v.size, " +
                "v.image_url AS imageUrl, " +
                "v.price, " +
                "cd.quantity AS quantity, " +
                "IFNULL(i.stock_quantity, 0) AS stock, " +
                "GREATEST(COALESCE(d1.discount_percent, 0), COALESCE(d2.discount_percent, 0)) AS discountPercent " +
                "FROM cart_details cd " +
                "JOIN product_variants v ON cd.variant_id = v.id " +
                "JOIN products p ON v.product_id = p.id " +
                "LEFT JOIN inventories i ON v.id = i.variant_id " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN product_types t ON p.product_type_id = t.id " +
                "LEFT JOIN discount_categories dc ON c.id = dc.category_id " +
                "LEFT JOIN discounts d1 ON dc.discount_id = d1.id AND (NOW() BETWEEN d1.start_date AND d1.end_date) " +
                "LEFT JOIN discount_product_types dt ON t.id = dt.product_type_id " +
                "LEFT JOIN discounts d2 ON dt.discount_id = d2.id AND (NOW() BETWEEN d2.start_date AND d2.end_date) " +
                "WHERE cd.cart_id = (SELECT id FROM carts WHERE user_id = ?)";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .mapToBean(CartItem.class)
                        .list()
        );
    }
    
    public String addToCart(int userId, int variantId, int quantityToAdd) {
        return jdbi.inTransaction(handle -> {
            Optional<Integer> stockOpt = handle.createQuery("SELECT stock_quantity FROM inventories WHERE variant_id = :vid")
                    .bind("vid", variantId)
                    .mapTo(Integer.class)
                    .findOne();

            if (stockOpt.isEmpty()) {
                System.out.println("Lỗi: variant_id " + variantId + " không tồn tại trong bảng inventories");
                return "Sản phẩm này hiện chưa có thông tin kho hàng!";
            }

            int currentStock = stockOpt.get();

            Integer cartId = handle.createQuery("SELECT id FROM carts WHERE user_id = :uid")
                    .bind("uid", userId)
                    .mapTo(Integer.class)
                    .findOne()
                    .orElseGet(() -> handle.createUpdate("INSERT INTO carts(user_id) VALUES(:uid)")
                            .bind("uid", userId)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class).one());

            Integer qtyInCart = handle.createQuery("SELECT quantity FROM cart_details WHERE cart_id = :cid AND variant_id = :vid")
                    .bind("cid", cartId)
                    .bind("vid", variantId)
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(0);

            if ((qtyInCart + quantityToAdd) > currentStock) {
                return "Rất tiếc, kho chỉ còn " + currentStock + " sản phẩm. Giỏ hàng đã có " + qtyInCart;
            }

            if (qtyInCart > 0) {
                handle.createUpdate("UPDATE cart_details SET quantity = quantity + :q WHERE cart_id = :cid AND variant_id = :vid")
                        .bind("q", quantityToAdd).bind("cid", cartId).bind("vid", variantId).execute();
            } else {
                handle.createUpdate("INSERT INTO cart_details(cart_id, variant_id, quantity) VALUES(:cid, :vid, :q)")
                        .bind("cid", cartId).bind("vid", variantId).bind("q", quantityToAdd).execute();
            }
            return "Success";
        });
    }

    public String updateQuantity(int userId, int variantId, int newQuantity) {
        return jdbi.inTransaction(handle -> {
            try {
                if (newQuantity <= 0) {
                    removeItem(userId, variantId);
                    return "Success";
                }

                Integer currentStock = handle.createQuery("SELECT stock_quantity FROM inventories WHERE variant_id = ?")
                        .bind(0, variantId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(-1);

                if (currentStock == -1) return "Sản phẩm này chưa được nhập kho!";
                if (currentStock == 0) return "Sản phẩm hiện đang hết hàng!";

                if (newQuantity > currentStock) {
                    return "Kho chỉ còn " + currentStock + " sản phẩm!";
                }

                String sqlFindCart = "SELECT id FROM carts WHERE user_id = ?";
                Optional<Integer> cartIdOpt = handle.createQuery(sqlFindCart)
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .findOne();

                if (cartIdOpt.isEmpty()) return "Giỏ hàng không tồn tại!";
                int cartId = cartIdOpt.get();

                int rows = handle.createUpdate("UPDATE cart_details SET quantity = ? WHERE cart_id = ? AND variant_id = ?")
                        .bind(0, newQuantity)
                        .bind(1, cartId)
                        .bind(2, variantId)
                        .execute();

                return rows > 0 ? "Success" : "Lỗi cập nhật";
            } catch (Exception e) {
                e.printStackTrace();
                return "Lỗi hệ thống: " + e.getMessage();
            }
        });
    }

    public boolean removeItem(int userId, int variantId) {
        return jdbi.withHandle(handle -> {
            Optional<Integer> cartIdOpt = handle.createQuery("SELECT id FROM carts WHERE user_id = ?")
                    .bind(0, userId)
                    .mapTo(Integer.class)
                    .findOne();

            if (cartIdOpt.isEmpty()) return false;

            int rows = handle.createUpdate("DELETE FROM cart_details WHERE cart_id = ? AND variant_id = ?")
                    .bind(0, cartIdOpt.get())
                    .bind(1, variantId)
                    .execute();

            return rows > 0;
        });
    }

    public int getTotalQuantityByUserId(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart_details cd " +
                "JOIN carts c ON cd.cart_id = c.id " +
                "WHERE c.user_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
    }

    public void clearCart(int userId) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("DELETE FROM cart_details WHERE cart_id = (SELECT id FROM carts WHERE user_id = :userId)")
                    .bind("userId", userId)
                    .execute();
        });
    }

    public CartItem getCartItemByVariant(int variantId, int quantity) {
        String sql = """
        SELECT 
            v.id AS variantId,
            p.id AS productId,
            p.product_name AS productName,
            v.price,
            v.image_url AS imageUrl,
            v.color,
            v.size,
            GREATEST(COALESCE(d1.discount_percent, 0), COALESCE(d2.discount_percent, 0)) AS discountPercent,
            IFNULL(i.stock_quantity, 0) AS stock
        FROM product_variants v
        JOIN products p ON v.product_id = p.id
        LEFT JOIN inventories i ON v.id = i.variant_id
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN product_types t ON p.product_type_id = t.id
        LEFT JOIN discount_categories dc ON c.id = dc.category_id
        LEFT JOIN discounts d1 ON dc.discount_id = d1.id AND (NOW() BETWEEN d1.start_date AND d1.end_date)
        LEFT JOIN discount_product_types dt ON t.id = dt.product_type_id
        LEFT JOIN discounts d2 ON dt.discount_id = d2.id AND (NOW() BETWEEN d2.start_date AND d2.end_date)
        WHERE v.id = :vid
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("vid", variantId)
                        .map((rs, ctx) -> {
                            CartItem item = new CartItem();

                            int stock = rs.getInt("stock");
                            int finalQty = Math.min(quantity, stock);

                            item.setVariantId(rs.getInt("variantId"));
                            item.setProductId(rs.getInt("productId"));
                            item.setProductName(rs.getString("productName"));
                            item.setPrice(rs.getDouble("price"));
                            item.setImageUrl(rs.getString("imageUrl"));
                            item.setColor(rs.getString("color"));
                            item.setSize(rs.getString("size"));
                            item.setDiscountPercent(rs.getDouble("discountPercent"));
                            item.setStock(stock);
                            item.setQuantity(finalQty);

                            return item;
                        })
                        .findOne()
                        .orElse(null)
        );
    }
}

