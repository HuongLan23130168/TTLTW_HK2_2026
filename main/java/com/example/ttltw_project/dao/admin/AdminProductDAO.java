package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.user.Discount;
import com.example.ttltw_project.model.user.Product;
import com.example.ttltw_project.model.user.Product_variant;
import org.jdbi.v3.core.Jdbi;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class AdminProductDAO {
    private final Jdbi jdbi;

    public AdminProductDAO() {
        this.jdbi = DBDAO.get();
    }

    // đếm sp để phân trang
    public int getTotalProductCount() {
        return jdbi.withHandle(h -> h.createQuery("SELECT COUNT(*) FROM products WHERE is_active = 1").mapTo(Integer.class).one());
    }

    public List<Product> getProducts(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = """
                    SELECT
                        p.id, p.product_name, p.product_code, t.type_name,
                        (SELECT image_url FROM product_images WHERE product_id = p.id ORDER BY id LIMIT 1) AS image_url,
                        (SELECT GROUP_CONCAT(c.category_name SEPARATOR ', ') FROM categories c WHERE FIND_IN_SET(c.id, p.category_id) > 0) AS category_name,
                        (SELECT COALESCE(SUM(inv.stock_quantity), 0) FROM inventories inv JOIN product_variants pv ON inv.variant_id = pv.id WHERE pv.product_id = p.id) AS stock,
                        COALESCE((SELECT MIN(price) FROM product_variants WHERE product_id = p.id), 0.00) AS original_price,
                        EXISTS(SELECT 1 FROM new_products np WHERE np.product_id = p.id) as isNew,
                        EXISTS(SELECT 1 FROM best_sellers bs WHERE bs.product_id = p.id) as isBestSeller,
                        COALESCE((
                            SELECT MAX(d.discount_percent)
                            FROM discounts d
                            WHERE
                                NOW() BETWEEN d.start_date AND d.end_date
                                AND (
                                    EXISTS (SELECT 1 FROM discount_product_types dpt WHERE dpt.discount_id = d.id AND dpt.product_type_id = p.product_type_id)
                                    OR
                                    EXISTS (SELECT 1 FROM discount_categories dc WHERE dc.discount_id = d.id AND FIND_IN_SET(dc.category_id, p.category_id))
                                )
                        ), 0) AS discountPercent
                    FROM products p
                    LEFT JOIN product_types t ON p.product_type_id = t.id
                    WHERE p.is_active = 1
                    ORDER BY p.id DESC
                    LIMIT :limit OFFSET :offset
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("limit", pageSize)
                .bind("offset", offset)
                .map((rs, ctx) -> {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setProduct_name(rs.getString("product_name"));
                    p.setProduct_code(rs.getString("product_code"));
                    p.setType_name(rs.getString("type_name"));
                    p.setCategory_name(rs.getString("category_name"));
                    p.setStock(rs.getInt("stock"));
                    p.setImage_url(rs.getString("image_url"));
                    p.setPrice(rs.getDouble("original_price"));

                    int discountPercent = rs.getInt("discountPercent");
                    if (discountPercent > 0) {
                        Discount d = new Discount();
                        d.setDiscount_percent(discountPercent);
                        d.setStart_date(new java.sql.Timestamp(System.currentTimeMillis() - 86400000));
                        d.setEnd_date(new java.sql.Timestamp(System.currentTimeMillis() + 86400000));
                        p.setDiscount(d);
                    }
                    return p;
                }).list());
    }

    public List<Product> getAllProductsSimple() {
        return jdbi.withHandle(h -> h.createQuery("SELECT id, product_name FROM products WHERE is_active = 1 ORDER BY product_name").mapToBean(Product.class).list());
    }

    public Product getProductById(int id) {
        Product product = jdbi.withHandle(h -> h.createQuery("SELECT * FROM products WHERE id = :id AND is_active = 1").bind("id", id).mapToBean(Product.class).findFirst().orElse(null));
        if (product != null) {
            String imageUrl = jdbi.withHandle(h -> h.createQuery("SELECT image_url FROM product_images WHERE product_id = :id ORDER BY id LIMIT 1").bind("id", id).mapTo(String.class).findFirst().orElse(null));
            product.setImage_url(imageUrl);
            product.setNewProduct(jdbi.withHandle(h -> h.createQuery("SELECT EXISTS(SELECT 1 FROM new_products WHERE product_id = :id)").bind("id", id).mapTo(Boolean.class).one()));
            product.setBestSeller(jdbi.withHandle(h -> h.createQuery("SELECT EXISTS(SELECT 1 FROM best_sellers WHERE product_id = :id)").bind("id", id).mapTo(Boolean.class).one()));
        }
        return product;
    }

    private void handleTags(org.jdbi.v3.core.Handle h, Product p, int productId) {
        h.createUpdate("DELETE FROM new_products WHERE product_id = :id").bind("id", productId).execute();
        if (p.isNewProduct()) {
            h.createUpdate("INSERT INTO new_products (product_id, added_at) VALUES (:id, NOW())").bind("id", productId).execute();
        }
        h.createUpdate("DELETE FROM best_sellers WHERE product_id = :id").bind("id", productId).execute();
        if (p.isBestSeller()) {
            h.createUpdate("INSERT INTO best_sellers (product_id, sold_quantity) VALUES (:id, 0)").bind("id", productId).execute();
        }
    }


//   thêm mới sản phẩm
    public boolean insertProductFull(Product p, List<Product_variant> variants, List<String> otherImages) {
        try {
            return jdbi.inTransaction(h -> {
                String sqlProduct = "INSERT INTO products (product_code, product_name, product_type_id, category_id, description, created_at, is_active) VALUES (:product_code, :product_name, :product_type_id, :category_id, :description, NOW(), 1)";
                int productId = h.createUpdate(sqlProduct)
                        .bindBean(p)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one();
                p.setId(productId);

                handleTags(h, p, productId);

                List<String> allImages = new ArrayList<>();
                if (p.getImage_url() != null && !p.getImage_url().isEmpty()) allImages.add(p.getImage_url());
                if (otherImages != null) allImages.addAll(otherImages);

                for (String img : allImages) {
                    h.createUpdate("INSERT INTO product_images(product_id, image_url) VALUES(:pid, :url)")
                            .bind("pid", productId)
                            .bind("url", img)
                            .execute();
                }

                if (variants != null) {
                    for (Product_variant v : variants) {
                        int generatedVariantId = h.createUpdate("""
                    INSERT INTO product_variants 
                    (product_id, variant_code, color, size, material, price, image_url) 
                    VALUES (:pid, :variant_code, :color, :size, :material, :price, :img)
                """)
                                .bind("pid", productId)
                                .bindBean(v)
                                .bind("img", p.getImage_url())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(int.class)
                                .one();

                        h.createUpdate("INSERT INTO inventories (variant_id, stock_quantity, last_updated) VALUES (:vid, :qty, NOW())")
                                .bind("vid", generatedVariantId)
                                .bind("qty", v.getStock())
                                .execute();
                    }
                }
                return true;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    public boolean updateProductFull(Product p, List<Product_variant> variants, List<String> otherImages) {
        try {
            return jdbi.inTransaction(h -> {
                h.createUpdate("UPDATE products SET product_name=:product_name, product_code=:product_code, description=:description, product_type_id=:product_type_id, category_id=:category_id WHERE id=:id").bindBean(p).execute();
                handleTags(h, p, p.getId());

                List<Integer> formVariantIds = variants.stream().map(Product_variant::getId).filter(id -> id > 0).collect(Collectors.toList());
                List<Integer> dbVariantIds = h.createQuery("SELECT id FROM product_variants WHERE product_id = :pid").bind("pid", p.getId()).mapTo(Integer.class).list();
                List<Integer> idsToDelete = dbVariantIds.stream().filter(id -> !formVariantIds.contains(id)).collect(Collectors.toList());

                if (!idsToDelete.isEmpty()) {
                    h.createUpdate("DELETE FROM inventories WHERE variant_id IN (<idsToDelete>)").bindList("idsToDelete", idsToDelete).execute();
                    h.createUpdate("DELETE FROM product_variants WHERE id IN (<idsToDelete>)").bindList("idsToDelete", idsToDelete).execute();
                }

                for (Product_variant v : variants) {
                    if (v.getId() > 0) {
                        h.createUpdate("""
                                            UPDATE product_variants 
                                            SET variant_code=:variant_code, color=:color, size=:size, 
                                                material=:material, price=:price, image_url=:img 
                                            WHERE id=:id
                                        """)
                                .bindBean(v)
                                .bind("img", p.getImage_url())
                                .execute();


                        h.createUpdate("UPDATE inventories SET stock_quantity = :qty, last_updated = NOW() WHERE variant_id = :vid")
                                .bind("qty", v.getStock())
                                .bind("vid", v.getId())
                                .execute();
                    }
                }

                h.createUpdate("DELETE FROM product_images WHERE product_id=:pid").bind("pid", p.getId()).execute();
                List<String> allImages = new ArrayList<>();
                if (p.getImage_url() != null && !p.getImage_url().isEmpty()) allImages.add(p.getImage_url());
                if (otherImages != null) allImages.addAll(otherImages);
                for (String img : allImages) {
                    h.createUpdate("INSERT INTO product_images(product_id, image_url) VALUES(:pid, :url)").bind("pid", p.getId()).bind("url", img).execute();
                }
                return true;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void softDeleteProduct(int productId) {
        try {
            jdbi.useHandle(h -> h.createUpdate("UPDATE products SET is_active = 0 WHERE id = :id")
                    .bind("id", productId)
                    .execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void hardDeleteProduct(int productId) {
        try {
            jdbi.useTransaction(h -> {
                h.createUpdate("DELETE FROM new_products WHERE product_id = :id").bind("id", productId).execute();
                h.createUpdate("DELETE FROM best_sellers WHERE product_id = :id").bind("id", productId).execute();
                h.createUpdate("DELETE FROM inventories WHERE variant_id IN (SELECT id FROM product_variants WHERE product_id=:pid)").bind("pid", productId).execute();
                h.createUpdate("DELETE FROM product_variants WHERE product_id=:pid").bind("pid", productId).execute();
                h.createUpdate("DELETE FROM product_images WHERE product_id=:pid").bind("pid", productId).execute();
                h.createUpdate("DELETE FROM products WHERE id=:pid").bind("pid", productId).execute();
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Product_variant> getVariantsByProductId(int productId) {
        String sql = "SELECT pv.*, COALESCE(inv.stock_quantity,0) AS stock FROM product_variants pv LEFT JOIN inventories inv ON pv.id = inv.variant_id WHERE pv.product_id = :pid";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("pid", productId).mapToBean(Product_variant.class).list());
    }

    public List<String> getGalleryByProductId(int productId) {
        return jdbi.withHandle(h -> h.createQuery("SELECT image_url FROM product_images WHERE product_id=:pid ORDER BY id LIMIT 1, 100").bind("pid", productId).mapTo(String.class).list());
    }

    private void processImagesAndVariants(org.jdbi.v3.core.Handle h, Product p, List<Product_variant> variants, List<String> otherImages, int productId) {
        List<String> allImages = new ArrayList<>();
        if (p.getImage_url() != null && !p.getImage_url().isEmpty()) allImages.add(p.getImage_url());
        if (otherImages != null) allImages.addAll(otherImages);
        for (String img : allImages) {
            h.createUpdate("INSERT INTO product_images(product_id, image_url) VALUES(:pid, :url)").bind("pid", productId).bind("url", img).execute();
        }
        if (variants != null) {
            for (Product_variant v : variants) {
                int varId = h.createUpdate("INSERT INTO product_variants (product_id, variant_code, color, size, material, price) VALUES (:pid, :variant_code, :color, :size, :material, :price)")
                        .bind("pid", productId).bindBean(v).executeAndReturnGeneratedKeys("id").mapTo(int.class).one();
                h.createUpdate("INSERT INTO inventories (variant_id, stock_quantity, last_updated) VALUES (:vid, :qty, NOW())").bind("vid", varId).bind("qty", v.getStock()).execute();
            }
        }
    }
}

