fetch('https://fortnite-api.com/v2/cosmetics')
  .then(response => response.json())
  .then(data => {
    // Acessando o nome da primeira skin no array "data.data"
    const skins = data.data; // lista de cosméticos (skins, etc.)
    if (skins && skins.length > 0) {
      let Skinsname = skins.map(skin => skin.name);

      console.log(Skinsname);
      document.getElementById('skin-name').innerText = 'A skin ai: ${Skinsname.join(', ')}';
    } else {
      document.getElementById('skin-name').innerText = 'Nao tem nenhuma skin com esse nome';
    }
  })
  .catch(error => console.error('Erro ao acessar a API:', error));
