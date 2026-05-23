package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderCompletedServlet", value = "/order-completed")
public class OrderCompletedServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderCode = request.getParameter("orderCode");

        if (orderCode == null || orderCode.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Order order = orderDAO.getOrderByCode(orderCode);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());

        request.setAttribute("orderCode", order.getOrderCode());
        request.setAttribute("orderName", order.getRecipientName());
        request.setAttribute("orderPhone", order.getRecipientPhone());
        request.setAttribute("orderEmail", order.getCustomerEmail());
        request.setAttribute("orderAddress", order.getShippingAddress());
        request.setAttribute("grandTotal", order.getTotalPrice());
        request.setAttribute("shippingFee", order.getShipping() != null ? order.getShipping().getShippingFee() : 0);
        request.setAttribute("shippingType", order.getShipping() != null ? order.getShipping().getShippingType() : "TIÊU CHUẨN");
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("orderDate", order.getOrderDate());

        String paymentMethod = "COD";
        if (order.getPaymentMethod() != null && !order.getPaymentMethod().isEmpty()) {
            paymentMethod = order.getPaymentMethod();
        }
        request.setAttribute("paymentMethod", paymentMethod);

        request.getRequestDispatcher("/user/completed.jsp").forward(request, response);
    }
}