<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giới thiệu - Noble Loft Theory</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/gioithieu.css">

</head>

<body>
<style>
    /* === BREADCRUMB === */
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

    /* ===== NÚT LÊN ĐẦU TRANG ===== */
    #backToTop {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 45px;
        height: 45px;
        background: #c19a6b;
        color: #fff;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        font-size: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        opacity: 0;
        pointer-events: none;
        transition: all 0.4s ease;
        z-index: 1000;
    }

    #backToTop:hover {
        background: #b68950;
        transform: translateY(-4px);
    }

    /* Khi hiển thị */
    #backToTop.show {
        opacity: 1;
        pointer-events: auto;
    }
</style>
<jsp:include page="/user/header.jsp"/>

<!-- ===== BREADCRUMB / TIẾN TRÌNH ===== -->
<div class="breadcrumb">
    <a href="home.jsp">Trang chủ</a> &#47;
    <span class="current">Giới thiệu </span>
</div>

<div class="content">

    <section class="intro-section">
        <div class="intro-bg">
            <div class="overlay"></div>
            <h1>Noble Loft Theory</h1>
        </div>
        <div class="intro-content">
            <p>
                Noble Loft Theory ra đời với sứ mệnh mang đến không gian sống tinh tế, ấm cúng và thể hiện rõ phong
                cách cá nhân của gia chủ.
                Chúng tôi tin rằng nội thất không chỉ là vật dụng, mà là sự kết hợp giữa nghệ thuật, cảm xúc và giá
                trị sống.
            </p>
        </div>
    </section>

    <h2>Tầm nhìn & Sứ mệnh</h2>

    <section class="vision-mission">
        <div class="vision-mission-bg">
            <div class="overlay"></div>
        </div>
        <div class="vision-container">
            <div class="vision-box">
                <h3>Tầm nhìn</h3>
                <p>
                    “Vươn tầm trở thành điểm mua sắm nội thất được yêu thích và tin cậy hàng đầu tại Việt Nam.”
                    Tầm nhìn của <b>Noble Loft Theory</b> không chỉ dừng lại ở việc cung cấp sản phẩm nội thất,
                    mà còn mong muốn mang đến những giá trị tích cực cho cuộc sống hiện đại của người Việt.
                    Từ việc lựa chọn nguyên liệu bền vững đến thiết kế không gian sống tinh giản,
                    chúng tôi cam kết đóng góp vào sự phát triển của cộng đồng và môi trường.
                </p>
                <p>
                    Chia sẻ triết lý kinh doanh và hành động theo những giá trị cốt lõi,
                    chúng tôi hy vọng trở thành nhân tố tạo nên thay đổi tích cực cho xã hội,
                    mang lại không gian sống tốt đẹp, tiện nghi và thân thiện với môi trường.
                </p>
            </div>

            <div class="mission-box">
                <h3>Sứ mệnh</h3>
                <p>
                    <b>Noble Loft Theory</b> luôn lấy sứ mệnh làm kim chỉ nam cho mọi bước phát triển – đó chính là
                    giá trị bền vững, gắn kết giữa con người và không gian sống.
                    Chúng tôi không chỉ tạo ra sản phẩm nội thất, mà còn kiến tạo phong cách sống tinh tế, đề cao
                    tính thẩm mỹ và sự tiện nghi trong từng chi tiết.
                    Với tinh thần tận tâm và sáng tạo.
                </p>
                <p>
                    <b>Noble Loft Theory</b> hướng đến việc mang lại giá trị bền
                    vững cho khách hàng, nhân viên và cộng đồng – nơi mỗi sản phẩm đều chứa đựng đam mê, trách nhiệm
                    và dấu ấn riêng của chúng tôi.
                </p>
            </div>
        </div>
    </section>


    <h2>Giá trị cốt lõi</h2>
    <div class="values">
        <div class="value-card">
            <div class="value-text">
                <h3>
                    <span class="value-letter">N</span><span class="value-suffix">oble</span>
                </h3>
                <h3>Nội Thất</h3>
                <p>
                    Noble Loft Theory mang đến những sản phẩm nội thất tinh tế,
                    kết hợp giữa chất liệu tự nhiên và thiết kế hiện đại,
                    tạo nên không gian sống tiện nghi, gần gũi.
                </p>
            </div>
            <img src="https://i.pinimg.com/1200x/e1/13/24/e11324ba9a92c3c0651731594837e4a4.jpg" alt="Nội Thất"
                 class="value-img">
        </div>

        <div class="value-card">
            <div class="value-text">
                <h3>
                    <span class="value-letter">L</span><span class="value-suffix">oft</span>
                </h3>
                <h3>Long Trọng</h3>
                <p>
                    Từng chi tiết đều được chăm chút tỉ mỉ, hướng đến sự thanh lịch và sang trọng trong từng đường
                    nét.
                    Noble Loft Theory tin rằng sự tinh giản chính là đỉnh cao của vẻ đẹp — nơi mỗi sản phẩm không
                    chỉ
                    là vật dụng nội thất, mà còn là biểu tượng của phong cách sống đẳng cấp và gu thẩm mỹ tinh tế.
                </p>
            </div>
            <img src="https://i.pinimg.com/736x/fa/32/55/fa32552aedaa5f9a55d34a41462ecd73.jpg" alt="Long Trọng"
                 class="value-img">
        </div>

        <div class="value-card">
            <div class="value-text">
                <h3>
                    <span class="value-letter">T</span><span class="value-suffix">heory</span>
                </h3>
                <h3>Thiết Kế</h3>
                <p>
                    Mỗi sản phẩm là sự kết hợp hài hòa giữa công năng và nghệ thuật,
                    thể hiện tinh thần sáng tạo và phong cách sống riêng của từng khách hàng.
                </p>
            </div>
            <img src="https://i.pinimg.com/736x/c7/e0/aa/c7e0aacaad9db60818f4983776ec8177.jpg" alt="Thiết Kế"
                 class="value-img">
        </div>
    </div>


    <div class="slogan-box">
        <img src="https://i.pinimg.com/736x/66/70/39/6670391806499c5c1b29ba6bdca60184.jpg"
             alt="Không gian sáng tạo">
        <div class="slogan-overlay">
            <p>“Nâng tầm không gian – Kiến tạo giá trị sống tinh tế.”</p>
        </div>
    </div>
    <section class="camket">
        <h2>Cam kết dịch vụ</h2>
        <p>
            Noble Loft Theory cam kết mang lại trải nghiệm mua sắm minh bạch, hỗ trợ bảo hành tận nơi và tư vấn
            thiết kế trọn gói.
            Sự hài lòng của khách hàng là nền tảng cho mọi hoạt động của chúng tôi.
        </p>
    </section>

    <div class="closing">
        Cảm ơn bạn đã tin tưởng và đồng hành cùng <strong>Noble Loft Theory</strong> – nơi khởi nguồn cho không gian
        sống đẳng cấp và tinh tế.
    </div>
</div>

<!-- NÚT LÊN ĐẦU TRANG -->
<button id="backToTop" title="Lên đầu trang">
    <i class="fa-solid fa-arrow-up"></i>
</button>

<jsp:include page="/user/footer.jsp"/>


</body>

</html>