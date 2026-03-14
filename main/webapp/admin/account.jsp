<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Noble Loft Theory - Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/account.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<div class="main-content account-page">
    <div class="profile-container">
        <h2>Tài khoản Admin</h2>

        <div class="profile-header">
            <div class="avatar">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.acc.fullName}&background=74512d&color=fff" alt="Admin">
            </div>
            <div class="info">
                <h3 id="adminName">${sessionScope.acc.fullName}</h3>
            </div>
            <button class="edit-btn" onclick="toggleEdit()">
                <i class="fas fa-pen-to-square"></i> Sửa
            </button>
        </div>

        <div class="card">
            <h4>Thông tin tài khoản</h4>
            <div class="row"><strong>Email:</strong> <span id="email">${sessionScope.acc.email}</span></div>
            <div class="row"><strong>Số điện thoại:</strong> <span id="phone">${sessionScope.acc.phone}</span></div>
            <div class="row"><strong>Giới tính:</strong> <span id="gender">${sessionScope.acc.gender}</span></div>
            <div class="row"><strong>Ngày sinh:</strong> <span id="birth">${sessionScope.acc.birth}</span></div>
            <div class="row"><strong>Chức vụ:</strong> Quản trị viên</div>
        </div>

        <div class="card">
            <h4>Địa chỉ</h4>
            <div class="row">
                <strong>Địa chỉ hiện tại:</strong>
                <span id="displayAddress">${not empty sessionScope.acc.address ? sessionScope.acc.address : 'Chưa cập nhật địa chỉ'}</span>
            </div>
        </div>

        <form id="editForm" class="card hidden" action="${pageContext.request.contextPath}/admin/update-account" method="POST">
            <label>Họ tên:</label>
            <input type="text" name="fullName" value="${sessionScope.acc.fullName}" required>

            <label>Email:</label>
            <input type="email" name="email" value="${sessionScope.acc.email}" readonly style="background: #eee;">

            <label>Số điện thoại:</label>
            <input type="text" name="phone" id="editPhone" value="${sessionScope.acc.phone}" maxlength="20" required>

            <label>Giới tính:</label>
            <select name="gender">
                <option value="Nam" ${sessionScope.acc.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                <option value="Nữ" ${sessionScope.acc.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                <option value="Khác" ${sessionScope.acc.gender == 'Khác' ? 'selected' : ''}>Khác</option>
            </select>

            <label>Ngày sinh:</label>
            <input type="date" name="birth" value="${sessionScope.acc.birth}">

            <label>Địa chỉ:</label>
            <input type="text" name="address" value="${sessionScope.acc.address}" required>

            <div class="btn-group">
                <button type="submit" class="save-btn">Lưu</button>
                <button type="button" class="cancel-btn" onclick="toggleEdit()">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/admin/js/account.js"></script>
</body>

</html>