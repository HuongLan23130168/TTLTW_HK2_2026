package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.NotificationDAO;
import com.example.ttltw_project.model.admin.Notification;
import com.example.ttltw_project.model.user.Product;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "AdminNotificationServlet", value = "/admin/notifications")
public class AdminNotificationServlet extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("markAllRead")) {
                notificationDAO.markAllAsRead();
                response.sendRedirect(request.getContextPath() + "/admin/notifications");
                return;
            } else if (action.equals("deleteAll")) {
                notificationDAO.deleteAllNotifications();
                response.sendRedirect(request.getContextPath() + "/admin/notifications");
                return;
            }
        }

        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "all";
        }
        request.setAttribute("notifications", notificationDAO.getNotifications(filter));
        request.setAttribute("currentFilter", filter);

        List<Notification> notifications = notificationDAO.getNotifications(filter);


        request.getRequestDispatcher("/admin/notifi.jsp").forward(request, response);
    }

    public void notifyNewProductAdded(Product product, User admin) {
        Notification notif = new Notification();
        notif.setUserId(admin.getId());
        notif.setTitle("Sản phẩm mới");
        notif.setContent("Sản phẩm '" + product.getProduct_name() + "' vừa được thêm vào kho.");
        notif.setType("product");
        notif.setStatus("unread");

        notif.setEntityId(product.getId());

        notificationDAO.addNotification(notif);
    }
}