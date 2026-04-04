package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminProductDAO;
import com.example.ttltw_project.dao.user.CategoryDAO;
import com.example.ttltw_project.dao.user.ProductTypeDAO;
import com.example.ttltw_project.model.user.Category;
import com.example.ttltw_project.model.user.Product;
import com.example.ttltw_project.model.user.ProductType;
import com.example.ttltw_project.model.user.Product_variant;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminEditProductServlet", value = "/admin/editProduct")
public class AdminEditProductServlet extends HttpServlet {

    private final AdminProductDAO productDAO = new AdminProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductTypeDAO typeDAO = new ProductTypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = productDAO.getProductById(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=not_found");
                return;
            }

            List<Product_variant> variants = productDAO.getVariantsByProductId(id);
            List<String> images = productDAO.getGalleryByProductId(id);
            List<Category> allCategories = categoryDAO.getAllCategories();
            List<ProductType> allTypes = typeDAO.getAllTypes();

            request.setAttribute("product", p);
            request.setAttribute("variantList", variants);
            request.setAttribute("imageList", images);
            request.setAttribute("allCategories", allCategories);
            request.setAttribute("allTypes", allTypes);

            request.setAttribute("currentCategoryId", p.getCategory_id());

            request.getRequestDispatcher("/admin/editProducts.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");

        // Kiểm tra ID có tồn tại không
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            Product product = new Product();
            product.setId(id);
            product.setProduct_name(request.getParameter("product_name"));
            product.setProduct_code(request.getParameter("product_code"));
            product.setProduct_type_id(Integer.parseInt(request.getParameter("product_type_id")));
            product.setDescription(request.getParameter("description"));
            product.setImage_url(request.getParameter("image_url"));

            product.setNewProduct(request.getParameter("isNewProduct") != null);
            product.setBestSeller(request.getParameter("isBestSeller") != null);

            String catIdRaw = request.getParameter("category_id");
            if (catIdRaw != null && !catIdRaw.trim().isEmpty()) {
                try {
                    product.setCategory_id(Integer.parseInt(catIdRaw));
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/editProduct?id=" + idParam + "&error=invalid_category");
                    return;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/editProduct?id=" + idParam + "&error=category_required");
                return;
            }

            String[] vIds = request.getParameterValues("variant_ids");
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
                    if (vIds != null && i < vIds.length && vIds[i] != null && !vIds[i].isEmpty()) {
                        v.setId(Integer.parseInt(vIds[i]));
                    }
                    v.setProduct_id(id);
                    v.setColor(colors[i]);
                    v.setSize((sizes != null && i < sizes.length) ? sizes[i] : "");
                    v.setMaterial((materials != null && i < materials.length) ? materials[i] : "");

                    String priceStr = (prices != null && i < prices.length) ? prices[i] : "0";
                    priceStr = priceStr.replaceAll("[^0-9]", "").trim();
                    int finalPrice = priceStr.isEmpty() ? 0 : Integer.parseInt(priceStr);
                    v.setPrice(finalPrice);

                    String stockStr = (stocks != null && i < stocks.length) ? stocks[i].trim() : "0";
                    v.setStock(Integer.parseInt(stockStr.isEmpty() ? "0" : stockStr));

                    variants.add(v);
                }
            }

            String[] otherImagesArr = request.getParameterValues("other_images");
            List<String> otherImages = (otherImagesArr != null) ? new ArrayList<>(Arrays.asList(otherImagesArr)) : new ArrayList<>();

            boolean success = productDAO.updateProductFull(product, variants, otherImages);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/editProduct?id=" + id + "&error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/editProduct?id=" + idParam + "&error=" + e.getMessage());
        }
    }
}