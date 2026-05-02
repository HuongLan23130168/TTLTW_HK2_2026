package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminCustomerDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCustomerServlet", value = "/AdminCustomerServlet")
public class AdminCustomerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "newest";
        }

        String search = request.getParameter("search");

        try {
            AdminCustomerDAO dao = new AdminCustomerDAO();
            List<User> customerList = dao.getAllCustomers(sortBy, search);

            // Gửi dữ liệu sang JSP
            request.setAttribute("customers", customerList);
            request.setAttribute("currentSort", sortBy);
            request.setAttribute("search", search);


            request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console server để debug
            response.getWriter().println("Lỗi Server: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}