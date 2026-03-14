<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Sidebar</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>

</head>
<body>


<div class="sidebar" id="sidebar">
    <div class="logo">
        <a href="dashboard.jsp">Noble Loft Theory</a>
    </div>

    <ul>
        <li class="active">
            <a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a>
        </li>
        <li>
            <a href="banners.jsp"><i class="fas fa-box"></i> Banner</a>
        </li>
        <li>
            <a href="products.jsp"><i class="fas fa-box"></i> Sản phẩm</a>
        </li>
        <li>
            <a href="orders.jsp"><i class="fas fa-cart-shopping"></i> Đơn hàng</a>
        </li>
        <li>
            <a href="customers.jsp"><i class="fas fa-users"></i> Khách hàng</a>
        </li>

        <li>
            <a href="account.jsp"><i class="fas fa-gear"></i> Tài khoản</a>
        </li>
    </ul>
</div>

</body>
</html>
