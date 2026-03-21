package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.user.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Map;

public class AdminDashboardDAO {
    private Jdbi jdbi = DBDAO.get();

    // Tổng doanh thu
    public double getTotalRevenue() {
        String sql = "SELECT SUM(o.total_price) FROM orders o " +
                "JOIN order_status_history osh ON o.id = osh.order_id " +
                "WHERE osh.status = 'đã giao' " +
                "AND osh.id = (SELECT MAX(id) FROM order_status_history WHERE order_id = o.id)";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql).mapTo(Double.class).findOne().orElse(0.0)
        );
    }

    // Đơn hàng mới nhất
    public List<Order> getRecentOrders() {
        String sql = "SELECT o.id, o.order_code AS orderCode, o.recipient_name AS recipientName, " +
                "o.total_price AS totalPrice, osh.status, o.order_date AS orderDate " +
                "FROM orders o " +
                "JOIN order_status_history osh ON o.id = osh.order_id " +
                "WHERE osh.id = (SELECT MAX(id) FROM order_status_history WHERE order_id = o.id) " +
                "ORDER BY o.order_date DESC LIMIT 8";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Order.class).list());
    }

    // Đơn hàng đang xử lý
    public int countPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders o " +
                "JOIN order_status_history osh ON o.id = osh.order_id " +
                "WHERE osh.status = 'đang xử lý' " + // Hoặc 'Chờ xác nhận'
                "AND osh.id = (SELECT MAX(id) FROM order_status_history WHERE order_id = o.id)";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    // Top 4 sản phẩm bán chạy
    public List<Product> getBestSellers() {
        String sql = "SELECT p.id, p.product_name, pv.price, pv.image_url, SUM(od.quantity) AS totalSold " +
                "FROM order_details od " +
                "JOIN product_variants pv ON od.variant_id = pv.id " +
                "JOIN products p ON pv.product_id = p.id " +
                "GROUP BY p.id, p.product_name, pv.price, pv.image_url " +
                "ORDER BY totalSold DESC LIMIT 4";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }

    // Kho hàng
    public int getLowStockCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM inventories WHERE stock_quantity < 10").mapTo(Integer.class).one());
    }

    public int getTotalStock() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT SUM(stock_quantity) FROM inventories").mapTo(Integer.class).findOne().orElse(0));
    }

    // Biểu đồ
    public List<Map<String, Object>> getRevenueLast7Days() {
        String sql = "SELECT DATE_FORMAT(date_range.date, '%d/%m') as date, " +
                "COALESCE(SUM(o.total_price), 0) as daily_revenue " +
                "FROM ( " +
                "  SELECT CURDATE() - INTERVAL (a.a + (10 * b.a)) DAY AS date " +
                "  FROM (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) AS a " +
                "  CROSS JOIN (SELECT 0 AS a) AS b " +
                ") AS date_range " +
                "LEFT JOIN orders o ON DATE(o.order_date) = date_range.date " +
                "LEFT JOIN order_status_history osh ON o.id = osh.order_id " +
                "  AND osh.status = 'đã giao' " +
                "  AND osh.id = (SELECT MAX(id) FROM order_status_history WHERE order_id = o.id) " +
                "GROUP BY date_range.date ORDER BY date_range.date ASC";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToMap().list());
    }
}
