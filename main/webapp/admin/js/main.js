const userBtn = document.querySelector(".user-btn");
const dropdownMenu = document.querySelector(".dropdown-menu");

userBtn.addEventListener("click", (e) => {
  e.stopPropagation();
  dropdownMenu.classList.toggle("show");
});

document.addEventListener("click", (e) => {
  if (!dropdownMenu.contains(e.target)) {
    dropdownMenu.classList.remove("show");
  }
});
