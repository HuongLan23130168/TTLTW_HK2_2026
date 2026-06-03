<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán chuyển khoản - Nobile Loft Theory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/user/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
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
        .success-icon { font-size: 70px; color: #ECB176; margin-bottom: 20px; }
        .order-code {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 10px;
            font-size: 22px;
            font-weight: bold;
            letter-spacing: 2px;
            color: #d40004;
            margin: 20px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .amount {
            font-size: 26px;
            font-weight: bold;
            color: #d40004;
            text-align: center;
            margin: 10px 0 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .bank-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            text-align: left;
            margin: 20px 0;
            border-left: 4px solid #74512D;
        }
        .bank-info h4 { margin: 0 0 14px; color: #74512D; }
        .bank-number {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #e9ecef;
            padding: 9px 12px;
            border-radius: 8px;
            margin: 8px 0;
            font-size: 14px;
            gap: 8px;
        }
        .bank-number span { flex: 1; }
        .copy-btn {
            background: #74512D;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .copy-btn:hover { background: #5a3a1f; }
        .copy-btn.copied { background: #28a745; }

        .qr-section {
            margin: 20px 0;
            padding: 20px;
            border: 2px dashed #74512D;
            border-radius: 12px;
        }
        .qr-section img {
            width: 220px;
            height: 220px;
            border-radius: 10px;
            border: 1px solid #eee;
            background: white;
        }
        .qr-caption { font-size: 12px; color: #888; margin-top: 8px; }

        .note {
            background: #fff3cd;
            padding: 12px 16px;
            border-radius: 8px;
            color: #856404;
            font-size: 13px;
            margin-top: 20px;
            text-align: left;
            line-height: 1.6;
        }
        .btn-confirm {
            display: block;
            background: #28a745;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            transition: background .2s;
        }
        .btn-confirm:hover { background: #1e7e34; }
        .confirm-note { font-size: 12px; color: #666; margin-top: 6px; text-align: center; }

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
            border: 2px solid #ddd;
        }
        .step.active { color: #fff; background-color: #ECB176; border-color: #ECB176; }
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
    <p>Vui lòng chuyển khoản để hoàn tất đơn hàng</p>

    <div class="order-code">
        Mã đơn: <strong>${orderCode}</strong>
        <button class="copy-btn" onclick="copyBtn(this, '${orderCode}')">
            <i class="fas fa-copy"></i> Sao chép
        </button>
    </div>

    <div class="amount">
        <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫
        <button class="copy-btn" onclick="copyBtn(this, '${totalAmount}')">
            <i class="fas fa-copy"></i> Sao chép
        </button>
    </div>

    <div class="qr-section">
        <div style="font-weight:bold; color:#74512D; margin-bottom:12px;">
            <i class="fas fa-qrcode"></i> Quét mã QR để chuyển khoản
        </div>
        <div id="qrcode-wrapper">
            <img id="qr-img" src="" alt="QR chuyển khoản"
                 onerror="this.src='https://placehold.co/220x220?text=QR+Error'"/>
        </div>
        <div class="qr-caption">
            Quét bằng app ngân hàng bất kỳ (VCB, TPBank, MB, BIDV, Momo...)
        </div>
    </div>

    <div class="bank-info">
        <h4><i class="fas fa-building-columns"></i> Thông tin chuyển khoản</h4>
        <div class="bank-number">
            <span><strong>Ngân hàng:</strong> TPBank</span>
            <button class="copy-btn" onclick="copyBtn(this, 'TPBank')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Số tài khoản:</strong> 80981182441</span>
            <button class="copy-btn" onclick="copyBtn(this, '80981182441')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Chủ tài khoản:</strong> CÔNG TY TNHH NOBILE</span>
            <button class="copy-btn" onclick="copyBtn(this, 'CÔNG TY TNHH NOBILE')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Số tiền:</strong> <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫</span>
            <button class="copy-btn" onclick="copyBtn(this, '${totalAmount}')">Sao chép</button>
        </div>
        <div class="bank-number">
            <span><strong>Nội dung:</strong> ${orderCode}</span>
            <button class="copy-btn" onclick="copyBtn(this, '${orderCode}')">Sao chép</button>
        </div>
    </div>

    <div class="note">
        <i class="fa-solid fa-circle-info"></i>
        <strong>Lưu ý quan trọng:</strong><br>
        • Chuyển khoản đúng <strong>số tiền</strong> và <strong>nội dung</strong> như trên.<br>
        • Đơn hàng sẽ được xác nhận và xử lý sau khi chúng tôi nhận được thanh toán (trong vòng 24h).<br>
        • Sau khi chuyển khoản, bấm nút bên dưới để thông báo cho chúng tôi.
    </div>

    <div style="margin-top: 24px;">
        <form action="${pageContext.request.contextPath}/confirm-bank-transfer" method="POST">
            <input type="hidden" name="orderCode" value="${orderCode}">
            <button type="submit" class="btn-confirm">
                <i class="fas fa-check-circle"></i> TÔI ĐÃ CHUYỂN KHOẢN
            </button>
        </form>
        <p class="confirm-note">
            Bấm vào đây sau khi chuyển khoản thành công để chúng tôi ưu tiên xác nhận đơn của bạn
        </p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var amount    = '${totalAmount}'.replace(/[^0-9]/g, '') || '0';
        var orderCode = '${orderCode}';

        var qrUrl = 'https://img.vietqr.io/image/TPB-80981182441-compact2.png'
            + '?amount=' + amount
            + '&addInfo=' + encodeURIComponent(orderCode)
            + '&accountName=' + encodeURIComponent('CONG TY TNHH NOBILE');

        document.getElementById('qr-img').src = qrUrl;
    });

    function copyBtn(btn, text) {
        navigator.clipboard.writeText(String(text)).then(function () {
            var orig = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i> Đã sao chép';
            btn.classList.add('copied');
            setTimeout(function () {
                btn.innerHTML = orig;
                btn.classList.remove('copied');
            }, 1800);
        }, function () {
            alert('Vui lòng copy thủ công: ' + text);
        });
    }
</script>

<jsp:include page="/user/footer.jsp"/>
</body>
</html>
