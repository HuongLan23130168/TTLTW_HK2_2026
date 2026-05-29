<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Chi tiết đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/viewOrders.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">

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
                            <c:when test="${order.returnStatus == 'PENDING'}">
                                <span class="status status-waiting">Yêu cầu hoàn hàng</span>
                            </c:when>
                            <c:when test="${order.returnStatus == 'APPROVED'}">
                                <span class="status status-cancelled">Đã hoàn</span>
                            </c:when>
                            <c:when test="${order.returnStatus == 'REJECTED'}">
                                <span class="status status-pending">Không chấp nhận hoàn hàng</span>
                            </c:when>
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
                                | <i class="far fa-calendar-alt"></i> <fmt:formatDate value="${order.order_date}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </c:if>
                    </a>
                </div>

                <div class="order-actions">
                    <h3>Hành động</h3>

                    <c:choose>
                        <c:when test="${order.returnStatus == 'PENDING'}">
                            <div class="alert-box alert-warning" style="margin-bottom: 15px;">
                                <i class="fa fa-rotate-left"></i> Khách hàng đang yêu cầu hoàn hàng
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/resolveReturn" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <textarea name="adminNote" rows="3" placeholder="Ghi chú xử lý hoàn hàng"
                                          style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; margin-bottom: 10px; font-family: inherit;"></textarea>
                                <button type="submit" name="decision" value="approve" class="btn-action btn-confirm"
                                        style="background-color: #27ae60; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; width: 100%; margin-bottom: 10px;"
                                        onclick="return confirm('Xác nhận chấp nhận hoàn hàng? Trạng thái user sẽ hiển thị Đã hoàn.');">
                                    <i class="fa fa-check"></i> Xác nhận hoàn hàng
                                </button>
                                <button type="submit" name="decision" value="reject" class="btn-action btn-cancel"
                                        style="background-color: #e74c3c; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; width: 100%;"
                                        onclick="return confirm('Không chấp nhận hoàn hàng? Người dùng sẽ phải nhận/giữ đơn này.');">
                                    <i class="fa fa-times"></i> Không xác nhận
                                </button>
                            </form>
                        </c:when>


                        <c:when test="${order.status == 'Chờ xác nhận thanh toán'}">
                            <form action="${pageContext.request.contextPath}/admin/confirm-payment" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="btn-action btn-payment-confirm"
                                        style="background-color: #27ae60; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; width: 100%; margin-bottom: 10px;"
                                        onclick="return confirm('Xác nhận đã nhận được tiền từ khách hàng?');">
                                    <i class="fas fa-check-double"></i> Xác nhận đã nhận tiền
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/admin/updateOrderStatus" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <input type="hidden" name="currentStatus" value="${order.status}">
                                <button type="submit" class="btn-action btn-cancel"
                                        style="background-color: #e74c3c; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; width: 100%;"
                                        onclick="return confirm('Hủy đơn hàng này?');">
                                    <i class="fa fa-times"></i> Hủy đơn hàng
                                </button>
                            </form>
                        </c:when>

                        <c:when test="${order.status == 'Chờ xử lý'}">
                            <form action="${pageContext.request.contextPath}/admin/updateOrderStatus" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <input type="hidden" name="currentStatus" value="${order.status}">
                                <button type="submit" class="btn-action btn-confirm"
                                        style="background-color: #3498db; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; width: 100%;"
                                        onclick="return confirm('Xác nhận đơn hàng và giao cho đơn vị vận chuyển?');">
                                    <i class="fa fa-truck"></i> Xác nhận & Giao vận chuyển
                                </button>
                            </form>
                        </c:when>

                        <c:when test="${order.status == 'Đã giao hàng - Hoàn thành'}">
                            <div class="alert-box alert-success">
                                <i class="fa fa-check-double"></i> Đơn hàng đã hoàn tất
                            </div>
                        </c:when>

                        <c:when test="${fn:contains(order.status, 'hủy')}">
                            <div class="alert-box alert-cancel">
                                <i class="fa fa-times-circle"></i> Đơn hàng đã hủy
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="alert-box">
                                <i class="fa fa-info-circle"></i> ${order.status}
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${order.status == 'Đã xác nhận - Giao vận chuyển' or order.status == 'Đã lấy hàng' or order.status == 'Đang vận chuyển'}">
                        <form action="${pageContext.request.contextPath}/admin/autoUpdateStatus" method="get" style="margin-top: 15px;">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn-action btn-auto"
                                    style="background-color: #3498db; width: 100%; padding: 10px; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 14px;"
                                    onclick="return confirm('Chuyển đơn hàng sang trạng thái tiếp theo?');">
                                <i class="fa fa-forward"></i> Chuyển tiếp trạng thái
                            </button>
                        </form>
                    </c:if>
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
                            <td>${order.shippingAddress}</td>
                        </tr>
                        <c:if test="${not empty order.note}">
                            <tr>
                                <td class="label-col">Ghi chú</td>
                                <td class="note-text">"${order.note}"</td>
                            </tr>
                        </c:if>
                    </table>
                </div>

                <c:if test="${not empty order.returnStatus}">
                    <div class="detail-card">
                        <h3>Thông tin hoàn hàng</h3>
                        <table>
                            <tr>
                                <td class="label-col">Trạng thái</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.returnStatus == 'PENDING'}"><strong>Chờ admin xử lý</strong></c:when>
                                        <c:when test="${order.returnStatus == 'APPROVED'}"><strong>Đã hoàn</strong></c:when>
                                        <c:otherwise><strong>Không chấp nhận hoàn hàng</strong></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="label-col">Ngày gửi</td>
                                <td><fmt:formatDate value="${order.returnRequestedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <td class="label-col">Phản hồi</td>
                                <td class="note-text">"${order.returnFeedback}"</td>
                            </tr>
                            <c:if test="${not empty order.returnAdminNote}">
                                <tr>
                                    <td class="label-col">Ghi chú admin</td>
                                    <td class="note-text">"${order.returnAdminNote}"</td>
                                </tr>
                            </c:if>
                        </table>

                        <div style="display: grid; gap: 12px; margin-top: 15px;">
                            <div>
                                <strong>Ảnh khách gửi</strong>
                                <a href="${pageContext.request.contextPath}/${order.returnImageUrl}" target="_blank" style="display:block; margin-top: 8px;">
                                    <img src="${pageContext.request.contextPath}/${order.returnImageUrl}" alt="Ảnh hoàn hàng"
                                         style="max-width: 100%; border-radius: 6px; border: 1px solid #ddd;">
                                </a>
                            </div>
                            <div>
                                <strong>Video khách gửi</strong>
                                <video controls style="display:block; width: 100%; margin-top: 8px; border-radius: 6px; border: 1px solid #ddd;">
                                    <source src="${pageContext.request.contextPath}/${order.returnVideoUrl}">
                                </video>
                            </div>
                        </div>
                    </div>
                </c:if>
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
            <a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-arrow-left"></i> Quay lại danh sách</a>
        </div>
    </c:if>
</main>

<script src="${pageContext.request.contextPath}/admin/js/contact.js"></script>
</body>
</html>
