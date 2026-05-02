package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.ProductDAO;
import com.example.ttltw_project.model.user.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/detail-product")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        String contextPath = request.getContextPath();

        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(contextPath + "/home");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            Product product = productDAO.getById(id);

            if (product != null) {
                List<Product> related = productDAO.getRelatedProducts(product.getProduct_type_id(), id);

                request.setAttribute("product", product);
                request.setAttribute("relatedProducts", related);

                request.getRequestDispatcher("/user/detail.jsp").forward(request, response);
            } else {
                System.out.println("DEBUG: Không tìm thấy sản phẩm ID = " + id);
                response.sendRedirect(contextPath + "/home?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(contextPath + "/home?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}