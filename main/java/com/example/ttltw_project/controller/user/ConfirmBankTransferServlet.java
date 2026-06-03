package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ConfirmBankTransferServlet", value = "/confirm-bank-transfer")
public class ConfirmBankTransferServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderCode = request.getParameter("orderCode");

        if (orderCode == null || orderCode.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();

        boolean updated = orderDAO.userConfirmBankTransfer(orderCode);

        if (updated) {
            System.out.println("Đã xác nhận chuyển khoản cho đơn: " + orderCode);
        } else {
            System.out.println("Không cập nhật được đơn: " + orderCode + " (có thể đã xác nhận rồi)");
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("acc");
            if (user != null) {
                Integer buyNowVariant = (Integer) session.getAttribute("buyNow_variantId");
                if (buyNowVariant == null) {
                    new CartDAO().clearCart(user.getId());
                }
                session.removeAttribute("buyNow_variantId");
                session.removeAttribute("buyNow_quantity");
            }
            session.removeAttribute("pendingOrderCode");
            session.removeAttribute("pendingOrderTotal");
            session.removeAttribute("pendingOrderItems");
            session.removeAttribute("pendingOrderName");
            session.removeAttribute("pendingOrderPhone");
            session.removeAttribute("pendingOrderEmail");
            session.removeAttribute("pendingOrderAddress");
            session.removeAttribute("pendingShippingFee");
            session.removeAttribute("pendingShippingType");
            session.removeAttribute("pendingOrderNote");
        }

        Order order = orderDAO.getOrderByCode(orderCode);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/tracking?orderCode=" + orderCode);
            return;
        }

        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
        double subtotal = orderItems.stream()
                .mapToDouble(i -> i.getPrice() * (1 - i.getDiscount() / 100.0) * i.getQuantity())
                .sum();

        request.setAttribute("orderItems",   orderItems);
        request.setAttribute("orderCode",    order.getOrderCode());
        request.setAttribute("orderName",    order.getRecipientName());
        request.setAttribute("orderPhone",   order.getRecipientPhone());
        request.setAttribute("orderEmail",   order.getCustomerEmail());
        request.setAttribute("orderAddress", order.getShippingAddress());
        request.setAttribute("orderDate",    order.getOrderDate());
        request.setAttribute("orderNote",    order.getNote());
        request.setAttribute("shippingType", order.getShipping() != null ? order.getShipping().getShippingType() : "");
        request.setAttribute("shippingFee",  order.getShipping() != null ? (double) order.getShipping().getShippingFee() : 0.0);
        request.setAttribute("grandTotal",   subtotal);
        request.setAttribute("paymentMethod", "Chuyển khoản");

        request.getRequestDispatcher("/user/completed.jsp").forward(request, response);
    }
}
