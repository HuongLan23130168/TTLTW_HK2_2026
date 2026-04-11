package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.user.ContactDAO;
import com.example.ttltw_project.model.user.Contact;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminContactServlet", value = "/admin/contacts")
public class AdminContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        ContactDAO dao = new ContactDAO();

        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Contact contact = dao.findById(id);

                request.setAttribute("contact", contact);
                request.getRequestDispatcher("/admin/contactDetail.jsp").forward(request, response);

            } else {
                String search = request.getParameter("search");
                String statusFilter = request.getParameter("statusFilter");

                List<Contact> contactList = dao.getAllContacts(search, statusFilter);

                request.setAttribute("contacts", contactList);
                request.setAttribute("search", search);
                request.setAttribute("statusFilter", statusFilter);

                request.getRequestDispatcher("/admin/contactList.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("mark_replied".equals(action)) {
            try {
                int contactId = Integer.parseInt(request.getParameter("id"));

                ContactDAO dao = new ContactDAO();
                dao.updateStatus(contactId, "REPLIED");


                response.sendRedirect(request.getContextPath() + "/admin/contacts?success=true");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}