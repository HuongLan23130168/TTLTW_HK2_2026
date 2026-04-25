console.clear();

document.addEventListener("DOMContentLoaded", () => {
    const signup = document.querySelector(".signup");
    const signin = document.querySelector(".signin");

    const signinBtn = document.getElementById("signin");
    const signupBtn = document.getElementById("signup-btn");

    signinBtn.addEventListener("click", (e) => {
        signup.classList.add("slide-up");
        signin.classList.remove("slide-up");
    });

    if(signupBtn) {
        signupBtn.addEventListener("click", (e) => {
            signin.classList.add("slide-up");
            signup.classList.remove("slide-up");
        });
    }

});

function togglePass(id, icon) {
    const input = document.getElementById(id);
    if (input.type === "password") {
        input.type = "text";
        icon.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.replace("fa-eye-slash", "fa-eye");
    }
}
