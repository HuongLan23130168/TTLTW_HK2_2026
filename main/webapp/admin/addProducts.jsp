<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Add Products</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/addProducts.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<!-- === ADD PRODUCTS === -->
<div class="main-content">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a> / <span class="current">Thêm mới</span>
    </div>

    <div class="form-box">
        <h2>Thêm Sản Phẩm Mới</h2>

        <form action="${pageContext.request.contextPath}/admin/addProduct" method="post" id="addProductForm">

            <div class="section-box">
                <h4><i class="fas fa-info-circle"></i> Thông tin chung</h4>
                <div class="form-row two-cols">
                    <div class="form-group">
                        <label>Tên sản phẩm <span class="required">*</span></label>
                        <input type="text" name="product_name" class="form-control" placeholder="Nhập tên sản phẩm..." required/>
                    </div>
                    <div class="form-group">
                        <label>Mã sản phẩm (SKU) <span class="required">*</span></label>
                        <input type="text" name="product_code" class="form-control" placeholder="VD: SP001" required/>
                    </div>
                </div>

                <div class="form-row two-cols">
                    <div class="form-group">
                        <label>Loại sản phẩm <span class="required">*</span></label>
                        <select name="product_type_id" class="form-control" required>
                            <option value="">-- Chọn loại --</option>
                            <c:forEach var="type" items="${types}">
                                <option value="${type.id}">${type.type_name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Danh mục (Phòng)</label>
                        <div class="checkbox-grid">
                            <c:forEach var="cat" items="${categories}">
                                <label class="checkbox-item">
                                    <input type="checkbox" name="category_id" value="${cat.id}"> ${cat.category_name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Nhãn nổi bật</label>
                    <div class="checkbox-grid" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));">
                        <label class="checkbox-item"><input type="checkbox" name="isNewProduct" value="true"> <span style="color: #007bff; font-weight: 600;">NEW</span> (Sản phẩm mới)</label>
                        <label class="checkbox-item"><input type="checkbox" name="isBestSeller" value="true"> <span style="color: #d63031; font-weight: 600;">HOT</span> (Bán chạy)</label>
                    </div>
                </div>

                <div class="form-group">
                    <label>Mô tả chi tiết</label>
                    <textarea name="description" class="form-control" placeholder="Mô tả chi tiết về sản phẩm..."></textarea>
                </div>
            </div>

            <div class="section-box">
                <h4><i class="fas fa-layer-group"></i> Cấu hình Biến thể</h4>
                <div class="variant-container">
                    <div class="variant-header">
                        <div>Màu sắc <span class="required">*</span></div>
                        <div>Size</div>
                        <div>Chất liệu</div>
                        <div>Giá bán (₫) <span class="required">*</span></div>
                        <div>Tồn kho</div>
                        <div class="text-center">Xóa</div>
                    </div>

                    <div id="variant-list">
                        <div class="variant-row">
                            <input type="text" name="colors" class="form-control" placeholder="Màu..." required>
                            <input type="text" name="sizes" class="form-control" placeholder="Size...">
                            <input type="text" name="materials" class="form-control" placeholder="Chất liệu...">
                            <input type="number" name="prices" class="form-control" placeholder="Giá..." required min="0">
                            <input type="number" name="stocks" class="form-control" value="10" min="0">
                            <button type="button" class="btn-remove-row" onclick="removeVariantRow(this)" title="Xóa dòng">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </div>

                    <button type="button" onclick="addVariantRow()" class="btn-add-variant">
                        <i class="fas fa-plus"></i> Thêm biến thể khác
                    </button>
                </div>
            </div>

            <div class="section-box">
                <h4><i class="far fa-images"></i> Quản lý hình ảnh</h4>
                <div class="form-row two-cols">
                    <div class="form-group">
                        <label>Ảnh đại diện (URL) <span class="required">*</span></label>
                        <input type="text" id="mainImageInput" name="image_url" class="form-control" required
                               placeholder="Dán link ảnh tại đây..."
                               oninput="document.getElementById('previewMain').src = this.value || ''">
                        <div class="preview-box">
                            <img id="previewMain" src="" class="img-preview"
                                 onerror="this.style.display='none'" onload="this.style.display='block'">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Album ảnh chi tiết</label>
                        <div id="gallery-container">
                        </div>
                        <button type="button" onclick="addGalleryInput()" class="btn-add-gallery">
                            <i class="fas fa-plus"></i> Thêm link ảnh phụ
                        </button>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-light">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu sản phẩm
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
<script src="${pageContext.request.contextPath}/admin/js/addProducts.js"></script>

</body>

</html>