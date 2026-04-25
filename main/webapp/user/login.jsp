<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng ký / Đăng nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/login.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

</head>

<body>
<style>
    @import url("https://fonts.googleapis.com/css?family=Fira+Sans");

    html,
    body {
        height: 100%;
        margin: 0;
        background-color: #E1E8EE;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: "Fira Sans", Helvetica, Arial, sans-serif;
        font-size: 14px;
    }

    .form-structor {
        background-color: #222;
        border-radius: 15px;
        height: 600px;
        width: 400px;
        position: relative;
        overflow: hidden;
    }

    .form-structor::after {
        content: "";
        opacity: 0.8;
        position: absolute;
        inset: 0;
        background: url("https://i.postimg.cc/ncBkxWWJ/bgr-login.jpg") no-repeat left bottom / 500px;
    }

    .switch-text {
        text-align: center;
        font-size: 12px;
        color: rgba(255, 255, 255, 0.8);
    }

    .switch-text .switch-btn {
        margin-top: 10px;
        color: #74512D;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-block;
    }

    .switch-text .switch-btn:hover {
        color: #A79277;
        text-decoration: underline;
    }
</style>

<div class="form-structor">
    <div class="signup">
        <h2 class="form-title">Đăng ký</h2>
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-holder">
                <input type="text" name="fullname" class="input" placeholder="Họ và tên" required/>
                <input type="email" name="email" class="input" placeholder="Email" required/>
                <div class="password-field">
                    <input type="password" name="password" id="reg-pass" class="input" placeholder="Mật khẩu" required/>
                    <i class="fa-solid fa-eye" onclick="togglePass('reg-pass', this)"></i>
                </div>
                <div class="password-field">
                    <input type="password" name="confirmPassword" id="confirm-pass" class="input"
                           placeholder="Xác nhận mật khẩu" required/>
                    <i class="fa-solid fa-eye" onclick="togglePass('confirm-pass', this)"></i>
                </div>
            </div>
            <button type="submit" class="submit-btn" style="border:none; width:100%; cursor:pointer;">Đăng ký</button>
        </form>
        <p class="switch-text">Đã có tài khoản? <span id="signin" class="switch-btn">Đăng nhập</span></p>

    </div>

    <div class="signin slide-up">
        <div class="center">
            <h2 class="form-title">Đăng nhập</h2>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-holder">
                    <input type="email" name="email" class="input" placeholder="Email" required/>
                    <div class="password-field">
                        <input type="password" name="password" id="login-pass" class="input" placeholder="Mật khẩu"
                               required/>
                        <i class="fa-solid fa-eye" onclick="togglePass('login-pass', this)"></i>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/user/forgot.jsp" class="forgot-password">Quên mật
                    khẩu?</a>
                <p class="switch-text">Chưa có tài khoản? <span id="signup-btn" class="switch-btn">Đăng ký</span></p>
                <button type="submit" class="submit-btn" style="border:none; width:100%; cursor:pointer;">Đăng nhập
                </button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/user/js/login.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('logout')) {
        Toast.fire({
            icon: 'success',
            title: 'Đã đăng xuất thành công!'
        });
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    <c:if test="${not empty errorMessage}">
    document.querySelector(".signup").classList.add("slide-up");
    document.querySelector(".signin").classList.remove("slide-up");

    Swal.fire({
        icon: 'error',
        title: '<span style="color: #74512D">Lỗi đăng nhập</span>',
        text: '${errorMessage}',
        confirmButtonColor: '#74512D',
        showClass: {popup: 'animate__animated animate__shakeX'}
    });
    </c:if>

    <c:if test="${not empty registerError}">
    document.querySelector(".signup").classList.remove("slide-up");
    document.querySelector(".signin").classList.add("slide-up");

    Swal.fire({
        icon: 'error',
        title: '<span style="color: #74512D">Lỗi đăng ký</span>',
        text: '${registerError}',
        confirmButtonColor: '#74512D',
        showClass: {popup: 'animate__animated animate__shakeX'}
    });
    </c:if>

    <c:if test="${not empty successMessage}">
    Toast.fire({
        icon: 'success',
        title: '${successMessage}'
    });
    </c:if>
</script>
</body>
</html>