package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminDashboardDAO;
import com.example.ttltw_project.dao.admin.NotificationDAO;
import com.example.ttltw_project.dao.user.UserDAO;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String filter = request.getParameter("filter");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        if (filter == null || filter.isEmpty()) {
            filter = "week";
        }

        request.setAttribute("currentFilter", filter);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.setAttribute("unreadNotifyCount", notificationDAO.getUnreadNotificationCount());
        request.setAttribute("revenue", dashboardDAO.getTotalRevenue());
        request.setAttribute("pendingOrdersCount", dashboardDAO.countPendingOrders());
        request.setAttribute("lowStock", dashboardDAO.getLowStockCount());
        request.setAttribute("totalStock", dashboardDAO.getTotalStock());
        request.setAttribute("recentOrders", dashboardDAO.getRecentOrders());
        request.setAttribute("bestSellers", dashboardDAO.getBestSellers());
        request.setAttribute("userList", userDAO.getAllUsers());

        List<Map<String, Object>> chartData;
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();

        if ("custom".equals(filter) && fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            chartData = dashboardDAO.getRevenueByDateRange(fromDate, toDate);

            LocalDate start = LocalDate.parse(fromDate);
            LocalDate end = LocalDate.parse(toDate);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM");

            Map<String, Double> revenueMap = new LinkedHashMap<>();
            for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
                revenueMap.put(date.format(formatter), 0.0);
            }

            for (Map<String, Object> map : chartData) {
                String label = map.get("label").toString();
                Double revenue = Double.parseDouble(map.get("revenue").toString());
                revenueMap.put(label, revenue);
            }

            labels = new ArrayList<>(revenueMap.keySet());
            values = new ArrayList<>(revenueMap.values());
        } else {
            chartData = dashboardDAO.getRevenueByFilter(filter);
            LocalDate today = LocalDate.now();

            switch (filter) {
                case "week":
                    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
                    Map<String, Double> weekMap = new LinkedHashMap<>();
                    for (int i = 6; i >= 0; i--) {
                        weekMap.put(today.minusDays(i).format(dayFormatter), 0.0);
                    }
                    for (Map<String, Object> map : chartData) {
                        weekMap.put(map.get("label").toString(), Double.parseDouble(map.get("revenue").toString()));
                    }
                    labels = new ArrayList<>(weekMap.keySet());
                    values = new ArrayList<>(weekMap.values());
                    break;

                case "month":
                    DateTimeFormatter monthDayFormatter = DateTimeFormatter.ofPattern("dd/MM");
                    Map<String, Double> monthMap = new LinkedHashMap<>();
                    for (int i = 29; i >= 0; i--) {
                        monthMap.put(today.minusDays(i).format(monthDayFormatter), 0.0);
                    }
                    for (Map<String, Object> map : chartData) {
                        monthMap.put(map.get("label").toString(), Double.parseDouble(map.get("revenue").toString()));
                    }
                    labels = new ArrayList<>(monthMap.keySet());
                    values = new ArrayList<>(monthMap.values());
                    break;

                case "year":
                    DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM/yyyy");
                    Map<String, Double> yearMap = new LinkedHashMap<>();
                    for (int i = 11; i >= 0; i--) {
                        yearMap.put(today.minusMonths(i).format(monthFormatter), 0.0);
                    }
                    for (Map<String, Object> map : chartData) {
                        yearMap.put(map.get("label").toString(), Double.parseDouble(map.get("revenue").toString()));
                    }
                    labels = new ArrayList<>(yearMap.keySet());
                    values = new ArrayList<>(yearMap.values());
                    break;
            }
        }

        request.setAttribute("jsonLabels", new Gson().toJson(labels));
        request.setAttribute("jsonValues", new Gson().toJson(values));

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
