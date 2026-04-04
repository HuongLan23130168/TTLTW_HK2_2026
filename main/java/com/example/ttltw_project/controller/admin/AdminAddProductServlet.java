package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminProductDAO;
import com.example.ttltw_project.dao.user.CategoryDAO;
import com.example.ttltw_project.dao.user.ProductTypeDAO;
import com.example.ttltw_project.model.user.*;
import com.example.ttltw_project.services.NotificationService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminAddProductServlet", value = "/admin/addProduct")
public class AdminAddProductServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductTypeDAO typeDAO = new ProductTypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Category> categoryList = categoryDAO.getAllCategories();
            List<ProductType> typeList = typeDAO.getAllTypes();
            request.setAttribute("categories", categoryList);
            request.setAttribute("types", typeList);
            request.getRequestDispatcher("/admin/addProducts.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=load_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        NotificationService notificationService = new NotificationService();

        try {
            Product product = new Product();
            product.setProduct_name(request.getParameter("product_name"));
            product.setProduct_code(request.getParameter("product_code"));
            product.setProduct_type_id(Integer.parseInt(request.getParameter("product_type_id")));
            product.setDescription(request.getParameter("description"));
            product.setImage_url(request.getParameter("image_url"));

            product.setNewProduct(request.getParameter("isNewProduct") != null);
            product.setBestSeller(request.getParameter("isBestSeller") != null);


            String[] catIds = request.getParameterValues("category_id");
            if (catIds != null && catIds.length > 0) {
                product.setCategory_id(Integer.parseInt(catIds[0]));
            } else {
                product.setCategory_id(0);
            }

            String[] colors = request.getParameterValues("colors");
            String[] sizes = request.getParameterValues("sizes");
            String[] materials = request.getParameterValues("materials");
            String[] prices = request.getParameterValues("prices");
            String[] stocks = request.getParameterValues("stocks");

            List<Product_variant> variants = new ArrayList<>();
            if (colors != null) {
                for (int i = 0; i < colors.length; i++) {
                    if (colors[i] == null || colors[i].trim().isEmpty()) continue;

                    Product_variant v = new Product_variant();
                    v.setVariant_code(product.getProduct_code() + "-" + (i + 1));
                    v.setColor(colors[i]);
                    v.setSize((sizes != null && i < sizes.length) ? sizes[i] : "");
                    v.setMaterial((materials != null && i < materials.length) ? materials[i] : "");


                    String rawPrice = (prices != null && i < prices.length) ? prices[i] : "0";
                    rawPrice = rawPrice.replaceAll("[^0-9]", "").trim();
                    v.setPrice(rawPrice.isEmpty() ? 0 : Integer.parseInt(rawPrice));

                    String rawStock = (stocks != null && i < stocks.length) ? stocks[i] : "0";
                    rawStock = rawStock.replaceAll("[^0-9]", "").trim();
                    v.setStock(rawStock.isEmpty() ? 0 : Integer.parseInt(rawStock));

                    variants.add(v);
                }
            }

            String[] otherImagesArr = request.getParameterValues("other_images");
            List<String> otherImages = (otherImagesArr != null) ? new ArrayList<>(Arrays.asList(otherImagesArr)) : new ArrayList<>();

            AdminProductDAO dao = new AdminProductDAO();
            boolean success = dao.insertProductFull(product, variants, otherImages);
            User adminUser = (User) request.getSession().getAttribute("acc");

            if (success) {
                notificationService.notifyNewProductAdded(product, adminUser);
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=added");
            } else {
                request.setAttribute("error", "Thêm sản phẩm thất bại.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/addProduct?error=" + e.getMessage());
        }
    }
}