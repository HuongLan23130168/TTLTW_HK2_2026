console.clear();


document.addEventListener('DOMContentLoaded', function() {
  const labels = document.querySelectorAll('.filter-label');
  labels.forEach(label => {
    label.addEventListener('click', function() {
      const options = this.nextElementSibling;
      const icon = this.querySelector('.filter-icon i');

      if (options.style.display === 'none' || options.style.display === '') {
        options.style.display = 'block';
        icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
      } else {
        options.style.display = 'none';
        icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
      }
    });
  });
});
document.querySelectorAll('.sidebar input').forEach(input => {
  input.addEventListener('change', () => {
    input.closest('form').submit();
  });
});

const backToTopBtn = document.getElementById("backToTop");
if(backToTopBtn) {
  window.onscroll = function() {
    if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
      backToTopBtn.classList.add("show");
    } else {
      backToTopBtn.classList.remove("show");
    }
  };
  backToTopBtn.onclick = function() {
    window.scrollTo({top: 0, behavior: 'smooth'});
  };
}