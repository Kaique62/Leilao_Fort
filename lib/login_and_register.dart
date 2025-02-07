import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leilao_fort_top/firebase_stuff.dart';
import 'package:leilao_fort_top/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef parentFunctionCallback = void Function();

Timer? timer;

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key, required this.function});

   final parentFunctionCallback function; 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
      width: 300,
      child: Column(children: [
        TextField(
            controller: _emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Email')),
        TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Senha')),
        ElevatedButton(onPressed: () async {
          if (await MyAppState.firebaseStuff.login(_emailController.text, _passwordController.text) == "logado"){
              function();
          }
        }, child: Text("Login")),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                  body: Center(
                child: reg(),
              ));
            }));
          },
          child: Text('Cadastrar'),
        )
      ]),
    ));
  }
}
class reg extends StatefulWidget {
  @override
  State<reg> createState() => RegisterScreen();
}

class RegisterScreen extends State<reg> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userController = TextEditingController();

  void checkMain(){
    if(MyAppState.isLogged){
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: SizedBox(
              width: 300,
              child: Column(children: [
                TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome de Usuario')),
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email')),
                TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Senha')),
                ElevatedButton(onPressed: () async{
                  if(await MyAppState.firebaseStuff.register(_userController.text, _emailController.text, _passwordController.text) == ""){
                    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                      return AlertDialog(
                        title: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 50),
                      );
                    });
                  timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkMain());
                  }
                }, child: Text("Cadastrar")),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Login'),
                )
              ]),
            ))));
  }
}
