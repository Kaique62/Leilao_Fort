import 'package:flutter/material.dart';

import 'package:leilao_fort_top/autetication/autentication_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutenticationManager _autenticationManager = AutenticationManager();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _emailController,

              ),
              TextField(
                controller: _passwordController,
              ),
              ElevatedButton(onPressed: () {
                _autenticationManager.register(email: _emailController.text, password: _passwordController.text);
              }, child: Text('Salvar'))
            ],
          ),
        )
      ),
    );
  }
}