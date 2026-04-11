<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Chi tiết Liên hệ #${contact.id}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/contactDetail.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/contacts">Liên hệ</a> /
        <span class="current">Chi tiết #${contact.id}</span>
    </div>

    <div class="detail-card">
        <div class="title-cus">
            <h2>Nội dung liên hệ</h2>
        </div>

        <div class="customer-info">
            <p><strong>Người gửi:</strong> ${contact.fullName}</p>
            <p><strong>Email:</strong> ${contact.email}</p>
            <p><strong>Trạng thái:</strong>
                <c:if test="${contact.status == 'NEW'}"><span class="status new">Chưa xử lý</span></c:if>
                <c:if test="${contact.status == 'REPLIED'}"><span class="status replied">Đã phản hồi</span></c:if>
            </p>

            <p style="margin-top: 20px;"><strong>Lời nhắn:</strong></p>
            <div class="message-box">${contact.message}</div>
        </div>

        <div class="action-box">
            <c:if test="${contact.status == 'NEW'}">
                <form action="${pageContext.request.contextPath}/admin/contacts" method="post" style="display:inline; margin: 0;">
                    <input type="hidden" name="action" value="mark_replied">
                    <input type="hidden" name="id" value="${contact.id}">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-check"></i> Đánh dấu đã phản hồi
                    </button>
                </form>
            </c:if>

            <a href="${pageContext.request.contextPath}/admin/contacts" class="btn-back">Quay lại</a>
        </div>
    </div>
</main>
</body>
</html>

