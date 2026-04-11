package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AddToCartServlet", value = "/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String vIdRaw = request.getParameter("variantId");
        String qtyRaw = request.getParameter("quantity");

        String redirectAction = request.getParameter("redirectAction");

        try {
            if (vIdRaw != null && !vIdRaw.isEmpty()) {
                int variantId = Integer.parseInt(vIdRaw);
                int quantity = Integer.parseInt(qtyRaw);

                CartDAO dao = new CartDAO();

                if ("buy".equals(redirectAction)) {

                    session.setAttribute("buyNow_variantId", variantId);
                    session.setAttribute("buyNow_quantity", quantity);

                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
                }

                String result = dao.addToCart(user.getId(), variantId, quantity);
                if ("Success".equals(result)) {
                    int newTotal = dao.getTotalQuantityByUserId(user.getId());
                    session.setAttribute("totalQty", newTotal);
                    session.setAttribute("msg", "Đã thêm vào giỏ hàng!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");
    }
}