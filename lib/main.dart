import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leilao_fort_top/firebase_options.dart';
import 'package:leilao_fort_top/login_and_register.dart';
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "./firebase_stuff.dart";
import 'dart:async';

var userData = "";
String usuario = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static var br_cosmetic;
  static var leiloes;
  var isLoading = true;
  var isLogged = true;
  
  static var ref = FirebaseDatabase.instance.ref();
  static final firebaseStuff = FirebaseStuff();

  var headerText = "";

  Future<void> checkLogin() async {
    var user = firebaseStuff.auth.currentUser;

    if (user != null) {
      setState(() {
        isLogged = true;
        usuario = user.displayName ?? ''; 
        headerText = usuario;
      });
      await fetchLeiloesData();
    } else {
      setState(() {
        isLogged = false;
        headerText = "Login/Cadastro";
      });
    }

    print("Usuário está logado: $isLogged");
  }

  Future<void> fetchLeiloesData() async {
    final snapshot = await ref.child("leiloes").get();
    if (snapshot.exists) {
      leiloes = snapshot.value;
    }
    var aux = {};
    for (int i = 0; i < leiloes.length; i++) {
      final response = await http.get(Uri.parse(
          'https://fortnite-api.com/v2/cosmetics/br/search?name=${leiloes[i]!['item']}&?language=pt-BR'));
      var dados = json.decode(utf8.decode(response.bodyBytes));
     // dados["data"]["leilao"] = i;
      aux[leiloes[i]?["item"]] = dados["data"];
    }

    setState(() {
      br_cosmetic = aux;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: isLogged ? AppBar(
          title: Image.network(
            'https://logos-download.com/wp-content/uploads/2021/01/Fortnite_Logo.png',
            height: 90,
            fit: BoxFit.contain,
          ),
          backgroundColor: Colors.blue,
          toolbarHeight: 100,
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isLogged = false;
                  });
                },
                child: Text(headerText))
          ],
        ) : null,
        body: isLogged
            ? isLoading
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue, size: 150),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: leiloes.length,
                    itemBuilder: (context, index) {
                      return _leilaoCard(
                          data: br_cosmetic[leiloes[leiloes.length - index - 1]!["item"]],
                          index: leiloes.length - index - 1);
                    },
                  )
            : LoginScreen(function: checkLogin),
      ),
    );
  }
}

class _leilaoCard extends StatefulWidget {
  final Map data;
  int index;

  _leilaoCard({required this.data, required this.index});
  @override
  State<_leilaoCard> createState() => LeilaoCard();
}

class LeilaoCard extends State<_leilaoCard> {

  bool finalizado = false;

  void initState(){
    super.initState();
    setState(() {
      finalizado = _LeilaoPopUpState.verificarSeEmAndamento(MyAppState.leiloes[widget.index]);
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, // Largura fixa para manter o design consistente
      height: 300, // Altura fixa para evitar problemas de layout
      child: Card(
        color: !finalizado ? Colors.redAccent : Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4, // Sombra suave
        clipBehavior: Clip.antiAlias, // Garante que os cantos arredondados funcionem para conteúdo interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child:Image.network(
              widget.data['images']['smallIcon'],
              width: 140,
              height: 140, // Tamanho fixo da imagem
              fit: BoxFit.cover,
            )), // Imagem com bordas arredondadas
            
            // Corpo do Card
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Restringe o tamanho da coluna
                children: [
                  // Nome do item
                  Text(
                    'Nome: ${widget.data['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Truncar texto longo
                  ),
                  SizedBox(height: 6),
                  // Tipo do item
                  Text(
                    'Tipo: ${widget.data['type']['displayValue']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 6),
                  // Descrição do item
                  Text(
                    widget.data['introduction']['text'] ?? 'Descrição não disponível',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  // Botão de ação
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LeilaoPopUp(leilao: widget.index);
                          });
                    },
                    icon: Icon(Icons.gavel),
                    label: Text('Fazer Lance'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeilaoPopUp extends StatefulWidget {
  final int leilao;
  LeilaoPopUp({super.key, required this.leilao});

  @override
  State<LeilaoPopUp> createState() => _LeilaoPopUpState();
}

class _LeilaoPopUpState extends State<LeilaoPopUp> {
  TextEditingController leilaoController = TextEditingController();
  var errorText = "";
  static DateTime agora = DateTime.now();
  static var inicio; 
  // Verifica se o leilão está em andamento
  static bool verificarSeEmAndamento(Map leilao) {
    try {

      agora = DateTime.now();
      // Validando os dados
      if (!leilao.containsKey('data') ||
          !leilao.containsKey('comeco') ||
          !leilao.containsKey('fim')) {
        return false;
      }

      final String data = leilao['data'] as String;
      final String comeco = leilao['comeco'] as String;
      final String fim = leilao['fim'] as String;

      // Formatando e criando objetos DateTime
      inicio = DateTime.parse(
          "${data.split('/').reversed.join('-')} $comeco");
      final DateTime fimDate = DateTime.parse(
          "${data.split('/').reversed.join('-')} $fim");

      return agora.isAfter(inicio) && agora.isBefore(fimDate);
    } catch (e) {
      print("Erro ao verificar se o leilão está em andamento: $e");
      return false;
    }
  }

  // Obtém os 3 maiores lances
  List<MapEntry<String, int>> obterTop3Lances(Map lances) {
    try {
      // Garantindo que o mapa está tipado corretamente
      final Map<String, int> lancesTipados =
          lances.cast<String, int>();

      final List<MapEntry<String, int>> ordenados =
          lancesTipados.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      // Retorna os 3 primeiros ou a lista completa, se menor que 3
      return ordenados.sublist(0, ordenados.length < 3 ? ordenados.length : 3);
    } catch (e) {
      print("Erro ao obter os 3 maiores lances: $e");
      return [];
    }
  }

  Future<String> fazerLance() async {
    final snapshot = await MyAppState.ref.child("leiloes").get();
    if (snapshot.exists) {
      MyAppState.leiloes = snapshot.value;
    }

    var errorMessage = "";
    var aux = MyAppState.leiloes[widget.leilao]!["lances"] as Map;

    if (!aux.containsKey(usuario) &&
        int.parse(leilaoController.text) >=
            (MyAppState.leiloes[widget.leilao]!["lance_inicial"] as int)) {
      aux[usuario] = int.parse(leilaoController.text);
      MyAppState.leiloes[widget.leilao]!["lances"] = aux as Object;

      MyAppState.ref.child("leiloes").set(MyAppState.leiloes);
    } else if (aux.containsKey(usuario)) {
      errorMessage = "Você já realizou um lance!";
    } else if (int.parse(leilaoController.text) <=
        (MyAppState.leiloes[widget.leilao]!["lance_inicial"] as int)) {
      errorMessage = "Valor abaixo do Lance Mínimo!";
    }
    return errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    final leilao = MyAppState.leiloes[widget.leilao];
    final emAndamento = verificarSeEmAndamento(leilao);

    return AlertDialog(
      title: Text("Leilão (ID: ${widget.leilao})"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
              MyAppState.br_cosmetic[leilao["item"]]['images']['icon']),
          Padding(padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${MyAppState.br_cosmetic[leilao["item"]]['name']}', textAlign: TextAlign.left),
              Text('Tipo: ${MyAppState.br_cosmetic[leilao["item"]]['type']['displayValue']}', textAlign: TextAlign.left),
              Text('${MyAppState.br_cosmetic[leilao["item"]]['introduction']['text']}', textAlign: TextAlign.left),
              Text('Total de Lances: ${leilao["lances"].keys.length}'),
              Text("Lance Mínimo: ${leilao["lance_inicial"]}"),
            ],
          ),
          ),
          if (emAndamento) ...[
            TextField(
              controller: leilaoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Valor do Lance: "),
                errorText: errorText.isEmpty ? null : errorText,
              ),
              keyboardType: TextInputType.number,
            ),
          ] else if(agora.isAfter(inicio)) ...[
             ...[
              Text("Top Lances:"),
              ...obterTop3Lances(leilao['lances']).map(
                (entry) => Text("${entry.key}: ${entry.value}"),
              ),
              Text("Vencedor: ${leilao['vencedor']}"),
            ]
          ],
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar")),
        if (emAndamento)
          ElevatedButton(
              onPressed: () async {
                var error = await fazerLance();
                if (error.isEmpty) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Lance Realizado!"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Ok!"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    errorText = error;
                  });
                }
              },
              child: Text("Realizar Lance"))
      ],
    );
  }
}
