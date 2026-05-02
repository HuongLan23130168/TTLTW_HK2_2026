<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Orders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">


    <style>
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        .filter-container form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-icon {
            position: absolute;
            left: 10px;
            color: #888;
            font-size: 14px;
            pointer-events: none;
        }

        .search-order-input {
            padding: 8px 12px 8px 35px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            width: 240px;
            outline: none;
            transition: border-color 0.3s;
        }

        .search-order-input:focus {
            border-color: #bca77d;
        }

        .btn-search {
            background-color: #bca77d;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .btn-search:hover {
            background-color: #a68a63;
        }

        .filter-select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            cursor: pointer;
        }
    </style>
</head>
<style>
    .alert {
        padding: 15px;
        margin-bottom: 20px;
        border: 1px solid transparent;
        border-radius: 4px;
    }

    .alert-danger {
        color: #721c24;
        background-color: #f8d7da;
        border-color: #f5c6cb;
    }
</style>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="customers-header">
        <h1>Danh sách đơn hàng</h1>
        <div class="filter-container">
            <form method="get" action="${pageContext.request.contextPath}/admin/orders">

                <div class="search-wrapper">
                    <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    <input type="text" name="search" class="search-order-input"
                           placeholder="Tìm mã đơn, tên khách..."
                           value="${param.search}">
                </div>

                <button type="submit" class="btn-search">
                    Tìm kiếm
                </button>

                <select name="sortBy" onchange="this.form.submit()">
                    <option value="newest" ${param.sortBy == 'newest' || empty param.sortBy ? 'selected' : ''}>Mới
                        nhất
                    </option>
                    <option value="oldest" ${param.sortBy == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                </select>
            </form>
        </div>
    </div>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger" role="alert">
                ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="table-container">
        <table class="customers-table">
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="order" items="${orders}">
                <tr>
                    <td>#${order.order_code}</td>
                    <td>${order.recipient_name}</td>
                    <td><fmt:formatDate value="${order.order_date}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><fmt:formatNumber value="${order.total_price}" type="number"/>₫</td>
                    <td>
                        <c:set var="lowerStatus" value="${fn:toLowerCase(order.status)}"/>
                        <c:choose>
                            <c:when test="${fn:contains(lowerStatus, 'hoàn thành') or fn:contains(lowerStatus, 'đã giao')}">
                                <span class="status status-completed">${order.status}</span>
                            </c:when>
                            <c:when test="${fn:contains(lowerStatus, 'hủy')}">
                                <span class="status status-cancelled">${order.status}</span>
                            </c:when>
                            <c:when test="${fn:contains(lowerStatus, 'xử lý') or fn:contains(lowerStatus, 'chờ')}">
                                <span class="status status-pending">${order.status}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status">${order.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/viewOrder?orderId=${order.id}"
                           class="view-btn">Xem</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>
</body>

</html>