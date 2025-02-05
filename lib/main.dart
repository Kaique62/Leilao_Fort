import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:loading_animation_widget/loading_animation_widget.dart';

var leiloes = {
  0: {
    "comeco": "13:00",
    "data": "04/02/2025",
    "fim": "15:00",
    "item": "Black Knight",
    "lance_inicial": 50,
    "lances": [
      {
        "usuario": "usuario1",
        "valor": 100
      },
      {
        "usuario": "usuario2",
        "valor": 200
      }
    ],
    "status": "finalizado",
    "vencedor": "usuario2"
  },
  1: {
    "comeco": "10:00",
    "data": "05/02/2025",
    "fim": "12:00",
    "item": "Renegade Raider",
    "lance_inicial": 150,
    "lances": [
      {
        "usuario": "usuario3",
        "valor": 200
      },
      {
        "usuario": "usuario4",
        "valor": 250
      },
      {
        "usuario": "usuario5",
        "valor": 300
      }
    ],
    "status": "finalizado",
    "vencedor": "usuario5"
  },
  2: {
    "comeco": "14:00",
    "data": "06/02/2025",
    "fim": "16:00",
    "item": "Reaper",
    "lance_inicial": 80,
    "lances": [
      {
        "usuario": "usuario6",
        "valor": 100
      },
      {
        "usuario": "usuario7",
        "valor": 120
      },
      {
        "usuario": "usuario8",
        "valor": 150
      }
    ],
    "status": "finalizado",
    "vencedor": "usuario8"
  },
  3: {
    "comeco": "17:00",
    "data": "07/02/2025",
    "fim": "19:00",
    "item": "Dark Matter",
    "lance_inicial": 200,
    "lances": [
      {
        "usuario": "usuario9",
        "valor": 250
      },
      {
        "usuario": "usuario10",
        "valor": 300
      }
    ],
    "status": "finalizado",
    "vencedor": "usuario10"
  }
};
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  var br_cosmetic = null;
  

  Future<void> query() async{
    br_cosmetic = {};
    for (var i in leiloes.keys) {
      final response = await http.get(Uri.parse('https://fortnite-api.com/v2/cosmetics/br/search?name=${leiloes[i]!['item']}&?language=pt-BR'));
      var dados = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        br_cosmetic[i] = dados;
      });
    }
    print(br_cosmetic);
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
           Row(
            children: [
              ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        Card(child: 
                        Column(children: [

                        ],),
                  );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(), 
                      itemCount: br_cosmetic.length)
            ],
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
        //  Image.network(br_cosmetic[br_cosmetic[index]]['images']['smallIcon']),
         // Text('Nome: ${br_cosmetic[br_cosmetic[index]]['name']}'),
         // Text('Tipo: ${br_cosmetic[br_cosmetic[index]]['type']['displayValue']}'),
         // Text('${br_cosmetic[br_cosmetic[index]] ['introduction']['text']}'),
          ElevatedButton(
            onPressed: () {
          //    showDialog(
            //    context: context,
              //   builder: buil)
          }, 
            child: Text('Fazer lance'), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white
            )
          )
        ],
      ),
    );
  }
}

Future<void> dialogueBuilder(BuildContext context, String leilao) {
  return showDialog<void> (
    context: context,
    builder: (BuildContext content) {
      return AlertDialog(
        title: Text("Leilão (ID: $leilao)"),
      );
    }
  );
}