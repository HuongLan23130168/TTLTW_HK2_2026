package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminCustomerDAO;
import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "ViewOrderServlet", value = "/admin/viewOrder")
public class AdminViewOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRole() != 2) { // role 2 là admin
            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            OrderDAO orderDAO = new OrderDAO();
            AdminCustomerDAO customerDAO = new AdminCustomerDAO();

            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                session.setAttribute("errorMessage", "Không tìm thấy đơn hàng với ID: " + orderId);
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Lấy thông tin khách hàng
            User customer = customerDAO.getCustomerById(order.getUserId());
            if (customer != null) {
                order.setCustomerName(customer.getFullName());
                order.setCustomerEmail(customer.getEmail());
                order.setCustomerPhone(customer.getPhone());
            } else {
                order.setCustomerName(order.getRecipientName());
                order.setCustomerEmail("Không có email");
                order.setCustomerPhone(order.getRecipientPhone());
            }

            // Địa chỉ giao hàng
            order.setCustomerAddress(order.getShippingAddress());

            List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            request.getRequestDispatcher("/admin/viewOrders.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}