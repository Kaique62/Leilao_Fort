import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leilao_fort_top/firebase_options.dart';
import 'dart:convert';
import 'dart:math';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "./firebase_stuff.dart";

var leiloes;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  static var br_cosmetic = null;
  static var ref = FirebaseDatabase.instance.ref();

  Future<void> query() async{
    final snapshot = await ref.child("leiloes").get();
    if (snapshot.exists) {
      leiloes = snapshot.value;
    }
    var aux = {};
    for (int i = 0; i < leiloes.length; i++) {
      final response = await http.get(Uri.parse('https://fortnite-api.com/v2/cosmetics/br/search?name=${leiloes[i]!['item']}&?language=pt-BR'));
      var dados = json.decode(utf8.decode(response.bodyBytes));
      print(leiloes[i]!["item"]);
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
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await query();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return br_cosmetic == null ? 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 150),
        ),
      ),
    ) 
    : MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold( 
        backgroundColor: Colors.white,
        appBar: AppBar( 
          title: Image.network('https://logos-download.com/wp-content/uploads/2021/01/Fortnite_Logo.png', height: 90, fit: BoxFit.contain),
          backgroundColor: Colors.blue,
          toolbarHeight: 100,

        ),
        body: 
           Center(
            child: 
              GridView.count(
            crossAxisCount: 3,
            children: List.generate(leiloes.length,  (index) {
              return SizedBox(height: 300, child: LeilaoCard(data: br_cosmetic[leiloes[index]!["item"]])); 
            }),
          )
          )        
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
  Widget build(BuildContext context){
    return Card(
      child: Column(
        children: [
        Image.network(widget.data['images']['smallIcon'], width: 100, height: 100,),
        Text('Nome: ${widget.data['name']}'),
        Text('Tipo: ${widget.data['type']['displayValue']}'),
        Text('${widget.data['introduction']['text']}'),
          ElevatedButton(
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                  return LeilaoPopUp(leilao: widget.data["leilao"]);
              });
          }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white
            ), 
            child: const Text('Fazer lance')
          )
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

  @override
  Widget build(BuildContext context){
    return SizedBox(
    height: 300,
     child: AlertDialog( 
      title: Text("Leilão (ID: ${widget.leilao})"),
      actions: [
        ElevatedButton(onPressed: () => {}, child: Text("Cancelar")),
        ElevatedButton(onPressed: () => {}, child: Text("Realizar Lance"))
      ],
      content: Column(
        children: [
          Image.network(MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['images']['smallIcon']),
          Text('Nome: ${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['name']}'),
          Text('Tipo: ${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['type']['displayValue']}'),
          Text('${MyAppState.br_cosmetic[leiloes[widget.leilao]!["item"]]['introduction']['text']}'),
          Text("Lance Minimo: ${leiloes[widget.leilao]!["lance_inicial"]}"),
          TextField(
            controller: leilaoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Valor do Lance: ")
            ),
          )
        ],
      ),
    ));
  }
}