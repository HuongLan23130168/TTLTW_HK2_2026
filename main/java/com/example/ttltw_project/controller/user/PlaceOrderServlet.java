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

            String city = request.getParameter("cityName");
            String district = request.getParameter("districtName");
            String ward = request.getParameter("wardName");
            String detail = request.getParameter("addressDetail");
            String address = detail + ", " + ward + ", " + district + ", " + city;

            String name = request.getParameter("fullName");
            name = name == null ? "" : name.trim();

            String phone = request.getParameter("phone");
            phone = phone == null ? "" : phone.trim().replaceAll("\\s+", "");

            String email = request.getParameter("email");
            email = email == null ? "" : email.trim();

            String note = request.getParameter("note");
            String shippingType =request.getParameter("shippingType");
            String shippingFeeRaw = request.getParameter("shippingFeeVal");

            if(!phone.matches("^0\\d{9}$")){
                response.sendRedirect(request.getContextPath() + "/checkout?error=phone");
                return;
            }

            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=email");
                return;
            }

            double shippingFee = 0;
            try {
                shippingFee = Double.parseDouble(shippingFeeRaw);

                if (shippingFee < 0) {
                    response.sendRedirect(request.getContextPath() + "/checkout?error=invalid-shipping");
                    return;
                }

            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=invalid-shipping");
                return;
            }

            if (!"tiêu chuẩn".equals(shippingType) && !"hỏa tốc".equals(shippingType)) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=invalid-shipping-type");
                return;
            }
            int paymentId = Integer.parseInt(request.getParameter("paymentMethod"));
            CartDAO cartDAO = new CartDAO();
            Integer variantId = (Integer) session.getAttribute("buyNow_variantId");
            Integer quantity = (Integer) session.getAttribute("buyNow_quantity");
            List<CartItem> items;
            boolean isBuyNow = (variantId != null && quantity != null);
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
            int totalWeight = calculateTotalWeight(items);
            String normalizedCity = normalizeProvince(city);
            boolean canUseExpress = normalizedCity.contains("Hồ Chí Minh");
            if ("hỏa tốc".equals(shippingType) && !canUseExpress) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=express-not-eligible");
                return;
            }

            Double standardShippingFee = GHTKProxyServlet.calculateFee(
                    normalizeProvince("Hồ Chí Minh"),
                    normalizeDistrict("Quận 9"),
                    normalizedCity,
                    normalizeDistrict(district),
                    ward,
                    detail,
                    totalWeight,
                    total,
                    "road"
            );

            if (standardShippingFee == null) {
                response.sendRedirect(request.getContextPath() + "/checkout?error=shipping-unavailable");
                return;
            }

            Double verifiedShippingFee = standardShippingFee;
            if ("hỏa tốc".equals(shippingType)) {
                Double expressShippingFee = GHTKProxyServlet.calculateFee(
                        normalizeProvince("Hồ Chí Minh"),
                        normalizeDistrict("Quận 9"),
                        normalizedCity,
                        normalizeDistrict(district),
                        ward,
                        detail,
                        totalWeight,
                        total,
                        "fly"
                );

                if (expressShippingFee == null) {
                    response.sendRedirect(request.getContextPath() + "/checkout?error=shipping-unavailable");
                    return;
                }

                verifiedShippingFee = Math.max(expressShippingFee, roundUpToThousand(standardShippingFee * 1.2));
            }

            if (Math.abs(verifiedShippingFee - shippingFee) > 1) {
                shippingFee = verifiedShippingFee;
            }

            System.out.println("TOTAL: " + total);
            System.out.println("SHIPPING FEE: " + shippingFee);
            System.out.println("CITY: " + city);

            OrderDAO orderDAO = new OrderDAO();
            String orderCode = orderDAO.createOrder(user.getId(), name, phone, address, note, paymentId, items, total, shippingType, shippingFee);

            if (orderCode != null) {
                Order order = orderDAO.getOrderByCode(orderCode);
                if (order == null) {
                    response.sendRedirect(request.getContextPath() + "/checkout?error=order-not-found");
                    return;
                }
                notificationService.notifyNewOrder(order);
                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
                double actualTotal = orderItems.stream().mapToDouble(i -> (i.getPrice() * i.getQuantity()) * (1 - i.getDiscount() / 100.0)).sum();

                if (paymentId == 1) {
                    if (!isBuyNow) {
                        cartDAO.clearCart(user.getId());
                    }

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
                    request.setAttribute("paymentMethod", "COD");
                    request.setAttribute("orderNote", note);

                    request.getRequestDispatcher("/user/completed.jsp").forward(request, response);

                } else {
                    session.setAttribute("pendingOrderCode", orderCode);
                    session.setAttribute("pendingOrderTotal", actualTotal + shippingFee);
                    session.setAttribute("pendingOrderItems", orderItems);
                    session.setAttribute("pendingOrderName", name);
                    session.setAttribute("pendingOrderPhone", phone);
                    session.setAttribute("pendingOrderEmail", email);
                    session.setAttribute("pendingOrderAddress", address);
                    session.setAttribute("pendingShippingFee", shippingFee);
                    session.setAttribute("pendingShippingType", shippingType);
                    session.setAttribute("pendingOrderNote", note);

                    response.sendRedirect(request.getContextPath() + "/bank-transfer-instruction");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi chi tiết: " + e.getMessage());
        }
    }

    private int calculateTotalWeight(List<CartItem> items) {
        CheckoutServlet checkoutServlet = new CheckoutServlet();
        int totalWeight = 0;
        for (CartItem item : items) {
            int[] dims = checkoutServlet.estimateDimensions(item.getSize());
            totalWeight += dims[0] * item.getQuantity();
        }
        if (totalWeight <= 0) return 1000;
        return Math.min(totalWeight, 30_000);
    }

    private double roundUpToThousand(double value) {
        return Math.ceil(value / 1000.0) * 1000;
    }

    private String normalizeProvince(String name) {
        if (name == null) return "";
        String trimmed = name.trim();
        return switch (trimmed) {
            case "Thành phố Hồ Chí Minh", "Hồ Chí Minh", "TP Hồ Chí Minh" -> "TP. Hồ Chí Minh";
            case "Tỉnh Thừa Thiên Huế", "Thừa Thiên Huế" -> "Huế";
            case "Thành phố Hà Nội" -> "Hà Nội";
            default -> trimmed
                    .replaceFirst("^Tỉnh\\s+", "")
                    .replaceFirst("^Thành phố\\s+", "");
        };
    }

    private String normalizeDistrict(String name) {
        if (name == null) return "";
        String trimmed = name.trim();
        return switch (trimmed) {
            case "Thủ Đức" -> "Thành phố Thủ Đức";
            default -> trimmed
                    .replaceFirst("^Huyện\\s+", "")
                    .replaceFirst("^Thị xã\\s+", "")
                    .replaceFirst("^Thành phố\\s+", "");
        };
    }
}
