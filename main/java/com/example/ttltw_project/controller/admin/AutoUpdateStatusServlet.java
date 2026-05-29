package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "AutoUpdateStatusServlet", value = "/admin/autoUpdateStatus")
public class AutoUpdateStatusServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=missing_order_id");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=order_not_found");
                return;
            }

            String currentStatus = order.getStatus();
            String newStatus = null;
            String newShippingStatus = null;

            switch (currentStatus) {
                case "Đã xác nhận - Giao vận chuyển":
                    newStatus = "Đã lấy hàng";
                    newShippingStatus = "Đã lấy hàng";
                    break;
                case "Đã lấy hàng":
                    newStatus = "Đang vận chuyển";
                    newShippingStatus = "Đang vận chuyển";
                    break;
                case "Đang vận chuyển":
                    newStatus = "Đã giao hàng - Hoàn thành";
                    newShippingStatus = "Giao thành công";
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=cannot_auto_update");
                    return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, newStatus, "Chuyển tiếp trạng thái", newShippingStatus);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=auto_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=system");
        }
    }
}