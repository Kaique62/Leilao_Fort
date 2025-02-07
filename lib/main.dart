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

Timer? timer;
var leiloes;
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
  static var br_cosmetic = null;
  static var ref = FirebaseDatabase.instance.ref();
  static final firebaseStuff = FirebaseStuff();

  static bool isLogged = false;

  Future<bool> checkLogin() async {
    bool initialValue = isLogged;
    if (firebaseStuff.checkAuthState()){
      setState(() {
        isLogged = true;
        usuario = firebaseStuff.auth.currentUser!.displayName!;
        print(usuario);
      });
    }
    else {
      isLogged = false;
    }
    if (isLogged){
      await query();
    }
    return isLogged;
  }

  Future<void> query() async {
    timer?.cancel();
    print("reading data...");
    final snapshot = await ref.child("leiloes").get();
    if (snapshot.exists) {
      leiloes = snapshot.value;
    }
    var aux = {};
    for (int i = 0; i < leiloes.length; i++) {
      final response = await http.get(Uri.parse(
          'https://fortnite-api.com/v2/cosmetics/br/search?name=${leiloes[i]!['item']}&?language=pt-BR'));
      var dados = json.decode(utf8.decode(response.bodyBytes));
      dados["data"]["leilao"] = i;
      aux[leiloes[i]?["item"]] = dados["data"];
    }

    setState(() {
      br_cosmetic = aux;
    });
    print(br_cosmetic.keys);
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkLogin());
    super.initState();
    setState(() {
      if (firebaseStuff.checkAuthState()){
        isLogged = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await query();
        });
      }
      else {
        isLogged = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogged ? ( br_cosmetic == null
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue, size: 150),
              ),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Image.network(
                      'https://logos-download.com/wp-content/uploads/2021/01/Fortnite_Logo.png',
                      height: 90,
                      fit: BoxFit.contain),
                  backgroundColor: Colors.blue,
                  toolbarHeight: 100,
                  actions: [
                    TextButton(
                        onPressed: () {
                            setState(() {
                              isLogged = false;
                            });
                        },
                        child: Text("Login/Cadastro"))
                  ],
                ),
                body: Center(
                    child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(leiloes.length, (index) {
                    return SizedBox(
                        height: 300,
                        child: LeilaoCard(
                            data: br_cosmetic[leiloes[index]!["item"]]));
                  }),
                ))),
    )
    ) :  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: LoginScreen(function: checkLogin,),
      ),
    );
  }
}

class LeilaoCard extends StatefulWidget {
  Map data;
  LeilaoCard({super.key, required this.data});

  @override
  State<LeilaoCard> createState() => LeilaoCardState();
}

class LeilaoCardState extends State<LeilaoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            widget.data['images']['smallIcon'],
            width: 100,
            height: 100,
          ),
          Text('Nome: ${widget.data['name']}'),
          Text('Tipo: ${widget.data['type']['displayValue']}'),
          Text('${widget.data['introduction']['text']}'),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LeilaoPopUp(leilao: widget.data["leilao"]);
                    });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text('Fazer lance'))
        ],
      ),
    );
  }
}

class LeilaoPopUp extends StatefulWidget {
  int leilao;
  LeilaoPopUp({super.key, required this.leilao});

  @override
  State<LeilaoPopUp> createState() => leilaoPopUpState();
}

class leilaoPopUpState extends State<LeilaoPopUp> {
  TextEditingController leilaoController = TextEditingController();

  var errorText = "";
  Future<String> fazerLance() async {
    final snapshot = await MyAppState.ref.child("leiloes").get();
    if (snapshot.exists) {
      leiloes = snapshot.value;
    }

    var errorMessage = "";
    var aux = leiloes[widget.leilao]!["lances"] as Map;
    print(leiloes[widget.leilao]!["lance_inicial"] as int);
    if (!aux.containsKey(usuario) && int.parse(leilaoController.text) >= (leiloes[widget.leilao]!["lance_inicial"] as int)) {
      aux[usuario] = int.parse(leilaoController.text);
      leiloes[widget.leilao]!["lances"] = aux as Object;
      print(leiloes[widget.leilao]!["lances"]);

      MyAppState.ref.child("leiloes").set(leiloes);
    }
    else if (aux.containsKey(usuario)){
      errorMessage = "Você ja realizou um lance!";
    }
    else if (int.parse(leilaoController.text) <= (leiloes[widget.leilao]!["lance_inicial"] as int)) {
      errorMessage = "Valor abaixo do Lance Minímo!";
    }
    return errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: AlertDialog(
          title: Text("Leilão (ID: ${widget.leilao})"),
          actions: [
            ElevatedButton(onPressed: () => {Navigator.pop(context)}, child: Text("Cancelar")),
            ElevatedButton(onPressed: () async {
                var aux = await fazerLance();
                if (aux == "") {
                  Navigator.pop(context);
                  showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(title: SizedBox(
                          width: 100,
                          height: 40,
                          child: Text("Lance Realizado!")),
                          actions: [ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Ok!"))],
                      );
                  });
                }
                else {
                  setState(() {
                    errorText = aux;
                  });
                }
            }, child: Text("Realizar Lance"))
          ],
          content: Column(
            children: [
              Image.network(
                  MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]
                      ['images']['smallIcon']),
              Text(
                  'Nome: ${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['name']}'),
              Text(
                  'Tipo: ${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['type']['displayValue']}'),
              Text(
                  '${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['introduction']['text']}'),
              Text("Lance Minimo: ${leiloes[widget.leilao]!["lance_inicial"]}"),
              TextField(
                controller: leilaoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Valor do Lance: ")),
              )
            ],
          ),
        ));
  }
}
