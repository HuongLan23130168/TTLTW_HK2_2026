package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "AdminDeleteProductServlet", value = "/admin/deleteProduct")
public class AdminDeleteProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            int id = Integer.parseInt(request.getParameter("id"));
            AdminProductDAO dao = new AdminProductDAO();
            dao.softDeleteProduct(id);

            response.sendRedirect(request.getContextPath() + "/admin/products?msg=deleted");
        }

        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=delete_failed");
        }
    }
}