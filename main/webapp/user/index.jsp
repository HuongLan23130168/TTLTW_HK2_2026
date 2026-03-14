<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Noble Loft Theory — Nội thất</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/footer.css">
        </head>

        <body>
            <jsp:include page="/frontend/header.jsp" />


            <main class="container">
                <section class="hero">
                    <div class="hero-bg">
                        <img src="https://i.pinimg.com/1200x/93/86/51/938651d21341d4d0ea6e5e91474487ef.jpg"
                            alt="Background mờ">
                    </div>

                    <div class="hero-blur"></div>

                    <div class="hero-img">
                        <img src="https://i.pinimg.com/1200x/f6/44/d5/f644d5876131e9a18d6a0c6d52af523e.jpg"
                            alt="Nội thất Noble Loft">
                    </div>

                    <div class="hero-content">
                        <h1>Noble Loft Theory</h1>
                        <p>
                            Kiến trúc nội thất phong cách Loft — sự kết hợp tinh tế giữa vật liệu thô mộc và thiết kế
                            hiện đại,
                            mang đến không gian sống mạnh mẽ, sang trọng và đầy cảm xúc.
                        </p>
                        <a href="#gallery" class="cta" id="scrollToGallery">Xem bộ sưu tập</a>
                    </div>
                </section>
                <!-- GALLERY -->
                <section class="section" id="gallery">
                    <h2 class="section-title">Bộ sưu tập mẫu</h2>
                    <div class="gallery-wrapper">
                        <button class="arrow left" onclick="prevSlide()">&#10094;</button>

                        <div class="gallery-track" id="galleryTrack">
                            <!-- Bộ sưu tập 1 -->
                            <div class="gallery-set">
                                <div class="card">
                                    <img src="https://i.pinimg.com/1200x/f6/44/d5/f644d5876131e9a18d6a0c6d52af523e.jpg"
                                        alt="Nội thất 1">
                                    <div class="card-body">
                                        <h3>Phòng khách sang trọng</h3>
                                        <p>Phong cách hiện đại, tinh tế với tông màu sáng nhẹ.</p>
                                    </div>
                                </div>
                                <div class="card">
                                    <img src="https://i.pinimg.com/1200x/b4/7c/db/b47cdb2336586f7a2509260f1b0bbe13.jpg"
                                        alt="Nội thất 2">
                                    <div class="card-body">
                                        <h3>Phòng ăn hiện đại</h3>
                                        <p>Thiết kế tối giản, nổi bật với ánh sáng tự nhiên.</p>
                                    </div>
                                </div>
                                <div class="card">
                                    <img src="https://i.pinimg.com/736x/83/25/61/832561a6c56758f270093fd924515306.jpg"
                                        alt="Nội thất 3">
                                    <div class="card-body">
                                        <h3>Phòng ngủ tinh tế</h3>
                                        <p>Không gian ấm áp, thư giãn sau ngày dài.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Bộ sưu tập 2 -->
                            <div class="gallery-set">
                                <div class="card">
                                    <img src="https://i.pinimg.com/736x/82/69/67/826967dc2ee6cfba2d32eb3e277ecd57.jpg"
                                        alt="Nội thất 4">
                                    <div class="card-body">
                                        <h3>Phòng làm việc nghệ thuật</h3>
                                        <p>Bố trí tiện nghi, tông màu gỗ tự nhiên.</p>
                                    </div>
                                </div>
                                <div class="card">
                                    <img src="https://i.pinimg.com/736x/d8/c5/19/d8c519bf9ed06094afd5e7d7c787f71b.jpg"
                                        alt="Nội thất 5">
                                    <div class="card-body">
                                        <h3>Phòng khách tối giản</h3>
                                        <p>Sử dụng ánh sáng vàng nhẹ tạo không khí ấm cúng.</p>
                                    </div>
                                </div>
                                <div class="card">
                                    <img src="https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=800&q=60"
                                        alt="Nội thất 6">
                                    <div class="card-body">
                                        <h3>Không gian nghệ thuật</h3>
                                        <p>Đường nét tinh tế, chất liệu cao cấp.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button class="arrow right" onclick="nextSlide()">&#10095;</button>
                    </div>
                    <section class="promo-slider">
                        <div class="slider-track">
                            <c:forEach var="banner" items="${banners}">
                                <div class="promo-group">
                                    <!-- Banner chính -->
                                    <div class="promo-main">
                                        <img src="${banner.imageUrl}" alt="${banner.title}">
                                        <div class="promo-content">
                                            <h2>${banner.title}</h2>
                                            <p>
                                                ${banner.description}
                                            </p>
                                            <a href="${banner.link}" class="promo-btn" id="scrollToProducts">Khám phá
                                                ngay</a>
                                        </div>
                                    </div>

                                    <div class="promo-side">
                                        <div class="promo-small sale-banner">
                                            <img src="${banner.subImageUrl}" alt="${banner.subTitle}">
                                            <div class="banner-text">
                                                <h3>${banner.subTitle}</h3>
                                                <p>${banner.subDescription}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>


                    <section class="new-products" id="newProducts">
                        <h2 class="section-title">Sản phẩm mới</h2>

                        <div class="product-grid">
                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">NEW</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/5d/8c/e9/5d8ce97e4cd9c1a5e95bee4f54e5e545.jpg"
                                        alt="Ghế Sofa">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Ghế Sofa</h3>
                                    <p>Thiết kế hiện đại, chất liệu da cao cấp mang đến sự sang trọng cho phòng khách.
                                    </p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">NEW</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/736x/87/3e/8f/873e8fe9f7b60dadec96991745ca8b30.jpg"
                                        alt="Bàn Trà">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Bàn Trà</h3>
                                    <p>Mẫu bàn trà tinh tế với chân gỗ bo tròn và mặt gỗ tự nhiên cao cấp.</p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">NEW</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/e8/0f/50/e80f50e56adbc55c040158dc32f31026.jpg"
                                        alt="Gương">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Gương</h3>
                                    <p>Gương trang trí, mang đến vẻ đẹp sang trọng cho không gian.</p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">NEW</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/f9/3c/8e/f93c8e2f5aafeb92760dc5db7bfb573e.jpg"
                                        alt="Thảm Trải Sàn">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Thảm Trải Sàn</h3>
                                    <p>Thảm họa tiết sang trọng, chất liệu mềm mại, phù hợp mọi phong cách nội thất.</p>
                                </div>
                            </a>
                        </div>
                    </section>
                    <section class="new-products" id="newProducts">
                        <h2 class="section-title">Sản phẩm bán chạy</h2>

                        <div class="product-grid">
                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">HOT</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/5d/8c/e9/5d8ce97e4cd9c1a5e95bee4f54e5e545.jpg"
                                        alt="Ghế Sofa">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Ghế Sofa</h3>
                                    <p>Thiết kế hiện đại, chất liệu da cao cấp mang đến sự sang trọng cho phòng khách.
                                    </p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">HOT</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/736x/87/3e/8f/873e8fe9f7b60dadec96991745ca8b30.jpg"
                                        alt="Bàn Trà">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Bàn Trà</h3>
                                    <p>Mẫu bàn trà tinh tế với chân gỗ bo tròn và mặt gỗ tự nhiên cao cấp.</p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">HOT</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/e8/0f/50/e80f50e56adbc55c040158dc32f31026.jpg"
                                        alt="Gương">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Gương</h3>
                                    <p>Gương trang trí, mang đến vẻ đẹp sang trọng cho không gian.</p>
                                </div>
                            </a>

                            <a href="decor.jsp" class="product-card">
                                <div class="badge-new">HOT</div>
                                <div class="product-img">
                                    <img src="https://i.pinimg.com/1200x/f9/3c/8e/f93c8e2f5aafeb92760dc5db7bfb573e.jpg"
                                        alt="Thảm Trải Sàn">
                                    <div class="overlay"><span>Xem thêm</span></div>
                                </div>
                                <div class="product-info">
                                    <h3>Thảm Trải Sàn</h3>
                                    <p>Thảm họa tiết sang trọng, chất liệu mềm mại, phù hợp mọi phong cách nội thất.</p>
                                </div>
                            </a>
                        </div>
                    </section>


                </section>

            </main>

            <button id="backToTop" title="Lên đầu trang">
                <i class="fa-solid fa-arrow-up"></i>
            </button>

            <footer class="footer">
                <div class="container">
                    <div class="footer-columns">
                        <!-- Cột 1: Giới thiệu -->
                        <div class="footer-col">
                            <h3>Giới thiệu</h3>
                            <p>Chào mừng bạn đến với <strong>Noble Loft Theory</strong> — không gian dành cho những ai
                                yêu thích
                                cái đẹp và nghệ thuật trang trí nội thất.</p>
                            <p>Chúng tôi mang đến các sản phẩm decor trang trí nhà với phong cách hiện đại, tối giản
                                nhưng vẫn
                                giữ được sự tinh tế trong từng chi tiết.</p>

                        </div>

                        <!-- Cột 2: Liên kết -->
                        <div class="footer-col">
                            <h3>Liên kết</h3>
                            <ul>
                                <li><a>Chính sách đổi trả hoàn hàng</a></li>
                                <li><a>Chính sách bảo mật mật khẩu</a></li>
                                <li><a>Hướng dẫn mua hàng, sản phẩm</a></li>
                                <li><a>Chính sách kiểm hàng hóa vận chuyển</a></li>
                                <li><a>Chính sách giao hàng tận nơi</a></li>
                                <li><a>Hướng dẫn thanh toán đơn hàng</a></li>
                            </ul>

                        </div>

                        <!-- Cột 3: Thông tin liên hệ -->
                        <div class="footer-col">
                            <h3>Thông tin liên hệ</h3>
                            <p><i class="fa fa-map-marker"></i>Khu phố 33, P.Linh Xuân, TP.HCM</p>
                            <p><i class="fa fa-map-marker"></i> Đại học Nông Lâm TP.Hồ Chí Minh</p>
                            <p><i class="fa fa-phone"></i> Liên hệ: 03751841444 - 03381776315 </p>

                            <p><i class="fa fa-envelope"></i> <a
                                    href="mailto:NLT@noblelofttheory.com">NLT@noblelofttheory.com</a></p>
                        </div>


                        <!-- Cột 4: Fanpage -->
                        <div class="footer-col">
                            <h3>Fanpage</h3>
                            <div class="fanpage-box">
                                <p>Liên hệ ngay trang chủ của shop Noble Loft Theory.</p>
                                <p>Nếu bạn đang có thắc mắc gì ở sản phẩm.</p>
                                <p>Fanpage, Youtube và Instagram.</p>


                                <div class="social-box">
                                    <div class="social-icons">
                                        <a href="https://www.facebook.com/share/1HP5fZGNqb/?mibextid=wwXIfr">
                                            <i class="fa-brands fa-facebook"></i></a>
                                        <a href="https://www.instagram.com/nltnoblelofttheory/">
                                            <i class="fa-brands fa-instagram"></i></a>
                                        <a href="https://www.youtube.com/channel/UC931-4vCWPGos5fSNQ8Rh-g">
                                            <i class="fa-brands fa-youtube"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>Copyright © 2025 NLT Noble Loft Theory. Powered by NLT </p>
                </div>
                </div>
            </footer>


        </body>

        </html>