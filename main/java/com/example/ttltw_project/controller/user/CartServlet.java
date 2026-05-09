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

@WebServlet(name = "CartServlet", value = "/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDAO dao = new CartDAO();
        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");
        String qtyRaw = request.getParameter("quantity");

        try {
            if (action != null) {

                if ("checkout".equals(action)) {
                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
                }


                if (idRaw != null && !idRaw.isEmpty()) {
                    int variantId = Integer.parseInt(idRaw);
                    if ("delete".equals(action)) {
                        dao.removeItem(user.getId(), variantId);
                    } else if ("update".equals(action) && qtyRaw != null) {
                        int quantity = Integer.parseInt(qtyRaw);
                        dao.updateQuantity(user.getId(), variantId, quantity);
                    }
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }

            List<CartItem> list = dao.getCartByUserId(user.getId());
            double grandTotal = 0;
            int totalQuantity = 0;
            if (list != null) {
                for (CartItem item : list) {
                    grandTotal += item.getTotalPrice();
                    totalQuantity += item.getQuantity();
                }
            }
            request.setAttribute("cartItems", list);
            request.setAttribute("grandTotal", grandTotal);
            session.setAttribute("totalQty", totalQuantity);
            request.getRequestDispatcher("/user/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }
}