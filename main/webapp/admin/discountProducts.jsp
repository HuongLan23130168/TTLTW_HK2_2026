<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quản lý Khuyến Mãi | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/discountProducts.css"/>
</head>
<body>
<jsp:include page="/admin/header.jsp"/>
<jsp:include page="/admin/sidebar.jsp"/>

<div class="main-content">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a> / <span class="current">Khuyến mãi</span>
    </div>

    <div class="page-header">
        <h1>Quản lý Khuyến Mãi</h1>
        <button onclick="openModal('create')" class="btn btn-primary">
            <i class="fas fa-plus-circle"></i> Tạo mới
        </button>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="custom-toast toast-error">
            <i class="fas fa-exclamation-circle"></i> Lỗi: ${errorMessage}
        </div>
    </c:if>

    <c:if test="${not empty param.msg}">
        <div class="custom-toast toast-success">
            <i class="fas fa-check-circle"></i> ${param.msg}
        </div>
    </c:if>

    <div class="table-container">
        <table class="data-table">
            <thead>
            <tr>
                <th class="text-center" style="width: 50px;">ID</th>
                <th>Chương trình / Code</th>
                <th class="text-center" style="width: 100px;">Mức giảm</th>
                <th>Thời gian</th>
                <th>Phạm vi</th>
                <th class="text-center" style="width: 100px;">Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="d" items="${discountList}">
                <tr>
                    <td class="text-center">#${d.id}</td>
                    <td>
                        <div style="font-weight: 600; color: #5a3e2b;">${d.discount_name}</div>
                        <span class="code-badge">${d.discount_code}</span>
                    </td>
                    <td class="text-center">
                        <span class="discount-pill">-${d.discount_percent}%</span>
                    </td>
                    <td>
                        <div class="date-column">
                            Start: <fmt:formatDate value="${d.start_date}" pattern="dd/MM/yyyy HH:mm"/><br>
                            End: <span style="color:#d63031"><fmt:formatDate value="${d.end_date}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty d.appliedScopeNames}">${d.appliedScopeNames}</c:when>
                            <c:otherwise><span style="color:#999;">Không tự động</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-center">
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin/discounts?action=edit&id=${d.id}" class="btn-icon btn-edit-icon">
                                <i class="fas fa-edit"></i>
                            </a>
                            <form action="${pageContext.request.contextPath}/admin/discounts" method="POST" style="margin:0" onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="id" value="${d.id}"/>
                                <button type="submit" class="btn-icon btn-delete-icon" title="Xóa">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${empty discountList}">
            <div style="text-align: center; padding: 40px; color: #888;">Chưa có dữ liệu khuyến mãi.</div>
        </c:if>
    </div>
</div>

<div id="discountModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <h2>${not empty discountToEdit ? 'Cập nhật' : 'Tạo mới'} Khuyến Mãi</h2>

        <form action="${pageContext.request.contextPath}/admin/discounts" method="POST" id="discountForm">
            <input type="hidden" name="action" id="formAction" value="${not empty discountToEdit.id ? 'update' : 'insert'}"/>

            <input type="hidden" name="id" id="discountIdField" value="${discountToEdit.id > 0 ? discountToEdit.id : ''}"/>

            <div class="form-grid">
                <div><label>Tên chương trình:</label><input type="text" name="discount_name" class="form-control" value="${discountToEdit.discount_name}" required/></div>
                <div><label>Mã Code:</label><input type="text" name="discount_code" class="form-control" value="${discountToEdit.discount_code}" required/></div>
            </div>

            <div class="form-grid">
                <div><label>% Giảm giá:</label><input type="number" name="discount_percent" class="form-control" value="${discountToEdit.discount_percent}" required min="0" max="100"/></div>
                <div>
                    <label>Phạm vi áp dụng:</label>
                    <select name="scope" id="scopeSelect" class="form-control" onchange="toggleScope()">
                        <option value="none">Không áp dụng tự động</option>
                        <option value="category" ${not empty discountToEdit.appliedCategoryIds ? 'selected' : ''}>Danh mục sản phẩm</option>
                        <option value="type" ${not empty discountToEdit.appliedProductTypeIds ? 'selected' : ''}>Loại sản phẩm</option>
                    </select>
                </div>
            </div>

            <div class="form-grid">
                <fmt:formatDate value="${discountToEdit.start_date}" pattern="yyyy-MM-dd'T'HH:mm" var="startDateFmt"/>
                <fmt:formatDate value="${discountToEdit.end_date}" pattern="yyyy-MM-dd'T'HH:mm" var="endDateFmt"/>
                <div><label>Ngày bắt đầu:</label><input type="datetime-local" name="start_date" class="form-control" value="${startDateFmt}" required/></div>
                <div><label>Ngày kết thúc:</label><input type="datetime-local" name="end_date" class="form-control" value="${endDateFmt}" required/></div>
            </div>

            <div id="category-section" class="form-group" style="display:none;">
                <label>Chọn Danh Mục:</label>
                <div class="scroll-box">
                    <c:forEach var="c" items="${categories}">
                        <c:set var="isSel" value="false" />
                        <c:forEach var="selId" items="${discountToEdit.appliedCategoryIds}">
                            <c:if test="${selId == c.id}"><c:set var="isSel" value="true" /></c:if>
                        </c:forEach>
                        <label class="checkbox-item">
                            <input type="checkbox" name="target_id_category" value="${c.id}" ${isSel ? 'checked' : ''}>
                                ${c.category_name}
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div id="type-section" class="form-group" style="display:none;">
                <label>Chọn Loại Sản Phẩm:</label>
                <div class="scroll-box">
                    <c:forEach var="t" items="${types}">
                        <c:set var="isSelType" value="false" />
                        <c:forEach var="selTypeId" items="${discountToEdit.appliedProductTypeIds}">
                            <c:if test="${selTypeId == t.id}"><c:set var="isSelType" value="true" /></c:if>
                        </c:forEach>
                        <label class="checkbox-item">
                            <input type="checkbox" name="target_id_type" value="${t.id}" ${isSelType ? 'checked' : ''}>
                                ${t.type_name}
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="form-group">
                <label>Mô tả:</label><textarea name="description" class="form-control" rows="2">${discountToEdit.description}</textarea>
            </div>

            <div class="form-actions">
                <button type="button" onclick="closeModal()" class="btn btn-cancel">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu lại</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(mode) {
        const actionInput = document.getElementById('formAction');
        const idField = document.getElementById('discountIdField');
        const form = document.getElementById('discountForm');

        document.getElementById('discountModal').style.display = 'block';

        if (mode === 'create') {

            form.reset();
            actionInput.value = "insert";
            idField.value = "";

            // Ẩn các section phạm vi
            document.getElementById("category-section").style.display = "none";
            document.getElementById("type-section").style.display = "none";

            document.querySelector('#discountModal h2').innerText = "Tạo mới Khuyến Mãi";
        } else {
            actionInput.value = "update";
            document.querySelector('#discountModal h2').innerText = "Cập nhật Khuyến Mãi";
            toggleScope();
        }
    }

    function closeModal() {
        document.getElementById('discountModal').style.display = 'none';
        const url = new URL(window.location);
        url.searchParams.delete('action');
        url.searchParams.delete('id');
        window.history.replaceState({}, '', url);
    }

    function toggleScope() {
        var scope = document.getElementById("scopeSelect").value;
        document.getElementById("category-section").style.display = (scope === "category") ? "block" : "none";
        document.getElementById("type-section").style.display = (scope === "type") ? "block" : "none";
    }

    document.addEventListener('DOMContentLoaded', function() {
        toggleScope();
        const urlParams = new URLSearchParams(window.location.search);
        // Nếu URL có ?action=edit thì mới hiện modal (do Servlet forward sang)
        if (urlParams.get('action') === 'edit') {
            openModal('edit');
        }
    });

    window.onclick = function(e) { if(e.target == document.getElementById('discountModal')) closeModal(); }
</script>
<script src="${pageContext.request.contextPath}/admin/js/main.js"></script>

</body>
</html>