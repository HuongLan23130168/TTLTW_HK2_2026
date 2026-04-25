package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import static com.example.ttltw_project.util.EncryptionUtils.hashMD5;

@WebServlet(name = "ResetPasswordServlet", value = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDAO dao = new UserDAO();

        if (token != null && dao.isResetTokenValid(token)) {
            request.setAttribute("token", token);
            request.getRequestDispatcher("/user/newPass.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Liên kết không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPass = request.getParameter("newPassword");
        String passwordPattern = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

        UserDAO dao = new UserDAO();
        String email = dao.getEmailByToken(token);

        if (newPass == null || !newPass.matches(passwordPattern)) {
            request.setAttribute("errorMessage", "Mật khẩu không đúng định dạng bảo mật!");
            request.getRequestDispatcher("/user/newPass.jsp").forward(request, response);
            return;
        }

        if (email != null) {
            String hashPassword = hashMD5(newPass);
            boolean success = dao.updatePassword(email, hashPassword);

            if (success) {
                dao.clearResetToken(email);
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Lỗi DB, vui lòng thử lại.");
                request.getRequestDispatcher("/user/newPass.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Phiên làm việc hết hạn!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }
}