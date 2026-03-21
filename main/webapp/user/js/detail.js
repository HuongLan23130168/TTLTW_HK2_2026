document.addEventListener('DOMContentLoaded', () => {
    if (typeof variantsData !== 'undefined' && variantsData.length > 0) {
        updateProductState();
    }
});

// --- RENDER GIAO DIỆN OPTION ---
function renderColors() {
    const uniqueColors = [...new Set(variantsData.map(v => v.color))];
    const container = document.getElementById('color-options');
    if (!container) return;

    container.innerHTML = uniqueColors.map(color => {
        const isActive = color === selectedColor ? 'active' : '';
        return `<div class="option ${isActive}" onclick="selectColor('${color}')">${color}</div>`;
    }).join('');
}

function renderSizes() {
    const container = document.getElementById('size-options');
    // Lọc ra các size duy nhất của màu đang chọn
    const availableSizesForColor = [...new Set(
        variantsData.filter(v => v.color === selectedColor).map(v => v.size)
    )];

    container.innerHTML = availableSizesForColor.map(size => {
        const variant = variantsData.find(v => v.color === selectedColor && v.size === size);
        const isActive = size === selectedSize ? 'active' : '';

        // KIỂM TRA: Nếu không có variant hoặc stock <= 0
        const isOutOfStock = !variant || variant.stock <= 0;

        if (isOutOfStock) {
            return `<div class="option disabled" title="Hết hàng">${size}</div>`;
        } else {
            return `<div class="option ${isActive}" onclick="selectSize('${size}')">${size}</div>`;
        }
    }).join('');
}
// --- XỬ LÝ CHỌN BIẾN THỂ ---
function selectColor(color) {
    if (selectedColor === color) return;
    selectedColor = color;
    const validVariants = variantsData.filter(v => v.color === color && v.stock > 0);
    if (validVariants.length > 0) {
        if (!validVariants.find(v => v.size === selectedSize)) {
            selectedSize = validVariants[0].size;
        }
    }
    updateProductState();
}

function selectSize(size) {
    if (selectedSize === size) return;
    selectedSize = size;
    updateProductState();
}

// --- CẬP NHẬT TRẠNG THÁI TỔNG THỂ ---
function updateProductState() {
    renderColors();
    renderSizes();

    const current = variantsData.find(v => v.color === selectedColor && v.size === selectedSize);

    if (current) {
        console.log("Variant đang chọn:", current); // Dùng để debug xem discountPercent có > 0 không

        const priceDisplay = document.getElementById('price-display');
        const discountArea = document.getElementById('discount-area');
        const oldPriceDisplay = document.getElementById('old-price-display');
        const percentDisplay = document.getElementById('discount-percent');

        // Hiển thị giá đã giảm
        priceDisplay.innerText = formatVND(current.finalPrice);

        if (current.discountPercent > 0) {
            discountArea.style.display = 'inline-flex'; // Hoặc 'flex' tùy CSS của bạn
            oldPriceDisplay.innerText = formatVND(current.price);
            percentDisplay.innerText = `-${current.discountPercent}%`;
        } else {
            discountArea.style.display = 'none';
        }

        // 3. Trạng thái kho hàng
        const stockStatus = document.getElementById('stock-status');
        if (stockStatus) {
            if (current.stock <= 0) {
                stockStatus.innerHTML = `<span style="color: #d9534f;"><i class="fa-solid fa-circle-xmark"></i> Hết hàng</span>`;
            } else {
                stockStatus.innerHTML = `<span style="color: #27ae60;"><i class="fa-solid fa-circle-check"></i> Còn hàng (${current.stock})</span>`;
            }
        }

        // 4. Cập nhật nút bấm
        const buyBtn = document.querySelector('.buy-now');
        const addCartBtn = document.querySelector('.add-cart');
        if (current.stock <= 0) {
            buyBtn.innerHTML = "Hết hàng";
            buyBtn.style.backgroundColor = "#ccc";
            buyBtn.style.pointerEvents = "none";
            addCartBtn.style.opacity = "0.5";
            addCartBtn.style.pointerEvents = "none";
        } else {
            buyBtn.innerHTML = "Mua ngay";
            buyBtn.style.backgroundColor = "#A79277";
            buyBtn.style.pointerEvents = "auto";
            addCartBtn.style.opacity = "1";
            addCartBtn.style.pointerEvents = "auto";
        }

        // 5. Cập nhật ID cho Form
        document.getElementById('selected-variant-id').value = current.id;

        // 6. Cập nhật Text mô tả
        document.getElementById('color-text').innerText = current.color;
        document.getElementById('size-text').innerText = current.size;

        // 7. Đổi ảnh chính
        const mainImg = document.getElementById('mainImage');
        if (mainImg && current.image_url) mainImg.src = current.image_url;
    }
}

// Helper để highlight UI mà không render lại tất cả
function highlightActiveOption() {
    document.querySelectorAll('#color-options .option').forEach(el => {
        el.classList.toggle('active', el.innerText === selectedColor);
    });
    document.querySelectorAll('#size-options .option').forEach(el => {
        el.classList.toggle('active', el.innerText === selectedSize);
    });
}


// --- 6. XỬ LÝ TĂNG GIẢM SỐ LƯỢNG ---
const qtyInput = document.getElementById('quantity');
const formQty = document.getElementById('form-quantity');
const btnInc = document.getElementById('qty-increase');
const btnDec = document.getElementById('qty-decrease');

if (btnInc && qtyInput) {
    btnInc.onclick = () => {
        let val = parseInt(qtyInput.value) || 1;
        qtyInput.value = val + 1;
        if (formQty) formQty.value = qtyInput.value;
    };
}
if (btnDec && qtyInput) {
    btnDec.onclick = () => {
        let val = parseInt(qtyInput.value) || 1;
        if (val > 1) {
            qtyInput.value = val - 1;
            if (formQty) formQty.value = qtyInput.value;
        }
    };
}

// --- 7. SUBMIT FORM ---
function submitCart(type) {
    const variantId = document.getElementById('selected-variant-id').value;
    if (!variantId) {
        Swal.fire('Lỗi', 'Vui lòng chọn đầy đủ màu sắc và kích thước còn hàng!', 'error');
        return;
    }
    const form = document.getElementById('cartForm');
    if (!form) return;

    // Cập nhật lần cuối trước khi gửi
    if (qtyInput && formQty) formQty.value = qtyInput.value;

    const redirectInput = document.getElementById('redirectAction');
    if (redirectInput) redirectInput.value = type;

    form.submit();
}

// --- 8. ĐỔI ẢNH THUMBNAIL ---
function changeImage(src, el) {
    const mainImg = document.getElementById('mainImage');
    if (mainImg) mainImg.src = src;

    // UI Active state cho ảnh nhỏ (nếu cần CSS)
    document.querySelectorAll('.thumbs img').forEach(img => img.style.border = "1px solid #ddd");
    if (el) el.style.border = "2px solid #A79277";
}

// --- 9. SLIDER (ĐÃ SỬA LỖI) ---
function scrollSlider(direction) {
    const slider = document.getElementById('productSlider');
    if (slider) {
        // Trượt bằng 1/3 chiều rộng khung hoặc 300px
        const scrollAmount = slider.clientWidth > 0 ? slider.clientWidth / 2 : 300;
        slider.scrollBy({
            left: direction * scrollAmount,
            behavior: 'smooth'
        });
    }
}

// --- 10. BACK TO TOP ---
const backToTopBtn = document.getElementById("backToTop");
if (backToTopBtn) {
    window.onscroll = function () {
        if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
            backToTopBtn.classList.add("show");
        } else {
            backToTopBtn.classList.remove("show");
        }
    };
    backToTopBtn.onclick = function () {
        window.scrollTo({top: 0, behavior: 'smooth'});
    };
}

