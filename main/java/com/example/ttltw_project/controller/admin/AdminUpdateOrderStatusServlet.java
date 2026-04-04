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

              if (currentStatus.equalsIgnoreCase("Chờ xử lý") || currentStatus.equalsIgnoreCase("Chờ lấy hàng")) {
                newStatus = "Đang giao";
                newShippingStatus = "Đang vận chuyển";
            }


            else if (currentStatus.contains("Đang giao") || currentStatus.contains("Vận chuyển")) {
                newStatus = "Chờ xác nhận";
                newShippingStatus = "Đã đến nơi giao nhận";



            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?msg=no_change");
                return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, newStatus, newShippingStatus);

            if (success) {
                NotificationService notificationService = new NotificationService();
                Order order = orderDAO.getOrderById(orderId);
                notificationService.notifyOrderUpdate(order, newStatus);

                // Nếu đang ở trang chi tiết (View Order) thì reload lại trang đó
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("viewOrder")) {
                    response.sendRedirect(request.getContextPath() + "/admin/viewOrder?orderId=" + orderId + "&msg=success");
                } else {
                    // Nếu ở trang danh sách
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