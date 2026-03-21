
    // 1. Thêm biến thể mới
    function addVariantRow() {
    const container = document.getElementById('variant-list');
    const rows = container.getElementsByClassName('variant-row');
    const sampleRow = rows[0];

    const newRow = sampleRow.cloneNode(true);
    const inputs = newRow.querySelectorAll('input');

    inputs.forEach(input => {
    input.value = '';

    if (input.name === 'variant_ids') {
    input.value = '';
}
    if (input.name === 'stocks') {
    input.value = '10';
}
});


    const btnRemove = newRow.querySelector('.btn-remove-row');
    if(btnRemove) {
    btnRemove.style.display = 'flex';
}

    container.appendChild(newRow);
}

    // 2. Xóa biến thể
    function removeVariantRow(btn) {
    const container = document.getElementById('variant-list');
    const rows = container.getElementsByClassName('variant-row');


    if (rows.length > 1) {
    btn.closest('.variant-row').remove();

} else {
    alert("Sản phẩm phải có ít nhất 1 phiên bản!");
}
}

    // 3. Thêm ảnh gallery
    function addGalleryInput() {
    const container = document.getElementById('gallery-container');
    const div = document.createElement('div');
    div.style.display = 'flex';
    div.style.gap = '10px';
    div.style.marginBottom = '10px';
    div.style.alignItems = 'center';

    div.innerHTML = `
            <input type="text" name="other_images" class="form-control" placeholder="URL ảnh phụ...">
            <button type="button" class="btn-remove-url" onclick="this.parentElement.remove()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        `;
    container.appendChild(div);
}
