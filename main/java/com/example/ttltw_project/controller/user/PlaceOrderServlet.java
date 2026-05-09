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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");
            HttpSession session = request.getSession();

            User user = (User) session.getAttribute("acc");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            String city = request.getParameter("cityName");
            String district = request.getParameter("districtName");
            String ward = request.getParameter("wardName");
            String detail = request.getParameter("addressDetail");
            String address = detail + ", " + ward + ", " + district + ", " + city;
            String name = safe(request.getParameter("fullName"));
            String phone = safe(request.getParameter("phone")).replaceAll("\\s+", "");
            String email = safe(request.getParameter("email"));
            String note = request.getParameter("note");

            int paymentId = Integer.parseInt(request.getParameter("paymentMethod"));

            if (!phone.matches("^0\\d{9}$")) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=phone");
                return;
            }

            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=email");
                return;
            }

            CartDAO cartDAO = new CartDAO();

            Integer variantId = (Integer) session.getAttribute("buyNow_variantId");
            Integer quantity = (Integer) session.getAttribute("buyNow_quantity");

            boolean isBuyNow = (variantId != null && quantity != null);

            List<CartItem> items;

            if (isBuyNow) {
                CartItem item = cartDAO.getCartItemByVariant(variantId, quantity);
                if (item == null) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                items = List.of(item);
            } else {
                items = cartDAO.getCartByUserId(user.getId());
                if (items == null || items.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }

            double total = items.stream().mapToDouble(CartItem::getTotalPrice).sum();

            System.out.println("TOTAL: " + total);
            System.out.println("CITY: " + city);

            OrderDAO orderDAO = new OrderDAO();

            String orderCode = orderDAO.createOrder(
                    user.getId(),
                    name,
                    phone,
                    address,
                    note,
                    paymentId,
                    items,
                    total,
                    "tiêu chuẩn",
                    0
            );

            if (orderCode == null) {
                response.sendRedirect("checkout?error=1");
                return;
            }

            Order order = orderDAO.getOrderByCode(orderCode);

            if (order == null) {
                response.sendRedirect("checkout?error=order-not-found");
                return;
            }

            notificationService.notifyNewOrder(order);

            List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());

            double actualTotal = orderItems.stream().mapToDouble(i -> (i.getPrice() * i.getQuantity()) * (1 - i.getDiscount() / 100.0)).sum();


            request.setAttribute("orderItems", orderItems);
            request.setAttribute("orderCode", orderCode);
            request.setAttribute("orderName", name);
            request.setAttribute("orderPhone", phone);
            request.setAttribute("orderEmail", email);
            request.setAttribute("orderAddress", address);
            request.setAttribute("orderDate", new java.util.Date());
            request.setAttribute("shippingType", "tiêu chuẩn");
            request.setAttribute("shippingFee", 0);
            request.setAttribute("grandTotal", actualTotal);
            request.setAttribute("paymentMethod",(paymentId == 1 ? "COD" : "Chuyển khoản"));
            request.setAttribute("orderNote", note);

            if (!isBuyNow) {
                cartDAO.clearCart(user.getId());
            }

            request.getRequestDispatcher("/user/completed.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi chi tiết: " + e.getMessage());
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
