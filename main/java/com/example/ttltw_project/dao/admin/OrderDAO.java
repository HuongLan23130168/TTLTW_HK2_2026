package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import com.example.ttltw_project.model.user.CartItem;
import com.example.ttltw_project.model.user.Shipping;
import com.example.ttltw_project.model.user.UserOrder;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class OrderDAO {

        private final Jdbi jdbi = DBDAO.get();


        public String createOrder(int userId, String name, String phone, String address, String note,
                                  int paymentId, List<CartItem> items, double total,
                                  String shippingType, double shippingFee) {
            try {
                return jdbi.inTransaction(handle -> {
                    //tạo mã đơn hàng
                    String orderCode = "NLT@" + (System.currentTimeMillis() % 100000);


                    int orderId = handle.createUpdate("INSERT INTO orders (order_code, user_id, recipient_name, recipient_phone, total_price, note, shipping_address, order_date) "
                                    + "VALUES (:code, :uid, :name, :phone, :total, :note, :addr, NOW())")
                            .bind("code", orderCode)
                            .bind("uid", userId)
                            .bind("name", name)
                            .bind("phone", phone)
                            .bind("total", total + shippingFee) // Tổng tiền bao gồm ship
                            .bind("note", note)
                            .bind("addr", address)
                            .executeAndReturnGeneratedKeys()
                            .mapTo(Integer.class)
                            .one();


                    handle.createUpdate("INSERT INTO order_status_history (order_id, status, created_at) VALUES (:oid, 'Chờ xử lý', NOW())")
                            .bind("oid", orderId)
                            .execute();


                    var detailBatch = handle.prepareBatch("INSERT INTO order_details (order_id, variant_id, quantity, unit_price) VALUES (?, ?, ?, ?)");
                    var stockBatch = handle.prepareBatch("UPDATE inventories SET stock_quantity = stock_quantity - ? WHERE variant_id = ? AND stock_quantity >= ?");

                    for (CartItem item : items) {
                        detailBatch.add(orderId, item.getVariantId(), item.getQuantity(), item.getPrice());
                        stockBatch.add(item.getQuantity(), item.getVariantId(), item.getQuantity());
                    }

                    detailBatch.execute();
                    int[] updateCounts = stockBatch.execute();

                    // Kiểm tra sp còn không
                    for (int count : updateCounts) {
                        if (count == 0) {
                            throw new RuntimeException("Sản phẩm đã hết hàng hoặc không đủ số lượng trong kho!");
                        }
                    }


                    handle.createUpdate("INSERT INTO shipping (order_id, shipping_type, shipping_fee, shipping_status) VALUES (:oid, :stype, :sfee, 'Chờ lấy hàng')")
                            .bind("oid", orderId)
                            .bind("stype", shippingType)
                            .bind("sfee", shippingFee)
                            .execute();


                    handle.createUpdate("INSERT INTO payments (order_id, payment_method, status) VALUES (:oid, :method, 'Chưa thanh toán')")
                            .bind("oid", orderId)
                            .bind("method", (paymentId == 1 ? "COD" : "Chuyển khoản"))
                            .execute();

                    return orderCode;
                });
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }

        public Order getOrderByCode(String code) {
            String sql = """
                    SELECT o.*, 
                           COALESCE(
                               (SELECT status 
                                FROM order_status_history h 
                                WHERE h.order_id = o.id 
                                ORDER BY h.created_at DESC 
                                LIMIT 1), 
                               'Chờ xử lý') AS status,
                           u.email as customerEmail, 
                           s.shipping_type, s.shipping_fee, s.shipping_status, s.tracking_number, 
                           p.payment_method as paymentMethodName 
                    FROM orders o 
                    LEFT JOIN users u ON o.user_id = u.id 
                    LEFT JOIN shipping s ON o.id = s.order_id 
                    LEFT JOIN payments p ON o.id = p.order_id 
                    WHERE o.order_code = :code
                """;

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("code", code)
                            .map((rs, ctx) -> {
                                Order order = new Order();
                                order.setId(rs.getInt("id"));


                                order.setUserId(rs.getInt("user_id"));

                                order.setOrderCode(rs.getString("order_code"));

                                order.setOrderDate(rs.getTimestamp("order_date"));
                                order.setTotalPrice(rs.getDouble("total_price"));
                                order.setRecipientName(rs.getString("recipient_name"));
                                order.setRecipientPhone(rs.getString("recipient_phone"));
                                order.setCustomerEmail(rs.getString("customerEmail"));
                                order.setShippingAddress(rs.getString("shipping_address"));
                                order.setNote(rs.getString("note"));
                                order.setStatus(rs.getString("status"));
                                order.setPaymentMethod(rs.getString("paymentMethodName"));

                                Shipping ship = new Shipping();
                                ship.setShippingType(rs.getString("shipping_type"));
                                ship.setShippingFee(rs.getInt("shipping_fee"));
                                ship.setShippingStatus(rs.getString("shipping_status"));
                                ship.setTrackingNumber(rs.getString("tracking_number"));
                                order.setShipping(ship);

                                return order;
                            })
                            .findOne().orElse(null)
            );
        }

        public Order getOrderById(int orderId) {
            String sql = "SELECT o.id, " +
                    "o.user_id AS userId, " +
                    "o.order_code AS orderCode, " +
                    "o.order_date AS orderDate, " +
                    "o.total_price AS totalPrice, " +
                    "s.shipping_fee AS shippingFee, " +
                    "o.recipient_name AS recipientName, " +
                    "o.recipient_phone AS recipientPhone, " +
                    "o.shipping_address AS shippingAddress, " +
                    "o.note, " +
                    "u.full_name AS customerName, " +
                    "u.email AS customerEmail, " +
                    "u.phone AS customerPhone, " +
                    "(SELECT h.status FROM order_status_history h WHERE h.order_id = o.id ORDER BY h.created_at DESC LIMIT 1) AS status " +
                    "FROM orders o " +
                    "LEFT JOIN users u ON o.user_id = u.id " +
                    "LEFT JOIN shipping s ON o.id = s.order_id " +
                    "WHERE o.id = :id";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("id", orderId)
                            .mapToBean(Order.class)
                            .findOne()
                            .orElse(null)
            );
        }


        // BÊN ADMIN
        // Lấy tất cả đơn hàng
        public List<Order> getAllOrders(String sortBy) {
            return getAllOrders(sortBy, null);
        }


        public List<Order> getAllOrders(String sortBy, String search) {
            String orderBy = "oldest".equals(sortBy) ? "o.order_date ASC" : "o.order_date DESC";

            StringBuilder sql = new StringBuilder("SELECT o.id, " +
                    "o.order_code AS orderCode, " +
                    "o.order_date AS orderDate, " +
                    "o.total_price AS totalPrice, " +
                    "o.recipient_name AS recipientName, " +
                    "o.recipient_phone AS recipientPhone, " +
                    "o.shipping_address AS shippingAddress, " +
                    "o.note, " +
                    "(SELECT h.status FROM order_status_history h WHERE h.order_id = o.id ORDER BY h.created_at DESC LIMIT 1) AS status " +
                    "FROM orders o ");

            boolean hasSearch = (search != null && !search.trim().isEmpty());
            if (hasSearch) {
                sql.append(" WHERE o.order_code LIKE :search OR o.recipient_name LIKE :search ");
            }

            sql.append(" ORDER BY ").append(orderBy);

            return jdbi.withHandle(handle -> {
                var query = handle.createQuery(sql.toString());
                if (hasSearch) {
                    query.bind("search", "%" + search.trim() + "%");
                }
                return query.mapToBean(Order.class).list();
            });
        }

        // Lấy danh sách đơn hàng cụ thể
        public List<Order> getOrdersByCustomerId(int userId) {
            String sql = "SELECT o.*, (SELECT h.status FROM order_status_history h WHERE h.order_id = o.id ORDER BY h.created_at DESC LIMIT 1) AS status " +
                    "FROM orders o WHERE o.user_id = :userId ORDER BY o.order_date DESC";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .mapToBean(Order.class)
                            .list()
            );
        }

        public void cancelOrder(int orderId) {
            Jdbi jdbi = DBDAO.get();
            jdbi.useHandle(handle -> {
                handle.createUpdate("INSERT INTO order_status_history (order_id, status, created_at) VALUES (:orderId, :status, NOW())")
                        .bind("orderId", orderId)
                        .bind("status", "Đã hủy")
                        .execute();
            });
        }

        public List<Order> getOrdersByUserId(int userId) {
            Jdbi jdbi = DBDAO.get();
            String sql = """
                    SELECT o.*, 
                           COALESCE(
                               (SELECT status 
                                FROM order_status_history h 
                                WHERE h.order_id = o.id 
                                ORDER BY h.created_at DESC 
                                LIMIT 1), 
                               'Chờ xử lý') AS status
                    FROM orders o
                    WHERE o.user_id = :userId
                    ORDER BY o.order_date DESC
                """;

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .mapToBean(Order.class)
                            .list()
            );
        }


        public List<UserOrder> getMyOrders(int userId) {
            String sql = "SELECT " +
                    "o.id, " +
                    "o.order_code AS orderCode, " +
                    "o.order_date AS orderDate, " +
                    "o.total_price AS totalPrice, " +
                    "(SELECT status FROM order_status_history WHERE order_id = o.id ORDER BY created_at DESC LIMIT 1) AS status, " +
                    "p.product_name AS productName, " +
                    "pv.image_url AS imageUrl, " +
                    "pv.color, " +
                    "pv.size, " +
                    "od.quantity, " +
                    "(SELECT COUNT(*) - 1 FROM order_details WHERE order_id = o.id) AS otherItemsCount " +
                    "FROM orders o " +
                    "JOIN order_details od ON o.id = od.order_id " +
                    "JOIN product_variants pv ON od.variant_id = pv.id " +
                    "JOIN products p ON pv.product_id = p.id " +
                    "WHERE o.user_id = :uid " +
                    "GROUP BY o.id " +
                    "ORDER BY o.order_date DESC";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("uid", userId)
                            .mapToBean(UserOrder.class)
                            .list()
            );
        }



        public List<OrderItem> getOrderItemsByOrderId(int orderId) {
            String sql = "SELECT od.variant_id AS variantId, pv.variant_code AS variantCode, p.product_name AS name, " +
                    "od.quantity AS quantity, " +
                    "od.unit_price AS price, " +
                    "pv.color AS color, " +
                    "pv.size AS size, " +
                    "pv.image_url AS imageUrl, " +
                    "COALESCE(d2.discount_percent, d1.discount_percent, 0) AS discount " +
                    "FROM order_details od " +
                    "JOIN product_variants pv ON od.variant_id = pv.id " +
                    "JOIN products p ON pv.product_id = p.id " +
                    "LEFT JOIN product_types t ON p.product_type_id = t.id " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN discount_product_types dt ON t.id = dt.product_type_id " +
                    "LEFT JOIN discount_categories dc ON c.id = dc.category_id " +
                    "LEFT JOIN discounts d1 ON dc.discount_id = d1.id " +
                    "LEFT JOIN discounts d2 ON dt.discount_id = d2.id " +
                    "WHERE od.order_id = :orderId";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .mapToBean(OrderItem.class)
                            .list()
            );
        }


        public boolean updateOrderStatus(int orderId, String newStatus, String newShippingStatus) {
            try {
                return jdbi.inTransaction(handle -> {

                    handle.createUpdate("INSERT INTO order_status_history (order_id, status, created_at) VALUES (:id, :status, NOW())")
                            .bind("id", orderId)
                            .bind("status", newStatus)
                            .execute();


                    int rowCount = handle.createUpdate("UPDATE shipping SET shipping_status = :shipStatus WHERE order_id = :id")
                            .bind("shipStatus", newShippingStatus)
                            .bind("id", orderId)
                            .execute();


                    return true;
                });
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
public boolean createReturnOrder(int orderId, int userId, String reason, String imageUrl, String bankAccount) {

        String sql = "INSERT INTO return_orders(order_id,user_id,reason,image_url,bank_account,status) VALUES (?,?,?,?,?,'Chờ duyệt')";

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.setString(3, reason);
            ps.setString(4, imageUrl);
            ps.setString(5, bankAccount);

            return ps.executeUpdate() > 0;

        }catch(Exception e){
            e.printStackTrace();
        }

        return false;
    }


    }
