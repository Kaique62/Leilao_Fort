import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js";
import { getDatabase, ref, get, child } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-database.js";

const firebaseConfig = {
  apiKey: "AIzaSyDHe5R2Sp9i4aIGBtwgKcfbHHtMJP2uMsQ",
  authDomain: "fortnite-top.firebaseapp.com",
  databaseURL: "https://fortnite-top-default-rtdb.firebaseio.com",
  projectId: "fortnite-top",
  storageBucket: "fortnite-top.firebasestorage.app",
  messagingSenderId: "854503433698",
  appId: "1:854503433698:web:f683a2f4e51964a32845bb"
};

// Inicializa o Firebase
const app = initializeApp(firebaseConfig);
const db = getDatabase(app);

// Função correta para buscar os dados de forma assíncrona
export async function getData() {
  const dbRef = ref(db);
  try {
    const snapshot = await get(child(dbRef, `leiloes`));
    if (snapshot.exists()) {
      console.log("Dados do Firebase:", snapshot.val());
      return snapshot.val();  // Retorna os dados corretamente
    } else {
      console.log("Nenhum dado disponível");
      return null;
    }
  } catch (error) {
    console.error("Erro ao buscar dados do Firebase:", error);
    return null;
  }
}
