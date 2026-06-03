package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.services.NotificationService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "UpdateOrderStatusServlet", value = "/admin/updateOrderStatus")
public class AdminUpdateOrderStatusServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String orderIdStr = request.getParameter("orderId");
            String currentStatus = request.getParameter("currentStatus");
            String action = request.getParameter("action");

            if (orderIdStr == null || currentStatus == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=missing_info");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=order_not_found");
                return;
            }

            boolean isPending = currentStatus.equalsIgnoreCase("Chờ xử lý");

            if ("cancel".equalsIgnoreCase(action)) {
                if (!isPending) {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=cannot_cancel");
                    return;
                }

                String cancelReason = request.getParameter("cancelReason");
                if (cancelReason == null || cancelReason.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=missing_cancel_reason");
                    return;
                }

                boolean success = orderDAO.cancelOrder(orderId, "Admin hủy đơn: " + cancelReason.trim());
                if (success) {
                    NotificationService notificationService = new NotificationService();
                    notificationService.notifyOrderUpdate(order, "Đã hủy");
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=cancelled");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=cancel_failed");
                }
                return;
            }

            if (isPending) {
                String newStatus = "Đã xác nhận - Giao vận chuyển";
                String newShippingStatus = "Đã giao cho đơn vị vận chuyển";
                String note = "Admin đã xác nhận đơn hàng";

                boolean success = orderDAO.updateOrderStatus(orderId, newStatus, note, newShippingStatus);

                if (success) {
                    NotificationService notificationService = new NotificationService();
                    notificationService.notifyOrderUpdate(order, newStatus);
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=confirmed");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=update_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?msg=cannot_change");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=system");
        }
    }
}
