<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ - Noble Loft Theory</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/contact.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">

</head>

<body>


<style>
    .breadcrumb {
        margin: 20px 40px 10px;
        color: #333;
    }

    .breadcrumb a {
        text-decoration: none;
        color: #000;
    }

    .breadcrumb a:hover {
        text-decoration: underline;
        color: #74512D;
    }

    .breadcrumb .current {
        color: #74512D;
        font-weight: 700;
    }
</style>
<jsp:include page="/user/header.jsp"/>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <span class="current">Liên hệ </span>
</div>

<main class="contact-main">
    <h1>Liên hệ với chúng tôi</h1>

    <% if ("true".equals(request.getParameter("success"))) { %>
    <div id="toast-success" class="toast-success show">
        <i>Gửi liên hệ thành công!</i>

    </div>
    <% } %>
    <p>Hãy để lại lời nhắn hoặc liên hệ trực tiếp nếu bạn có bất kỳ thắc mắc nào.
        Chúng tôi rất hân hạnh được hỗ trợ bạn!</p>


    <div class="contact-container">
        <!-- KHUNG NHỎ CHO THÔNG TIN LIÊN HỆ -->
        <div class="info-wrapper">
            <div class="contact-info">
                <h2>Thông tin liên hệ</h2>
                <p><i class="fa-solid fa-location-dot"></i> Khu phố 33, P.Linh Xuân, TP.HCM</p>
                <p><i class="fa-solid fa-building"></i> Đại học Nông Lâm TP.HCM</p>
                <p><i class="fa-solid fa-phone"></i> 0375 184 144 - 0338 177 631</p>
                <p><i class="fa-solid fa-envelope"></i> NLT@noblelofttheory.com</p>
                <p><i class="fa-brands fa-facebook"></i> Noble Loft Theory Decor</p>
            </div>
        </div>


        <form class="contact-form"
              action="${pageContext.request.contextPath}/contact"
              method="post">

            <h2>Gửi lời nhắn cho chúng tôi</h2>
            <label for="full_name">Họ và tên</label>
            <input type="text"
                   id="full_name"
                   name="full_name"
                   placeholder="Nhập họ và tên của bạn"
                   required>

            <label for="email">Email</label>
            <input type="email"
                   id="email"
                   name="email"
                   placeholder="Nhập email của bạn"
                   required>

            <label for="message">Nội dung</label>
            <textarea id="message"
                      name="message"
                      rows="5"
                      placeholder="Nhập nội dung liên hệ..."
                      required></textarea>

            <button type="submit">Gửi liên hệ</button>
        </form>

        <!-- FORM GỬI LIÊN HỆ -->
        <%--            <form class="contact-form"--%>
        <%--                  action="${pageContext.request.contextPath}/contact"--%>
        <%--                  method="post">--%>
        <%--            <h2>Gửi lời nhắn cho chúng tôi</h2>--%>
        <%--                <label for="name">Họ và tên</label>--%>
        <%--                <input type="text" id="name" name="name" placeholder="Nhập họ và tên của bạn" required>--%>

        <%--                <label for="email">Email</label>--%>
        <%--                <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>--%>

        <%--                <label for="message">Nội dung</label>--%>
        <%--                <textarea id="message" name="message" rows="5" placeholder="Nhập nội dung liên hệ..."--%>
        <%--                    required></textarea>--%>

        <%--                <button type="submit">Gửi liên hệ</button>--%>
        <%--            </form>--%>


    </div>
</main>

<jsp:include page="/user/footer.jsp"/>

<script>


    const toast = document.getElementById("toast-success");

    if (toast) {
        setTimeout(() => {
            toast.classList.remove("show");
            setTimeout(() => toast.remove(), 400);
        }, 2000);
    }

    if (window.location.search.includes("success=true")) {
        setTimeout(() => {
            const url = new URL(window.location);
            url.searchParams.delete("success");
            window.history.replaceState({}, document.title, url.pathname);
        }, 100); // xoá ngay sau khi load
    }
</script>


</body>

</html>