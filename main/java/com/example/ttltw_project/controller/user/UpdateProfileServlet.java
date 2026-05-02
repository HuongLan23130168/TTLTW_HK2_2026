package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.UserDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");

        if (user != null) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String birth = request.getParameter("birth");

            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUserInfo(user.getId(), fullName, phone, gender, birth);



            if (success) {
                user.setFullName(fullName);
                user.setPhone(phone);

                //  set ns và gt cho user
                user.setGender(gender);
                user.setBirth(birth);


                session.setAttribute("acc", user);

                response.sendRedirect(request.getContextPath() + "/account?msg=update_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/account?msg=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

}