package com.example.ttltw_project.controller.user;


import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.dao.user.AddressDAO;
import com.example.ttltw_project.dao.user.UserDAO;
import com.example.ttltw_project.model.user.Address;
import com.example.ttltw_project.model.user.User;
import com.example.ttltw_project.model.user.UserOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AccountServlet", urlPatterns = "/account")
public class AccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User authUser = (User) session.getAttribute("acc");

        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User currentUser = userDAO.getUserWithAddress(authUser.getEmail());
        req.setAttribute("user", currentUser);


        AddressDAO addressDAO = new AddressDAO();
        List<Address> listAddresses = addressDAO.getByUserId(authUser.getId());
        req.setAttribute("listAddresses", listAddresses);

        OrderDAO orderDAO = new OrderDAO();
        List<UserOrder> allOrders = orderDAO.getMyOrders(authUser.getId());

        String statusParam = req.getParameter("status");
        List<UserOrder> filteredOrders = new ArrayList<>();

        String activePage = "profile";

        String paramPage = req.getParameter("activePage");
        if(paramPage != null && !paramPage.isEmpty()){
            activePage = paramPage;
        }

        if (statusParam == null || statusParam.equals("all")) {
            filteredOrders = allOrders;
            if (statusParam != null) activePage = "orders";
        } else {
            activePage = "orders";

            for (UserOrder order : allOrders) {
                String dbStatus = order.getStatus() != null ? order.getStatus().toLowerCase().trim() : "";
                boolean isMatch = false;

                switch (statusParam) {
                    case "wait":
                        if (dbStatus.contains("chờ")) {
                            isMatch = true;
                        }
                        break;

                    case "shipping":
                        if (dbStatus.contains("đang") || dbStatus.contains("vận chuyển")) {
                            isMatch = true;
                        }
                        break;

                    case "done":
                        if (dbStatus.contains("đã giao") || dbStatus.contains("hoàn thành") || dbStatus.contains("thành công")) {
                            isMatch = true;
                        }
                        break;

                    case "cancel":
                        if (dbStatus.contains("hủy") || "APPROVED".equals(order.getReturnStatus())) {
                            isMatch = true;
                        }
                        break;
                }

                if (isMatch) {
                    filteredOrders.add(order);
                }
            }
        }

        req.setAttribute("orders", filteredOrders);
        req.setAttribute("activePage", activePage);

        req.getRequestDispatcher("/user/account.jsp").forward(req, resp);
    }
}
