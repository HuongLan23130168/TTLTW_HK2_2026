
    // --- Slider cho Promo Banner ---
    let currentPromoIndex = 0;
    const promoTrack = document.querySelector('.slider-track');
    const promoSlides = document.querySelectorAll('.promo-group');

    function autoPlayPromo() {
    currentPromoIndex++;
    if (currentPromoIndex >= promoSlides.length) {
    currentPromoIndex = 0;
}
    updatePromoSlider();
}

    function updatePromoSlider() {
    const width = promoSlides[0].clientWidth;
    promoTrack.style.transform = `translateX(-${currentPromoIndex * width}px)`;
}

    // Tự động chạy mỗi 5 giây
    let promoInterval = setInterval(autoPlayPromo, 5000);

    // --- Slider cho Gallery Bộ Sưu Tập ---
    let currentGalleryIndex = 0;
    const galleryTrack = document.getElementById('galleryTrack');
    const gallerySets = document.querySelectorAll('.gallery-set');

    function nextSlide() {
    if (currentGalleryIndex < gallerySets.length - 1) {
    currentGalleryIndex++;
    updateGallery();
} else {
    currentGalleryIndex = 0; // Quay lại đầu
    updateGallery();
}
}

    function prevSlide() {
    if (currentGalleryIndex > 0) {
    currentGalleryIndex--;
    updateGallery();
}
}

    function updateGallery() {
    galleryTrack.style.transform = `translateX(-${currentGalleryIndex * 100}%)`;
}

    // --- Nút Back To Top ---
    const backToTop = document.getElementById('backToTop');
    window.onscroll = function() {
    if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
    backToTop.classList.add('show');
} else {
    backToTop.classList.remove('show');
}
};

    backToTop.onclick = function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
};
