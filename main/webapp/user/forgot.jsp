<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/contentForm.css" />
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
            <h2 class="form-title">Quên mật khẩu</h2>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <div class="form-holder">
                    <input type="email" name="email" class="input" placeholder="Nhập email của bạn" required />
                </div>

                <button type="submit" class="submit-btn" style="border:none; width:100%; cursor:pointer;">
                    Gửi liên kết đặt lại
                </button>
            </form>

            <p class="switch-text">
                <a href="${pageContext.request.contextPath}/user/login.jsp" class="switch-btn" style="text-decoration: none;">
                    &larr; Quay lại đăng nhập
                </a>
            </p>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        <c:if test="${not empty errorMessage}">
        Swal.fire({
            icon: 'error',
            title: '<span style="color: #74512D">Lỗi</span>',
            text: '${errorMessage}',
            confirmButtonColor: '#74512D'
        });
        </c:if>
    </script>

</body>

</html>