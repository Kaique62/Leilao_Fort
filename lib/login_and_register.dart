import 'package:flutter/material.dart';
import 'package:leilao_fort_top/firebase_stuff.dart';
import 'package:leilao_fort_top/main.dart';

typedef parentFunctionCallback = void Function();

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
                child: RegisterScreen(),
              ));
            }));
          },
          child: Text('Cadastrar'),
        )
      ]),
    ));
  }
}

class RegisterScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userController = TextEditingController();

  RegisterScreen({super.key});

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
                  await MyAppState.firebaseStuff.register(_emailController.text, _passwordController.text);
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
