
function addVariantRow() {
    const container = document.getElementById('variant-list');
    const rows = container.getElementsByClassName('variant-row');


    const sampleRow = rows[0];


    const newRow = sampleRow.cloneNode(true);


    const inputs = newRow.querySelectorAll('input');
    inputs.forEach(input => {
        input.value = '';

        if (input.name === 'stocks') {
            input.value = '10';
        }
    });


    container.appendChild(newRow);
}


function removeVariantRow(btn) {
    const container = document.getElementById('variant-list');
    const rows = container.getElementsByClassName('variant-row');

    if (rows.length > 1) {
        btn.closest('.variant-row').remove();
    } else {
        alert("Sản phẩm phải có ít nhất 1 phiên bản (Màu sắc/Size)!");
    }
}


function previewMainImage(input) {
    const imgPreview = document.getElementById('previewMain');
    const defaultImg = '/admin/img/no-image.png';

    if (input.value && input.value.trim() !== "") {
        imgPreview.src = input.value;
    } else {
        imgPreview.src = defaultImg;
    }

    imgPreview.onerror = function() {
        this.src = defaultImg;
    };
}

function addGalleryInput() {
    const container = document.getElementById('gallery-container');

    const div = document.createElement('div');


    div.style.display = 'flex';
    div.style.gap = '10px';
    div.style.marginBottom = '10px';
    div.style.alignItems = 'center';

    div.innerHTML = `
        <input type="text" name="other_images" class="form-control" 
               placeholder="Dán URL ảnh phụ vào đây..." 
               style="flex:1; padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
               
        <button type="button" class="btn-remove-url" onclick="this.parentElement.remove()">
            <i class="fa-solid fa-xmark"></i>
        </button>
    `;

    container.appendChild(div);
}

document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById('addProductForm');

    if(form) {
        form.addEventListener('submit', function(e) {
            // Kiểm tra xem có dòng biến thể nào chưa nhập giá không?
            const prices = document.getElementsByName('prices');
            let valid = true;

            for(let i = 0; i < prices.length; i++) {
                if(!prices[i].value || parseFloat(prices[i].value) < 0) {
                    valid = false;
                    prices[i].style.borderColor = "red";
                } else {
                    prices[i].style.borderColor = "#ccc";
                }
            }

            if(!valid) {
                e.preventDefault();
                alert("Vui lòng nhập giá bán hợp lệ cho tất cả các biến thể!");
            }
        });
    }
});