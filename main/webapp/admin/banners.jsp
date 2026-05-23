<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Quản lý Banner Hệ Thống</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/banners.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="banner-header">
        <h1>Quản lý Banner & Khuyến Mãi</h1>
    </div>

    <div class="form-card">
        <h2>Thêm Thiết Lập Banner Mới</h2>
        <form action="${pageContext.request.contextPath}/admin/banners" method="post" class="add-banner-form">
            <input type="hidden" name="action" value="add">

            <div class="form-grid">
                <div class="form-section-title"><h3><i class="fas fa-image"></i> Banner Chính</h3></div>

                <div class="form-group">
                    <label for="title">Tiêu đề chính</label>
                    <input type="text" id="title" name="title" placeholder="VD: BST Nội thất mùa Thu" required>
                </div>

                <div class="form-group">
                    <label for="image_url">Đường dẫn ảnh Banner chính (URL) <span style="color:red">*</span></label>
                    <div style="position: relative;">
                        <i class="fas fa-link" style="position: absolute; left: 12px; top: 12px; color: #888;"></i>
                        <input type="url" id="image_url" name="image_url" placeholder="https://example.com/banner-main.jpg" required style="padding-left: 35px;">
                    </div>
                    <div id="main-preview-container" style="margin-top: 10px; min-height: 25px;"></div>
                </div>

                <div class="form-group">
                    <label for="link">Đường dẫn khi click</label>
                    <input type="text" id="link" name="link" placeholder="/collections/new-arrival">
                </div>

                <div class="form-group form-group-full">
                    <label for="description">Mô tả chính</label>
                    <textarea id="description" name="description" rows="2"></textarea>
                </div>

                <div class="form-section-title"><h3><i class="fas fa-ad"></i> Banner Phụ (Promo Side)</h3></div>

                <div class="form-group">
                    <label for="sub_title">Tiêu đề phụ</label>
                    <input type="text" id="sub_title" name="sub_title" placeholder="VD: Sale 50%">
                </div>

                <div class="form-group">
                    <label for="sub_image_url">Đường dẫn ảnh Banner phụ (URL)</label>
                    <div style="position: relative;">
                        <i class="fas fa-link" style="position: absolute; left: 12px; top: 12px; color: #888;"></i>
                        <input type="url" id="sub_image_url" name="sub_image_url" placeholder="https://example.com/banner-sub.jpg" style="padding-left: 35px;">
                    </div>
                    <div id="sub-preview-container" style="margin-top: 10px; min-height: 25px;"></div>
                </div>

                <div class="form-group">
                    <label for="sub_description">Mô tả phụ</label>
                    <input type="text" id="sub_description" name="sub_description" placeholder="VD: Dành cho khách hàng mới">
                </div>
            </div>

            <div class="form-actions">
                <button type="reset" class="btn" style="background-color: #e9ecef; color: #495057;">
                    <i class="fas fa-redo"></i> Làm lại
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Thêm Banner
                </button>
            </div>

    <div class="table-container">
        <table class="data-table">
            <thead>
            <tr>
                <th>Thứ tự</th>
                <th>Ảnh Chính</th>
                <th>Ảnh Phụ</th>
                <th>Thông tin Banner</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${bannerList}" var="banner">
                <tr class="${not banner.is_active ? 'row-inactive' : ''}">
                    <td class="text-center"><strong>${banner.display_order}</strong></td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty banner.image_url}">
                                <img src="${pageContext.request.contextPath}/${banner.image_url}" class="banner-thumbnail" alt="Main">
                            </c:when>
                            <c:otherwise>
                                <div class="no-image-placeholder">
                                    <i class="fas fa-image"></i> <span>Trống</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty banner.sub_image_url}">
                                <img src="${pageContext.request.contextPath}/${banner.sub_image_url}" class="banner-thumbnail small-thumb" alt="Sub">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted"><i class="fas fa-ban"></i> Trống</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <div class="info-cell">
                            <strong>${not empty banner.title ? banner.title : 'Chưa có tiêu đề'}</strong>
                            <div class="sub-info">
                                <c:if test="${not empty banner.sub_title}">
                                    <small>Phụ: ${banner.sub_title}</small><br>
                                </c:if>
                                <small>Link: ${not empty banner.link ? banner.link : '#'}</small>
                            </div>
                        </div>
                    </td>

                    <td>
            <span class="status-badge ${banner.is_active ? 'active' : 'inactive'}">
                    ${banner.is_active ? 'Hiển thị' : 'Đang ẩn'}
            </span>
                    </td>

                    <td class="actions">
                        <c:choose>
                            <c:when test="${banner.is_active}">
                                <a href="${pageContext.request.contextPath}/admin/banners?action=edit&id=${banner.id}" class="btn btn-sm btn-edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/banners" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${banner.id}">
                                    <button type="submit" class="btn btn-sm btn-delete" onclick="return confirm('Ẩn banner này?')">
                                        <i class="fas fa-eye-slash"></i>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/admin/banners" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="restore">
                                    <input type="hidden" name="id" value="${banner.id}">
                                    <button type="submit" class="btn btn-sm btn-restore">
                                        <i class="fas fa-undo-alt"></i> Khôi phục
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>
<script>
    function previewImageFromUrl(inputId, previewId) {
        const input = document.getElementById(inputId);
        const preview = document.getElementById(previewId);
        let typingTimer;
        const doneTypingInterval = 500;

        input.addEventListener('input', function() {
            clearTimeout(typingTimer);
            const url = this.value.trim();

            if (!url) {
                preview.innerHTML = '';
                return;
            }


            preview.innerHTML = '<p style="font-size: 13px; color: #888;"><i class="fas fa-spinner fa-spin"></i> Đang tải ảnh...</p>';


            typingTimer = setTimeout(() => {
                const img = new Image();

                img.onload = function() {
                    preview.innerHTML = '<p style="font-size: 13px; color: #3d8b58; margin-bottom: 5px;"><i class="fas fa-check-circle"></i> Xem trước ảnh:</p>';
                    img.className = 'banner-thumbnail';
                    img.style.maxHeight = '150px';
                    img.style.width = 'auto';
                    img.style.objectFit = 'contain';
                    img.style.borderRadius = '6px';
                    img.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
                    img.style.border = '1px solid #ddd';
                    preview.appendChild(img);
                };

                img.onerror = function() {
                    preview.innerHTML = '<p style="color: #dc3545; font-size: 13px;"><i class="fas fa-exclamation-triangle"></i> Link ảnh không hợp lệ hoặc không thể tải được.</p>';
                };

                img.src = url;
            }, doneTypingInterval);
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        previewImageFromUrl('image_url', 'main-preview-container');
        previewImageFromUrl('sub_image_url', 'sub-preview-container');
    });
</script>
</body>
</html>