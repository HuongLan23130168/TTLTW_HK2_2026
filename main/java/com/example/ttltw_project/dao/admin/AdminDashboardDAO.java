package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.user.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AdminDashboardDAO {
    private Jdbi jdbi = DBDAO.get();

    // Tổng doanh thu
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(o.total_price), 0) FROM orders o " +
                "WHERE o.status = 'Đã giao hàng - Hoàn thành'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Double.class).one());
    }

    public int countPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Chờ xử lý'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public List<Order> getRecentOrders() {
        String sql = "SELECT o.id, o.order_code AS orderCode, o.recipient_name AS recipientName, " +
                "o.total_price AS totalPrice, o.status, o.order_date AS orderDate " +
                "FROM orders o ORDER BY o.order_date DESC LIMIT 8";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Order.class).list());
    }

    public List<Product> getBestSellers() {
        String sql = "SELECT p.id, p.product_name, pv.price, pv.image_url, " +
                "COALESCE(SUM(od.quantity), 0) AS totalSold " +
                "FROM products p " +
                "INNER JOIN product_variants pv ON p.id = pv.product_id " +
                "LEFT JOIN order_details od ON pv.id = od.variant_id " +
                "LEFT JOIN orders o ON od.order_id = o.id AND o.status = 'Đã giao hàng - Hoàn thành' " +
                "GROUP BY p.id, p.product_name, pv.price, pv.image_url " +
                "ORDER BY totalSold DESC LIMIT 4";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }

    public int getLowStockCount() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM inventories WHERE stock_quantity < 10").mapTo(Integer.class).one());
    }

    public int getTotalStock() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COALESCE(SUM(stock_quantity), 0) FROM inventories").mapTo(Integer.class).one());
    }

    public List<Map<String, Object>> getRevenueByFilter(String filter) {
        String sql = "";
        switch (filter) {
            case "week":
                sql = "SELECT DATE_FORMAT(o.order_date, '%d/%m') as label, " +
                        "COALESCE(SUM(o.total_price), 0) as revenue " +
                        "FROM orders o " +
                        "WHERE o.status = 'Đã giao hàng - Hoàn thành' " +
                        "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                        "GROUP BY DATE(o.order_date) ORDER BY o.order_date ASC";
                break;
            case "month":
                sql = "SELECT DATE_FORMAT(o.order_date, '%d/%m') as label, " +
                        "COALESCE(SUM(o.total_price), 0) as revenue " +
                        "FROM orders o " +
                        "WHERE o.status = 'Đã giao hàng - Hoàn thành' " +
                        "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) " +
                        "GROUP BY DATE(o.order_date) ORDER BY o.order_date ASC";
                break;
            case "year":
                sql = "SELECT DATE_FORMAT(o.order_date, '%m/%Y') as label, " +
                        "COALESCE(SUM(o.total_price), 0) as revenue " +
                        "FROM orders o " +
                        "WHERE o.status = 'Đã giao hàng - Hoàn thành' " +
                        "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) " +
                        "GROUP BY YEAR(o.order_date), MONTH(o.order_date) " +
                        "ORDER BY YEAR(o.order_date) ASC, MONTH(o.order_date) ASC";
                break;
            default:
                sql = "SELECT DATE_FORMAT(o.order_date, '%d/%m') as label, " +
                        "COALESCE(SUM(o.total_price), 0) as revenue " +
                        "FROM orders o " +
                        "WHERE o.status = 'Đã giao hàng - Hoàn thành' " +
                        "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                        "GROUP BY DATE(o.order_date) ORDER BY o.order_date ASC";
                break;
        }
        String finalSql = sql;
        return jdbi.withHandle(handle -> handle.createQuery(finalSql).mapToMap().list());
    }

    public List<Map<String, Object>> getRevenueByDateRange(String fromDate, String toDate) {
        String sql = "SELECT DATE_FORMAT(o.order_date, '%d/%m') as label, " +
                "COALESCE(SUM(o.total_price), 0) as revenue " +
                "FROM orders o " +
                "WHERE o.status = 'Đã giao hàng - Hoàn thành' " +
                "AND DATE(o.order_date) >= DATE(:fromDate) " +
                "AND DATE(o.order_date) <= DATE(:toDate) " +
                "GROUP BY DATE(o.order_date) ORDER BY o.order_date ASC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("fromDate", fromDate)
                .bind("toDate", toDate)
                .mapToMap().list());
    }
}
