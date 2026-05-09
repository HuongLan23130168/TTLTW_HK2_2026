package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.dao.user.UserDAO;
import com.example.ttltw_project.model.user.User;
import com.example.ttltw_project.services.EmailService;
import com.example.ttltw_project.util.EncryptionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String hashedPass = EncryptionUtils.hashMD5(password);

        UserDAO dao = new UserDAO();
        User user = dao.login(email, hashedPass);

        if (user != null) {
            if (user.getStatus() == 1) {
                HttpSession session = request.getSession(true);
                session.setAttribute("acc", user);

                if ("2".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("errorMessage", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email!");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }

    }
}
