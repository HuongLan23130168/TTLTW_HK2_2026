<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Products</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<!-- === PRODUCTS === -->
<div class="main-content">

    <div class="page-header">
        <h1>Quản lý sản phẩm</h1>
        <div style="display: flex; gap: 10px;">
            <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-primary"
               style="background-color: #6c757d;">
                <i class="fas fa-tags"></i> Quản lý Khuyến Mãi
            </a>
            <a href="${pageContext.request.contextPath}/admin/addProduct" class="btn btn-primary">
                <i class="fas fa-plus"></i> Thêm sản phẩm
            </a>
        </div>
    </div>

    <c:if test="${not empty alertMessage}">
        <div class="custom-toast toast-success">
            <i class="fas fa-check-circle"></i> ${alertMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="custom-toast toast-error">
            <i class="fas fa-exclamation-circle"></i> Lỗi: ${errorMessage}
        </div>
    </c:if>
    <div class="table-container">
        <table class="data-table">
            <thead>
            <tr>
                <th class="text-center" style="width: 60px;">ID</th>
                <th>Sản phẩm</th>
                <th>Danh mục</th>
                <th>Loại</th>
                <th>Giá bán</th>
                <th class="text-center" style="width: 100px;">Giảm giá</th>
                <th class="text-center" style="width: 120px;">Tồn kho</th>
                <th class="text-center" style="width: 80px;">Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td class="text-center">#${p.id}</td>

                    <td>
                        <div class="product-cell">
                            <img src="${p.image_url}" class="product-thumb"
                                 onerror="this.src='${pageContext.request.contextPath}/admin/img/no-image.png'">

                            <div class="product-info">
                                <h4 title="${p.product_name}">${p.product_name}</h4>

                                <div class="product-code">Mã: ${p.product_code}</div>

                                <div class="tag-row">
                                    <c:if test="${p.newProduct}">
                                        <span class="badge-custom badge-new">NEW</span>
                                    </c:if>
                                    <c:if test="${p.bestSeller}">
                                        <span class="badge-custom badge-best">BEST</span>
                                    </c:if>
                                    <c:if test="${p.discountPercent > 0}">
                                        <span class="badge-custom badge-sale">SALE</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td><strong>${p.category_name}</strong></td>

                    <td style="color: #666;">${p.type_name}</td>

                    <td>

                        <div class="price-group">
                            <c:choose>
                                <c:when test="${p.discountPercent > 0}">

                                    <span class="price-new">
                                        <fmt:formatNumber value="${p.price_new}" type="number" maxFractionDigits="0"/> đ
                                    </span>

                                    <span class="price-old">
                                        <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                </c:when>
                                <c:otherwise>

                                    <span class="price-new">
                                        <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>

                    <td class="text-center">
                        <c:if test="${p.discountPercent > 0}">
                            <span class="discount-pill">-${p.discountPercent}%</span>
                        </c:if>
                        <c:if test="${p.discountPercent <= 0}">
                            <span style="color: #ccc;">-</span>
                        </c:if>
                    </td>

                    <td class="text-center">
                        <c:choose>
                            <c:when test="${p.stock > 0}">
                                <span class="status-pill active">Sẵn (${p.stock})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-pill inactive">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="text-center">
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin/editProduct?id=${p.id}"
                               class="btn-icon btn-edit-icon" title="Sửa">
                                <i class="fas fa-edit"></i>
                            </a>
                            <form action="${pageContext.request.contextPath}/admin/deleteProduct" method="POST"
                                  style="margin:0" onsubmit="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?');">
                                <input type="hidden" name="id" value="${p.id}"/>
                                <button type="submit" class="btn-icon btn-delete-icon" title="Xóa">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty products}">
            <div style="text-align: center; padding: 40px; color: #888;">Chưa có dữ liệu sản phẩm nào.</div>
        </c:if>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 1}"><a href="?page=${currentPage - 1}" class="page-link"><i
                    class="fas fa-chevron-left"></i></a></c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}"><a href="?page=${currentPage + 1}" class="page-link"><i
                    class="fas fa-chevron-right"></i></a></c:if>
        </div>
    </c:if>
</div>
<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
<script src="${pageContext.request.contextPath}/admin/js/products.js"></script>
</body>

</html>