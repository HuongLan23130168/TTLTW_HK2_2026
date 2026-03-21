<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Sửa Banner & Khuyến Mãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/banners.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="page-header">
        <h1>Cập nhật Banner #${banner.id}</h1>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/admin/banners" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${banner.id}">

            <div class="form-grid">
                <div class="form-section-title"><h3><i class="fas fa-image"></i> Thiết lập Banner Chính</h3></div>

                <div class="form-group">
                    <label for="title">Tiêu đề chính</label>
                    <input type="text" id="title" name="title" value="${banner.title}" >
                </div>

                <div class="form-group">
                    <label for="image_file">Thay đổi ảnh chính</label>
                    <input type="file" id="image_file" name="image_file" accept="image/*">
                    <div id="main-preview-container" class="current-img-preview">
                        <p>Ảnh hiện tại:</p>
                        <img src="${pageContext.request.contextPath}/${banner.image_url}"
                             class="banner-thumbnail-small">
                    </div>
                    <input type="hidden" name="existing_image_url" value="${banner.image_url}">
                </div>

                <div class="form-group">
                    <label for="link">Đường dẫn chuyển hướng (Link)</label>
                    <input type="text" id="link" name="link" value="${banner.link}">
                </div>

                <div class="form-group form-group-full">
                    <label for="description">Mô tả chính</label>
                    <textarea id="description" name="description" rows="2">${banner.description}</textarea>
                </div>

                <div class="form-section-title"><h3><i class="fas fa-ad"></i> Thiết lập Banner Phụ (Khuyến mãi bên phải)
                </h3></div>

                <div class="form-group">
                    <label for="sub_title">Tiêu đề phụ</label>
                    <input type="text" id="sub_title" name="sub_title" value="${banner.sub_title}">
                </div>

                <div class="form-group">
                    <label for="sub_image_file">Thay đổi ảnh phụ</label>
                    <input type="file" id="sub_image_file" name="sub_image_file" accept="image/*">
                    <div id="sub-preview-container" class="current-img-preview">
                        <p>Ảnh phụ hiện tại:</p>
                        <c:if test="${not empty banner.sub_image_url}">
                            <img src="${pageContext.request.contextPath}/${banner.sub_image_url}"
                                 class="banner-thumbnail-small">
                        </c:if>
                    </div>
                    <input type="hidden" name="existing_sub_image_url" value="${banner.sub_image_url}">
                </div>

                <div class="form-group">
                    <label for="sub_description">Mô tả phụ</label>
                    <input type="text" id="sub_description" name="sub_description" value="${banner.sub_description}">
                </div>

                <div class="form-section-title"><h3><i class="fas fa-cog"></i> Thông số hiển thị</h3></div>

                <div class="form-row" style="grid-column: 1 / -1;">
                    <div class="form-group">
                        <label for="display_order">Thứ tự ưu tiên</label>
                        <input type="number" id="display_order" name="display_order" value="${banner.display_order}">
                    </div>
                    <div class="form-group">
                        <label for="is_active">Trạng thái hiển thị</label>
                        <select id="is_active" name="is_active">
                            <option value="true" ${banner.is_active ? 'selected' : ''}>Công khai</option>
                            <option value="false" ${not banner.is_active ? 'selected' : ''}>Tạm ẩn</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/banners" class="btn btn-secondary">Quay lại</a>
            </div>
        </form>
    </div>
</main>
<script>
    function previewImage(input, previewId) {
        const preview = document.getElementById(previewId);
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                let img = preview.querySelector('img');
                if (!img) {
                    img = document.createElement('img');
                    img.className = 'banner-thumbnail-small';
                    preview.innerHTML = '<p>Xem trước ảnh mới:</p>';
                    preview.appendChild(img);
                }
                img.src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
    document.getElementById('image_file').addEventListener('change', function () {
        previewImage(this, 'main-preview-container');
    });

    document.getElementById('sub_image_file').addEventListener('change', function () {
        previewImage(this, 'sub-preview-container');
    });
</script>
</body>
</html>