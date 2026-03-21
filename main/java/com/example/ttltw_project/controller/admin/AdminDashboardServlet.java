package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminDashboardDAO;
import com.example.ttltw_project.dao.admin.NotificationDAO;
import com.example.ttltw_project.dao.user.UserDAO;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        request.setAttribute("unreadNotifyCount", notificationDAO.getUnreadNotificationCount());

        // Thống kê
        request.setAttribute("revenue", dashboardDAO.getTotalRevenue());
        request.setAttribute("pendingOrdersCount", dashboardDAO.countPendingOrders());
        request.setAttribute("lowStock", dashboardDAO.getLowStockCount());
        request.setAttribute("totalStock", dashboardDAO.getTotalStock());

        // Danh sách
        request.setAttribute("recentOrders", dashboardDAO.getRecentOrders());
        request.setAttribute("bestSellers", dashboardDAO.getBestSellers());
        request.setAttribute("userList", userDAO.getAllUsers());

        // Biểu đồ
        List<Map<String, Object>> chartData = dashboardDAO.getRevenueLast7Days();
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();

        for (Map<String, Object> map : chartData) {
            labels.add(map.get("date").toString());
            Object rev = map.get("daily_revenue");
            values.add(rev != null ? Double.parseDouble(rev.toString()) : 0.0);
        }

        request.setAttribute("jsonLabels", new Gson().toJson(labels));
        request.setAttribute("jsonValues", new Gson().toJson(values));

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}