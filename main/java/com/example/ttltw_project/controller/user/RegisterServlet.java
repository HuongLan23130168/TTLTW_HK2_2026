package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.UserDAO;

import com.example.ttltw_project.services.EmailService;
import com.example.ttltw_project.util.EncryptionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("/user/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");

        String emailRegex = "^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9.-]+\\.)+(gmail|yahoo|outlook|edu|vn|com)$";

        if (email == null || !email.matches(emailRegex)) {
            request.setAttribute("registerError", "Email không hợp lệ!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        String passRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        if (!password.matches(passRegex)) {
            request.setAttribute("registerError", "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPass)) {
            request.setAttribute("registerError", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        String hashedPass = EncryptionUtils.hashMD5(password);
        UserDAO dao = new UserDAO();

        boolean isSuccess = dao.register(fullName, email, hashedPass);
        if (isSuccess) {
            String token = java.util.UUID.randomUUID().toString();
            dao.updateToken(email, token);

            new EmailService().sendMagicLink(email, token, request.getContextPath());

            request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng kiểm tra Email để kích hoạt tài khoản.");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        } else {
            request.setAttribute("registerError", "Email đã tồn tại!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }
}