package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminCustomerDAO;
import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "CustomerDetailServlet", value = "/admin/customer-detail")
public class AdminCustomerDetailServlet extends HttpServlet {
    private final AdminCustomerDAO customerDAO = new AdminCustomerDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customers");
            return;
        }

        try {
            int customerId = Integer.parseInt(idParam);
            User customer = customerDAO.getCustomerById(customerId);

            if (customer == null) {
                request.setAttribute("error", "Không tìm thấy khách hàng với ID: " + customerId);
                response.sendRedirect(request.getContextPath() + "/admin/customers?error=notfound");
                return;
            }

            List<Order> orderList = orderDAO.getOrdersByCustomerId(customerId);

            double totalSpent = orderList.stream()
                    .mapToDouble(Order::getTotalPrice)
                    .sum();

            Order latestOrder = orderList.isEmpty() ? null : orderList.get(0);

            request.setAttribute("customer", customer);
            request.setAttribute("orderList", orderList);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("latestOrder", latestOrder);

            request.getRequestDispatcher("/admin/customerDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}