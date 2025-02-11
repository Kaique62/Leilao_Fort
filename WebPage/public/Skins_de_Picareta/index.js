import {leiloes} from "../index.js";

console.log(leiloes)

fetch('https://fortnite-api.com/v2/cosmetics?language=pt-BR')
.then(response => response.json())
.then(data => {
    console.log('Resposta completa da API:', data);  // Mostra toda a resposta da API para análise

    // Verificar se a chave "data" existe antes de acessá-la
    if (data && data.data) {
        console.log('Chave "data" encontrada:', data.data);  // Log para ver a chave "data"
        
        // Verificar se a chave "br" existe e é um array
        if (Array.isArray(data.data.br)) {
            const skins = data.data.br;  // Acessando as skins dentro de "br"
            mostrarSkins(skins);
        } else {
            console.log('Erro: "br" não é um array ou não está presente');
        }
    } else {
        console.log('Erro: "data" não foi encontrado ou é indefinido');
    }
})
.catch(error => console.log("erro na API", error));



function mostrarSkins(skins) {
    console.log(skins);
    
    const container = document.getElementById('skins-container');

    skins.forEach(skin => {
        const div = document.createElement('div');
        div.classList.add('top');
        

        div.innerHTML = `
        <img src="${skin.images.icon}" alt="${skin.name}">
        <h3>${skin.name}</h3>
        `;
        container.appendChild(div);

    })
}


