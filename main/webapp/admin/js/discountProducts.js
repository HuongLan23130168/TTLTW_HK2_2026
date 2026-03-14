document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('discountModal');
    const form = document.getElementById('discountForm');
    const createButton = document.getElementById('createDiscountBtn');
    const closeModalButton = document.querySelector('.close-modal');
    const cancelButton = form.querySelector('.btn-cancel');
    const scopeSelect = document.getElementById('scopeSelect');

    const modalTitle = document.getElementById('modalTitle');
    const formSubmitButton = document.getElementById('formSubmitButton');
    const formActionInput = form.querySelector('input[name="action"]');
    const formIdInput = form.querySelector('input[name="id"]');

    const openModal = () => {
        modal.style.display = 'block';
        if (scopeSelect) toggleScopeInputs();
    };

    const closeModal = () => {
        modal.style.display = 'none';
        const url = new URL(window.location);
        url.searchParams.delete('action');
        url.searchParams.delete('id');
        window.history.pushState({}, '', url);
    };

    if (createButton) {
        createButton.addEventListener('click', () => {
            form.reset();
            modalTitle.innerText = 'Thiết lập giảm giá mới';
            formSubmitButton.innerText = 'Lưu';
            formActionInput.value = 'insert';
            if (formIdInput) formIdInput.value = '';
            document.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
            openModal();
        });
    }

    if (closeModalButton) closeModalButton.addEventListener('click', closeModal);
    if (cancelButton) cancelButton.addEventListener('click', closeModal);
    window.addEventListener('click', (event) => {
        if (event.target === modal) closeModal();
    });

    const toggleScopeInputs = () => {
        if (!scopeSelect) return;
        const scope = scopeSelect.value;
        const scopeCategory = document.getElementById('scope_category');
        const scopeType = document.getElementById('scope_type');
        if (scopeCategory) scopeCategory.style.display = scope === 'category' ? 'block' : 'none';
        if (scopeType) scopeType.style.display = scope === 'type' ? 'block' : 'none';
    };

    if (scopeSelect) {
        scopeSelect.addEventListener('change', toggleScopeInputs);
    }

    function openEditModal(discount) {
        form.reset();
        modalTitle.innerText = 'Chỉnh sửa giảm giá';
        formSubmitButton.innerText = 'Cập nhật';
        formActionInput.value = 'update';
        if (formIdInput) formIdInput.value = discount.id;

        form.discount_name.value = discount.discount_name || '';
        form.discount_code.value = discount.discount_code || '';
        form.discount_percent.value = discount.discount_percent || 0;
        form.description.value = discount.description || '';

        if (discount.start_date) form.start_date.value = new Date(discount.start_date).toISOString().slice(0, 16);
        if (discount.end_date) form.end_date.value = new Date(discount.end_date).toISOString().slice(0, 16);

        let scope = 'none';
        if (discount.appliedCategoryIds && discount.appliedCategoryIds.length > 0) scope = 'category';
        else if (discount.appliedProductTypeIds && discount.appliedProductTypeIds.length > 0) scope = 'type';
        form.scope.value = scope;

        setCheckedCheckboxes('target_id_category', discount.appliedCategoryIds);
        setCheckedCheckboxes('target_id_type', discount.appliedProductTypeIds);

        openModal();
    }

    function setCheckedCheckboxes(checkboxName, ids) {
        if (!ids) return;
        const checkboxes = form.querySelectorAll(`input[name="${checkboxName}"]`);
        checkboxes.forEach(cb => {
            cb.checked = ids.includes(parseInt(cb.value));
        });
    }

    const discountJsonData = document.getElementById('discountJsonData');
    if (discountJsonData && discountJsonData.textContent.trim() !== 'null') {
        try {
            const discountData = JSON.parse(discountJsonData.textContent);
            openEditModal(discountData);
        } catch (e) {
            console.error("Lỗi khi đọc dữ liệu JSON của discount:", e);
        }
    }
});
