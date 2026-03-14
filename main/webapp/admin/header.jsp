<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Header</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>

</head>
<body>

<header class="header">
    <div class="header-left">
    </div>

    <div class="header-right">

        <div class="profile-dropdown">
            <button class="icon-button user-btn">
                <i class="fa-solid fa-user"></i>
            </button>

            <div class="dropdown-menu">
                <a href="account.jsp"><i class="fas fa-user"></i> Tài khoản</a>
                <a href="index.jsp"><i class="fas fa-right-from-bracket"></i> Đăng xuất</a>
            </div>
        </div>
    </div>
</header>

</body>
</html>
