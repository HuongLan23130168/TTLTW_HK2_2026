document.addEventListener("DOMContentLoaded", () => {
    // ===== Header top (Tra cứu, Giới thiệu, Liên hệ) =====
    const topLinks = document.querySelectorAll(".header-right > a"); // chỉ lấy link text
    const currentPageTop = window.location.pathname.split("/").pop() || "index.html";

// Giữ active theo URL của trang
    topLinks.forEach(link => {
        const href = link.getAttribute("href");
        if (href && href === currentPageTop) {
            link.classList.add("active");
        }
    });

    // ===== Menu chính =====
    const menuLinks = document.querySelectorAll(".menu > a, .menu > .dropdown > a");
    const dropdown = document.querySelector(".dropdown");
    const dropdownToggle = dropdown?.querySelector("a");
    const currentPage = window.location.pathname.split("/").pop() || "index.html";

    // --- Bỏ active cũ ---
    menuLinks.forEach(l => l.classList.remove("active"));

    // --- Tô sáng trang hiện tại ---
    if (currentPage.startsWith("decor")) {
        dropdownToggle?.classList.add("active");
    } else {
        menuLinks.forEach(link => {
            const href = link.getAttribute("href");
            if (href && href === currentPage) {
                link.classList.add("active");
            }
        });
    }

    // --- Khi click Decor ---
    menuLinks.forEach(link => {
        link.addEventListener("click", (e) => {
            if (link === dropdownToggle) {
                e.preventDefault();
                // Toggle class "open" để giữ menu mở sau click
                dropdown.classList.toggle("open");
            } else {
                menuLinks.forEach(l => l.classList.remove("active"));
                link.classList.add("active");
                dropdown.classList.remove("open");
            }
        });
    });

    // --- Khi click ra ngoài thì đóng dropdown ---
    document.addEventListener("click", (e) => {
        if (!dropdown.contains(e.target)) {
            dropdown.classList.remove("open");
        }
    });

    // --- Hover Decor cũng mở menu ---
    dropdown.addEventListener("mouseenter", () => {
        dropdown.classList.add("hovering");
    });
    dropdown.addEventListener("mouseleave", () => {
        dropdown.classList.remove("hovering");
    });
});