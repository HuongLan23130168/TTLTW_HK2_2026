document.addEventListener("click", function (e) {
    const toggle = e.target.closest(".action-toggle");
    const allMenus = document.querySelectorAll(".action-menu");

    allMenus.forEach((m) => (m.style.display = "none"));

    if (toggle) {
        e.preventDefault();
        const menu = toggle.nextElementSibling;
        menu.style.display = "flex";
    }
});
