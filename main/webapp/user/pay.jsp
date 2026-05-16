<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/pay.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">

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

    .progress {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 80px;
        margin: 20px 0 40px;
    }

    .progress .step {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 10px 18px;
        border: 2px solid;
        border-radius: 20px;
        font-weight: 600;
        color: #999;
        position: relative;
        background-color: #fff;
        transition: all 0.3s ease;
    }

    .progress .step i {
        margin-right: 6px;
    }

    .progress .step.active {
        color: #fff;
        background-color: #ECB176;
    }

    .progress .step::after {
        content: "";
        position: absolute;
        right: -60px;
        top: 50%;
        width: 50px;
        height: 2px;
        background-color: #ddd;
        transform: translateY(-50%);
    }

    .progress .step:last-child::after {
        display: none;
    }

    .cart-item {
        display: flex;
        align-items: center;
        background: #fff;
        border: 2px solid #eee;
        border-radius: 10px;
        padding: 10px 15px;
        margin-bottom: 15px;
        gap: 15px;
    }

    .cart-item img {
        width: 80px;
        height: 80px;
        border-radius: 8px;
        object-fit: cover;
    }

    .cart-item .item-info {
        flex: 1;
    }

    .cart-item h4 {
        font-size: 15px;
        margin: 3px 0;
        color: #333;
    }

    .color {
        font-size: 13px;
        color: #666;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .color-box {
        display: inline-block;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        border: 1px solid #ccc;
    }

    .color-name {
        font-weight: 500;
    }

    .price {
        display: flex;
        align-items: baseline;
        gap: 8px;
    }

    .current-price {
        color: #e67e22;
        font-weight: 700;
        font-size: 15px;
    }

    .old-price {
        color: #aaa;
        font-size: 13px;
        text-decoration: line-through;
    }

    .discount {
        color: #d40004;
        font-weight: 600;
        font-size: 13px;
    }

    .checkout-btn {
        display: block;
        width: 100%;
        background: #A79277;
        color: #fff;
        padding: 15px;
        border: none;
        border-radius: 8px;
        font-weight: 700;
        font-size: 16px;
        margin-top: 20px;
        cursor: pointer;
        transition: background 0.3s, transform 0.2s;
        text-transform: uppercase;
    }

    .checkout-btn:hover {
        background: #74512D;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .checkout-btn:active {
        transform: translateY(0);
    }
</style>

<jsp:include page="/user/header.jsp"/>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &#47;
    <a href="${pageContext.request.contextPath}/detail-product">Chi tiết sản phẩm</a> &#47;
    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> &#47;
    <span class="current">Thông tin đặt hàng</span>
</div>

<div class="progress">
    <div class="step"><i class="fa fa-cart-shopping"></i> Giỏ hàng</div>
    <div class="step active"><i class="fa fa-credit-card"></i> Thông tin đặt hàng</div>
    <div class="step"><i class="fa fa-check-circle"></i> Hoàn tất</div>
</div>

<form id="checkoutForm"
      action="${pageContext.request.contextPath}/place-order"
      method="POST">
    <div class="checkout-container">
        <div class="checkout-left">
            <h4>THÔNG TIN NGƯỜI NHẬN</h4>
            <div class="form-group">
                <input type="text" id="fullName" name="fullName" placeholder="Họ & tên*" required>
                <small class="error-message"></small>

                <input type="tel" id="phone" name="phone" placeholder="Số điện thoại*" required>
                <small class="error-message"></small>

                <input type="email" id="email" name="email" value="${sessionScope.acc.email}" required>
                <small class="error-message"></small>
            </div>

            <h4>ĐỊA CHỈ NHẬN HÀNG</h4>
            <div class="address-group">
                <input type="text"
                       id="addressDetail"
                       name="addressDetail"
                       placeholder="Số nhà, tên đường*"
                       required>
                <small class="error-message"></small>

                <select id="province" class="form-control" required>
                    <option value="">Chọn Tỉnh/Thành</option>
                </select>
                <small class="error-message"></small>

                <select id="district" class="form-control" required>
                    <option value="">Chọn Quận/Huyện</option>
                </select>
                <small class="error-message"></small>

                <select id="ward" class="form-control" required>
                    <option value="">Chọn Phường/Xã</option>
                </select>
                <small class="error-message"></small>

                <input type="hidden" name="cityName" id="cityName">
                <input type="hidden" name="districtName" id="districtName">
                <input type="hidden" name="wardName" id="wardName">
                <input type="hidden" name="shippingFeeVal" id="shippingFeeVal" value="0">

                <textarea name="note" placeholder="Ghi chú cho người giao hàng (nếu có)"></textarea>
            </div>

            <h4 class="section-title">HÌNH THỨC THANH TOÁN</h4>
            <div class="option-grid">
                <label class="option-box">
                    <input type="radio" name="paymentMethod" value="1" checked>
                    <div class="option-content"><p class="main-text">COD</p></div>
                </label>
                <label class="option-box">
                    <input type="radio" name="paymentMethod" value="2">
                    <div class="option-content"><p class="main-text">CHUYỂN KHOẢN</p></div>
                </label>
            </div>

            <h4 class="section-title">HÌNH THỨC VẬN CHUYỂN</h4>
            <div class="option-grid">
                <label class="option-box" id="standardShipLabel">
                    <input type="radio" name="shippingType" value="tiêu chuẩn" checked>
                    <div class="option-content">
                        <p class="main-text">TIÊU CHUẨN</p>
                        <p class="sub-text" id="standardShipPrice">Đang tính...</p>
                    </div>
                </label>
                <label class="option-box" id="expressShipLabel">
                    <input type="radio" name="shippingType" value="hỏa tốc">
                    <div class="option-content">
                        <p class="main-text">HỎA TỐC</p>
                        <p class="sub-text" id="expressShipPrice">Đang tính...</p>
                    </div>
                </label>
            </div>
        </div>
        <div class="checkout-right">
            <h3>THÔNG TIN THANH TOÁN</h3>
            <hr class="divider">
            <p class="section-title">Danh sách sản phẩm</p>

            <div class="cart-list">
                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                        <img src="${item.imageUrl}" alt="${item.productName}">
                        <div class="item-info">
                            <h4>${item.productName}</h4>
                            <p style="font-size: 12px; color: #888; margin: 5px 0;">
                                SL: ${item.quantity} |
                                Phân loại: ${not empty item.color ? item.color : 'Mặc định'} - ${item.size}
                            </p>
                            <div class="price">
                                <span class="current-price">
                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>₫
                                </span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <hr class="divider">
            <div class="shipping-line">
                <p>Hình thức thanh toán: </p>
                <span id="paymentMethodDisplay">COD</span>
            </div>

            <div class="payment-line">
                <p>Hình thức vận chuyển: </p>
                <span id="shippingMethodDisplay">TIÊU CHUẨN</span>
            </div>

            <hr class="divider">
            <div class="total-line">
                <p>Tiền sản phẩm: </p>
                <span>
                    <fmt:formatNumber value="${grandTotal}" pattern="#,###"/>₫
                </span>
            </div>

            <div class="ship-total">
                <p>Phí vận chuyển: </p>
                <span id="shippingFeeDisplay">Chọn địa chỉ để tính phí</span>
            </div>

            <hr class="divider">
            <div class="final-total">
                <p>TỔNG THANH TOÁN</p>
                <span id="finalTotalDisplay">
                    <fmt:formatNumber value="${grandTotal}" pattern="#,###"/>₫
                </span>
            </div>

            <button type="submit" class="checkout-btn">
                XÁC NHẬN ĐẶT HÀNG
            </button>
        </div>
    </div>
</form>

<script>
    (function () {
        const GHTK_URL = "${pageContext.request.contextPath}/api/ghtk";
        const PROVINCE_URL = "https://esgoo.net/api-tinhthanh";

        const currentGrandTotal = ${grandTotal != null ? grandTotal : 0};
        const totalWeight = ${totalWeight != null ? totalWeight : 1000};

        const SHOP_PROVINCE = "Hồ Chí Minh";
        const SHOP_DISTRICT = "Quận 9";

        let cachedFeeStandard = null;
        let cachedFeeExpress = null;
        let currentRequestId = 0;

        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");
        const shippingFeeDisplay = document.getElementById("shippingFeeDisplay");
        const finalTotalDisplay = document.getElementById("finalTotalDisplay");
        const standardShipPrice = document.getElementById("standardShipPrice");
        const expressShipPrice = document.getElementById("expressShipPrice");
        const expressShipLabel = document.getElementById("expressShipLabel");

        function formatMoney(n) {
            return Number(n || 0).toLocaleString("vi-VN") + "₫";
        }

        function normalizeProvince(name) {
            if (!name) return "";
            const map = {
                "Thành phố Hồ Chí Minh": "TP. Hồ Chí Minh",
                "Hồ Chí Minh": "TP. Hồ Chí Minh",
                "TP Hồ Chí Minh": "TP. Hồ Chí Minh",
                "Tỉnh Thừa Thiên Huế": "Huế",
                "Thừa Thiên Huế": "Huế",
                "Thành phố Hà Nội": "Hà Nội",
                "Hà Nội": "Hà Nội"
            };
            let normalized = map[name.trim()];
            if (normalized) return normalized;

            return name.trim()
                .replace(/^Tỉnh\s+/, "")
                .replace(/^Thành phố\s+/, "");
        }

        function normalizeDistrict(name) {
            if (!name) return "";
            const map = {
                "Thành phố Thủ Đức": "Thành phố Thủ Đức",
                "Thủ Đức": "Thành phố Thủ Đức"
            };
            let normalized = map[name.trim()];
            if (normalized) return normalized;

            return name.trim()
                .replace(/^Huyện\s+/, "")
                .replace(/^Thị xã\s+/, "")
                .replace(/^Thành phố\s+/, "");
        }

        function capNhatPhiShip(fee) {
            if (fee == null || isNaN(fee)) return;
            document.getElementById("shippingFeeVal").value = fee;
            shippingFeeDisplay.innerText = formatMoney(fee);
            finalTotalDisplay.innerText = formatMoney(currentGrandTotal + Number(fee));
        }

        function resetShippingState() {
            cachedFeeStandard = null;
            cachedFeeExpress = null;
            shippingFeeDisplay.innerText = "Chọn địa chỉ để tính phí";
            finalTotalDisplay.innerText = formatMoney(currentGrandTotal);
            standardShipPrice.innerText = "—";
            expressShipPrice.innerText = "—";
            expressShipLabel.style.display = "none";
            document.querySelector('input[value="tiêu chuẩn"]').checked = true;
            document.getElementById("shippingMethodDisplay").innerText = "TIÊU CHUẨN";
        }

        function setLoadingState() {
            standardShipPrice.innerText = "Đang tính...";
            expressShipPrice.innerText = "Đang tính...";
            shippingFeeDisplay.innerText = "Đang tính...";
        }

        async function tinhPhiGHTK(provinceTo, districtTo, transport) {
            try {
                const params = new URLSearchParams({
                    pick_province: normalizeProvince(SHOP_PROVINCE),
                    pick_district: normalizeDistrict(SHOP_DISTRICT),
                    province: normalizeProvince(provinceTo),
                    district: normalizeDistrict(districtTo),
                    weight: totalWeight,
                    value: Math.round(currentGrandTotal),
                    transport: transport
                });

                const response = await fetch(GHTK_URL + "/fee?" + params.toString());
                const json = await response.json();

                console.log("GHTK RESPONSE:", transport, json);

                if (json.success && json.fee && json.fee.fee != null) {
                    return Number(json.fee.fee);
                }
                return null;
            } catch (err) {
                console.error("Lỗi GHTK:", err);
                return null;
            }
        }

        function apDungPhiHienTai() {
            const selected = document.querySelector('input[name="shippingType"]:checked');
            if (!selected) return;
            const fee = selected.value === "hỏa tốc" ? cachedFeeExpress : cachedFeeStandard;
            if (fee != null) {
                capNhatPhiShip(fee);
            }
        }

        async function tinhTatCaPhiShip(provinceTo, districtTo) {
            const requestId = ++currentRequestId;

            setLoadingState();
            cachedFeeStandard = null;
            cachedFeeExpress = null;

            const normalizedProvince = normalizeProvince(provinceTo);
            const isHCM = normalizedProvince.includes("Hồ Chí Minh");

            let feeRoad = null;
            let feeFly = null;

            if (isHCM) {
                [feeRoad, feeFly] = await Promise.all([
                    tinhPhiGHTK(provinceTo, districtTo, "road"),
                    tinhPhiGHTK(provinceTo, districtTo, "fly")
                ]);
            } else {
                feeRoad = await tinhPhiGHTK(provinceTo, districtTo, "road");
            }

            if (requestId !== currentRequestId) return;

            if (feeRoad == null) {
                standardShipPrice.innerText = "Không hỗ trợ khu vực này";
                shippingFeeDisplay.innerText = "Không khả dụng";
                expressShipLabel.style.display = "none";
                document.getElementById("shippingFeeVal").value = "";
                return;
            }

            cachedFeeStandard = feeRoad;
            standardShipPrice.innerText = formatMoney(feeRoad);

            if (isHCM) {
                if (feeFly != null && feeFly > feeRoad) {
                    cachedFeeExpress = feeFly;
                    expressShipPrice.innerText = formatMoney(feeFly);
                } else {
                    cachedFeeExpress = Math.round(feeRoad * 1.25);
                    expressShipPrice.innerText = formatMoney(cachedFeeExpress) + " (ước tính)";
                }
                expressShipLabel.style.display = "flex";
            } else {
                expressShipLabel.style.display = "none";
                document.querySelector('input[value="tiêu chuẩn"]').checked = true;
                document.getElementById("shippingMethodDisplay").innerText = "TIÊU CHUẨN";
            }

            apDungPhiHienTai();
        }

        document.addEventListener("DOMContentLoaded", function () {

            fetch(PROVINCE_URL + "/1/0.htm")
                .then(res => res.json())
                .then(data => {
                    if (data.error === 0) {
                        data.data.sort((a, b) => a.full_name.localeCompare(b.full_name, "vi"));
                        data.data.forEach(p => {
                            provinceSelect.options.add(new Option(p.full_name, p.id));
                        });
                    }
                })
                .catch(err => console.error("Lỗi fetch tỉnh:", err));

            provinceSelect.onchange = function () {
                const provinceName = this.options[this.selectedIndex].text;
                document.getElementById("cityName").value = provinceName;

                districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                document.getElementById("districtName").value = "";
                document.getElementById("wardName").value = "";

                resetShippingState();

                if (!this.value) return;

                fetch(PROVINCE_URL + "/2/" + this.value + ".htm")
                    .then(res => res.json())
                    .then(data => {
                        if (data.error === 0) {
                            data.data.sort((a, b) => a.full_name.localeCompare(b.full_name, "vi"));
                            data.data.forEach(d => {
                                districtSelect.options.add(new Option(d.full_name, d.id));
                            });
                        }
                    })
                    .catch(err => console.error("Lỗi fetch quận:", err));
            };

            districtSelect.onchange = function () {
                const districtName = this.options[this.selectedIndex].text;
                document.getElementById("districtName").value = districtName;

                wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                document.getElementById("wardName").value = "";

                if (this.value) {
                    fetch(PROVINCE_URL + "/3/" + this.value + ".htm")
                        .then(res => res.json())
                        .then(data => {
                            if (data.error === 0) {
                                data.data.sort((a, b) => a.full_name.localeCompare(b.full_name, "vi"));
                                data.data.forEach(w => {
                                    wardSelect.options.add(new Option(w.full_name, w.id));
                                });
                            }
                        })
                        .catch(err => console.error("Lỗi fetch phường:", err));
                }

                const provinceName = document.getElementById("cityName").value;
                if (provinceName && districtName) {
                    tinhTatCaPhiShip(provinceName, districtName);
                }
            };

            wardSelect.onchange = function () {
                document.getElementById("wardName").value = this.options[this.selectedIndex].text;
            };

            document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
                radio.addEventListener("change", function () {
                    document.getElementById("paymentMethodDisplay").innerText =
                        this.value === "1" ? "COD" : "CHUYỂN KHOẢN";
                });
            });

            document.querySelectorAll('input[name="shippingType"]').forEach(radio => {
                radio.addEventListener("change", function () {
                    document.getElementById("shippingMethodDisplay").innerText =
                        this.value === "hỏa tốc" ? "HỎA TỐC" : "TIÊU CHUẨN";
                    apDungPhiHienTai();
                });
            });
        });

    })();

    const checkoutForm = document.getElementById("checkoutForm");

    checkoutForm.addEventListener("submit", function (e) {
        let isValid = true;
        clearAllErrors();

        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");
        const fullName = document.getElementById("fullName");
        const fullNameValue = fullName.value.trim();
        const shippingFee = document.getElementById("shippingFeeVal");
        const nameRegex = /^[\p{L}\s'.-]{2,50}$/u;

        if (!fullNameValue) {
            showError(fullName, "Vui lòng nhập họ tên");
            isValid = false;
        } else if (!nameRegex.test(fullNameValue)) {
            showError(fullName, "Họ tên không hợp lệ");
            isValid = false;
        }

        const phone = document.getElementById("phone");
        const phoneValue = phone.value.trim().replace(/\s+/g, "");
        const phoneRegex = /^0\d{9}$/;

        if (!phoneValue) {
            showError(phone, "Vui lòng nhập số điện thoại");
            isValid = false;
        } else if (!phoneRegex.test(phoneValue)) {
            showError(phone, "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");
            isValid = false;
        }

        const email = document.getElementById("email");
        const emailValue = email.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailValue) {
            showError(email, "Vui lòng nhập email");
            isValid = false;
        } else if (!emailRegex.test(emailValue)) {
            showError(email, "Email không hợp lệ");
            isValid = false;
        }

        const addressDetail = document.getElementById("addressDetail");
        if (!addressDetail.value.trim()) {
            showError(addressDetail, "Vui lòng nhập địa chỉ");
            isValid = false;
        }

        if (!provinceSelect.value) {
            showError(provinceSelect, "Vui lòng chọn tỉnh/thành");
            isValid = false;
        }

        if (!districtSelect.value) {
            showError(districtSelect, "Vui lòng chọn quận/huyện");
            isValid = false;
        }

        if (!wardSelect.value) {
            showError(wardSelect, "Vui lòng chọn phường/xã");
            isValid = false;
        }

        if (shippingFee.value === "" || Number(shippingFee.value) < 0) {
            alert("Vui lòng chọn địa chỉ để tính phí vận chuyển");
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    function showError(input, message) {
        input.classList.add("error");
        const error = input.nextElementSibling;
        if (error && error.classList.contains("error-message")) {
            error.innerText = message;
        }
    }

    function clearAllErrors() {
        document.querySelectorAll(".error").forEach(el => el.classList.remove("error"));
        document.querySelectorAll(".error-message").forEach(el => el.innerText = "");
    }
</script>

<jsp:include page="/user/footer.jsp"/>

</body>

</html>