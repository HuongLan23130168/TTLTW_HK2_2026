<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Quản lý Liên hệ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/contactList.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<main class="main-content">
    <div class="contacts-header">
        <h1>Danh sách liên hệ</h1>


            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/contacts" method="GET">
                    <div class="search-wrapper">
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                        <input type="text" name="search" class="search-input-contact" placeholder="Tìm tên hoặc email..." value="${param.search}">
                    </div>

                    <button type="submit" class="btn-search">Tìm kiếm</button>

                    <select name="statusFilter" class="filter-select" onchange="this.form.submit()">
                        <option value="" ${empty param.statusFilter ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="NEW" ${param.statusFilter == 'NEW' ? 'selected' : ''}>Chưa xử lý</option>
                        <option value="REPLIED" ${param.statusFilter == 'REPLIED' ? 'selected' : ''}>Đã phản hồi</option>
                    </select>
                    <a href="${pageContext.request.contextPath}/admin/contacts" class="btn-reset">Làm mới</a>
                </form>
            </div>
        </div>
    </div>

    <c:if test="${param.success == 'true'}">
        <div class="alert-success"><i class="fas fa-check-circle"></i> Cập nhật trạng thái phản hồi thành công!</div>
    </c:if>

    <div class="table-container">
        <table class="contacts-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Khách hàng</th>
                <th>Email</th>
                <th>Nội dung</th> <th>Trạng thái</th>
                <th>Chi tiết</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${contacts}">
                <tr>
                    <td>#${c.id}</td>
                    <td><strong>${c.fullName}</strong></td>
                    <td>${c.email}</td>

                    <td class="msg-preview" title="${c.message}">${c.message}</td>

                    <td>
                        <c:choose>
                            <c:when test="${c.status == 'NEW'}">
                                <span class="status new">Chưa xử lý</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status replied">Đã phản hồi</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/contacts?action=view&id=${c.id}" class="view-btn">Xem</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty contacts}">
                <tr><td colspan="6" style="text-align: center; padding: 20px;">Không có dữ liệu liên hệ.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>