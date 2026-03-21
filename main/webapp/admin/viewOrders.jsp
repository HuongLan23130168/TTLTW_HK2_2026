<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Chi tiết đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/viewOrders.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">

    <c:if test="${empty order}">
        <div class="orders-id empty-container">
            <i class="fa fa-search empty-icon"></i>
            <h2 class="empty-title">Không tìm thấy đơn hàng</h2>
            <p>Đơn hàng bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
            <div class="back-to-orders">
                <a href="${pageContext.request.contextPath}/admin/orders">Quay lại danh sách</a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a> &#47;
            <span class="current">Chi tiết đơn hàng #${order.order_code}</span>
        </div>

        <div class="transaction-wrapper">

            <div class="left-card">
                <div class="orders-id">
                    <a>
                        <span>Mã đơn: <strong>#${order.order_code}</strong></span>

                        <c:set var="lowerStatus" value="${fn:toLowerCase(order.status)}"/>
                        <c:choose>
                            <c:when test="${fn:contains(lowerStatus, 'đã giao') or fn:contains(lowerStatus, 'hoàn thành')}">
                                <span class="status status-completed">${order.status}</span>
                            </c:when>

                            <c:when test="${fn:contains(lowerStatus, 'chờ xác nhận')}">
                                <span class="status status-waiting">${order.status}</span>
                            </c:when>

                            <c:when test="${fn:contains(lowerStatus, 'đang giao') or fn:contains(lowerStatus, 'vận chuyển')}">
                                <span class="status status-shipping">${order.status}</span>
                            </c:when>

                            <c:when test="${fn:contains(lowerStatus, 'hủy')}">
                                <span class="status status-cancelled">${order.status}</span>
                            </c:when>

                            <c:otherwise>
                                <span class="status status-pending">${order.status}</span>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty order.order_date}">
            <span class="order-date-text">
                | <i class="far fa-calendar-alt"></i> <fmt:formatDate value="${order.order_date}"
                                                                      pattern="dd/MM/yyyy HH:mm"/>
            </span>
                        </c:if>
                    </a>
                </div>

                <div class="order-actions">
                    <h3>Hành động</h3>
                    <form action="${pageContext.request.contextPath}/admin/updateOrderStatus" method="post">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="currentStatus" value="${order.status}">

                        <c:choose>
                            <c:when test="${order.status == 'Chờ xử lý' || order.status == 'Chờ lấy hàng'}">
                                <button type="submit" class="btn-action btn-ship"
                                        onclick="return confirm('Xác nhận giao đơn hàng này cho đơn vị vận chuyển?');">
                                    <i class="fa fa-truck"></i> Xác nhận Giao Hàng
                                </button>
                            </c:when>

                            <c:when test="${fn:contains(order.status, 'Đang giao') || fn:contains(order.status, 'Vận chuyển')}">
                                <button type="submit" class="btn-action" style="background-color: #d35400;"
                                        onclick="return confirm('Xác nhận hàng ĐÃ ĐẾN ĐỊA CHỈ KHÁCH (Chờ khách xác nhận)?');">
                                    <i class="fa fa-map-marker-alt"></i> Xác nhận Hàng Đã Đến
                                </button>
                            </c:when>

                            <c:when test="${order.status == 'Chờ xác nhận'}">
                                <div class="alert-box"
                                     style="background: #fdebd0; color: #d35400; border: 1px solid #fad7a0;">
                                    <i class="fa fa-clock"></i> Đã giao hàng đến nơi. Đang chờ khách xác nhận.
                                </div>
                            </c:when>

                            <c:when test="${fn:contains(order.status, 'Đã giao') || fn:contains(order.status, 'Hoàn thành')}">
                                <div class="alert-box alert-success">
                                    <i class="fa fa-check-double"></i> Đơn hàng hoàn tất
                                </div>
                            </c:when>

                            <c:when test="${fn:contains(order.status, 'hủy') || fn:contains(order.status, 'Hủy')}">
                                <div class="alert-box alert-cancel">
                                    <i class="fa fa-times-circle"></i> Đơn hàng đã hủy
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="alert-box alert-default">
                                    <i class="fa fa-info-circle"></i> Không có hành động
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
                <div class="detail-card">
                    <h3>Thông tin khách hàng</h3>
                    <table>
                        <tr>
                            <td class="label-col">Họ tên</td>
                            <td><strong>${order.customerName}</strong></td>
                        </tr>
                        <tr>
                            <td class="label-col">Email</td>
                            <td>${order.customerEmail}</td>
                        </tr>
                        <tr>
                            <td class="label-col">Số điện thoại</td>
                            <td>${order.customerPhone}</td>
                        </tr>
                        <tr>
                            <td class="label-col">Địa chỉ nhận</td>
                            <td>${order.customerAddress}</td>
                        </tr>
                        <c:if test="${not empty order.note}">
                            <tr>
                                <td class="label-col">Ghi chú</td>
                                <td class="note-text">"${order.note}"</td>
                            </tr>
                        </c:if>
                    </table>
                </div>

            </div>

            <div class="right-card">
                <div class="detail-card">
                    <h3>Danh sách sản phẩm</h3>

                    <c:if test="${empty orderItems}">
                        <p class="text-center text-muted">Không có sản phẩm nào trong đơn hàng này.</p>
                    </c:if>

                    <c:if test="${not empty orderItems}">
                        <div class="product-list-container">
                            <c:forEach var="item" items="${orderItems}" varStatus="stt">
                                <div class="product-item-card">

                                    <div class="product-item-image">
                                        <c:set var="imgUrl" value="${item.imageUrl}" />
                                            <%-- Sử dụng ảnh placeholder lớn nếu không có ảnh --%>
                                        <c:if test="${empty imgUrl}">
                                            <c:set var="imgUrl" value="https://placehold.co/300x300?text=No+Img" />
                                        </c:if>
                                        <img src="${imgUrl}" alt="${item.name}">
                                    </div>

                                    <div class="product-item-details">

                                        <div class="product-item-info">
                                            <h4 class="product-name">${item.name}</h4>
                                            <div class="product-variant">
                                                <c:if test="${not empty item.color}">Màu: ${item.color}</c:if>
                                                <c:if test="${not empty item.size}">
                                                    <c:if test="${not empty item.color}"><span class="separator">|</span></c:if>
                                                    Size: ${item.size}
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="product-item-meta">
                                            <div class="meta-group quantity">
                                                <span class="label">SL:</span>
                                                <span class="value">x${item.quantity}</span>
                                            </div>

                                            <div class="meta-group price">
                                                <span class="label">Đơn giá:</span>
                                                <c:choose>
                                                    <c:when test="${item.discount > 0}">
                                                        <div class="price-box">
                                                <span class="final-price">
                                                    <fmt:formatNumber value="${item.price * (1 - item.discount / 100)}" type="number"/>₫
                                                </span>
                                                            <span class="old-price">
                                                    <fmt:formatNumber value="${item.price}" type="number"/>₫
                                                </span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                            <span class="final-price">
                                                <fmt:formatNumber value="${item.price}" type="number"/>₫
                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="meta-group total">
                                                <span class="label">Thành tiền:</span>
                                                <span class="value total-price">
                                        <fmt:formatNumber value="${item.total}" type="number"/>₫
                                    </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="summary-section">
                            <p class="summary-row">Tạm tính:
                                <strong><fmt:formatNumber value="${order.totalPrice - order.shippingFee}" type="number"/>₫</strong>
                            </p>
                            <p class="summary-row">Phí vận chuyển:
                                <strong><fmt:formatNumber value="${order.shippingFee}" type="number"/>₫</strong>
                            </p>
                            <h4 class="grand-total">
                                Tổng cộng: <fmt:formatNumber value="${order.totalPrice}" type="number"/>₫
                            </h4>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="back-to-orders">
            <a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-arrow-left"></i> Quay lại danh
                sách</a>
        </div>
    </c:if>
</main>

<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
</body>
</html>