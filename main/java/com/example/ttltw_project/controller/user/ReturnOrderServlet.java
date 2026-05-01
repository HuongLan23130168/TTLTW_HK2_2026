package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/return-order")
@MultipartConfig
public class ReturnOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String reason = request.getParameter("reason");
        String bankAccount = request.getParameter("bankAccount");

        Part filePart = request.getPart("returnImage");

        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        String uploadPath = getServletContext().getRealPath("/uploads");

        File uploadDir = new File(uploadPath);
        if(!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + fileName);

        String imageUrl = "uploads/" + fileName;

        boolean success = orderDAO.createReturnOrder(
                orderId,
                user.getId(),
                reason,
                imageUrl,
                bankAccount
        );

        if(success){
            response.sendRedirect("account?activePage=orders&msg=return_success");
        }else{
            response.sendRedirect("account?activePage=orders&error=return_failed");
        }

    }
}