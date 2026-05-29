<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Quản lý Banner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/banners.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <style>

        .alert-toast {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            position: relative;
            transition: all 0.4s ease;
        }
        .alert-success {
            background-color: #f0fdf4;
            border-left: 5px solid #16a34a;
            color: #14532d;
            border: 1px solid #bbf7d0;
            border-left-width: 5px;
        }
        .alert-danger {
            background-color: #fef2f2;
            border-left: 5px solid #dc2626;
            color: #7f1d1d;
            border: 1px solid #fecaca;
            border-left-width: 5px;
        }
        .alert-icon {
            font-size: 20px;
            margin-right: 15px;
        }
        .alert-body {
            flex-grow: 1;
            font-weight: 600;
            font-size: 14px;
        }
        .alert-close {
            background: none;
            border: none;
            font-size: 16px;
            color: inherit;
            cursor: pointer;
            opacity: 0.5;
            padding: 5px;
            margin-left: 10px;
            transition: opacity 0.2s;
        }
        .alert-close:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="banner-header">
        <h1>Quản lý Banner & Khuyến Mãi</h1>
    </div>

    <c:if test="${not empty sessionScope.toastMessage}">
        <div class="alert-toast ${sessionScope.toastType == 'error' ? 'alert-danger' : 'alert-success'} animate__animated animate__fadeInDown">
            <div class="alert-icon">
                <c:choose>
                    <c:when test="${sessionScope.toastType == 'error'}">
                        <i class="fas fa-exclamation-circle"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-check-circle"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="alert-body">
                    ${sessionScope.toastMessage}
            </div>
            <button type="button" class="alert-close" onclick="this.parentElement.remove();">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <c:remove var="toastMessage" scope="session"/>
        <c:remove var="toastType" scope="session"/>
    </c:if>

    <div class="form-card">
        <c:choose>
            <c:when test="${not empty editBanner}">
                <h2>Chỉnh Sửa Banner #${editBanner.id}</h2>
            </c:when>
            <c:otherwise>
                <h2>Thêm Thiết Lập Banner Mới</h2>
            </c:otherwise>
        </c:choose>

        <form action="${pageContext.request.contextPath}/admin/banners" method="post" class="add-banner-form">
            <input type="hidden" name="action" value="${not empty editBanner ? 'update' : 'add'}">

            <c:if test="${not empty editBanner}">
                <input type="hidden" name="id" value="${editBanner.id}">
            </c:if>

            <div class="form-grid">
                <div class="form-section-title"><h3><i class="fas fa-image"></i> Banner Chính</h3></div>

                <div class="form-group">
                    <label for="title">Tiêu đề chính</label>
                    <input type="text" id="title" name="title" value="${editBanner.title}" placeholder="VD: BST Nội thất mùa Thu" required>
                </div>

                <div class="form-group">
                    <label for="image_url">Đường dẫn ảnh Banner chính (URL) <span style="color:red">*</span></label>
                    <div style="position: relative;">
                        <i class="fas fa-link" style="position: absolute; left: 12px; top: 12px; color: #888;"></i>
                        <input type="url" id="image_url" name="image_url" value="${editBanner.image_url}" placeholder="https://example.com/banner-main.jpg" required style="padding-left: 35px;">
                    </div>
                    <div id="main-preview-container" style="margin-top: 10px; min-height: 25px;">
                        <c:if test="${not empty editBanner.image_url}">
                            <p style="font-size: 13px; color: #3d8b58; margin-bottom: 5px;"><i class="fas fa-check-circle"></i> Ảnh hiện tại:</p>
                            <img src="${editBanner.image_url}" class="banner-thumbnail" style="max-height: 150px; width: auto; object-fit: contain; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border: 1px solid #ddd;">
                        </c:if>
                    </div>
                </div>

                <div class="form-group">
                    <label for="link">Đường dẫn điều hướng khi click vào Banner</label>
                    <div style="position: relative;">
                        <i class="fas fa-external-link-alt" style="position: absolute; left: 12px; top: 12px; color: #888;"></i>
                        <input type="text" id="link" name="link" value="${editBanner.link}" placeholder="VD: /products hoặc https://example.com" style="padding-left: 35px;">
                    </div>
                </div>

                <div class="form-group form-group-full">
                    <label for="description">Mô tả chính</label>
                    <textarea id="description" name="description" rows="2" placeholder="Nhập mô tả ngắn cho banner...">${editBanner.description}</textarea>
                </div>

                <div class="form-section-title"><h3><i class="fas fa-ad"></i> Banner Phụ (Promo Side)</h3></div>

                <div class="form-group">
                    <label for="sub_title">Tiêu đề phụ</label>
                    <input type="text" id="sub_title" name="sub_title" value="${editBanner.sub_title}" placeholder="VD: Sale 50%">
                </div>

                <div class="form-group">
                    <label for="sub_image_url">Đường dẫn ảnh Banner phụ (URL)</label>
                    <div style="position: relative;">
                        <i class="fas fa-link" style="position: absolute; left: 12px; top: 12px; color: #888;"></i>
                        <input type="url" id="sub_image_url" name="sub_image_url" value="${editBanner.sub_image_url}" placeholder="https://example.com/banner-sub.jpg" style="padding-left: 35px;">
                    </div>
                    <div id="sub-preview-container" style="margin-top: 10px; min-height: 25px;">
                        <c:if test="${not empty editBanner.sub_image_url}">
                            <p style="font-size: 13px; color: #3d8b58; margin-bottom: 5px;"><i class="fas fa-check-circle"></i> Ảnh hiện tại:</p>
                            <img src="${editBanner.sub_image_url}" class="banner-thumbnail" style="max-height: 150px; width: auto; object-fit: contain; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border: 1px solid #ddd;">
                        </c:if>
                    </div>
                </div>

                <div class="form-group form-group-full">
                    <label for="sub_description">Mô tả phụ</label>
                    <input type="text" id="sub_description" name="sub_description" value="${editBanner.sub_description}" placeholder="VD: Dành cho khách hàng mới">
                </div>

                <div class="form-section-title"><h3><i class="fas fa-cog"></i> Thông số hiển thị</h3></div>

                <div class="form-group">
                    <label for="display_order">Thứ tự hiển thị (Ưu tiên)</label>
                    <input type="number" id="display_order" name="display_order" value="${not empty editBanner ? editBanner.display_order : 1}" min="1" required>
                </div>

                <div class="form-group">
                    <label for="is_active">Trạng thái cấu hình</label>
                    <select id="is_active" name="is_active" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; height: 40px;">
                        <option value="true" ${editBanner.is_active || empty editBanner ? 'selected' : ''}>Hiển thị (Công khai)</option>
                        <option value="false" ${not empty editBanner && not editBanner.is_active ? 'selected' : ''}>Tạm ẩn (Bảo trì)</option>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <c:choose>
                    <c:when test="${not empty editBanner}">
                        <a href="${pageContext.request.contextPath}/admin/banners" class="btn" style="background-color: #e9ecef; color: #495057; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Cập nhật Banner
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="reset" class="btn" style="background-color: #e9ecef; color: #495057;">
                            <i class="fas fa-redo"></i> Làm lại
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Thêm Banner
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
    </div>

    <div class="table-container" style="margin-top: 30px;">
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
                                <img src="${banner.image_url}" class="banner-thumbnail" alt="Main" style="max-width: 120px; max-height: 60px; object-fit: cover; border-radius: 4px;">
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
                                <img src="${banner.sub_image_url}" class="banner-thumbnail small-thumb" alt="Sub" style="max-width: 80px; max-height: 50px; object-fit: cover; border-radius: 4px;">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted"><i class="fas fa-ban"></i> Trống</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <div class="info-cell">
                            <strong>${not empty banner.title ? banner.title : 'Chưa có tiêu đề'}</strong>
                            <div class="sub-info" style="margin-top: 4px; font-size: 12px; color: #666;">
                                <c:if test="${not empty banner.sub_title}">
                                    <span><i class="fas fa-tag"></i> Phụ: ${banner.sub_title}</span><br>
                                </c:if>
                                <span style="color: #2b6cb0;"><i class="fas fa-link"></i> Link: ${not empty banner.link ? banner.link : '#'}</span>
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
                                <a href="${pageContext.request.contextPath}/admin/banners?action=edit&id=${banner.id}" class="btn btn-sm btn-edit" title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/banners" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${banner.id}">
                                    <button type="submit" class="btn btn-sm btn-delete" onclick="return confirm('Ẩn banner này?')" title="Tạm ẩn">
                                        <i class="fas fa-eye-slash"></i>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/admin/banners" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="restore">
                                    <input type="hidden" name="id" value="${banner.id}">
                                    <button type="submit" class="btn btn-sm btn-restore" title="Khôi phục trạng thái hiển thị">
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

        if(!input || !preview) return;

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


        const alertBox = document.querySelector('.alert-toast');
        if (alertBox) {
            setTimeout(() => {
                alertBox.classList.remove('animate__fadeInDown');
                alertBox.classList.add('animate__fadeOutUp');
                setTimeout(() => alertBox.remove(), 400);
            }, 4000);
        }
    });
</script>
</body>
</html>