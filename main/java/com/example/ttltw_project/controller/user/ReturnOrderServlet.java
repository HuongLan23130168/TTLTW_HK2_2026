package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.admin.OrderDAO;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet(name = "ReturnOrderServlet", urlPatterns = "/user/returnOrder")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 100,
        maxRequestSize = 1024 * 1024 * 130
)
public class ReturnOrderServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User authUser = (User) session.getAttribute("acc");
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String feedback = req.getParameter("feedback");
            Part imagePart = req.getPart("returnImage");
            Part videoPart = req.getPart("returnVideo");

            if (feedback == null || feedback.trim().isEmpty() || !isImage(imagePart) || !isVideo(videoPart)) {
                resp.sendRedirect(req.getContextPath() + "/account?status=done&error=invalid_return_request");
                return;
            }

            String uploadPath = getUploadPath(req);
            String imageUrl = saveFile(imagePart, uploadPath);
            String videoUrl = saveFile(videoPart, uploadPath);

            boolean created = orderDAO.createReturnRequest(orderId, authUser.getId(), imageUrl, videoUrl, feedback.trim());
            if (created) {
                resp.sendRedirect(req.getContextPath() + "/account?status=all&msg=return_requested");
            } else {
                resp.sendRedirect(req.getContextPath() + "/account?status=done&error=return_not_allowed");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/account?status=done&error=invalid_order");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/account?status=done&error=system");
        }
    }

    private boolean isImage(Part part) {
        return part != null && part.getSize() > 0 && part.getContentType() != null && part.getContentType().startsWith("image/");
    }

    private boolean isVideo(Part part) {
        return part != null && part.getSize() > 0 && part.getContentType() != null && part.getContentType().startsWith("video/");
    }

    private String getUploadPath(HttpServletRequest req) {
        String applicationPath = req.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + "returns";
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        return uploadFilePath;
    }

    private String saveFile(Part filePart, String uploadPath) throws IOException {
        String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileName = System.currentTimeMillis() + "_" + submittedFileName;
        filePart.write(uploadPath + File.separator + fileName);
        return UPLOAD_DIR + "/returns/" + fileName;
    }
}
