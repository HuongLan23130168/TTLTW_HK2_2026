console.clear();

document.addEventListener('DOMContentLoaded', function() {
  const filterGroups = document.querySelectorAll('.filter-group');

  filterGroups.forEach(group => {
    const label = group.querySelector('.filter-label');
    const options = group.querySelector('.options');
    const icon = label.querySelector('.filter-icon i');

    const checkedInput = options.querySelector('input:checked');

    if (checkedInput) {
      options.classList.add('show');
      if (icon) icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
    }

    label.addEventListener('click', function() {
      const isShowing = options.classList.contains('show');

      if (!isShowing) {
        options.classList.add('show');
        if (icon) icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
      } else {
        options.classList.remove('show');
        if (icon) icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
      }
    });
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