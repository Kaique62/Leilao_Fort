import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-auth.js";
import { getDatabase, ref, set, push, get, child } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-database.js";

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
const db = getDatabase();

var data;

var teste ={
  "comeco": "17:00",
  "data": "07/02/2025",
  "fim": "19:00",
  "item": "Dark Matter",
  "lance_inicial": 200,
  "lances": [
    {
      "usuario": "usuario9",
      "valor": 250
    },
    {
      "usuario": "usuario10",
      "valor": 300
    }
  ],
  "status": "finalizado",
  "vencedor": "usuario10"
}

get(child(ref(db), `leiloes`)).then((snapshot) => {
  if (snapshot.exists())
    data = snapshot.val();
});

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

    testLeilaoData();
}

  function testLeilaoData(){
    data["2"] = teste;
    print(data);
    set(ref(db, "leiloes/"), data)
}
