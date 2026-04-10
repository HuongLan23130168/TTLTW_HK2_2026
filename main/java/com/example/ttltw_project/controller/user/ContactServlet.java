package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.ContactDAO;
import com.example.ttltw_project.model.user.Contact;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "ContactServlet", value = "/ContactServlet")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("full_name");
        String email = req.getParameter("email");
        String message = req.getParameter("message");

        Contact contact = new Contact();
        contact.setFullName(fullName);
        contact.setEmail(email);
        contact.setMessage(message);
        contact.setStatus("NEW");

        ContactDAO.insert(contact);



        // resp.sendRedirect("contact.jsp?success=true");

        resp.sendRedirect(req.getContextPath() + "/frontend/contact.jsp?success=true");

    }
}

