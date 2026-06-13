<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Customers</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="customers-header">
        <h1>Danh sách khách hàng</h1>
        <div class="filter-container">
            <form method="get" action="${pageContext.request.contextPath}/admin/customers">
                <div class="search-wrapper">
                    <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    <input type="text" name="search" class="search-customer-input"
                           placeholder="Tìm tên, email, sđt..."
                           value="${param.search}">
                </div>

                <button type="submit" class="btn-search">
                    Tìm kiếm
                </button>

                <select name="sortBy" onchange="this.form.submit()">
                    <option value="newest" ${param.sortBy == 'newest' || empty param.sortBy ? 'selected' : ''}>Tài khoản mới nhất</option>
                    <option value="oldest" ${param.sortBy == 'oldest' ? 'selected' : ''}>Tài khoản cũ nhất</option>
                </select>
            </form>
        </div>
    </div>

    <div class="table-container">
        <table class="customers-table">
            <thead>
            <tr>
                <th>STT</th>
                <th>Tên</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>Ngày tạo</th>
                <th>Chi tiết</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${customers}" var="c" varStatus="loop">
                <tr>
                    <td>${loop.count}</td>
                    <td>${c.fullName}</td>
                    <td>${c.email}</td>
                    <td>${c.phone}</td>
                    <td><fmt:formatDate value="${c.created_at}" pattern="dd-MM-yyyy HH:mm:ss"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.id}" class="view-btn">Xem</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>


<script src="${pageContext.request.contextPath}/admin/js/contact.js"></script>
</body>

</html>
