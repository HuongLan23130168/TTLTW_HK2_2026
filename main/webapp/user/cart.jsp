<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng của bạn</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
</head>

<body>
<style>

    .breadcrumb {
        margin: 20px 40px 10px;
        color: #333;
    }

    .breadcrumb a {
        text-decoration: none;
        color: #000;
    }

    .breadcrumb a:hover {
        text-decoration: underline;
        color: #74512D;
    }

    .breadcrumb .current {
        color: #74512D;
        font-weight: 700;
    }

    .progress {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 80px;
        margin: 20px 0 40px;
    }

    .progress .step {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 10px 18px;
        border: 2px solid;
        border-radius: 20px;
        font-weight: 600;
        color: #999;
        position: relative;
        background-color: #fff;
        transition: all 0.3s ease;
    }

    .progress .step i {
        margin-right: 6px;
    }

    .progress .step.active {
        color: #fff;
        background-color: #ECB176;
    }

    .progress .step::after {
        content: "";
        position: absolute;
        right: -60px;
        top: 50%;
        width: 50px;
        height: 2px;
        background-color: #ddd;
        transform: translateY(-50%);
    }

    .progress .step:last-child::after {
        display: none;
    }

    .cart-item {
        display: flex;
        align-items: center;
        background: #fff;
        border: 2px solid #eee;
        border-radius: 10px;
        padding: 10px 15px;
        margin-bottom: 15px;
        gap: 15px;
    }

    .cart-item img {
        width: 80px;
        height: 80px;
        border-radius: 8px;
        object-fit: cover;
    }

    .cart-item .item-info {
        flex: 1;
    }

    .cart-item h4 {
        font-size: 15px;
        margin: 3px 0;
        color: #333;
    }

    .color {
        font-size: 13px;
        color: #666;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .color-box {
        display: inline-block;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        border: 1px solid #ccc;
    }

    .color-name {
        font-weight: 500;
    }

    .price {
        display: flex;
        align-items: baseline;
        gap: 8px;
    }

    .current-price {
        color: #e67e22;
        font-weight: 700;
        font-size: 15px;
    }

    .old-price {
        color: #aaa;
        font-size: 13px;
        text-decoration: line-through;
    }

    .discount {
        color: #d40004;
        font-weight: 600;
        font-size: 13px;
    }

    .checkout-btn {
        display: block;
        text-align: center;
        background: #A79277;
        color: #fff;
        text-decoration: none;
        padding: 12px;
        border-radius: 8px;
        font-weight: 550;
        margin-top: 20px;
        transition: background 0.3s;
    }

    .checkout-btn:hover {
        background: #74512D;
    }
</style>
<jsp:include page="/user/header.jsp"/>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <span class="current">Giỏ hàng</span>
</div>

<div class="progress">
    <div class="step active"><i class="fa fa-cart-shopping"></i> Giỏ hàng</div>
    <div class="step"><i class="fa fa-credit-card"></i> Thông tin đặt hàng</div>
    <div class="step"><i class="fa fa-check-circle"></i> Hoàn tất</div>
</div>

<div class="cart-container">

    <c:if test="${not empty sessionScope.error}">
        <div style="background-color: #ffe6e6; color: #d40004; padding: 15px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #ffcccc;">
            <i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.error}
        </div>
        <% session.removeAttribute("error"); %>
    </c:if>

    <c:choose>
        <c:when test="${not empty cartItems}">

            <c:set var="totalQty" value="0"/>

            <div class="cart-left">
                <div class="select-all">
                    <input type="checkbox" id="selectAll">
                    <label for="selectAll">Sản phẩm trong giỏ <span>(${cartItems.size()})</span></label>
                </div>

                <div class="cart-list">
                    <c:forEach var="item" items="${cartItems}">

                        <c:set var="totalQty" value="${totalQty + item.quantity}"/>

                        <div class="cart-item">
                            <input type="checkbox" class="item-check" name="selectedItems" value="${item.detailId}">

                            <img src="${item.imageUrl}" alt="${item.productName}"
                                 onerror="this.src='https://via.placeholder.com/80'">

                            <div class="item-info">
                                <h4><a href="${pageContext.request.contextPath}/detail-product?id=${item.variantId}"
                                       style="text-decoration: none; color: #333;">${item.productName}</a></h4>

                                <div class="color">
                                    <span class="color-name">Màu: ${item.color}</span> |
                                    <span class="size-name">Size: ${item.size}</span>
                                </div>
                                <div class="color" style="font-size: 12px; color: #888;">
                                    Mã: ${item.code} <br>
                                </div>

                                <div class="price">
                                    <c:choose>
                                        <c:when test="${item.discountPercent > 0}">
            <span class="current-price">
                <fmt:formatNumber value="${item.getFinalPrice()}" pattern="#,###"/>₫
            </span>
                                            <span class="old-price"
                                                  style="text-decoration: line-through; color: #aaa; margin-left: 5px;">
                <fmt:formatNumber value="${item.price}" pattern="#,###"/>₫
            </span>
                                            <span class="discount"
                                                  style="color: #d40004; font-size: 12px; margin-left: 5px;">
                (-<fmt:formatNumber value="${item.discountPercent}" pattern="#"/>%)
            </span>
                                        </c:when>
                                        <c:otherwise>
            <span class="current-price">
                <fmt:formatNumber value="${item.price}" pattern="#,###"/>₫
            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="quantity">
                                <c:choose>
                                    <c:when test="${item.quantity > 1}">
                                        <a href="${pageContext.request.contextPath}/cart?action=update&id=${item.variantId}&quantity=${item.quantity - 1}"
                                           class="qty-btn">-</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/cart?action=delete&id=${item.variantId}"
                                           class="qty-btn" onclick="return confirm('Xóa sản phẩm này?')">-</a>
                                    </c:otherwise>
                                </c:choose>

                                <span style="margin: 0 10px; font-weight: bold;">${item.quantity}</span>

                                <c:choose>
                                    <c:when test="${item.quantity < item.stock}">
                                        <a href="${pageContext.request.contextPath}/cart?action=update&id=${item.variantId}&quantity=${item.quantity + 1}"
                                           class="qty-btn">+</a>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="#" class="qty-btn"
                                           style="color: #ccc;"
                                           onclick="alert('Rất tiếc, kho chỉ còn ${item.stock} sản phẩm!'); return false;">+</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="font-weight: bold; font-size: 14px; color: #333; min-width: 80px; text-align: right;">
                                <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>₫
                            </div>

                            <a href="${pageContext.request.contextPath}/cart?action=delete&id=${item.variantId}"
                               class="delete-btn"
                               onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')" title="Xóa">
                                <i class="fa fa-trash"></i>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="cart-right">
                <h3>THÔNG TIN THANH TOÁN</h3>
                <hr class="divider">

                <div class="quantity-total">
                    <p>Tổng số lượng sản phẩm: </p>
                    <span>${totalQty}</span>
                </div>

                <div class="total">
                    <p>Tạm tính: </p>
                    <span><fmt:formatNumber value="${grandTotal}" pattern="#,###"/>₫</span>
                </div>

                <hr class="divider">

                <div class="final-total">
                    <p>Tổng thanh toán: </p>
                    <span style="color: #d40004; font-size: 20px; font-weight: bold;">
                        <fmt:formatNumber value="${grandTotal}" pattern="#,###"/>₫
                    </span>
                </div>

                <a href="${pageContext.request.contextPath}/cart?action=checkout" class="checkout-btn">
                    THANH TOÁN
                </a>

                <div style="text-align: center; margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/list-product"
                       style="text-decoration: none; color: #666; font-size: 13px;">
                        <i class="fa fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div style="text-align: center; padding: 80px 0; width: 100%; background: #fff; border-radius: 10px;">
                <i class="fa-solid fa-cart-arrow-down" style="font-size: 80px; color: #ddd; margin-bottom: 20px;"></i>
                <h2 style="color: #555;">Giỏ hàng của bạn đang trống!</h2>
                <p style="color: #888; margin-bottom: 30px;">Hãy thêm sản phẩm để nhận ưu đãi nhé.</p>
                <a href="${pageContext.request.contextPath}/list-product" class="checkout-btn"
                   style="width: 250px; margin: 0 auto; display: inline-block;">MUA SẮM NGAY</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.getElementById('selectAll').onclick = function () {
        var checkboxes = document.querySelectorAll('.item-check');
        for (var checkbox of checkboxes) {
            checkbox.checked = this.checked;
        }
    }
</script>
<jsp:include page="/user/footer.jsp"/>

</body>
</html>