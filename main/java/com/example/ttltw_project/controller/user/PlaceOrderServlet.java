package com.example.ttltw_project.controller.user;


import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import com.example.ttltw_project.model.user.CartItem;
import com.example.ttltw_project.model.user.User;
import com.example.ttltw_project.services.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PlaceOrderServlet", value = "/place-order")
public class PlaceOrderServlet extends HttpServlet {
    NotificationService notificationService = new NotificationService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("Đã chạy vào PlaceOrderServlet!");
            request.setCharacterEncoding("UTF-8");
            HttpSession session = request.getSession();

            User user = (User) session.getAttribute("acc");
            if (user == null) {
                System.out.println("Lỗi: Không tìm thấy User trong session!");
                response.sendRedirect("login");
                return;
            }

            String name = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String detail = request.getParameter("addressDetail");
            String address = detail + ", " + ward + ", " + district + ", " + city;
            String note = request.getParameter("note");

            int paymentId = Integer.parseInt(request.getParameter("paymentMethod"));
            String shippingType = request.getParameter("shippingType");
            double shippingFee = "hỏa tốc".equals(shippingType) ? 130000 : 30000;

            CartDAO cartDAO = new CartDAO();

            Integer variantId = (Integer) session.getAttribute("buyNow_variantId");
            Integer quantity = (Integer) session.getAttribute("buyNow_quantity");

            List<CartItem> items;
            boolean isBuyNow = (variantId != null && quantity != null);

            if (isBuyNow) {
                CartItem item = cartDAO.getCartItemByVariant(variantId, quantity);
                items = List.of(item);
            } else {
                items = cartDAO.getCartByUserId(user.getId());

                if (items == null || items.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }

            double total = items.stream().mapToDouble(CartItem::getTotalPrice).sum();
            OrderDAO orderDAO = new OrderDAO();
            String orderCode = orderDAO.createOrder(user.getId(), name, phone, address, note,
                    paymentId, items, total, shippingType, shippingFee);

            if (orderCode != null) {
                Order order = orderDAO.getOrderByCode(orderCode);

                notificationService.notifyNewOrder(order);

                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
                double actualTotal = orderItems.stream()
                        .mapToDouble(i -> (i.getPrice() * i.getQuantity()) * (1 - i.getDiscount() / 100.0))
                        .sum();

                request.setAttribute("orderItems", orderItems);
                request.setAttribute("orderCode", orderCode);
                request.setAttribute("orderName", name);
                request.setAttribute("orderPhone", phone);
                request.setAttribute("orderEmail", email);
                request.setAttribute("orderAddress", address);
                request.setAttribute("orderDate", new java.util.Date());
                request.setAttribute("shippingType", shippingType);
                request.setAttribute("shippingFee", shippingFee);
                request.setAttribute("grandTotal", actualTotal);
                request.setAttribute("paymentMethod", (paymentId == 1 ? "COD" : "Chuyển khoản"));
                request.setAttribute("orderNote", note);

                if (!isBuyNow) {
                    cartDAO.clearCart(user.getId());
                }
                request.getRequestDispatcher("/user/completed.jsp").forward(request, response);
            } else {
                response.sendRedirect("checkout?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi chi tiết: " + e.getMessage());
        }
    }
}