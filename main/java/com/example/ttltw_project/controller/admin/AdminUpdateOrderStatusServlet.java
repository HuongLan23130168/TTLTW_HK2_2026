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

            if (currentStatus.equalsIgnoreCase("Chờ xử lý")) {
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