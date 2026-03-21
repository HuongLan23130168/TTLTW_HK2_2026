<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<div class="main-content">

    <div class="stats-section">
        <div class="chart-section">
            <h3>Biểu đồ Doanh thu (7 ngày)</h3>
            <div style="height: 300px;">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <div class="best-seller">
            <h3>Sản phẩm bán chạy</h3>
            <ul class="top-products">
                <c:forEach var="p" items="${bestSellers}">
                    <li>
                        <img src="${p.image_url}" alt="${p.product_name}">
                        <div>
                            <strong class="prod-title">${p.product_name}</strong>
                            <p class="muted">
                                <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/>₫
                                - ${p.totalSold} đã bán
                            </p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>


    <div class="recent-orders">
        <div class="recent-orders-header">
            <h3>Đơn hàng gần đây</h3>
        </div>

        <div class="recent-orders">
            <table>
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${recentOrders}">
                    <tr>
                        <td><a href="order-detail?id=${o.id}">#${o.orderCode}</a></td>
                        <td>${o.recipientName}</td>
                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><fmt:formatNumber value="${o.totalPrice}" type="number" maxFractionDigits="0"/>₫</td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status == 'đã giao'}">
                                    <span class="status delivered">Đã giao</span>
                                </c:when>
                                <c:when test="${o.status == 'đã hủy'}">
                                    <span class="status cancelled">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status processing">${o.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const chartLabels = ${not empty jsonLabels ? jsonLabels : '[]'};
    const chartData = ${not empty jsonValues ? jsonValues : '[]'};

    console.log("Labels:", chartLabels);
    console.log("Data:", chartData);
</script>
<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
<script src="${pageContext.request.contextPath}/admin/js/dashboard.js"></script>
</body>

</html>