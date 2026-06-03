package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "SimulateShippingServlet", value = "/admin/simulateShipping")
public class SimulateShippingServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String shippingStatus = request.getParameter("shippingStatus");

            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=order_not_found");
                return;
            }

            // Map shipping status sang order status
            String orderStatus = mapToOrderStatus(shippingStatus);

            // Cập nhật trạng thái
            boolean success = orderDAO.updateOrderStatus(orderId, orderStatus, "Giả lập: " + shippingStatus, shippingStatus);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=simulated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=simulate_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=system");
        }
    }

    private String mapToOrderStatus(String shippingStatus) {
        switch (shippingStatus) {
            case "Đã lấy hàng": return "Đã lấy hàng";
            case "Đang vận chuyển": return "Đang vận chuyển";
            case "Đã giao thành công": return "Đã giao hàng - Hoàn thành";
            default: return shippingStatus;
        }
    }
}