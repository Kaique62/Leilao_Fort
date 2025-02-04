import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-auth.js";

const firebaseConfig = {
  apiKey: "AIzaSyDHe5R2Sp9i4aIGBtwgKcfbHHtMJP2uMsQ",
  authDomain: "fortnite-top.firebaseapp.com",
  databaseURL: "https://fortnite-top-default-rtdb.firebaseio.com",
  projectId: "fortnite-top",
  storageBucket: "fortnite-top.firebasestorage.app",
  messagingSenderId: "854503433698",
  appId: "1:854503433698:web:f683a2f4e51964a32845bb"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth();

document.addEventListener('DOMContentLoaded', function() {
  const loginButton = document.getElementById("loginButton");

  loginButton.addEventListener("click", login); // Attach the login function to the button click
});

function login() {
  const email = document.getElementById("email").value;
  const password = document.getElementById("senha").value;

  signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
      console.log("Login successful", user);
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.error("Error:", errorCode, errorMessage);
    });
}
