document.addEventListener("DOMContentLoaded", function () {

    const API = "https://provinces.open-api.vn/api";

    const province = document.getElementById("province");
    const district = document.getElementById("district");
    const ward = document.getElementById("ward");

    const cityName = document.getElementById("cityName");
    const districtName = document.getElementById("districtName");
    const wardName = document.getElementById("wardName");

    const fullName = document.getElementById("fullName");
    const phone = document.getElementById("phone");

    const fullNameError = document.getElementById("fullNameError");
    const phoneError = document.getElementById("phoneError");

    const form = document.getElementById("checkoutForm");

    function setError(input, errorEl, message) {
        if (!input || !errorEl) return;
        input.classList.add("input-error");
        errorEl.innerText = message;
    }

    function clearError(input, errorEl) {
        if (!input || !errorEl) return;
        input.classList.remove("input-error");
        errorEl.innerText = "";
    }


    fetch(API + "/p/")
        .then(res => res.json())
        .then(data => {
            data.sort((a, b) => a.name.localeCompare(b.name));
            data.forEach(p => {
                let opt = document.createElement("option");
                opt.value = p.code;
                opt.textContent = p.name;
                province.appendChild(opt);
            });
        });


    province.addEventListener("change", function () {

        district.innerHTML = `<option value="">Chọn Quận/Huyện</option>`;
        ward.innerHTML = `<option value="">Chọn Phường/Xã</option>`;

        cityName.value = province.options[province.selectedIndex].text;
        districtName.value = "";
        wardName.value = "";

        if (!this.value) return;

        fetch(API + "/p/" + this.value + "?depth=2")
            .then(res => res.json())
            .then(data => {
                data.districts
                    .sort((a, b) => a.name.localeCompare(b.name))
                    .forEach(d => {
                        let opt = document.createElement("option");
                        opt.value = d.code;
                        opt.textContent = d.name;
                        district.appendChild(opt);
                    });
            });
    });


    district.addEventListener("change", function () {

        ward.innerHTML = `<option value="">Chọn Phường/Xã</option>`;
        districtName.value = district.options[district.selectedIndex].text;
        wardName.value = "";

        if (!this.value) return;

        fetch(API + "/d/" + this.value + "?depth=2")
            .then(res => res.json())
            .then(data => {
                data.wards
                    .sort((a, b) => a.name.localeCompare(b.name))
                    .forEach(w => {
                        let opt = document.createElement("option");
                        opt.value = w.code;
                        opt.textContent = w.name;
                        ward.appendChild(opt);
                    });
            });
    });

    ward.addEventListener("change", function () {
        wardName.value = ward.options[ward.selectedIndex].text;
    });


    fullName.addEventListener("input", function () {
        const value = fullName.value.trim();

        if (value.length === 0) {
            setError(fullName, fullNameError, "Họ tên không được để trống");
        } else if (value.length < 3) {
            setError(fullName, fullNameError, "Họ tên phải từ 3 ký tự");
        } else {
            clearError(fullName, fullNameError);
        }
    });


    phone.addEventListener("input", function () {
        const value = phone.value.trim();
        const phoneRegex = /^0\d{9}$/;

        if (value.length === 0) {
            setError(phone, phoneError, "Số điện thoại không được để trống");
        } else if (!phoneRegex.test(value)) {
            setError(phone, phoneError, "SĐT phải gồm 10 số và bắt đầu bằng 0");
        } else {
            clearError(phone, phoneError);
        }
    });


    form.addEventListener("submit", function (e) {

        let hasError = false;

        const nameValue = fullName.value.trim();
        const phoneValue = phone.value.trim();

        if (nameValue.length < 3) {
            setError(fullName, fullNameError, "Họ tên không hợp lệ");
            hasError = true;
        }

        if (!/^0\d{9}$/.test(phoneValue)) {
            setError(phone, phoneError, "Số điện thoại không hợp lệ");
            hasError = true;
        }

        if (hasError) e.preventDefault();
    });

});