import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-auth.js";
import { getDatabase, ref, get, child } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-database.js";

var leiloes = {};

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

getData();

function getData() {
  const dbRef = ref(getDatabase());
  get(child(dbRef, `leiloes`)).then((snapshot) => {
    if (snapshot.exists()) {
      console.log(snapshot.val());
    } else {
      console.log("No data available");
    }
  }).catch((error) => {
    console.error(error);
  });
}
