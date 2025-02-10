import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leilao_fort_top/firebase_stuff.dart';
import 'package:leilao_fort_top/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef parentFunctionCallback = void Function();

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final parentFunctionCallback function;

  LoginScreen({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.network(
                'https://logos-download.com/wp-content/uploads/2021/01/Fortnite_Logo.png',
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (await MyAppState.firebaseStuff.login(
                          _emailController.text, _passwordController.text, context) ==
                      "logado") {
                    function();
                  } else {
                    _showErrorDialog(context, "Credenciais inválidas!");
                  }
                },
                child: Text("Login"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => RegisterScreen(func: function),
                    ),
                  );
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final parentFunctionCallback func;
  const RegisterScreen({super.key, required this.func});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome de Usuario',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.blue,
                            size: 50,
                          ),
                        );
                      },
                    );
                  if (await MyAppState.firebaseStuff.register(
                          _userController.text, _emailController.text, _passwordController.text, context) ==
                      "logado") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        widget.func();
                  } else {
                    Navigator.pop(context);
                    _showErrorDialog(context, "Erro no cadastro!");
                  }
                },
                child: Text("Cadastrar"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Já tem uma conta? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
