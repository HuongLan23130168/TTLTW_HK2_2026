package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "AdminOrderServlet", value = "/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "newest";
        }

        String search = request.getParameter("search");

        List<Order> orderList = orderDAO.getAllOrders(sortBy, search);

        System.out.println("DEBUG: Search='" + search + "', Sort='" + sortBy + "', Found=" + (orderList != null ? orderList.size() : 0));

        request.setAttribute("orders", orderList);
        request.setAttribute("currentSort", sortBy);
        request.setAttribute("search", search);

        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}