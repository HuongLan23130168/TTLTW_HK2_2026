<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Chi tiết khách hàng - ${customer.fullName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customerDetail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<!-- === DASHBOARD === -->
<main class="main-content">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/customers">Khách hàng</a> /
        <span class="current">${customer.fullName}</span>
    </div>

    <c:if test="${not empty customer}">
        <div class="customer-detail-container">
            <div class="detail-card-left">
                <div class="title-cus">
                    <h2>Thông tin cá nhân</h2>
                </div>
                <div class="customer-info">
                    <p><strong>Họ và tên:</strong> ${customer.fullName}</p>
                    <p><strong>Email:</strong> ${customer.email}</p>
                    <p><strong>Số điện thoại:</strong> ${customer.phone}</p>
                    <p><strong>Giới tính:</strong> ${not empty customer.gender ? customer.gender : 'Chưa cập nhật'}</p>
                    <p><strong>Ngày sinh:</strong> ${not empty customer.birth ? customer.birth : 'Chưa cập nhật'}</p>
                    <p><strong>Địa chỉ:</strong> ${not empty customer.address ? customer.address : 'Chưa cập nhật'}</p>
                </div>
            </div>

            <div class="detail-card-right">
                <div class="title-cus">
                    <h2>Thống kê</h2>
                </div>
                <div class="customer-stats">
                    <div class="stat-card">
                        <h3>Tổng đơn hàng</h3>
                        <p>${fn:length(orderList)}</p>
                    </div>
                    <div class="stat-card">
                        <h3>Tổng tiền đã mua</h3>
                        <p><fmt:formatNumber value="${totalSpent}" type="currency" currencySymbol="₫" /></p>
                    </div>
                    <div class="stat-card">
                        <h3>Đơn hàng gần nhất</h3>
                        <c:if test="${not empty latestOrder}">
                            <p>#${latestOrder.id} - <fmt:formatDate value="${latestOrder.orderDate}" pattern="dd/MM/yyyy" /></p>
                        </c:if>
                        <c:if test="${empty latestOrder}">
                            <p>Chưa có</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="order-history-card">
            <div class="title-cus">
                <h2>Lịch sử mua hàng</h2>
            </div>
            <div class="recent-orders">
                <table>
                    <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty orderList}">
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 20px;">Chưa có đơn hàng nào.</td>
                        </tr>
                    </c:if>
                    <c:forEach items="${orderList}" var="order">
                        <tr>
                            <td>#${order.orderCode}</td>
<%--                            <td>--%>
<%--                                <a href="${pageContext.request.contextPath}/admin/viewOrder?orderId=${order.id}">#${order.id}</a>--%>
<%--                            </td>--%>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <fmt:formatNumber value="${order.totalPrice}" type="number"/>₫
                            </td>
<%--                            <td>--%>
<%--                                <c:set var="statusClass" value="secondary" />--%>
<%--                                <c:set var="statusLower" value="${fn:toLowerCase(order.status)}" />--%>
<%--                                <c:choose>--%>
<%--                                    <c:when test="${fn:contains(statusLower, 'đã giao') || fn:contains(statusLower, 'thành công')}">--%>
<%--                                        <c:set var="statusClass" value="success" />--%>
<%--                                    </c:when>--%>
<%--                                    <c:when test="${fn:contains(statusLower, 'đang xử lý') || fn:contains(statusLower, 'chờ')}">--%>
<%--                                        <c:set var="statusClass" value="warning" />--%>
<%--                                    </c:when>--%>
<%--                                    <c:when test="${fn:contains(statusLower, 'đã hủy') || fn:contains(statusLower, 'thất bại')}">--%>
<%--                                        <c:set var="statusClass" value="danger" />--%>
<%--                                    </c:when>--%>
<%--                                </c:choose>--%>
<%--                                <span class="status ${statusClass}">--%>
<%--                                    ${order.status}--%>
<%--                                </span>--%>
<%--                            </td>--%>
                            <td>${order.status}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
    <c:if test="${empty customer}">
        <p>Không tìm thấy thông tin khách hàng với ID được cung cấp.</p>
    </c:if>

    <div class="back-to-customers">
        <a href="${pageContext.request.contextPath}/admin/customers">Quay lại</a>
    </div>
</main>

<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
</body>

</html>
