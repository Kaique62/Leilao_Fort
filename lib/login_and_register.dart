import 'package:flutter/material.dart';
import 'package:leilao_fort_top/firebase_stuff.dart';
import 'package:leilao_fort_top/main.dart';

typedef parentFunctionCallback = void Function();

// ignore: must_be_immutable
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
        Text('Login', style: TextStyle(
                  fontSize: 50)),
        Padding(padding: EdgeInsets.all(10.0), 
                child:
        TextField(
            controller: _emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Email'))),
        Padding(padding: EdgeInsets.all(10.0), 
                child:
        TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Senha'))),
        Padding(padding: EdgeInsets.all(10.0), 
                child:
        ElevatedButton(onPressed: () async {
          if (await MyAppState.firebaseStuff.login(_emailController.text, _passwordController.text) == "logado"){
              function();
          }
        }, child: Text("Login"))),

        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                  body: Center(
                child: RegisterScreen(function: function),
              ));
            }));
          },
          child: Text('Cadastrar'),
        )
      ]),
    ));
  }
}

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userController = TextEditingController();


  RegisterScreen({super.key, required this.function});

    final parentFunctionCallback function; 
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
                Text('CADASTRAR', style: TextStyle(
                  fontSize: 50
                ),),

                Padding(padding: EdgeInsets.all(10.0), 
                child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome de Usuario')),
                        ),
                Padding(padding: EdgeInsets.all(10.0),
                child:
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email'))),
                Padding(padding: EdgeInsets.all(10.0), 
                child:
                TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Senha'))),
                Padding(padding: EdgeInsets.all(10.0), 
                child:
                ElevatedButton(onPressed: () async{
                   if (await MyAppState.firebaseStuff.register(_emailController.text, _passwordController.text) == ""){
                      Navigator.pop(context);
                    }
                }, child: Text("Cadastrar"))),
                Padding(padding: EdgeInsets.all(10.0), 
                child:
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Login'),
                ),
                ),
              ]),
            ))));
  }
}
