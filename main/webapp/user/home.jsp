<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Noble Loft Theory — Nội thất</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/footer.css">
    <link rel="icon" href="data:,">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
<jsp:include page="/user/header.jsp"/>

<main class="container">
    <%--    SECTION 1--%>
    <section class="hero">
        <div class="hero-bg">
            <img src="https://i.pinimg.com/1200x/93/86/51/938651d21341d4d0ea6e5e91474487ef.jpg" alt="Background mờ">
        </div>
        <div class="hero-blur"></div>
        <div class="hero-img">
            <img src="https://i.pinimg.com/1200x/f6/44/d5/f644d5876131e9a18d6a0c6d52af523e.jpg"
                 alt="Nội thất Noble Loft">
        </div>
        <div class="hero-content">
            <h1>Noble Loft Theory</h1>
            <p>
                Kiến trúc nội thất phong cách Loft — sự kết hợp tinh tế giữa vật liệu thô mộc và thiết kế hiện đại,
                mang đến không gian sống mạnh mẽ, sang trọng và đầy cảm xúc.
            </p>
            <a href="#gallery" class="cta" id="scrollToGallery">Xem bộ sưu tập</a>
        </div>
    </section>

    <section class="section" id="gallery">
        <h2 class="section-title">Bộ sưu tập mẫu</h2>

        <div class="gallery-wrapper">
            <button class="arrow left" onclick="prevSlide()">&#10094;</button>

            <div class="gallery-track" id="galleryTrack">
                <!--BST 1-->
                <div class="gallery-set">
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/list-product?room=1">
                            <img src="https://i.pinimg.com/1200x/f6/44/d5/f644d5876131e9a18d6a0c6d52af523e.jpg"
                                 alt="Phòng khách">
                        </a>
                        <div class="card-body">
                            <h3>Phòng khách sang trọng</h3>
                            <p>Phong cách hiện đại, tinh tế với tông màu sáng nhẹ.</p>
                        </div>
                    </div>
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/list-product?room=2">
                            <img src="https://i.pinimg.com/1200x/b4/7c/db/b47cdb2336586f7a2509260f1b0bbe13.jpg"
                                 alt="Phòng ngủ">
                        </a>
                        <div class="card-body">
                            <h3>Phòng bếp hiện đại</h3>
                            <p>Thiết kế tối giản, nổi bật với ánh sáng tự nhiên.</p>
                        </div>
                    </div>
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/list-product?room=3">
                            <img src="https://i.pinimg.com/736x/83/25/61/832561a6c56758f270093fd924515306.jpg"
                                 alt="Phòng làm việc">
                        </a>
                        <div class="card-body">
                            <h3>Phòng ngủ tinh tế</h3>
                            <p>Không gian ấm áp, thư giãn sau ngày dài.</p>
                        </div>
                    </div>
                </div>
                <!-- BST 2-->
                <div class="gallery-set">
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/list-product?room=4">
                            <img src="https://i.pinimg.com/736x/82/69/67/826967dc2ee6cfba2d32eb3e277ecd57.jpg"
                                 alt="Nội thất 4">
                        </a>
                        <div class="card-body">
                            <h3>Phòng làm việc nghệ thuật</h3>
                            <p>Bố trí tiện nghi, tông màu gỗ tự nhiên.</p>
                        </div>
                    </div>
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/list-product?room=5">
                            <img src="https://i.pinimg.com/736x/d8/c5/19/d8c519bf9ed06094afd5e7d7c787f71b.jpg"
                                 alt="Nội thất 5">
                        </a>
                        <div class="card-body">
                            <h3>Ban công thư giãn</h3>
                            <p>Ánh sáng vàng dịu mang lại sự ấm cúng, biến nơi đây thành góc nghỉ ngơi lý tưởng.</p>
                        </div>
                    </div>
                </div>
            </div>

            <button class="arrow right" onclick="nextSlide()">&#10095;</button>
        </div>
    </section>

    <%--    SECTION 3--%>
    <section class="promo-slider">
        <div class="slider-track">
            <c:forEach items="${banners}" var="b">
                <div class="promo-group ${empty b.sub_image_url ? 'no-side' : ''}">
                    <div class="promo-main">
                        <img src="${b.image_url}" alt="${b.title}">
                        <div class="promo-content">
                            <h2>${b.title}</h2>
                            <p>${b.description}</p>
                            <a href="${b.link}" class="promo-btn">Khám phá ngay</a>
                        </div>
                    </div>

                    <c:if test="${not empty b.sub_image_url}">
                        <div class="promo-side">
                            <div class="promo-small">
                                <img src="${b.sub_image_url}" alt="${b.sub_title}">
                                <div class="banner-text">
                                    <h3>${b.sub_title}</h3>
                                    <p>${b.sub_description}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </section>


    <%--    SECTION 4--%>
    <section class="new-products" id="newProducts">
        <h2 class="section-title">Sản phẩm mới</h2>
        <div class="product-grid">
            <c:forEach items="${newProducts}" var="p">
                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="product-card">
                    <div class="badge-new">NEW</div>

                    <div class="product-img">
                        <img src="${empty p.image_url ? 'path/to/default-image.jpg' : p.image_url}"
                             alt="${p.product_name}">
                        <div class="overlay"><span>Xem thêm</span></div>
                    </div>

                    <div class="product-info">
                        <h3>${p.product_name}</h3>

                        <p class="product-desc">
                                ${fn:length(p.description) > 60 ? fn:substring(p.description, 0, 60).concat('...') : p.description}
                        </p>

                        <p class="price">
                            <c:choose>
                                <c:when test="${p.discount != null && p.discount.active}">
                                <span class="price-new">
                                    <fmt:formatNumber value="${p.finalPrice}" type="number"/>₫
                                </span>
                                    <span class="price-old">
                                    <fmt:formatNumber value="${p.price}" type="number"/>₫
                                </span>
                                </c:when>
                                <c:otherwise>
                                <span class="price-normal">
                                    <fmt:formatNumber value="${p.price}" type="number"/>₫
                                </span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </a>
            </c:forEach>
        </div>
    </section>

    <%--    SECTION 5--%>
    <section class="new-products" id="hotProducts">
        <h2 class="section-title">Sản phẩm bán chạy</h2>
        <div class="product-grid">
            <c:forEach items="${hotProducts}" var="p">
                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="product-card">
                    <div class="badge-new" style="background: #e74c3c;">HOT</div>

                    <div class="product-img">
                        <img src="${empty p.image_url ? 'https://via.placeholder.com/300x400?text=Noble+Loft' : p.image_url}"
                             alt="${p.product_name}">
                        <div class="overlay"><span>Xem thêm</span></div>
                    </div>

                    <div class="product-info">
                        <h3>${p.product_name}</h3>
                        <p class="product-desc">
                                ${fn:length(p.description) > 60 ? fn:substring(p.description, 0, 60).concat('...') : p.description}
                        </p>

                        <p class="price">
                            <c:choose>
                                <c:when test="${p.discount != null && p.discount.active}">
                                <span class="price-new">
                                    <fmt:formatNumber value="${p.finalPrice}" type="number"/>₫
                                </span>
                                    <span class="price-old">
                                    <fmt:formatNumber value="${p.price}" type="number"/>₫
                                </span>
                                </c:when>
                                <c:otherwise>
                                <span class="price-normal">
                                    <fmt:formatNumber value="${p.price}" type="number"/>₫
                                </span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </a>
            </c:forEach>
        </div>
    </section>
</main>


<button id="backToTop" title="Lên đầu trang">
    <i class="fa-solid fa-arrow-up"></i>
</button>

<jsp:include page="/user/footer.jsp"/>

<script>
    <c:if test="${not empty sessionScope.acc && empty sessionScope.notified}">
    Swal.fire({
        icon: 'success',
        title: 'Chào mừng bạn đã đến Noble Loft Theory!',
        text: 'Chào bạn ${sessionScope.acc.fullName}, chúc bạn mua sắm vui vẻ!',
        timer: 3000,
        showConfirmButton: false
    });
    <c:set var="notified" value="true" scope="session" />
    </c:if>
</script>

<script src="${pageContext.request.contextPath}/frontend/js/home.js"></script>


</body>

</html>