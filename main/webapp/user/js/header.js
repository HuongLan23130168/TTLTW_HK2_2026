document.addEventListener("DOMContentLoaded", () => {
    // 1. Logic xử lý menu Dropdown (Decor)
    const dropdown = document.querySelector(".dropdown");
    const dropdownToggle = dropdown?.querySelector("a");

    // Khi click vào chữ "Decor" sẽ mở menu con thả xuống
    if (dropdownToggle) {
        dropdownToggle.addEventListener("click", (e) => {
            e.preventDefault();
            dropdown.classList.toggle("open");
        });
    }

    // 2. Click ra ngoài thì đóng Dropdown
    document.addEventListener("click", (e) => {
        if (dropdown && !dropdown.contains(e.target)) {
            dropdown.classList.remove("open");
        }
    });

    // 3. Hiệu ứng di chuột cho Dropdown
    dropdown?.addEventListener("mouseenter", () => {
        dropdown.classList.add("hovering");
    });
    dropdown?.addEventListener("mouseleave", () => {
        dropdown.classList.remove("hovering");
    });
});