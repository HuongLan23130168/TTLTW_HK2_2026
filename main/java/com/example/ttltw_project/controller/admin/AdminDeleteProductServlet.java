package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminDeleteProductServlet", value = "/admin/deleteProduct")
public class AdminDeleteProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String action = request.getParameter("action"); // Bắt buộc phải có dòng này

            AdminProductDAO dao = new AdminProductDAO();

            if ("restore".equals(action)) {
                dao.restoreProduct(id);
                request.getSession().setAttribute("toastMessage", "Đã hiển thị lại sản phẩm thành công!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                dao.softDeleteProduct(id);
                request.getSession().setAttribute("toastMessage", "Đã tạm ẩn sản phẩm thành công!");
                request.getSession().setAttribute("toastType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Thao tác thất bại. Vui lòng kiểm tra lại!");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}