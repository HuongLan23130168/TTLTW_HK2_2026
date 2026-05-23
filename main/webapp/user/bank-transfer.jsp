<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hướng dẫn chuyển khoản - Nobile Loft Theory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <style>
        .bank-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 30px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            font-size: 70px;
            color: #28a745;
            margin-bottom: 20px;
        }
        .order-code {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 10px;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 2px;
            color: #d40004;
            margin: 20px 0;
        }
        .bank-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            text-align: left;
            margin: 20px 0;
            border-left: 4px solid #74512D;
        }
        .bank-info p {
            margin: 10px 0;
        }
        .bank-info strong {
            display: inline-block;
            width: 120px;
        }
        .amount {
            font-size: 28px;
            font-weight: bold;
            color: #d40004;
            text-align: center;
            margin: 20px 0;
        }
        .qr-section {
            margin: 25px 0;
            padding: 20px;
            background: #fff;
            border: 2px dashed #74512D;
            border-radius: 12px;
            text-align: center;
        }
        .qr-title {
            font-weight: bold;
            margin-bottom: 15px;
            color: #74512D;
        }
        #qrcode {
            display: flex;
            justify-content: center;
            margin: 15px 0;
        }
        #qrcode img {
            width: 200px;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 10px;
            background: white;
        }
        .copy-btn {
            background: #74512D;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-left: 10px;
            font-size: 12px;
        }
        .copy-btn:hover {
            background: #5a3a1f;
        }
        .bank-number {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #e9ecef;
            padding: 8px 12px;
            border-radius: 8px;
            margin: 10px 0;
        }
        .note {
            background: #fff3cd;
            padding: 12px;
            border-radius: 8px;
            color: #856404;
            font-size: 13px;
            margin-top: 20px;
        }
        .btn-continue {
            display: inline-block;
            background: #74512D;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            text-decoration: none;
            margin-top: 20px;
            transition: background 0.3s;
        }
        .btn-continue:hover {
            background: #5a3a1f;
        }
        .btn-order {
            display: inline-block;
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            text-decoration: none;
            margin-top: 10px;
            margin-left: 10px;
        }
        .progress {
            display: flex;
            justify-content: center;
            gap: 80px;
            margin: 20px 0 40px;
        }
        .step {
            padding: 10px 18px;
            border-radius: 20px;
            font-weight: 600;
            color: #999;
            background: #fff;
            border: 2px solid;
        }
        .step.active {
            color: #fff;
            background-color: #ECB176;
        }
        .flex-between {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>

<jsp:include page="/user/header.jsp"/>

<div class="progress">
    <div class="step"><i class="fa fa-cart-shopping"></i> Giỏ hàng</div>
    <div class="step"><i class="fa fa-credit-card"></i> Thông tin đặt hàng</div>
    <div class="step active"><i class="fa fa-check-circle"></i> Hoàn tất</div>
</div>

<div class="bank-container">
    <div class="success-icon">
        <i class="fa-regular fa-clock"></i>
    </div>

    <h2>ĐẶT HÀNG THÀNH CÔNG!</h2>
    <p>Cảm ơn bạn đã đặt hàng tại Nobile Loft Theory</p>

    <div class="order-code">
        Mã đơn hàng: <strong>${orderCode}</strong>
        <button class="copy-btn" onclick="copyToClipboard('${orderCode}')">
            <i class="fas fa-copy"></i> Sao chép
        </button>
    </div>

    <div class="amount">
        Số tiền cần chuyển: <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫
        <button class="copy-btn" onclick="copyToClipboard('${totalAmount}')">
            <i class="fas fa-copy"></i> Sao chép
        </button>
    </div>

    <div class="qr-section">
        <div class="qr-title">
            <i class="fas fa-qrcode"></i> Quét mã QR để chuyển khoản
        </div>
        <div id="qrcode"></div>
        <p style="font-size: 12px; color: #888; margin-top: 10px;">
            Mở ứng dụng ngân hàng và quét mã QR bên trên
        </p>
    </div>

    <div class="bank-info">
        <h4><i class="fas fa-building-columns"></i> Thông tin chuyển khoản</h4>
        <div class="bank-number">
            <span><strong>Ngân hàng:</strong> Vietcombank</span>
            <button class="copy-btn" onclick="copyToClipboard('Vietcombank')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Số tài khoản:</strong> 123456789</span>
            <button class="copy-btn" onclick="copyToClipboard('123456789')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Chủ tài khoản:</strong> CÔNG TY TNHH NOBILE</span>
            <button class="copy-btn" onclick="copyToClipboard('CÔNG TY TNHH NOBILE')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Nội dung:</strong> ${orderCode}</span>
            <button class="copy-btn" onclick="copyToClipboard('${orderCode}')">Sao chép</button>
        </div>
    </div>

    <div class="note">
        <i class="fa-solid fa-circle-info"></i>
        Đơn hàng sẽ được xử lý sau khi chúng tôi xác nhận thanh toán (trong vòng 24h).
        Vui lòng chuyển khoản đúng số tiền và nội dung trên.
    </div>

    <div class="confirm-section" style="margin: 25px 0;">
        <a href="${pageContext.request.contextPath}/order-completed?orderCode=${orderCode}"
           class="btn-confirm"
           style="background: #28a745; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center;">
            <i class="fas fa-check-circle"></i> TÔI ĐÃ CHUYỂN KHOẢN
        </a>
        <p style="font-size: 12px; color: #666; margin-top: 8px; text-align: center;">
            Sau khi chuyển khoản thành công, vui lòng bấm vào đây để xem đơn hàng
        </p>
    </div>
</div>

<script>
    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(function() {
            alert('Đã sao chép: ' + text);
        }, function() {
            alert('Không thể sao chép, vui lòng copy thủ công');
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        var orderCode = '${orderCode}';
        var amount = '${totalAmount}';

        var amountValue = amount.replace(/[^0-9]/g, '');
        if (!amountValue || amountValue === '') {
            amountValue = '0';
        }

        var qrUrl = 'https://img.vietqr.io/image/VCB-123456789-compact.png?amount=' + amountValue + '&addInfo=' + encodeURIComponent(orderCode) + '&accountName=CONG%20TY%20TNHH%20NOBILE';

        document.getElementById("qrcode").innerHTML = '<img src="' + qrUrl + '" width="200" height="200" style="border:1px solid #ddd; border-radius:12px; padding:10px; background:white;" onerror="this.src=\'https://placehold.co/200x200?text=QR+Error\'">';
    });
</script>

<jsp:include page="/user/footer.jsp"/>
</body>
</html>