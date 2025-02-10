

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
const app = initializeApp(firebaseConfig);


function getData() {
  const dbRef = ref(getDatabase());
  get(child(dbRef, `leiloes`)).then((snapshot) => {
    if (snapshot.exists()) {
      const leiloes = snapshot.val();
      // Chamar a função que vai exibir as skins na tela
      displaySkins(leiloes);
    } else {
      console.log("No data available");
    }
  }).catch((error) => {
    console.error(error);
  });
}

async function fetchSkinData(skinName) {
  const apiUrl = `https://fortnite-api.com/v2/cosmetics?language=pt-BR`;
  try {
    const response = await fetch(apiUrl);
    const data = await response.json();
    const skin = data.data.find(s => s.name.toLowerCase() === skinName.toLowerCase()); 

    return skin ? skin : null; 
  } catch (error) {
    console.error("Erro ao buscar dados da skin:", error);
    return null;
  }
}


async function displaySkins(leiloes) {
  const container = document.getElementById('skins-container');

  for (const skinId in leiloes) {
    const leilao = leiloes[skinId];
    const skinName = leilao.nome_da_skin;
    const fortniteData = await fetchSkinData(skinName);

    if (fortniteData) {
      // Se a skin foi encontrada na API do Fortnite
      const card = document.createElement('div');
      card.classList.add('skin-card');

      card.innerHTML = `
        <img src="${fortniteData.images.icon}" alt="${fortniteData.name}" class="skin-image">
        <h3>${fortniteData.name}</h3>
        <p><strong>Nome da skin:</strong> ${fortniteData.name}</p>
        <p><strong>Horário de que foi leiloada:</strong> ${leilao.horario_leiloada}</p>
        <p><strong>Horário que o leilão acabou:</strong> ${leilao.horario_que_o_leilao_acabou}</p>
        <p><strong>Lance mínimo:</strong> ${leilao.lance_minimo}</p>
        <p><strong>Lance máximo:</strong> ${leilao.lance_maximo}</p>
        <p><strong>Vencedor:</strong> ${leilao.vencedor}</p>
      `;

      container.appendChild(card);
    } else {
      const card = document.createElement('div');
      card.classList.add('skin-card');

      card.innerHTML = `
        <h3>${skinName}</h3>
        <p><strong>Nome da skin:</strong> ${skinName}</p>
        <p><strong>Horário de que foi leiloada:</strong> ${leilao.horario_leiloada}</p>
        <p><strong>Horário que o leilão acabou:</strong> ${leilao.horario_que_o_leilao_acabou}</p>
        <p><strong>Lance mínimo:</strong> ${leilao.lance_minimo}</p>
        <p><strong>Lance máximo:</strong> ${leilao.lance_maximo}</p>
        <p><strong>Vencedor:</strong> ${leilao.vencedor}</p>
        <p><strong>Info não encontrada na API do Fortnite.</strong></p>
      `;

      container.appendChild(card);
    }
  }
}

window.onload = () => {
  getData();
}

