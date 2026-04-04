<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/pay.css">
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
        width: 100%;
        background: #A79277;
        color: #fff;
        padding: 15px;
        border: none;
        border-radius: 8px;
        font-weight: 700;
        font-size: 16px;
        margin-top: 20px;
        cursor: pointer;
        transition: background 0.3s, transform 0.2s;
        text-transform: uppercase;
    }

    .checkout-btn:hover {
        background: #74512D;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .checkout-btn:active {
        transform: translateY(0);
    }
</style>

<jsp:include page="/user/header.jsp"/>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <a href="${pageContext.request.contextPath}/detail-product">Chi tiết sản phẩm</a> &#47;
    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> &#47;
    <span class="current">Thông tin đặt hàng</span>
</div>

<div class="progress">
    <div class="step"><i class="fa fa-cart-shopping"></i> Giỏ hàng</div>
    <div class="step active"><i class="fa fa-credit-card"></i> Thông tin đặt hàng</div>
    <div class="step"><i class="fa fa-check-circle"></i> Hoàn tất</div>
</div>

<form action="${pageContext.request.contextPath}/place-order" method="POST">
    <div class="checkout-container">
        <div class="checkout-left">
            <h4>THÔNG TIN NGƯỜI NHẬN</h4>
            <div class="form-group">
                <input type="text" name="fullName" placeholder="Họ & tên*" required>
                <input type="tel" name="phone" placeholder="Số điện thoại*" required>
                <input type="email" name="email" value="${sessionScope.acc.email}" required>
            </div>

            <h4>ĐỊA CHỈ NHẬN HÀNG</h4>
            <div class="address-group">
                <input type="text" name="addressDetail" placeholder="Số nhà, tên đường*" required>
                <input type="text" name="ward" placeholder="Phường/Xã*" required>
                <input type="text" name="district" placeholder="Quận/Huyện*" >
                <input type="text" name="city" placeholder="Tỉnh/Thành phố*" required>
                <textarea name="note" placeholder="Ghi chú cho người giao hàng (nếu có)"></textarea>
            </div>

            <h4 class="section-title">HÌNH THỨC THANH TOÁN</h4>
            <div class="option-grid">
                <label class="option-box">
                    <input type="radio" name="paymentMethod" value="1" checked>
                    <div class="option-content"><p class="main-text">COD</p></div>
                </label>
                <label class="option-box">
                    <input type="radio" name="paymentMethod" value="2">
                    <div class="option-content"><p class="main-text">CHUYỂN KHOẢN</p></div>
                </label>
            </div>

            <h4 class="section-title">HÌNH THỨC VẬN CHUYỂN</h4>
            <div class="option-grid">
                <label class="option-box">
                    <input type="radio" name="shippingType" value="tiêu chuẩn" checked
                           onclick="updateShipping(30000)">
                    <div class="option-content">
                        <p class="main-text">TIÊU CHUẨN</p>
                        <p class="sub-text">30,000₫</p>
                    </div>
                </label>
                <label class="option-box">
                    <input type="radio" name="shippingType" value="hỏa tốc"
                           onclick="updateShipping(130000)">
                    <div class="option-content">
                        <p class="main-text">HỎA TỐC (TP.HCM)</p>
                        <p class="sub-text">130,000₫</p>
                    </div>
                </label>
            </div>
        </div>
        <div class="checkout-right">
            <h3>THÔNG TIN THANH TOÁN</h3>
            <hr class="divider">
            <p class="section-title">Danh sách sản phẩm</p>

            <div class="cart-list">
                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                        <img src="${item.imageUrl}" alt="${item.productName}">
                        <div class="item-info">
                            <h4>${item.productName}</h4>
                            <p style="font-size: 12px; color: #888; margin: 5px 0;">
                                SL: ${item.quantity} |
                                Phân loại: ${not empty item.color ? item.color : 'Mặc định'} - ${item.size}
                            </p>
                            <div class="price">
                                <span class="current-price">
                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>₫
                                </span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <hr class="divider">
            <div class="shipping-line">
                <p>Hình thức thanh toán: </p>
                <span id="paymentMethodDisplay">COD</span>
            </div>

            <div class="payment-line">
                <p>Hình thức vận chuyển: </p>
                <span id="shippingMethodDisplay">TIÊU CHUẨN</span>
            </div>

            <hr class="divider">
            <div class="total-line">
                <p>Tiền sản phẩm: </p>
                <span><fmt:formatNumber value="${grandTotal}" pattern="#,###"/>₫</span>
            </div>

            <div class="ship-total">
                <p>Phí vận chuyển: </p>
                <span id="shippingFeeDisplay">30,000₫</span>
            </div>

            <hr class="divider">
            <div class="final-total">
                <p>TỔNG THANH TOÁN</p>
                <span id="finalTotalDisplay">
                    <fmt:formatNumber value="${grandTotal + 30000}" pattern="#,###"/>₫
                </span>
            </div>

            <form action="${pageContext.request.contextPath}/place-order" method="POST">
                <button type="submit" class="checkout-btn">
                    XÁC NHẬN ĐẶT HÀNG
                </button>
            </form>
        </div>
    </div>
</form>

<script>
    const grandTotal = ${grandTotal};

    function updateShipping(fee) {
        document.getElementById('shippingFeeDisplay').innerText = fee.toLocaleString() + '₫';

        const methodName = (fee === 30000) ? "TIÊU CHUẨN" : "HỎA TỐC";
        document.getElementById('shippingMethodDisplay').innerText = methodName;

        const finalTotal = grandTotal + fee;
        document.getElementById('finalTotalDisplay').innerText = finalTotal.toLocaleString() + '₫';
    }

    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const methodText = (this.value === "1") ? "COD" : "CHUYỂN KHOẢN";
            document.getElementById('paymentMethodDisplay').innerText = methodText;
        });
    });
</script>

<jsp:include page="/user/footer.jsp"/>

</body>

</html>