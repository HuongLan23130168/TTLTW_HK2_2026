package com.example.ttltw_project.controller.admin;

import com.example.ttltw_project.dao.admin.AdminBannerDAO;
import com.example.ttltw_project.model.admin.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;


@WebServlet(name = "BannerServlet", value = "/admin/banners")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminBannerServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";
    private final AdminBannerDAO bannerDAO = new AdminBannerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            showEditForm(req, resp);
        } else {
            showBannerList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            handleAddBanner(req, resp);
        } else if ("delete".equals(action)) {
            handleDeleteBanner(req, resp);
        } else if ("update".equals(action)) {
            handleUpdateBanner(req, resp);
        } else if ("restore".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            bannerDAO.restoreBanner(id);
            req.getSession().setAttribute("toastMessage", "Đã khôi phục hiển thị banner thành công!");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect(req.getContextPath() + "/admin/banners");
        }
    }

    private void showBannerList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Banner> bannerList = bannerDAO.getAllBanners();
        req.setAttribute("bannerList", bannerList);
        req.getRequestDispatcher("/admin/banners.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Banner banner = bannerDAO.getBannerById(id);
            req.setAttribute("banner", banner);
            req.getRequestDispatcher("/admin/editBanner.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/banners");
        }
    }

    private void handleAddBanner(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String link = req.getParameter("link");

        String displayOrderParam = req.getParameter("display_order");
        int displayOrder = 1;
        if (displayOrderParam != null && !displayOrderParam.trim().isEmpty()) {
            try {
                displayOrder = Integer.parseInt(displayOrderParam.trim());
            } catch (NumberFormatException e) {
                displayOrder = 1;
            }
        }

        String isActiveParam = req.getParameter("is_active");

        boolean isActive = (isActiveParam == null) || "true".equalsIgnoreCase(isActiveParam.trim());

        String subTitle = req.getParameter("sub_title");
        String subDescription = req.getParameter("sub_description");

        String dbImageUrl = req.getParameter("image_url");
        String dbSubImageUrl = req.getParameter("sub_image_url");

        Banner newBanner = new Banner();
        newBanner.setTitle(title);
        newBanner.setDescription(description);
        newBanner.setImage_url(dbImageUrl != null ? dbImageUrl.trim() : "");
        newBanner.setLink(link != null ? link.trim() : "");
        newBanner.setDisplay_order(displayOrder);
        newBanner.setIs_active(isActive);

        newBanner.setSub_image_url(dbSubImageUrl != null ? dbSubImageUrl.trim() : "");
        newBanner.setSub_title(subTitle);
        newBanner.setSub_description(subDescription);

        req.getSession().setAttribute("toastMessage", "Thêm thiết lập banner mới thành công!");
        req.getSession().setAttribute("toastType", "success");

        bannerDAO.addBanner(newBanner);
        resp.sendRedirect(req.getContextPath() + "/admin/banners");
    }

    private void handleUpdateBanner(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        int id = 0;
        if (idParam != null && !idParam.trim().isEmpty()) {
            id = Integer.parseInt(idParam.trim());
        }

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String link = req.getParameter("link");

        String displayOrderParam = req.getParameter("display_order");
        int displayOrder = 1;
        if (displayOrderParam != null && !displayOrderParam.trim().isEmpty()) {
            try {
                displayOrder = Integer.parseInt(displayOrderParam.trim());
            } catch (NumberFormatException e) {
                displayOrder = 1;
            }
        }

        String isActiveParam = req.getParameter("is_active");
        boolean isActive = (isActiveParam == null) || "true".equalsIgnoreCase(isActiveParam.trim());

        String subTitle = req.getParameter("sub_title");
        String subDescription = req.getParameter("sub_description");

        String dbImageUrl = req.getParameter("image_url");
        String dbSubImageUrl = req.getParameter("sub_image_url");

        Banner banner = new Banner();
        banner.setId(id);
        banner.setTitle(title);
        banner.setDescription(description);
        banner.setImage_url(dbImageUrl != null ? dbImageUrl.trim() : "");
        banner.setLink(link != null ? link.trim() : "");
        banner.setDisplay_order(displayOrder);
        banner.setIs_active(isActive);

        banner.setSub_image_url(dbSubImageUrl != null ? dbSubImageUrl.trim() : "");
        banner.setSub_title(subTitle);
        banner.setSub_description(subDescription);

        req.getSession().setAttribute("toastMessage", "Cập nhật thông tin banner thành công!");
        req.getSession().setAttribute("toastType", "success");

        bannerDAO.updateBanner(banner);
        resp.sendRedirect(req.getContextPath() + "/admin/banners");
    }

    private void handleDeleteBanner(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            bannerDAO.deleteBanner(id);
            req.getSession().setAttribute("toastMessage", "Đã chuyển banner sang trạng thái Tạm ẩn thành công!");
            req.getSession().setAttribute("toastType", "success");
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/banners");
    }


    private String getUploadPath(HttpServletRequest req) {
        String applicationPath = req.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + "banners";
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        return uploadFilePath;
    }

    private String saveFile(Part filePart, String uploadPath) throws IOException {
        if (filePart == null || filePart.getSubmittedFileName() == null || filePart.getSubmittedFileName().isEmpty() || filePart.getSize() <= 0) {
            return "";
        }
        String fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        filePart.write(uploadPath + File.separator + fileName);
        return UPLOAD_DIR + "/banners/" + fileName;
    }
}