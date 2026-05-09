<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Mật khẩu mới</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/contentForm.css"/>
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
    <div class="content">
        <h2 class="form-title">Đặt lại mật khẩu</h2>
        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <input type="hidden" name="token" value="${token != null ? token : param.token}"/>

            <div class="form-holder">
                <div class="input-group">
                    <input type="password" name="newPassword" id="newPassword" class="input" placeholder="Mật khẩu mới"
                           required/>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePass(this, 'newPassword')"></i>
                </div>

                <div class="input-group">
                    <input type="password" name="confirmPassword" id="confirmPassword" class="input"
                           placeholder="Xác nhận mật khẩu" required/>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePass(this, 'confirmPassword')"></i>
                </div>
            </div>

            <button type="submit" class="submit-btn" style="border:none; width:100%; cursor:pointer;">
                Cập nhật mật khẩu
            </button>

            <p class="switch-text">
                <a href="${pageContext.request.contextPath}/user/login.jsp" class="switch-btn"
                   style="text-decoration: none; margin-top: 20px; display: block;">
                    &larr; Quay lại đăng nhập
                </a>
            </p>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function togglePass(iconElement, inputId) {
        const input = document.getElementById(inputId);
        if (input.type === "password") {
            input.type = "text";
            iconElement.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            input.type = "password";
            iconElement.classList.replace("fa-eye-slash", "fa-eye");
        }
    }

    <c:if test="${not empty errorMessage}">
    Swal.fire({
        icon: 'error',
        title: 'Lỗi',
        text: '${errorMessage}',
        confirmButtonColor: '#74512D'
    });
    </c:if>

    document.querySelector("form").addEventListener("submit", function (e) {
        const pass = document.getElementById('newPassword').value;
        const confirm = document.getElementById('confirmPassword').value;
        const regex = /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        if (!regex.test(pass)) {
            e.preventDefault();
            Swal.fire({
                icon: 'warning',
                title: 'Mật khẩu yếu',
                html: 'Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 số và 1 ký tự đặc biệt!',
                confirmButtonColor: '#74512D'
            });
        } else if (pass !== confirm) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Không khớp',
                text: 'Xác nhận mật khẩu không trùng khớp!',
                confirmButtonColor: '#74512D'
            });
        }
    });
</script>
</body>

</html>