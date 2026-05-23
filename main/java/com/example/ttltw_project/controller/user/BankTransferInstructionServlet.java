package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.model.admin.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BankTransferInstructionServlet", value = "/bank-transfer-instruction")
public class BankTransferInstructionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String orderCode = (String) session.getAttribute("pendingOrderCode");
        Double totalAmount = (Double) session.getAttribute("pendingOrderTotal");
        List<OrderItem> orderItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");
        String orderName = (String) session.getAttribute("pendingOrderName");
        String orderPhone = (String) session.getAttribute("pendingOrderPhone");
        String orderEmail = (String) session.getAttribute("pendingOrderEmail");
        String orderAddress = (String) session.getAttribute("pendingOrderAddress");
        Double shippingFee = (Double) session.getAttribute("pendingShippingFee");
        String shippingType = (String) session.getAttribute("pendingShippingType");
        String orderNote = (String) session.getAttribute("pendingOrderNote");

        if (orderCode == null || totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.setAttribute("orderCode", orderCode);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("orderName", orderName);
        request.setAttribute("orderPhone", orderPhone);
        request.setAttribute("orderEmail", orderEmail);
        request.setAttribute("orderAddress", orderAddress);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("shippingType", shippingType);
        request.setAttribute("orderNote", orderNote);

        session.removeAttribute("pendingOrderCode");
        session.removeAttribute("pendingOrderTotal");
        session.removeAttribute("pendingOrderItems");
        session.removeAttribute("pendingOrderName");
        session.removeAttribute("pendingOrderPhone");
        session.removeAttribute("pendingOrderEmail");
        session.removeAttribute("pendingOrderAddress");
        session.removeAttribute("pendingShippingFee");
        session.removeAttribute("pendingShippingType");
        session.removeAttribute("pendingOrderNote");

        request.getRequestDispatcher("/user/bank-transfer.jsp").forward(request, response);
    }
}