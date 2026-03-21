function toggleEdit() {
    const editForm = document.getElementById('editForm');
    if (editForm.classList.contains('hidden')) {
        editForm.classList.remove('hidden');
        setTimeout(() => editForm.classList.add('show'), 10);
    } else {
        editForm.classList.remove('show');
        setTimeout(() => editForm.classList.add('hidden'), 400);
    }
}

const params = new URLSearchParams(window.location.search);
const msg = params.get('msg');
const detail = params.get('detail');

if (msg === 'success') {
    alert('Cập nhật thành công!');
}
else if (msg === 'error') {
    const errors = {
        'data_too_long': 'Dữ liệu quá dài so với quy định.',
        'server_error': 'Lỗi hệ thống (Server Error).',
        'not_found': 'Không tìm thấy tài khoản để cập nhật.'
    };

    const reason = errors[detail] || 'Vui lòng kiểm tra lại kết nối hoặc dữ liệu.';
    alert('Lỗi: ' + reason);
}