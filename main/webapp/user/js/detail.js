document.addEventListener('DOMContentLoaded', () => {

    if (typeof variantsData !== 'undefined' && variantsData.length > 0) {
        updateProductState();
    }

    let referrer = document.referrer;
    if (referrer && referrer.includes("/list-product")) {
        sessionStorage.setItem("savedListUrl", referrer);
    }
});

function goBackToList() {
    let lastListUrl = sessionStorage.getItem("savedListUrl");
    if (lastListUrl) {
        window.location.href = lastListUrl; // Về đúng trang list đã lưu
    } else {
        window.location.href = "${pageContext.request.contextPath}/list-product"; // Fallback an toàn
    }
}

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
    const availableSizesForColor = [...new Set(
        variantsData.filter(v => v.color === selectedColor).map(v => v.size)
    )];

    container.innerHTML = availableSizesForColor.map(size => {
        const variant = variantsData.find(v => v.color === selectedColor && v.size === size);
        const isActive = size === selectedSize ? 'active' : '';

        const isOutOfStock = !variant || variant.stock <= 0;

        if (isOutOfStock) {
            return `<div class="option disabled" title="Hết hàng">${size}</div>`;
        } else {
            return `<div class="option ${isActive}" onclick="selectSize('${size}')">${size}</div>`;
        }
    }).join('');
}
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

function updateProductState() {
    renderColors();
    renderSizes();

    const current = variantsData.find(v => v.color === selectedColor && v.size === selectedSize);

    if (current) {
        console.log("Variant đang chọn:", current);

        const priceDisplay = document.getElementById('price-display');
        const discountArea = document.getElementById('discount-area');
        const oldPriceDisplay = document.getElementById('old-price-display');
        const percentDisplay = document.getElementById('discount-percent');

        priceDisplay.innerText = formatVND(current.finalPrice);

        if (current.discountPercent > 0) {
            discountArea.style.display = 'inline-flex';
            oldPriceDisplay.innerText = formatVND(current.price);
            percentDisplay.innerText = `-${current.discountPercent}%`;
        } else {
            discountArea.style.display = 'none';
        }

        const stockStatus = document.getElementById('stock-status');
        if (stockStatus) {
            if (current.stock <= 0) {
                stockStatus.innerHTML = `<span style="color: #d9534f;"><i class="fa-solid fa-circle-xmark"></i> Hết hàng</span>`;
            } else {
                stockStatus.innerHTML = `<span style="color: #27ae60;"><i class="fa-solid fa-circle-check"></i> Còn hàng (${current.stock})</span>`;
            }
        }

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

        document.getElementById('selected-variant-id').value = current.id;

        document.getElementById('color-text').innerText = current.color;
        document.getElementById('size-text').innerText = current.size;

        const mainImg = document.getElementById('mainImage');
        if (mainImg && current.image_url) mainImg.src = current.image_url;
    }
}

function highlightActiveOption() {
    document.querySelectorAll('#color-options .option').forEach(el => {
        el.classList.toggle('active', el.innerText === selectedColor);
    });
    document.querySelectorAll('#size-options .option').forEach(el => {
        el.classList.toggle('active', el.innerText === selectedSize);
    });
}


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


// function submitCart(type) {
//     const variantId = document.getElementById('selected-variant-id').value;
//     if (!variantId) {
//         Swal.fire('Lỗi', 'Vui lòng chọn đầy đủ màu sắc và kích thước còn hàng!', 'error');
//         return;
//     }
//     const form = document.getElementById('cartForm');
//     if (!form) return;
//
//     if (qtyInput && formQty) formQty.value = qtyInput.value;
//
//     const redirectInput = document.getElementById('redirectAction');
//     if (redirectInput) redirectInput.value = type;
//
//     form.submit();
// }
function submitCart(action) {
    const form = document.getElementById("cartForm");

    document.getElementById("redirectAction").value = action;
    document.getElementById("form-quantity").value =
        document.getElementById("quantity").value;

    form.submit();
}
function changeImage(src, el) {
    const mainImg = document.getElementById('mainImage');
    if (mainImg) mainImg.src = src;

    document.querySelectorAll('.thumbs img').forEach(img => img.style.border = "1px solid #ddd");
    if (el) el.style.border = "2px solid #A79277";
}

function scrollSlider(direction) {
    const slider = document.getElementById('productSlider');
    if (slider) {
        const scrollAmount = slider.clientWidth > 0 ? slider.clientWidth / 2 : 300;
        slider.scrollBy({
            left: direction * scrollAmount,
            behavior: 'smooth'
        });
    }
}

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

