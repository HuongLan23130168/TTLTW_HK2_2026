document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchProduct");
    const tableBody = document.getElementById("tbody");

    if (searchInput && tableBody) {
        searchInput.addEventListener("keyup", function () {
            const searchTerm = removeVietnameseTones(this.value.toLowerCase().trim());
            const rows = tableBody.getElementsByTagName("tr");
            let hasResult = false;

            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                if (row.id === "no-result-row") continue;

                const nameText = row.querySelector(".product-name-text")?.innerText || "";
                const codeText = row.querySelector(".product-code")?.innerText || "";

                const rowText = removeVietnameseTones((nameText + " " + codeText).toLowerCase());

                if (rowText.indexOf(searchTerm) > -1) {
                    row.style.display = "";
                    hasResult = true;
                } else {
                    row.style.display = "none";
                }
            }

            let noResultRow = document.getElementById("no-result-row");
            if (!hasResult) {
                if (!noResultRow) {
                    noResultRow = document.createElement("tr");
                    noResultRow.id = "no-result-row";
                    noResultRow.innerHTML = `<td colspan="8" style="text-align:center; padding: 30px; color: #777;">Không tìm thấy sản phẩm phù hợp.</td>`;
                    tableBody.appendChild(noResultRow);
                } else noResultRow.style.display = "";
            } else if (noResultRow) noResultRow.style.display = "none";
        });
    }
});

function removeVietnameseTones(str) {
    if (!str) return "";
    str = str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    str = str.replace(/đ/g, 'd').replace(/Đ/g, 'D');
    return str;
}