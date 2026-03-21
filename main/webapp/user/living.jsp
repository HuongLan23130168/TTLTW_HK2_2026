<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng khách</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/living.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
</head>

<body>
<jsp:include page="/user/header.jsp"/>


<nav class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <span class="current">${roomName}</span>

</nav>

<div class="container">
    <main>
        <div class="sort">
            <div class="category-header">
                <h2 id="categoryName">Tất cả sản phẩm</h2>
            </div>

            <div class="sortProducts">
                <label for="sortProducts">Sắp xếp: </label>
                <form method="get" action="${pageContext.request.contextPath}/list-product">
                    <select name="sort" onchange="this.form.submit()">
                        <option value="">Mặc định</option>
                        <option value="price-asc" ${param.sort=='price-asc'?'selected':''}>Giá tăng</option>
                        <option value="price-desc" ${param.sort=='price-desc'?'selected':''}>Giá giảm</option>
                    </select>

                    <input type="hidden" name="priceRange" value="${param.priceRange}">
                    <c:forEach var="c" items="${paramValues.category}">
                        <input type="hidden" name="category" value="${c}">
                    </c:forEach>
                    <c:forEach var="r" items="${paramValues.room}">
                        <input type="hidden" name="room" value="${r}">
                    </c:forEach>
                    <c:forEach var="cl" items="${paramValues.color}">
                        <input type="hidden" name="color" value="${cl}">
                    </c:forEach>
                </form>
            </div>
        </div>

        <div class="product-list" id="productList">
            <c:forEach var="p" items="${products}">
                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="product">
                    <div class="img" style="background-image: url('${p.imageUrl}')">
                        <c:if test="${not empty p.discount && p.discount.isActive()}">
                            <div class="discount">
                                <span>-<fmt:formatNumber value="${p.discount.discount_percent}" pattern="#.##"/>%</span>
                            </div>
                        </c:if>
                    </div>

                    <div class="product-info">
                        <h4>${p.product_name}</h4>
                        <div class="tags">
                            <span>Phòng khách</span>
                            <span>Tối giản</span>
                        </div>
                        <div class="price-cart">
                            <div class="price-box">
                                <c:choose>
                                    <c:when test="${not empty p.discount && p.discount.isActive()}">
                                        <span class="price">
                                            <fmt:formatNumber value="${p.getFinalPrice()}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </span>
                                        <span class="old-price">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

        <div id="pagination">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:url var="pageUrl" value="/list-product">
                    <c:param name="page" value="${i}"/>
                    <c:param name="sort" value="${param.sort}"/>
                    <c:param name="priceRange" value="${param.priceRange}"/>

                    <c:forEach var="c" items="${paramValues.category}">
                        <c:param name="category" value="${c}"/>
                    </c:forEach>

                    <c:forEach var="r" items="${paramValues.room}">
                        <c:param name="room" value="${r}"/>
                    </c:forEach>
                </c:url>
                <a class="page-btn ${i==page?'active':''}" href="${pageUrl}">${i}</a>
            </c:forEach>
        </div>
    </main>

    <button id="backToTop" title="Lên đầu trang">
        <i class="fa-solid fa-arrow-up"></i>
    </button>
</div>

<jsp:include page="/user/footer.jsp"/>


<script src="${pageContext.request.contextPath}/user/js/living.js"></script>
</body>
</html>
