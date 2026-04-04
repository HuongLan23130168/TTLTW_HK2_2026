package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminDiscountDAO;
import com.example.ttltw_project.dao.admin.AdminProductDAO;
import com.example.ttltw_project.dao.user.CategoryDAO;
import com.example.ttltw_project.dao.user.ProductTypeDAO;
import com.example.ttltw_project.model.user.Category;
import com.example.ttltw_project.model.user.Discount;
import com.example.ttltw_project.model.user.Product;
import com.example.ttltw_project.model.user.ProductType;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.jdbi.v3.core.JdbiException;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "AdminDiscountProductServlet", value = "/admin/discounts")
public class AdminDiscountProductServlet extends HttpServlet {

    private final AdminDiscountDAO discountDAO = new AdminDiscountDAO();
    private final AdminProductDAO productDAO = new AdminProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductTypeDAO typeDAO = new ProductTypeDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Discount discountToEdit = discountDAO.getById(id);
                if (discountToEdit != null) {
                    request.setAttribute("discountToEdit", discountToEdit);
                }
            } else {
                request.setAttribute("discountToEdit", new Discount());
            }
            listDiscounts(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        System.out.println("DEBUG - Action: " + action + " | ID: " + request.getParameter("id"));

        try {
            if ("insert".equals(action)) {
                insertDiscount(request, response);
            } else if ("update".equals(action)) {
                updateDiscount(request, response);
            } else if ("delete".equals(action)) {
                deleteDiscount(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/discounts");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi thực thi: " + e.getMessage());
            listDiscounts(request, response);
        }

    }

    private void listDiscounts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Discount> list = discountDAO.getAll();
        request.setAttribute("discountList", list);
        List<Product> productList = productDAO.getAllProductsSimple();
        List<Category> categoryList = categoryDAO.getAllCategories();
        List<ProductType> typeList = typeDAO.getAllTypes();
        request.setAttribute("products", productList);
        request.setAttribute("categories", categoryList);
        request.setAttribute("types", typeList);
        request.getRequestDispatcher("/admin/discountProducts.jsp").forward(request, response);
    }

    private void deleteDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException, JdbiException {
        int id = Integer.parseInt(request.getParameter("id"));
        discountDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?msg=deleted");
    }

    private void insertDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException, JdbiException {
        Discount d = extractFromRequest(request);
        String scope = request.getParameter("scope");
        List<Integer> targetIds = getTargetIds(request, scope);
        discountDAO.insert(d, scope, targetIds);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?msg=inserted");
    }


    private void updateDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty() || "0".equals(idStr)) {
                throw new IllegalArgumentException("Không tìm thấy ID hợp lệ để cập nhật!");
            }

            int id = Integer.parseInt(idStr);
            Discount d = extractFromRequest(request);
            d.setId(id);

            String scope = request.getParameter("scope");
            List<Integer> targetIds = getTargetIds(request, scope);

            discountDAO.update(d, scope, targetIds);
            response.sendRedirect(request.getContextPath() + "/admin/discounts?msg=updated");

        } catch (Exception e) {
            throw new ServletException(e.getMessage());
        }
    }
    private List<Integer> getTargetIds(HttpServletRequest request, String scope) {
        if (scope == null || "none".equals(scope)) {
            return new ArrayList<>();
        }
        String[] idsStr = null;
        switch (scope) {
            case "category" -> idsStr = request.getParameterValues("target_id_category");
            case "type" -> idsStr = request.getParameterValues("target_id_type");
        }
        if (idsStr != null) {
            return Arrays.stream(idsStr).map(Integer::parseInt).collect(Collectors.toList());
        }
        return new ArrayList<>();
    }

    private Discount extractFromRequest(HttpServletRequest request) {
        Discount d = new Discount();
        d.setDiscount_code(request.getParameter("discount_code"));
        d.setDiscount_name(request.getParameter("discount_name"));
        d.setDescription(request.getParameter("description"));
        try {
            String percentStr = request.getParameter("discount_percent");
            if (percentStr != null && !percentStr.isEmpty()) {
                d.setDiscount_percent(Integer.parseInt(percentStr));
            } else {
                d.setDiscount_percent(0);
            }
        } catch (NumberFormatException e) {
            d.setDiscount_percent(0);
        }
        try {
            String startStr = request.getParameter("start_date");
            String endStr = request.getParameter("end_date");
            if (startStr != null && !startStr.isEmpty())
                d.setStart_date(Timestamp.valueOf(LocalDateTime.parse(startStr)));
            if (endStr != null && !endStr.isEmpty()) d.setEnd_date(Timestamp.valueOf(LocalDateTime.parse(endStr)));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return d;
    }
}