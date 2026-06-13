package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminProductDAO;
import com.example.ttltw_project.model.user.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductServlet", value = "/admin/products")
public class AdminProductServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            AdminProductDAO dao = new AdminProductDAO();

            String keyword = request.getParameter("keyword");

            int page = 1;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int totalProducts = dao.getTotalProductCount(keyword);
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);


            List<Product> list = dao.getProducts(keyword, page, PAGE_SIZE);


            request.setAttribute("products", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("keyword", keyword);


            String msg = request.getParameter("msg");
            if (msg != null) {
                switch (msg) {
                    case "added" -> request.setAttribute("alertMessage", "Thêm sản phẩm mới thành công!");
                    case "updated" -> request.setAttribute("alertMessage", "Cập nhật sản phẩm thành công!");
                    case "deleted" -> request.setAttribute("alertMessage", "Đã xóa sản phẩm khỏi hệ thống!");
                }
                request.setAttribute("alertType", "success");
            }

            String error = request.getParameter("error");
            if (error != null) {
                request.setAttribute("alertMessage", "Thao tác thất bại: " + error);
                request.setAttribute("alertType", "danger");
            }

            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("alertMessage", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("alertType", "danger");
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}