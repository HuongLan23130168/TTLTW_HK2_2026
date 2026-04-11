package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.model.user.CartItem;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDAO cartDAO = new CartDAO();

        Integer variantId = (Integer) session.getAttribute("buyNow_variantId");
        Integer quantity = (Integer) session.getAttribute("buyNow_quantity");

        List<CartItem> items;

        if (variantId != null && quantity != null) {
            CartItem item = cartDAO.getCartItemByVariant(variantId, quantity);
            items = List.of(item);

        } else {
            items = cartDAO.getCartByUserId(user.getId());
            if (items == null || items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        double grandTotal = items.stream()
                .mapToDouble(CartItem::getTotalPrice)
                .sum();

        request.setAttribute("cartItems", items);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/user/pay.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}