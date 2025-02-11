import { getData } from "./data.js";

async function start() {
    const data = await getData();
    
    if (data) {
        console.log("Dados carregados:", data);
        mostrarSkins(data);
    } else {
        console.log("Erro ao carregar os dados.");
    }
} 
document.addEventListener('DOMContentLoaded', function() {
    start();
});

function mostrarSkins(leiloes) {
    if (!Array.isArray(leiloes)) {
        console.log("Os dados não são um array. Convertendo...");
        leiloes = Object.values(leiloes); // Converte para array
    }

    console.log("Leilões recebidos:", leiloes);

    const container = document.getElementById('mostrarleilao');

    leiloes.forEach(leilao => {
        const div = document.createElement('div');
        div.classList.add('card');

        // Pegando o maior lance
        const lances = leilao.lances || {};

        let urlTest;

        fetch('https://fortnite-api.com/v2/cosmetics/br/search?name=' + leilao.item)
        .then(response => response.json())
        .then(apiData => {
            console.log('Resposta completa da API:', apiData);
            if (apiData) {  
                console.log('Dados extraídos corretamente:', apiData.data);
                urlTest = apiData.data.images.icon
                    if (leilao.item){
                        div.innerHTML = `
                        <h3>${leilao.item}</h3>
                        <img src="${urlTest}" alt="${leilao.item}" class="skin-image" />
                        <p><strong>Data:</strong> ${leilao.data}</p>
                        <p><strong>Horário:</strong> ${leilao.comeco} - ${leilao.fim}</p>
                        <p><strong>Lance Inicial:</strong> $${leilao.lance_inicial}</p>
                    `;
        
                    container.appendChild(div);
                }
            }
            else {

                    if (leilao.item){
                        div.innerHTML = `
                        <h3>${leilao.item}</h3>
                        <p><strong>Data:</strong> ${leilao.data}</p>
                        <p><strong>Horário:</strong> ${leilao.comeco} - ${leilao.fim}</p>
                        <p><strong>Lance Inicial:</strong> $${leilao.lance_inicial}</p>
                    `;
        
                    container.appendChild(div);
                }

            }
        })
        .catch(error => console.error("Erro na API", error));
    
    });
}