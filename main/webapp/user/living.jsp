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
    <form action="${pageContext.request.contextPath}/list-product" method="get">
        <aside class="sidebar" id="filter-sidebar">
            <h3>Bộ lọc tìm kiếm</h3>

            <div class="filter-group">
                <label class="filter-label" style="cursor: pointer;">
                    <span>Mức giá</span>
                    <span class="filter-icon"><i class="fa-solid fa-chevron-down"></i></span>
                </label>
                <div class="options">
                    <div><input type="radio" name="priceRange"
                                value="all"${empty param.priceRange || param.priceRange=='all'?'checked':''}>Tất cả
                    </div>
                    <div><input type="radio" name="priceRange" value="1" ${param.priceRange=='1'?'checked':''}> Dưới
                        500.000₫
                    </div>
                    <div><input type="radio" name="priceRange" value="2" ${param.priceRange=='2'?'checked':''}> 500.000₫
                        - 1.000.000₫
                    </div>
                    <div><input type="radio" name="priceRange" value="3" ${param.priceRange=='3'?'checked':''}>
                        1.000.000₫ - 3.000.000₫
                    </div>
                    <div><input type="radio" name="priceRange" value="4" ${param.priceRange=='4'?'checked':''}> Trên
                        3.000.000₫
                    </div>
                </div>
            </div>

            <c:set var="cats" value="${fn:join(paramValues.category, ',')}"/>
            <div class="filter-group">
                <label class="filter-label" style="cursor: pointer;">
                    <span>Danh mục</span>
                    <span class="filter-icon"><i class="fa-solid fa-chevron-down"></i></span>
                </label>
                <div class="options" style="display: none;">
                    <div><input type="checkbox" name="category" value="CAY" ${fn:contains(cats,'CAY')?'checked':''}> Cây
                    </div>
                    <div><input type="checkbox" name="category" value="HOA" ${fn:contains(cats,'HOA')?'checked':''}> Hoa
                    </div>
                    <div><input type="checkbox" name="category" value="DEN" ${fn:contains(cats,'DEN')?'checked':''}> Đèn
                    </div>
                    <div><input type="checkbox" name="category"
                                value="PHUKIEN" ${fn:contains(cats,'PHUKIEN')?'checked':''}>Phụ kiện
                    </div>
                    <div><input type="checkbox" name="category"
                                value="DONGHO" ${fn:contains(cats,'DONGHO')?'checked':''}>Đồng hồ
                    </div>
                    <div><input type="checkbox" name="category" value="TRANH" ${fn:contains(cats,'TRANH')?'checked':''}>Tranh
                    </div>
                    <div><input type="checkbox" name="category" value="GUONG" ${fn:contains(cats,'GUONG')?'checked':''}>Gương
                    </div>
                    <div><input type="checkbox" name="category" value="NEN" ${fn:contains(cats,'NEN')?'checked':''}>Nến
                        & Tinh dầu
                    </div>
                    <div><input type="checkbox" name="category" value="BINH" ${fn:contains(cats,'BINH')?'checked':''}>Bình
                        & Lọ hoa
                    </div>
                    <div><input type="checkbox" name="category" value="CHAN" ${fn:contains(cats,'CHAN')?'checked':''}>Chăn
                    </div>
                    <div><input type="checkbox" name="category" value="GOI" ${fn:contains(cats,'GOI')?'checked':''}>Gối
                    </div>
                    <div><input type="checkbox" name="category" value="KE" ${fn:contains(cats,'KE')?'checked':''}>Kệ &
                        Giá đỡ mini
                    </div>
                    <div><input type="checkbox" name="category" value="BAN" ${fn:contains(cats,'BAN')?'checked':''}>Bàn
                        decor
                    </div>
                    <div><input type="checkbox" name="category" value="GHE" ${fn:contains(cats,'GHE')?'checked':''}>Ghế
                        decor
                    </div>
                </div>
            </div>

            <c:set var="rooms" value="${fn:join(paramValues.room, ',')}"/>
            <div class="filter-group">
                <label class="filter-label" style="cursor: pointer;">
                    <span>Theo phòng</span>
                    <span class="filter-icon"><i class="fa-solid fa-chevron-down"></i></span>
                </label>
                <div class="options" style="display: none;">
                    <div>
                        <input type="checkbox" name="room" value="1"
                        ${fn:contains(rooms,'1')?'checked':''}>
                        Phòng khách
                    </div>
                    <div>
                        <input type="checkbox" name="room" value="2"
                        ${fn:contains(rooms,'2')?'checked':''}>
                        Phòng bếp
                    </div>
                    <div>
                        <input type="checkbox" name="room" value="3"
                        ${fn:contains(rooms,'3')?'checked':''}>
                        Phòng ngủ
                    </div>
                    <div>
                        <input type="checkbox" name="room" value="4"
                        ${fn:contains(rooms,'4')?'checked':''}>
                        Phòng làm việc
                    </div>
                    <div>
                        <input type="checkbox" name="room" value="5"
                        ${fn:contains(rooms,'5')?'checked':''}>
                        Ban công
                    </div>
                </div>
            </div>

            <input type="hidden" name="sort" value="${param.sort}">
            <button type="submit" class="filter-btn">Áp dụng</button>
        </aside>
    </form>


    <main>
        <div class="sort">
            <div class="category-header">
                <h2 id="categoryName">Sản phẩm</h2>
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

        <c:choose>

            <c:when test="${empty products}">
                <div class="no-product">
                    <i class="fa-solid fa-box-open"></i>
                    <h3>Không có sản phẩm nào phù hợp với bộ lọc bạn đã chọn.</h3>
                </div>
            </c:when>

            <c:otherwise>
                <div class="product-list" id="productList">
                    <c:forEach var="p" items="${products}">
                        <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="product">
                            <div class="img" style="background-image: url('${p.image_url}')">
                                <c:if test="${not empty p.discount && p.discount.isActive()}">
                                    <div class="discount">
                                        <span>-<fmt:formatNumber value="${p.discount.discount_percent}" pattern="#.##"/>%</span>
                                    </div>
                                </c:if>
                            </div>

                            <div class="product-info">
                                <h4>${p.product_name}</h4>
                                <div class="tags">
                                    <span>${p.category_name}</span>
                                    <span>${p.type_name}</span>
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
            </c:otherwise>

        </c:choose>
    </main>

    <button id="backToTop" title="Lên đầu trang">
        <i class="fa-solid fa-arrow-up"></i>
    </button>
</div>

<jsp:include page="/user/footer.jsp"/>


<script src="${pageContext.request.contextPath}/user/js/living.js"></script>
</body>
</html>
