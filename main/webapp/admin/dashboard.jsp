<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">

</head>

<body>

<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<div class="main-content">
    <!-- Stats Cards -->
    <div class="stats-cards">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-chart-line"></i>
            </div>
            <div class="stat-info">
                <h3>Tổng doanh thu</h3>
                <p class="stat-value">
                    <fmt:formatNumber value="${revenue}" type="number" maxFractionDigits="0"/>₫
                </p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-info">
                <h3>Đơn hàng chờ</h3>
                <p class="stat-value">${pendingOrdersCount}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-boxes"></i>
            </div>
            <div class="stat-info">
                <h3>Tồn kho</h3>
                <p class="stat-value">${totalStock}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="stat-info">
                <h3>Sắp hết hàng</h3>
                <p class="stat-value">${lowStock}</p>
            </div>
        </div>
    </div>

    <div class="stats-section">
        <div class="chart-section">
            <div class="chart-header">
                <h3><i class="fas fa-chart-line"></i> Biểu đồ Doanh thu</h3>
                <div class="chart-filters">
                    <a href="?filter=week" class="filter-btn ${currentFilter == 'week' ? 'active' : ''}">1 Tuần</a>
                    <a href="?filter=month" class="filter-btn ${currentFilter == 'month' ? 'active' : ''}">1 Tháng</a>
                    <a href="?filter=year" class="filter-btn ${currentFilter == 'year' ? 'active' : ''}">1 Năm</a>
                    <button class="filter-btn ${currentFilter == 'custom' ? 'active' : ''}" onclick="toggleDateRange()">
                        <i class="fas fa-calendar-alt"></i> Tùy chỉnh
                    </button>
                </div>
            </div>

            <div id="dateRangePicker" style="display: ${currentFilter == 'custom' ? 'flex' : 'none'}; margin-bottom: 20px; gap: 10px; align-items: center; flex-wrap: wrap;">
                <div class="date-input-group">
                    <label><i class="fas fa-calendar-alt"></i> Từ ngày:</label>
                    <input type="date" id="fromDate" name="fromDate" value="${fromDate}" class="date-input">
                </div>
                <div class="date-input-group">
                    <label><i class="fas fa-calendar-alt"></i> Đến ngày:</label>
                    <input type="date" id="toDate" name="toDate" value="${toDate}" class="date-input">
                </div>
                <button class="apply-date-btn" onclick="applyDateRange()">
                    <i class="fas fa-chart-line"></i> Xem thống kê
                </button>
                <div class="date-range-info">
                    <i class="fas fa-info-circle"></i>
                    <span id="dateRangeInfo"></span>
                </div>
            </div>

            <div style="height: 320px;">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <div class="best-seller">
            <h3><i class="fas fa-trophy"></i> Sản phẩm bán chạy</h3>
            <ul class="top-products">
                <c:forEach var="p" items="${bestSellers}">
                    <li>
                        <img src="${p.image_url}" alt="${p.product_name}" onerror="this.src='${pageContext.request.contextPath}/admin/images/no-image.png'">
                        <div>
                            <strong class="prod-title">${p.product_name}</strong>
                            <p class="muted">
                                <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/>₫
                                - ${p.totalSold} đã bán
                            </p>
                        </div>
                    </li>
                </c:forEach>
                <c:if test="${empty bestSellers}">
                    <li class="no-data">Chưa có dữ liệu sản phẩm bán chạy</li>
                </c:if>
            </ul>
        </div>
    </div>

    <div class="recent-orders-wrapper">
        <div class="recent-orders-header">
            <h3><i class="fas fa-shopping-cart"></i> Đơn hàng gần đây</h3>
            <div class="search-orders">
                <input type="text" class="search-input-orders" placeholder="Tìm kiếm đơn hàng...">
                <i class="fas fa-search search-icon-orders"></i>
            </div>
        </div>

        <div class="recent-orders-table">
            <table>
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Ngày đặt</th>
                    <th class="text-right">Tổng tiền</th>
                    <th class="text-center">Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${recentOrders}">
                    <tr>
                        <td><a href="order-detail?id=${o.id}">#${o.orderCode}</a></td>
                        <td>${o.recipientName}</td>
                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-right"><fmt:formatNumber value="${o.totalPrice}" type="number" maxFractionDigits="0"/>₫</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${o.status == 'Đã giao hàng - Hoàn thành' or o.status == 'đã giao'}">
                                    <span class="status delivered"><i class="fas fa-check-circle"></i> Đã giao</span>
                                </c:when>
                                <c:when test="${o.status == 'Đã hủy' or o.status == 'đã hủy'}">
                                    <span class="status cancelled"><i class="fas fa-times-circle"></i> Đã hủy</span>
                                </c:when>
                                <c:when test="${o.status == 'Chờ xử lý'}">
                                    <span class="status pending"><i class="fas fa-clock"></i> Chờ xử lý</span>
                                </c:when>
                                <c:when test="${o.status == 'Đã xác nhận - Giao vẫn chuyển'}">
                                    <span class="status shipping"><i class="fas fa-truck"></i> Đang giao</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status processing"><i class="fas fa-spinner"></i> ${o.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentOrders}">
                    <tr>
                        <td colspan="5" class="no-data">Chưa có đơn hàng nào</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    window.chartLabels = ${jsonLabels != null ? jsonLabels : '[]'};
    window.chartData = ${jsonValues != null ? jsonValues : '[]'};
    window.currentFilter = '${currentFilter}';
</script>
<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
<script src="${pageContext.request.contextPath}/admin/js/dashboard.js"></script>
</body>

</html>
