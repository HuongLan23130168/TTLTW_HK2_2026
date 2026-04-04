package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.admin.Order;
import com.example.ttltw_project.model.admin.OrderItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "AdminOrderDetailServlet", value = "/admin/order-detail")
public class AdminOrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy ID
        String idParam = request.getParameter("id");

        //  Kiểm tra nếu rỗng/null  quay về trang danh sách
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            //  chuyển id sang số nguyên
            int orderId = Integer.parseInt(idParam);

            // Lấy thông tin đơn hàng từ database
            Order order = orderDAO.getOrderById(orderId);

            // Không tìm thấy báo lỗi
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=notfound");
                return;
            }

            // Lấy danh sách sản phẩm
            List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            request.getRequestDispatcher("/admin/viewOrder.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu ID không phải là số hợp lệ
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

}