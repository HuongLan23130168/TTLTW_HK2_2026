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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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

        .row-inactive {
            opacity: 0.6;
            background-color: #f8f9fa;
        }
        .btn-restore {
            background-color: #28a745;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            border: none;
            font-size: 12px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-restore:hover {
            background-color: #218838;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-badge.active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-badge.inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<div class="main-content">

    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
        <h1>Quản lý sản phẩm</h1>

        <div style="display: flex; align-items: center; gap: 20px;">
            <form action="${pageContext.request.contextPath}/admin/products" method="GET" class="search-box">
                <i class="fa fa-search"></i>
                <input type="text" name="keyword" placeholder="Tìm theo tên, mã sản phẩm..." value="${param.keyword}">
            </form>

            <div style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-primary" style="background-color: #6c757d;">
                    <i class="fas fa-tags"></i> Quản lý Khuyến Mãi
                </a>
                <a href="${pageContext.request.contextPath}/admin/addProduct" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm sản phẩm
                </a>
            </div>
        </div>
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
                <th class="text-center" style="width: 120px;">Tồn kho / Trạng thái</th>
                <th class="text-center" style="width: 100px;">Hành động</th>
            </tr>
            </thead>
            <tbody id="tbody">
            <c:forEach var="p" items="${products}">
                <tr class="${not p.is_active ? 'row-inactive' : ''}">
                    <td class="text-center">#${p.id}</td>

                    <td>
                        <div class="product-cell">
                            <img src="${p.image_url}" class="product-thumb"
                                 onerror="this.src='${pageContext.request.contextPath}/admin/img/no-image.png'">

                            <div class="product-info">
                                <h4 title="${p.product_name}" class="product-name-text">${p.product_name}</h4>

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
                            <c:when test="${not p.is_active}">
                                <span class="status-badge inactive">Đang ẩn</span>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${p.stock > 0}">
                                        <span class="status-pill active">Sẵn (${p.stock})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill inactive">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="text-center">
                        <div class="action-buttons" style="display: flex; gap: 5px; justify-content: center; align-items: center;">

                            <c:choose>
                                <c:when test="${p.is_active}">
                                    <a href="${pageContext.request.contextPath}/admin/editProduct?id=${p.id}"
                                       class="btn-icon btn-edit-icon" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/deleteProduct" method="POST" style="margin:0"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn tạm ẩn sản phẩm này không?');">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${p.id}"/>
                                        <button type="submit" class="btn-icon btn-delete-icon" title="Tạm ẩn">
                                            <i class="fas fa-eye-slash"></i>
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/admin/deleteProduct" method="POST" style="margin:0"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn hiển thị lại sản phẩm này không?');">
                                        <input type="hidden" name="action" value="restore"/>
                                        <input type="hidden" name="id" value="${p.id}"/>
                                        <button type="submit" class="btn-restore" title="Khôi phục">
                                            <i class="fas fa-undo-alt"></i> Khôi phục
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>

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
            <c:set var="searchParam" value=""/>
            <c:if test="${not empty param.keyword}">
                <c:set var="searchParam" value="&keyword=${param.keyword}"/>
            </c:if>

            <c:if test="${currentPage > 1}">
                <a href="?page=${currentPage - 1}${searchParam}" class="page-link">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}${searchParam}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="?page=${currentPage + 1}${searchParam}" class="page-link">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </c:if>
        </div>
    </c:if>
</div>
<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
<script src="${pageContext.request.contextPath}/admin/js/products.js"></script>

<script>

    document.addEventListener("DOMContentLoaded", function() {
        const alertBox = document.querySelector('.alert-toast');
        if (alertBox) {
            setTimeout(() => {
                alertBox.classList.remove('animate__fadeInDown');
                alertBox.classList.add('animate__fadeOutUp');
                setTimeout(() => alertBox.remove(), 400);
            }, 3000);
        }
    });
</script>
</body>

</html>