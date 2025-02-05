function buscarSkin() {
    const skinName = document.getElementById('skin-input').value.trim(); // Obtém o nome da skin
    if (!skinName) {
      alert("Por favor, insira o nome da skin.");
      return;
    }
  
    
    fetch('https://fortnite-api.com/v2/cosmetics?language=pt-BR')
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro na resposta da API');
        }
        return response.json();
      })
      .then(data => {
        console.log('Dados recebidos da API:', data); 
  
        if (data && data.data) {
          console.log('Estrutura de data.data:', Object.keys(data.data)); // Logar as chaves de data.data
  
        
          if (data.data.br) {
            const skins = data.data.br; 
            console.log('Array de skins:', skins);
            const filteredSkins = skins.filter(skin => skin.type && skin.type.backendValue === 'AthenaCharacter'); // Filtra para pegar somente skins
            const skin = filteredSkins.find(skin => skin.name && skin.name.toLowerCase() === skinName.toLowerCase());
  
            if (skin) {
             
              const tipo = skin.type && skin.type.displayValue ? skin.type.displayValue : skin.type;
              const raridade = skin.rarity && skin.rarity.displayValue ? skin.rarity.displayValue : skin.rarity;
  
              document.getElementById('skins-container').innerHTML = `
                <h3>Skin Encontrada:</h3>
                <p><strong>Nome:</strong> ${skin.name}</p>
                <p><strong>Tipo:</strong> ${tipo}</p>
                <p><strong>Raridade:</strong> ${raridade}</p>
                <img src="${skin.images.icon}" alt="${skin.name}" style="width: 100px;">
              `;
            } else {
              document.getElementById('skins-container').innerHTML = `<p>Skin não encontrada.</p>`;
            }
          } 
        } 
      })
      .catch(error => {
        console.error('Erro ao buscar dados da API:', error);
        document.getElementById('skins-container').innerHTML = `<p>Erro ao buscar informações. Tente novamente.</p>`;
      });
  }




  function registrar() {
    const skinName = document.getElementById('skin-input').value.trim(); 
    if (!skinName) {
        alert("Por favor, insira o nome da skin.");
        return;
    }

    fetch('https://fortnite-api.com/v2/cosmetics?language=pt-BR')
        .then(response => {
            if (!response.ok) {
                throw new Error('Erro na resposta da API');
            }
            return response.json();
        })
        .then(data => {
            console.log('Dados recebidos da API:', data);

            if (data && data.data) {
                console.log('Estrutura de data.data:', Object.keys(data.data)); // Logar as chaves de data.data

                if (data.data.br) {
                    const skins = data.data.br;
                    console.log('Array de skins:', skins);

                    const filteredSkins = skins.filter(skin => skin.type && skin.type.backendValue === 'AthenaCharacter');
                    const skin = filteredSkins.find(skin => skin.name && skin.name.toLowerCase() === skinName.toLowerCase());

                    if (skin) {
                        
                        const tipo = skin.type && skin.type.displayValue ? skin.type.displayValue : skin.type;
                        const raridade = skin.rarity && skin.rarity.displayValue ? skin.rarity.displayValue : skin.rarity;

                        const skinInfo = {
                            nome: skin.name,
                            tipo: tipo,
                            raridade: raridade,
                            imagem: skin.images.icon
                        };
                        console.log(skinInfo);

                        // Criando uma div para exibir a skin
                        const skinDiv = document.createElement('div');
                        skinDiv.classList.add('skin'); 

                        // Adicionando as informações à nova div
                        skinDiv.innerHTML = `
                            <img src="${skinInfo.imagem}" alt="${skinInfo.nome}" style="width: 200px;">
                            <p><strong>Nome:</strong><b> ${skinInfo.nome}</b></p>
                            <p><strong>Tipo:</strong> ${skinInfo.tipo}</p>
                            <p><strong>Raridade:</strong> ${skinInfo.raridade}</p>
                            
                        `;

                        // Adicionando a div à área de exibição
                        document.getElementById('skins-container').appendChild(skinDiv);
                    } else {
                        const errorDiv = document.createElement('div');
                        errorDiv.classList.add('error'); // Classe para a mensagem de erro

                        errorDiv.innerHTML = `<p>Skin não encontrada.</p>`;

                        // Adicionando a div de erro à área de exibição
                        document.getElementById('skins-container').appendChild(errorDiv);
                    }
                }
            }
        })
        .catch(error => {
            console.error('Erro ao buscar dados da API:', error);
            const errorDiv = document.createElement('div');
            errorDiv.classList.add('error');

            errorDiv.innerHTML = `<p>Erro ao buscar informações. Tente novamente.</p>`;

            document.getElementById('skins-container').appendChild(errorDiv);
        });
}

  