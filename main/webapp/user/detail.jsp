<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.product_name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
<c:if test="${not empty sessionScope.msg}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Tuyệt vời!',
            text: '<c:out value="${sessionScope.msg}"/>',
            showConfirmButton: true,
            confirmButtonText: 'Xem giỏ hàng',
            showCancelButton: true,
            cancelButtonText: 'Tiếp tục mua sắm',
            confirmButtonColor: '#A79277',
        }).then((result) => {
            if (result.isConfirmed) window.location.href = '${pageContext.request.contextPath}/cart';
        });
    </script>
    <c:remove var="msg" scope="session"/>
</c:if>

<jsp:include page="/user/header.jsp"/>

<c:choose>
    <c:when test="${not empty product}">
        <c:set var="defaultVariant" value="${product.variants[0]}"/>

        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
            <a href="${pageContext.request.contextPath}/list-product">Sản phẩm</a> &#47;
            <span class="current">${product.product_name}</span>
        </div>

        <section class="product-detail">
            <div class="left">
                <img id="mainImage" src="${defaultVariant.image_url}" alt="${product.product_name}" class="main-img">
                <div class="thumbs">
                    <c:set var="addedImages" value=""/>
                    <c:forEach var="v" items="${product.variants}">
                        <c:if test="${not empty v.image_url && !addedImages.contains(v.image_url)}">
                            <img src="${v.image_url}" onclick="changeImage(this.src, this)" class="thumb-item">
                            <c:set var="addedImages" value="${addedImages}|${v.image_url}"/>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not empty product.images}">
                        <c:forEach var="img" items="${product.images}">
                            <c:if test="${!addedImages.contains(img.image_url)}">
                                <img src="${img.image_url}" onclick="changeImage(this.src, this)" class="thumb-item">
                            </c:if>
                        </c:forEach>
                    </c:if>
                </div>
            </div>

            <div class="right">
                <h1>${product.product_name}</h1>

                <div class="price-wrapper">
                    <p class="price-sale" id="price-display"></p>
                    <span id="discount-area" style="display:none; align-items: center; gap: 8px;">
                        <p class="price-old" id="old-price-display"
                           style="text-decoration: line-through; color: #999; margin: 0;"></p>
                        <span class="discount-badge" id="discount-percent"></span>
                    </span>
                </div>

                <div id="stock-status" style="margin: 10px 0; font-size: 14px;"></div>

                <div class="select-group">
                    <label>Màu sắc: <span id="color-text"
                                          style="font-weight:normal">${defaultVariant.color}</span></label>
                    <div class="option-list" id="color-options"></div>
                </div>

                <div class="select-group">
                    <label>Kích thước: <span id="size-text"
                                             style="font-weight:normal">${defaultVariant.size}</span></label>
                    <div class="option-list" id="size-options"></div>
                </div>

                <div class="quantity-box">
                    <button class="qty-btn minus" id="qty-decrease">−</button>
                    <input type="number" id="quantity" value="1" min="1">
                    <button class="qty-btn plus" id="qty-increase">+</button>
                </div>

                <div class="actions">
                    <form id="cartForm" action="${pageContext.request.contextPath}/add-to-cart" method="post"
                          style="display:none;">
                        <input type="hidden" name="variantId" id="selected-variant-id" value="${defaultVariant.id}">
                        <input type="hidden" name="quantity" id="form-quantity" value="1">
                        <input type="hidden" name="redirectAction" id="redirectAction" value="add">
                    </form>

                    <a href="javascript:void(0)" class="add-cart" onclick="submitCart('add')">
                        <i class="fa fa-cart-plus"></i> Thêm vào giỏ hàng
                    </a>
                    <a href="javascript:void(0)" class="buy-now" onclick="submitCart('buy')">
                        Mua ngay
                    </a>
                </div>
            </div>
        </section>

        <section class="detail-section">
            <h2>Mô tả chi tiết</h2>
            <div class="description">
                <div class="desc-text">${product.description}</div>

                <div class="desc-gallery" style="margin: 20px 0;display: flex;flex-direction: row;gap: 15px;flex-wrap: wrap;justify-content: center;align-content: center;">
                    <c:forEach var="img" items="${product.images}">
                        <img src="${img.image_url}" alt="Ảnh chi tiết"
                             style="width: 300px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    </c:forEach>
                </div>

                <hr>
                <strong>Thông số kỹ thuật:</strong><br>
                • Mã sản phẩm: ${product.product_code}<br>
                • Chất liệu: <span id="info-material">${defaultVariant.material}</span><br>
                • Kiểu dáng: <span id="info-style">${defaultVariant.style}</span><br>
                • Xuất xứ: <span id="info-origin">Việt Nam</span><br><br>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <div style="text-align: center; padding: 100px;"><h2>Sản phẩm không tồn tại</h2></div>
    </c:otherwise>
</c:choose>

<c:if test="${not empty relatedProducts}">
    <section class="related-products">
        <h2>Sản phẩm tương tự</h2>
        <div class="slider-container">
            <button class="slide-btn prev" onclick="scrollSlider(-1)"><i class="fa fa-chevron-left"></i></button>
            <div class="slider" id="productSlider">
                <c:forEach var="rel" items="${relatedProducts}">
                    <a href="${pageContext.request.contextPath}/detail-product?id=${rel.id}" class="product">
                        <img src="${rel.image_url}" alt="${rel.product_name}" loading="lazy">
                        <h4>${rel.product_name}</h4>
                        <p class="price">
                            <fmt:formatNumber value="${rel.price}"
                                              type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0"/>₫
                        </p>
                    </a>
                </c:forEach>
            </div>
            <button class="slide-btn next" onclick="scrollSlider(1)"><i class="fa fa-chevron-right"></i></button>
        </div>
    </section>
</c:if>

<button id="backToTop" title="Lên đầu trang"><i class="fa-solid fa-arrow-up"></i></button>

<script>
    const variantsData = [
        <c:forEach var="v" items="${product.variants}" varStatus="loop">
        {
            "id": ${v.id},
            "color": "${v.jsonSafeColor}",
            "size": "${v.jsonSafeSize}",
            "material": "${v.material}",
            "style": "${v.style}",
            "origin": "${v.origin}",
            "price": ${v.price},
            "finalPrice": ${product.discount != null && product.discount.isActive()
            ? Math.round(v.price * (1 - product.discount.discount_percent.doubleValue() / 100))
            : v.price},
            "discountPercent": ${product.discount != null && product.discount.isActive()
            ? product.discount.discount_percent
            : 0},
            "image_url": "${v.image_url}",
            "stock": ${v.stock}
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    let selectedColor = "${defaultVariant.jsonSafeColor}";
    let selectedSize = "${defaultVariant.jsonSafeSize}";

    function formatVND(amount) {
        return new Intl.NumberFormat('vi-VN').format(Math.round(amount)) + '₫';
    }
</script>


<jsp:include page="/user/footer.jsp"/>
<script src="${pageContext.request.contextPath}/frontend/js/detail.js"></script>
</body>
</html>