import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:leilao_fort_top/main.dart';

class FirebaseStuff {
  FirebaseDatabase firebaseDB = FirebaseDatabase.instance;
  var userData = FirebaseDatabase.instance.ref();
  FirebaseAuth auth = FirebaseAuth.instance;

  // Para observar o estado de autenticação e retornar o valor de isLogged
  bool checkAuthState() {
    bool isLogged = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLogged = false;
      } else {
        isLogged = true;
      }
    });
    return isLogged;
  }

Future<String> login(String email, String senha, BuildContext context) async {
  String errorMessage = "";
  try {
    // Tentando fazer login com email e senha
    await auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    
    // Verificando se o login foi bem-sucedido
    if (auth.currentUser != null) {
      // Usuário logado, redireciona para a HomePage
      errorMessage = "logado";
      print("Login bem-sucedido: ${auth.currentUser!.email}"); // Print para verificar o usuário
    } else {
      errorMessage = "Usuário não logado";
      print("Usuário não logado");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      errorMessage = 'A senha fornecida é muito fraca.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'A conta já existe para esse e-mail.';
    } else {
      errorMessage = e.message ?? 'Erro desconhecido';
    }
    print("Erro de autenticação: $errorMessage"); // Print para verificar o erro
  } catch (e) {
    errorMessage = 'Erro inesperado: ${e.toString()}';
    print("Erro inesperado: $errorMessage");
  }
  print("Mensagem de erro: $errorMessage"); // Print da mensagem de erro
  return errorMessage;
}



  Future<String> register(String user, String email, String senha, BuildContext context) async {
    String errorMessage = "";
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: senha);
      // Após criar o usuário, atualizar o nome de exibição e realizar login
      await auth.currentUser?.updateDisplayName(user);
      // Logando automaticamente após o registro
      errorMessage = await login(email, senha, context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      }
    }
    return errorMessage;
  }

  Future<void> retrieveData(String path) async {
    // Exemplo de como recuperar dados de um caminho específico no Firebase Realtime Database
    final snapshot = await userData.child(path).get();
    if (snapshot.exists) {
      print("Data retrieved: ${snapshot.value}");
    } else {
      print("No data available at this path.");
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  // FirebaseDataBase
  DatabaseReference returnData(String path) {
    return userData.child(path);
  }
}
