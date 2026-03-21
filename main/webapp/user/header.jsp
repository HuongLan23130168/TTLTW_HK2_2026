<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Noble Loft Theory</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/frontend/css/header.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<c:set var="roomsParam"
       value="${empty paramValues.room ? '' : fn:join(paramValues.room, ',')}"/>

<c:set var="catsParam"
       value="${empty paramValues.category ? '' : fn:join(paramValues.category, ',')}"/>

<header class="header">
    <div class="header-top">
        <div class="logo">
            <img src="https://i.postimg.cc/5t4yq9qJ/logo-ltw.jpg" alt="Logo">
            <span>
                <a href="${pageContext.request.contextPath}/home">
                    Noble Loft Theory
                </a>
            </span>
        </div>

        <div class="header-right">
            <a href="${pageContext.request.contextPath}/frontend/tracking.jsp"
               class="${fn:contains(pageContext.request.requestURI, 'tracking.jsp') ? 'active' : ''}">
                Tra cứu đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/frontend/gioithieu.jsp"
               class="${fn:contains(pageContext.request.requestURI, 'gioithieu.jsp') ? 'active' : ''}">
                Giới thiệu
            </a>
            <a href="${pageContext.request.contextPath}/frontend/contact.jsp"
               class="contact ${fn:contains(pageContext.request.requestURI, 'contact.jsp') ? 'active' : ''}">
                Liên hệ
            </a>

            <div class="icons">
                <div class="cart-icon" style="position: relative;">
                    <a href="${pageContext.request.contextPath}/cart" class="circle" title="Giỏ hàng">
                        <i class="fa fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.totalQty && sessionScope.totalQty > 0}">
                            <span class="badge" id="cart-badge">${sessionScope.totalQty}</span>
                        </c:if>
                    </a>
                </div>

                <div class="user-info account-dropdown">
                    <c:choose>
                        <c:when test="${not empty sessionScope.acc}">
                            <div class="circle user-trigger">
                                <i class="fa-solid fa-user"></i>
                            </div>
                            <div class="account-menu-box">
                                <a href="${pageContext.request.contextPath}/account" class="account-item"
                                   title="Tài khoản của tôi">
                                    <i class="fa-solid fa-circle-user"></i>
                                </a>
                                <hr class="menu-divider">
                                <a href="${pageContext.request.contextPath}/logout" class="account-item logout"
                                   title="Đăng xuất">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="circle">
                                <i class="fa-solid fa-user"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <nav class="menu">
        <a href="${pageContext.request.contextPath}/home"
           class="${fn:contains(pageContext.request.requestURI, 'home') || pageContext.request.requestURI.endsWith('/') ? 'active' : ''}">
            Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/list-product?room=1"
           class="${fn:contains(roomsParam,'1') ? 'active' : ''}">
            Phòng khách
        </a>
        <a href="${pageContext.request.contextPath}/list-product?room=2"
           class="${fn:contains(roomsParam,'2')?'active':''}">
            Phòng bếp
        </a>
        <a href="${pageContext.request.contextPath}/list-product?room=3"
           class="${fn:contains(roomsParam,'3')?'active':''}">
            Phòng ngủ
        </a>
        <a href="${pageContext.request.contextPath}/list-product?room=4"
           class="${fn:contains(roomsParam,'4')?'active':''}">
            Phòng làm việc
        </a>
        <a href="${pageContext.request.contextPath}/list-product?room=5"
           class="${fn:contains(roomsParam,'5')?'active':''}">
            Ban công
        </a>

        <div class="dropdown ${not empty catsParam ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/list-product">
                Decor <i class="fa-solid fa-chevron-down"></i>
            </a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/list-product?category=CAY"
                   class="${fn:contains(catsParam,'CAY')?'active':''}">
                    Cây
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=HOA"
                   class="${fn:contains(catsParam,'HOA')?'active':''}">
                    Hoa
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=DEN"
                   class="${fn:contains(catsParam,'DEN')?'active':''}">
                    Đèn
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=PHUKIEN"
                   class="${fn:contains(catsParam,'PHUKIEN')?'active':''}">
                    Phụ kiện
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=DONGHO"
                   class="${fn:contains(catsParam,'DONGHO')?'active':''}">
                    Đồng hồ
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=TRANH"
                   class="${fn:contains(catsParam,'TRANH')?'active':''}">
                    Tranh
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=GUONG"
                   class="${fn:contains(catsParam,'GUONG')?'active':''}">
                    Gương
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=NEN"
                   class="${fn:contains(catsParam,'NEN')?'active':''}">
                    Nến & Tinh dầu
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=BINH"
                   class="${fn:contains(catsParam,'BINH')?'active':''}">
                    Bình & Lọ hoa
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=CHAN"
                   class="${fn:contains(catsParam,'CHAN')?'active':''}">
                    Chăn
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=GOI"
                   class="${fn:contains(catsParam,'GOI')?'active':''}">
                    Gối
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=KE"
                   class="${fn:contains(catsParam,'KE')?'active':''}">
                    Kệ & Giá đỡ mini
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=BAN"
                   class="${fn:contains(catsParam,'BAN')?'active':''}">
                    Bàn decor
                </a>
                <a href="${pageContext.request.contextPath}/list-product?category=GHE"
                   class="${fn:contains(catsParam,'GHE')?'active':''}">
                    Ghế decor
                </a>
            </div>
        </div>
    </nav>
</header>

<script src="${pageContext.request.contextPath}/frontend/js/header.js"></script>
</body>
</html>
