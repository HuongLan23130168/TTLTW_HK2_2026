<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Tài khoản của tôi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/account.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/accountOrders.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/changePass.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">


</head>

<body>

<jsp:include page="/user/header.jsp"/>

<nav class="breadcrumb" style="margin: 20px 40px 10px; color: #333;">
    <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: #000;">Trang chủ</a> &#47;
    <span class="current" style="color: #74512D; font-weight: 700;">Tài khoản</span>
</nav>

<div class="account-container">

    <aside class="sidebar">
        <div class="profile-header">
            <div class="avatar">${user.fullName.charAt(0)}</div>
            <div class="profile-info">
                <p><strong id="userName">${user.fullName}</strong></p>
            </div>
        </div>

        <ul class="menu-account">
            <li class="${activePage == null || activePage == 'profile' ? 'active' : ''}" data-target="#page-profile">
                Tài khoản của tôi
            </li>

            <li class="${activePage == 'orders' ? 'active' : ''}" data-target="#page-orders">
                Đơn mua
            </li>
        </ul>

        <div class="logout-btn"><a href="logout">Đăng xuất</a></div>
    </aside>

    <main class="account-details">

        <div id="page-profile" class="page ${activePage == null || activePage == 'profile' ? 'active' : ''}">

            <div class="info-box" id="profile-view">
                <div class="info-left">
                    <p><strong>Email:</strong> <span>${user.email}</span></p>
                    <p><strong>Họ và tên:</strong> <span>${user.fullName}</span></p>
                    <p><strong>Số điện thoại:</strong> <span>${user.phone}</span></p>
                </div>
                <div class="info-right">
                    <div class="circle-avatar">${user.fullName.charAt(0)}</div>
                </div>
                <button class="edit-btn" onclick="toggleProfileEdit()">Sửa</button>
            </div>

            <form action="update-profile" method="post" class="info-box hidden" id="profile-edit" style="display: block;">
                <div class="info-left" style="width: 100%;">
                    <h3 style="color: #6F4E37; border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-bottom: 15px;">
                        Cập nhật thông tin
                    </h3>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display:block; font-weight:bold; margin-bottom:5px;">Email (Không thể sửa):</label>
                        <input type="text" value="${user.email}" disabled
                               style="width: 100%; padding: 8px; background: #eee; border: 1px solid #ccc; border-radius: 5px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display:block; font-weight:bold; margin-bottom:5px;">Họ và tên:</label>
                        <input type="text" name="fullName" value="${user.fullName}" required
                               style="width: 100%; padding: 8px; border: 1px solid #A79277; border-radius: 5px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display:block; font-weight:bold; margin-bottom:5px;">Số điện thoại:</label>
                        <input type="text" name="phone" value="${user.phone}" required pattern="[0-9]{10,11}"
                               style="width: 100%; padding: 8px; border: 1px solid #A79277; border-radius: 5px;">
                    </div>

                    <div style="text-align: right;">
                        <button type="button" class="cancel-btn" onclick="toggleProfileEdit()"
                                style="padding: 8px 15px; background: transparent; border: 1px solid #6F4E37; color: #6F4E37; border-radius: 5px; cursor: pointer; margin-right: 10px;">
                            Hủy
                        </button>
                        <button type="submit" class="save-btn"
                                style="padding: 8px 15px; background: #6F4E37; border: none; color: #fff; border-radius: 5px; cursor: pointer;">
                            Lưu thay đổi
                        </button>
                    </div>
                </div>
            </form>

            <hr style="margin: 30px 0; border: 0; border-top: 1px solid #EEE2D0;">

            <h4 style="display: inline-block;">Sổ địa chỉ</h4>
            <button class="add-btn" onclick="openAddressModal()">➕ Thêm địa chỉ mới</button>

            <div class="address-box">
                <div class="address-list">
                    <c:if test="${empty listAddresses}">
                        <p style="color: #888; padding: 10px;">Bạn chưa lưu địa chỉ nào.</p>
                    </c:if>

                    <c:forEach var="addr" items="${listAddresses}">
                        <div class="address-row" style="display: flex; justify-content: space-between; align-items: center; background: #FEFAEF; padding: 12px; border-radius: 8px; margin-bottom: 10px; border: 1px solid #d8b99c;">
                            <div class="address-content" style="flex-grow: 1;">
                                    ${addr.address}
                                <c:if test="${addr.is_default == 1}">
                                    <span style="color: #A79277; font-weight: bold; font-size: 13px; margin-left: 5px;">(Mặc định)</span>
                                </c:if>
                            </div>

                            <div class="address-actions" style="min-width: 100px; text-align: right;">
                                <button onclick="openEditModal('${addr.id}', '${addr.address}', ${addr.is_default})"
                                        style="background: #6F4E37; color: #fff; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; margin-right: 5px;">
                                    Sửa
                                </button>

                                <a href="delete-address?id=${addr.id}" onclick="return confirm('Bạn có chắc muốn xóa địa chỉ này không?');"
                                   style="background: #d9534f; color: #fff; text-decoration: none; padding: 5px 10px; border-radius: 4px; font-size: 13.33px;">
                                    Xóa
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                    <div id="modal-edit-address" class="modal">
                        <div class="modal-content">
                            <h3 style="color: #6F4E37; margin-top: 0;">Cập nhật địa chỉ</h3>
                            <form action="update-address" method="post">
                                <input type="hidden" id="edit-id" name="id">

                                <div style="margin-bottom: 15px;">
                                    <label style="display:block; font-weight:bold; margin-bottom:5px; color: #6F4E37;">Địa chỉ chi tiết:</label>
                                    <textarea id="edit-address" name="address" rows="3" required
                                              style="width: 100%; padding: 10px; border: 1px solid #A79277; border-radius: 5px; font-family: inherit;"></textarea>
                                </div>

                                <div style="margin-bottom: 20px;">
                                    <input type="checkbox" id="edit-isDefault" name="isDefault" value="1">
                                    <label for="edit-isDefault" style="cursor: pointer; color: #333;">Đặt làm địa chỉ mặc định</label>
                                </div>

                                <div style="text-align: right;">
                                    <button type="button" onclick="closeEditModal()"
                                            style="padding: 8px 15px; background: #eee; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px;">
                                        Hủy
                                    </button>
                                    <button type="submit"
                                            style="padding: 8px 15px; background: #6F4E37; color: white; border: none; border-radius: 5px; cursor: pointer;">
                                        Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="modal-address" class="modal">
            <div class="modal-content">
                <h3 style="color: #6F4E37; margin-top: 0;">Thêm địa chỉ mới</h3>
                <form action="add-address" method="post">
                    <div style="margin-bottom: 15px;">
                        <label style="display:block; font-weight:bold; margin-bottom:5px; color: #6F4E37;">Địa chỉ chi tiết:</label>
                        <textarea name="address" rows="3" required placeholder="Số nhà, Tên đường, Phường/Xã, Quận/Huyện..."
                                  style="width: 100%; padding: 10px; border: 1px solid #A79277; border-radius: 5px; font-family: inherit;"></textarea>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <input type="checkbox" id="isDefault" name="isDefault" value="1">
                        <label for="isDefault" style="cursor: pointer; color: #333;">Đặt làm địa chỉ mặc định</label>
                    </div>

                    <div style="text-align: right;">
                        <button type="button" onclick="closeAddressModal()"
                                style="padding: 8px 15px; background: #eee; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px;">
                            Đóng
                        </button>
                        <button type="submit"
                                style="padding: 8px 15px; background: #6F4E37; color: white; border: none; border-radius: 5px; cursor: pointer;">
                            Lưu địa chỉ
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <div id="modal-address" class="modal">
            <div class="modal-content">
                <h3 style="color: #6F4E37;">Thêm địa chỉ mới</h3>
                <form action="${pageContext.request.contextPath}/add-address" method="post">
                    <label style="display:block; margin: 10px 0 5px; font-weight: bold;">Địa chỉ chi tiết:</label>
                    <textarea name="address" rows="3" placeholder="Ví dụ: 123 Đường ABC, Phường X, Quận Y..." required style="width: 100%; padding: 10px; border: 1px solid #A79277; border-radius: 5px;"></textarea>

                    <div style="margin-top: 10px;">
                        <input type="checkbox" id="isDefault" name="isDefault" value="1">
                        <label for="isDefault">Đặt làm địa chỉ mặc định</label>
                    </div>

                    <div class="modal-actions" style="margin-top: 20px; text-align: right;">
                        <button type="button" class="cancel-btn" onclick="closeAddressModal()">Đóng</button>
                        <button type="submit" class="save-btn">Lưu địa chỉ</button>
                    </div>
                </form>
            </div>
        </div>
        <div id="page-password" class="page">
            <div class="form change">
                <h2 class="form-title">Đổi mật khẩu</h2>
                <form action="change-password" method="post">
                    <div class="form-holder">
                        <input type="password" name="oldPassword" class="input-cp" placeholder="Mật khẩu hiện tại" required>
                        <input type="password" name="newPassword" class="input-cp" placeholder="Mật khẩu mới" required>
                        <input type="password" name="confirmPassword" class="input-cp" placeholder="Xác nhận mật khẩu mới" required>
                    </div>
                    <button type="submit" id="btnChange" class="submit-btn">Đổi lại mật khẩu</button>
                </form>
            </div>
        </div>

        <div class="page" id="policy-doitra">
            <h2>Chính sách đổi trả</h2> <p>Nội dung chính sách đổi trả...</p>
        </div>
        <div class="page" id="policy-baomat">
            <h2>Chính sách bảo mật</h2> <p>Nội dung chính sách bảo mật...</p>
        </div>
        <div class="page" id="policy-kiemhang">
            <h2>Chính sách kiểm hàng</h2> <p>Nội dung chính sách kiểm hàng...</p>
        </div>
        <div class="page" id="policy-giaohang">
            <h2>Chính sách giao hàng</h2> <p>Nội dung chính sách giao hàng...</p>
        </div>
        <div class="page" id="policy-thanhtoan">
            <h2>Hướng dẫn thanh toán</h2> <p>Nội dung thanh toán...</p>
        </div>

        <div id="page-orders" class="page ${activePage == 'orders' ? 'active' : ''}">

            <div class="order-tabs">
                <a href="account?status=all" class="order-tab ${param.status == null || param.status == 'all' ? 'active' : ''}">Tất cả</a>
                <a href="account?status=wait" class="order-tab ${param.status == 'wait' ? 'active' : ''}">Chờ xử lý</a>
                <a href="account?status=shipping" class="order-tab ${param.status == 'shipping' ? 'active' : ''}">Đang giao</a>
                <a href="account?status=done" class="order-tab ${param.status == 'done' ? 'active' : ''}">Đã giao</a>
                <a href="account?status=cancel" class="order-tab ${param.status == 'cancel' ? 'active' : ''}">Đã hủy</a>
            </div>

            <div class="order-container">
                <div id="order-list">
                    <c:if test="${empty orders}">
                        <div style="text-align: center; padding: 30px; color: #888;">
                            <p>Không tìm thấy đơn hàng nào.</p>
                            <a href="home.jsp" style="color: #74512D; font-weight: bold; text-decoration: underline;">Mua sắm ngay</a>
                        </div>
                    </c:if>

                    <c:forEach var="o" items="${orders}">
                        <div class="order-card">
                            <div class="order-status">
                                <c:choose>
                                    <c:when test="${o.status == 'Đã giao'}"><span class="status-badge success">Đã giao</span></c:when>
                                    <c:when test="${o.status == 'Đang giao'}"><span class="status-badge shipping">Đang giao</span></c:when>
                                    <c:when test="${o.status == 'Đã hủy'}"><span class="status-badge cancel">Đã hủy</span></c:when>
                                    <c:otherwise><span class="status-badge waiting">${o.status}</span></c:otherwise>
                                </c:choose>
                            </div>

                            <div class="order-item">
                                <img src="${o.imageUrl != null ? o.imageUrl : 'https://placehold.co/80x80?text=No+Image'}"
                                     alt="Sản phẩm" onerror="this.src='https://placehold.co/80x80?text=Error'">

                                <div class="order-info">
                                    <h4>${o.productName}</h4>
                                    <p style="font-size: 13px; color: #888; margin-bottom: 5px;">
                                        Mã đơn: #${o.orderCode} | Ngày: <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy"/>
                                    </p>
                                    <p class="order-price">
                                        <fmt:formatNumber value="${o.totalPrice}" type="currency" currencySymbol="đ"/>
                                    </p>
                                    <div class="order-tags">
                                        <span class="order-tag">${o.color}</span>
                                        <span class="order-tag">Size ${o.size}</span>
                                        <span class="order-tag">x${o.quantity}</span>
                                    </div>
                                    <c:if test="${o.otherItemsCount > 0}">
                                        <p class="other-items-hint">(+ ${o.otherItemsCount} sản phẩm khác)</p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="order-footer">

                                    <%--                                <c:if test="${o.status == 'Đã giao'}">--%>
                                    <%--                                    <button class="order-view-btn-huy" style="background: #28a745;">Mua lại</button>--%>
                                    <%--                                </c:if>--%>


                                <c:if test="${o.status == 'Chờ xử lý'}">
                                    <form action="cancel-order" method="post" style="display: inline-block;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể hoàn tác.');">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <button type="submit" class="order-view-btn-huy">Hủy đơn</button>
                                    </form>
                                </c:if>

                                <c:set var="stt" value="${o.status.toLowerCase()}" />
                                <c:if test="${stt.contains('xác nhận') || stt.contains('chờ nhận') || stt.contains('đang giao')}">

                                    <form action="${pageContext.request.contextPath}/user/confirmReceipt" method="post" style="display: inline-block;">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <button type="submit" class="btn-confirm-received"
                                                style="margin-right: 5px;"
                                                onclick="return confirm('Bạn xác nhận đã nhận được hàng và hài lòng với sản phẩm?');">
                                            <i class="fa fa-check-circle"></i> Đã nhận hàng
                                        </button>
                                    </form>

                                </c:if>
                                <a href="${pageContext.request.contextPath}/tracking?orderCode=${o.orderCode}"
                                   class="order-view-btn"
                                   style="text-decoration: none;">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/user/footer.jsp"/>
<script src="${pageContext.request.contextPath}/user/js/account.js"></script>


<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pages = document.querySelectorAll(".page");
        const menuItems = document.querySelectorAll(".menu-account li[data-target]");

        function showPage(selector) {
            pages.forEach((p) => p.classList.remove("active"));
            const page = document.querySelector(selector);
            if (page) page.classList.add("active");
        }

        // JS này chỉ xử lý việc click vào Sidebar
        menuItems.forEach((item) => {
            item.addEventListener("click", () => {
                // UI: Đổi active trên menu
                menuItems.forEach((i) => i.classList.remove("active"));
                item.classList.add("active");

                // UI: Hiện nội dung trang tương ứng
                const target = item.getAttribute("data-target");
                if (target) showPage(target);
            });
        });

        // Submenu hover
        document.querySelectorAll(".menu-account .has-submenu").forEach((parent) => {
            parent.addEventListener("mouseenter", () => parent.classList.add("open"));
            parent.addEventListener("mouseleave", () => parent.classList.remove("open"));
        });
    });
</script>

</body>
</html>