import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget  {
  MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  
  Map ? br_cosmetic;
  
  Future<void> query() async{
    final response = await http.get(Uri.parse('https://fortnite-api.com/v2/cosmetics/br?language=pt-BR'));
    var dados = json.decode(utf8.decode(response.bodyBytes));
    var intValue = Random().nextInt(dados['data'].length);
    setState(() {
      br_cosmetic = dados['data'][intValue];
    });
  }

  void initState() {
    super.initState();
    query();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold( 
        backgroundColor: Colors.white,
        appBar: AppBar( 
          title: Image.network('https://logos-download.com/wp-content/uploads/2021/01/Fortnite_Logo.png', height: 90, fit: BoxFit.contain),
          backgroundColor: Colors.blue,
          toolbarHeight: 100,

        ),
        body: Center(
          child: Column(
            children: [
              Card(child: 
                Column(children: [

                  Image.network(br_cosmetic!['images']['smallIcon']),
                  Text('Nome: ${br_cosmetic!['name']}'),
                  Text('Tipo: ${br_cosmetic!['type']['displayValue']}'),
                  Text('Raridade: ${br_cosmetic!['rarity']['displayValue']}'),
                  Text('${br_cosmetic!['introduction']['text']}')
                ],),
          )
            ],
          )        
      ),
      ));
  }
}