<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Tra cứu đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/tracking.css">
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
</style>


<jsp:include page="/user/header.jsp"/>

<main class="tracking-main-content">
    <div class="breadcrumb">
        <a href="home.jsp">Trang chủ</a> &#47;
        <span class="current">Tra cứu đơn hàng </span>
    </div>

    <div class="search-section">
        <h2 class="page-title">TRA CỨU ĐƠN HÀNG</h2>
        <form action="${pageContext.request.contextPath}/tracking" method="get" class="order-tracking-search-box">
            <input type="text" name="orderCode"
                   placeholder="Nhập mã đơn hàng của bạn"
                   required
                   value="${param.orderCode}">
            <button type="submit">
                <i class="fa fa-search"></i> TRA CỨU
            </button>
        </form>
    </div>

    <c:if test="${not empty error}">
        <div class="tracking-result-container error-message">
            <p>${error}</p>
        </div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="tracking-result-container">
            <div class="order-left">
                <h3 class="block-title">THÔNG TIN ĐƠN HÀNG</h3>
                <p class="section-title">Danh sách sản phẩm</p>

                <div class="card-list">
                    <c:forEach items="${orderItems}" var="d">
                        <div class="cart-item" style="display: flex; align-items: center; border: 1px solid #eee; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <img src="${d.imageUrl}"
                                 alt="${d.name}"
                                 style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px;"
                                 onerror="this.src='https://i.postimg.cc/5t4yq9qJ/logo-ltw.jpg'">
                            <div class="item-info">
                                <h4 style="font-size: 1.2rem; margin-bottom: 5px;">${d.name}</h4>
                                <p style="color: #666; margin-bottom: 5px;">
                                    SL: ${d.quantity} | Phân loại: ${d.color} - ${d.size}
                                </p>
                                <div class="price-box">
                                    <strong style="color: #74512D; font-size: 1.1rem;">
                                        <fmt:formatNumber value="${d.price * (1 - (d.discount / 100.0))}" pattern="#,###"/>₫
                                    </strong>
                                    <c:if test="${d.discount > 0}">
                                <span style="text-decoration: line-through; color: #999; margin-left: 10px;">
                                    <fmt:formatNumber value="${d.price}" pattern="#,###"/>₫
                                </span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="order-summary-table" style="margin-top: 20px;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <tr style="height: 40px;"><td>Mã đơn hàng</td><td align="right"><strong>${order.orderCode}</strong></td></tr>
                        <tr style="height: 40px;"><td>Tên người nhận</td><td align="right">${order.recipientName}</td></tr>
                        <tr style="height: 40px;"><td>Số điện thoại</td><td align="right">${order.recipientPhone}</td></tr>
                        <tr style="height: 40px;"><td>Email</td><td align="right">${order.customerEmail}</td></tr>
                        <tr style="height: 40px;"><td>Địa chỉ</td><td align="right">${order.shippingAddress}</td></tr>
                        <tr style="height: 40px;"><td>Ngày đặt</td><td align="right"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td></tr>
                        <tr style="height: 40px;"><td>Ghi chú khách hàng</td><td align="right"><i style="color: #666;">${not empty order.note ? order.note : 'Không có ghi chú'}</i></td></tr>
                        <tr style="border-top: 1px solid #eee; height: 50px;">
                            <td>Hình thức thanh toán</td>
                            <td align="right"><strong>${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</strong></td>
                        </tr>
                        <tr style="height: 40px;">
                            <td>Hình thức vận chuyển</td>
                            <td align="right"><strong>${order.shipping.shippingType.toUpperCase()}</strong></td>
                        </tr>

                        <tr style="border-top: 1px solid #eee; height: 40px;">
                            <td>Tổng tiền hàng</td>
                            <td align="right"><fmt:formatNumber value="${order.totalPrice - order.shipping.shippingFee}" pattern="#,###"/>₫</td>
                        </tr>
                        <tr style="height: 40px;">
                            <td>Phí vận chuyển</td>
                            <td align="right"><fmt:formatNumber value="${order.shipping.shippingFee}" pattern="#,###"/>₫</td>
                        </tr>
                    </table>

                    <div class="final-total" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-top: 20px; border-top: 2px solid #eee;">
                        <h3 style="text-transform: uppercase; margin: 0;">Tổng thanh toán</h3>
                        <h2 style="color: #74512D; margin: 0;"><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>₫</h2>
                    </div>
                </div>
            </div>
            <div class="order-right">
                <h3 class="block-title">TÌNH TRẠNG ĐƠN HÀNG</h3>
                <div class="order-summary">
                    <table>
                        <tr>
                            <td>Trạng thái</td>
                            <td align="right">
                    <span class="status status-${order.shipping.shippingStatus.toLowerCase()}">
                            ${order.shipping.shippingStatus}
                    </span>
                            </td>
                        </tr>
                        <tr>
                            <td>Mã vận chuyển</td>
                            <td align="right">${not empty order.shipping.trackingNumber ? order.shipping.trackingNumber : 'Đang cập nhật'}</td>
                        </tr>
                        <tr>
                            <td>Ghi chú</td>
                            <td align="right" style="color: #74512D; font-weight: 600;">
                                    ${not empty order.note ? order.note : 'N/A'}
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </c:if>

    <p class="footer-text">
        Quý khách vui lòng kiểm tra lại mã đơn hoặc gọi CSKH:
        <strong>0375 1841 444</strong>
    </p>
</main>


<jsp:include page="/user/footer.jsp"/>

</body>
</html>