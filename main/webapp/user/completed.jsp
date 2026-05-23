<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hoàn tất</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/completed.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap"
          rel="stylesheet">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
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

<jsp:include page="/user/header.jsp" />


<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <a href="${pageContext.request.contextPath}/detail-product">Chi tiết sản phẩm</a> &#47;
    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> &#47;
    <a href="${pageContext.request.contextPath}/place-order">Thông tin đặt hàng</a> &#47;
    <span class="current">Hoàn tất</span>
</div>

<div class="progress">
    <div class="step"><i class="fa fa-cart-shopping"></i> Giỏ hàng</div>
    <div class="step"><i class="fa fa-credit-card"></i> Thông tin đặt hàng</div>
    <div class="step active"><i class="fa fa-check-circle"></i> Hoàn tất</div>
</div>


<div class="completed-container">
    <h2 class="title">CẢM ƠN BẠN ĐÃ MUA HÀNG TẠI NLT</h2>

    <div class="order-info">
        <h3>THÔNG TIN ĐƠN HÀNG</h3>
        <p class="section-title">Danh sách sản phẩm</p>

        <div class="cart-list">
            <c:forEach var="item" items="${orderItems}">
                <div class="cart-item">
                    <img src="${item.imageUrl}" alt="${item.name}"
                         onerror="this.src='https://placehold.co/80x80?text=No+Image'">
                    <div class="item-info">
                        <h4>${item.name}</h4>
                        <p style="font-size: 12px; color: #888; margin: 5px 0;">
                            SL: ${item.quantity} |
                            Phân loại: ${not empty item.color ? item.color : 'Mặc định'} - ${item.size}
                        </p>
                        <div class="price">
                                        <span class="current-price">
                                            <span class="current-price">
                                                <fmt:formatNumber value="${item.price * (1 - item.discount / 100)}"
                                                                  pattern="#,###" />₫
                                            </span>
                                        </span>

                            <c:if test="${item.discount > 0}">
                                            <span class="old-price"
                                                  style="text-decoration: line-through; color: #888; font-size: 0.9em; margin-left: 5px;">
                                                <fmt:formatNumber value="${item.price}" pattern="#,###" />₫
                                            </span>
                                <span class="discount">(-${item.discount}%)</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="order-summary">
            <c:set var="subtotal" value="0" />
            <c:forEach var="item" items="${orderItems}">
                <c:set var="itemTotal" value="${item.price * (1 - item.discount / 100) * item.quantity}" />
                <c:set var="subtotal" value="${subtotal + itemTotal}" />
            </c:forEach>
            <c:set var="finalTotal" value="${subtotal + shippingFee}" />

            <table>
                <tr class="divider">
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td>Mã đơn hàng</td>
                    <td style="font-weight: bold; color: #74512D;">${orderCode}</td>
                </tr>
                <tr>
                    <td>Tên người nhận</td>
                    <td>${orderName}</td>
                </tr>
                <tr>
                    <td>Số điện thoại</td>
                    <td>${orderPhone}</td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td>${orderEmail}</td>
                </tr>
                <tr>
                    <td>Địa chỉ</td>
                    <td>${orderAddress}</td>
                </tr>
                <tr>
                    <td>Ngày đặt</td>
                    <td>
                        <fmt:formatDate value="${orderDate}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                </tr>
                <tr>
                    <td>Ghi chú</td>
                    <td><i style="color: #666;">${not empty orderNote ? orderNote : 'Không có ghi chú'}</i>
                    </td>
                </tr>
                <tr class="divider">
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td>Hình thức thanh toán</td>
                    <td style="text-transform: uppercase;">${paymentMethod}</td>
                </tr>
                <tr>
                    <td>Hình thức vận chuyển</td>
                    <td style="text-transform: uppercase;">${shippingType}</td>
                </tr>
                <tr class="divider">
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td>Tổng tiền hàng</td>
                    <td>
                        <fmt:formatNumber value="${subtotal}" pattern="#,###" />₫
                    </td>
                </tr>
                <tr>
                    <td>Phí vận chuyển</td>
                    <td>
                        <fmt:formatNumber value="${shippingFee}" pattern="#,###" />₫
                    </td>
                </tr>
                <tr class="divider">
                    <td colspan="2"></td>
                </tr>
            </table>

            <div class="total">
                <span>TỔNG THANH TOÁN</span>
                <span class="price">
                                <fmt:formatNumber value="${finalTotal}" pattern="#,###" />₫
                            </span>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/tracking" class="checkout-btn">TRA CỨU ĐƠN HÀNG</a>
    </div>
</div>

<jsp:include page="/user/footer.jsp" />


</body>

</html>