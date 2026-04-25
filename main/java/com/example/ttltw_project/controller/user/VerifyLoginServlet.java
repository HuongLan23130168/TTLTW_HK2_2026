package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.dao.user.UserDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "VerifyLoginServlet", value = "/verify-login")
public class VerifyLoginServlet extends HttpServlet {


    private static final boolean DEV_MODE = true;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDAO dao = new UserDAO();

        boolean success = dao.activateUser(token);

        if (success) {
            request.setAttribute("successMessage", "Kích hoạt thành công! Mời bạn đăng nhập.");
        } else {
            request.setAttribute("errorMessage", "Link xác thực không hợp lệ hoặc đã hết hạn.");
        }
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}