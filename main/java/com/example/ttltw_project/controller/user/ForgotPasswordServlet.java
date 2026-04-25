package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.UserDAO;
import com.example.ttltw_project.services.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();

        if (dao.checkEmailExists(email)) {
            String token = java.util.UUID.randomUUID().toString();

            dao.updateResetToken(email, token);

            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" +
                    request.getServerPort() + request.getContextPath() +
                    "/reset-password?token=" + token;

            String content = "Chào bạn, vui lòng nhấn vào link sau để đặt lại mật khẩu: " + resetLink;
            EmailService emailService = new EmailService();
            emailService.sendEmail(email, "Đặt lại mật khẩu", resetLink);

            request.setAttribute("successMessage", "Link đặt lại mật khẩu đã được gửi vào Email của bạn!");
            request.getRequestDispatcher("/user/forgot.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Email này không tồn tại trong hệ thống!");
            request.getRequestDispatcher("/user/forgot.jsp").forward(request, response);
        }
    }
}