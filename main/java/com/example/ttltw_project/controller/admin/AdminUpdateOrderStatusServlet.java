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

        HttpSession session = request.getSession();
        try {
            String orderIdStr = request.getParameter("orderId");
            String currentStatus = request.getParameter("currentStatus");

            if (orderIdStr == null || currentStatus == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=missing_info");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            String newStatus = "";
            String newShippingStatus = "";
            String note = "";

            // xác nhận đã giao đon hangf cho đơn vị vận chuyển
            if (currentStatus.equalsIgnoreCase("Chờ xử lý")) {
                newStatus = "Đã xác nhận - Giao vận chuyển";
                newShippingStatus = "Đã giao cho đơn vị vận chuyển";
                note = "Admin đã xác nhận đơn hàng và chuyển cho đơn vị vận chuyển";
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?msg=cannot_change");
                return;
            }

            // method cho 4 trạng thái
            boolean success = orderDAO.updateOrderStatus(orderId, newStatus, note, newShippingStatus);

            if (success) {
                NotificationService notificationService = new NotificationService();
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    notificationService.notifyOrderUpdate(order, newStatus);
                }

                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("viewOrder")) {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?msg=success");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=system");
        }
    }
}