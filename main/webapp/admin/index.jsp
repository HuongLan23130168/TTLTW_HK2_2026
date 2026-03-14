<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>
<main>
    <!-- === DASHBOARD === -->
    <div class="main-content">
        <div class="center-box">
            <i class="fas fa-lock" style="font-size: 50px; color: #74512d;"></i>
            <h1>Đây là trang của Admin!</h1>
            <h3>Bạn cần <a href="${pageContext.request.contextPath}/login"
                           style="color: #74512d; text-decoration: underline;">đăng nhập</a> để xem nội dung dashboard
            </h3></div>
    </div>
</main>
<script src="js/main.js"></script>
</body>

</html>