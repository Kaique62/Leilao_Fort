import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_database/firebase_database.dart';

class FirebaseStuff {
  bool isLogged = false;

  FirebaseDatabase firebaseDB = FirebaseDatabase.instance;
  var userData = FirebaseDatabase.instance.ref();

  bool checkAuthState() {
    FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user == null) {
        isLogged = false;
      } else {
        isLogged = true;
      }
    });
    return isLogged;
  }

  Future<String> login(email, senha) async {
    String errorMessage = "";
      try {
         await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: senha,
        );
        userData = firebaseDB.ref("users/email");
        errorMessage = "logado";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        }
      } catch (e) {
        errorMessage = e.toString();
      }
      checkAuthState();
      return errorMessage;
  }

  Future<String> register(email, senha) async {
    String errorMessage = "";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
    }
    return errorMessage;
  }

  void singOut() async{
    await FirebaseAuth.instance.signOut();
  } 

  //FirebaseDataBase
  returnData () {
    return userData;
  }

}