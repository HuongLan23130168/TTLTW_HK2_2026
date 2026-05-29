package com.example.ttltw_project.controller.webhook;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ShippingWebhookServlet", value = "/api/webhook/shipping")
public class ShippingWebhookServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        try {
            // Đọc body request
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            String body = sb.toString();
            System.out.println("Webhook received: " + body);

            Map<String, Object> data = gson.fromJson(body, Map.class);

            // Lấy dữ liệu
            String orderCode = (String) data.get("order_code");
            String shippingStatus = (String) data.get("status");
            String trackingNumber = (String) data.get("tracking_number");
            String note = (String) data.get("note");

            if (orderCode == null || shippingStatus == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Missing order_code or status\"}");
                return;
            }

            boolean success = orderDAO.updateFromShippingWebhook(orderCode, shippingStatus, trackingNumber, note);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Order not found\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    // GHN webhook mẫu
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.getWriter().write("Webhook endpoint is running");
    }
}