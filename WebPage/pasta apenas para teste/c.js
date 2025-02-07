// Firebase Configuration (adicionar no início do seu código)
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-app.js";
import { getFirestore, collection, getDocs } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-firestore.js";

// Sua configuração do Firebase
const firebaseConfig = {
  apiKey: "SUA_API_KEY",
  authDomain: "SEU_AUTH_DOMAIN",
  projectId: "SEU_PROJECT_ID",
  storageBucket: "SEU_STORAGE_BUCKET",
  messagingSenderId: "SEU_MESSAGING_SENDER_ID",
  appId: "SEU_APP_ID"
};

// Inicializa o Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Função para buscar dados do Firebase
async function getLeilaoData() {
  const leiloesCol = collection(db, 'leiloes'); // Supondo que os leilões estão armazenados em uma coleção chamada 'leiloes'
  const leiloesSnapshot = await getDocs(leiloesCol);
  const leiloesList = leiloesSnapshot.docs.map(doc => doc.data()); // Array com os dados do leilão
  console.log('Leilões do Firebase:', leiloesList);
  return leiloesList;
}

// Função para buscar skins na API usando o nome
async function getSkinFromAPI(nome) {
  try {
    const response = await fetch(`https://fortnite-api.com/v2/cosmetics?language=pt-BR&name=${encodeURIComponent(nome)}`);
    const data = await response.json();
    
    if (data && data.data && Array.isArray(data.data.br)) {
      return data.data.br; // Retorna as skins encontradas com o nome correspondente
    } else {
      console.log('Nenhuma skin encontrada ou erro na resposta');
      return [];
    }
  } catch (error) {
    console.error('Erro ao buscar dados na API:', error);
    return [];
  }
}

// Função para mostrar as skins no card
function mostrarSkins(leiloes) {
  const container = document.getElementById('skins-container');
  container.innerHTML = ''; // Limpa o container antes de adicionar novos cards

  leiloes.forEach(async (leilao) => {
    const skinsEncontradas = await getSkinFromAPI(leilao.nome); // Busca as skins na API com o nome da skin do leilão

    skinsEncontradas.forEach(skin => {
      const div = document.createElement('div');
      div.classList.add('card');
      
      div.innerHTML = `
        <img src="${skin.images.icon}" alt="${skin.name}">
        <h3>${skin.name}</h3>
        <p>Tipo: ${skin.type}</p>
        <p>Preço: ${leilao.preco}</p>
        <p>Horário de Início: ${leilao.horarioInicio}</p>
        <p>Horário de Fim: ${leilao.horarioFim}</p>
        <p>Vencedor: ${leilao.vencedor || 'Nenhum'}</p>
      `;
      container.appendChild(div);
    });
  });
}

// Carregar dados do Firebase e exibir na tela
async function loadData() {
  const leiloes = await getLeilaoData(); // Pega os dados do Firebase
  mostrarSkins(leiloes); // Exibe as skins e os dados dos leilões na tela
}

loadData(); // Chama a função para carregar e exibir os dados
