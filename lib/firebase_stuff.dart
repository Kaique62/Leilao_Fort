import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseStuff {
  bool isLogged = false;

  FirebaseDatabase firebaseDB = FirebaseDatabase.instance;
  var userData = FirebaseDatabase.instance.ref();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLogged = false;
        print(user!.displayName);
      } else {
        isLogged = true;
      }
    });
    return isLogged;
  }

  Future<String> login(email, senha) async {
    String errorMessage = "";
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      userData = firebaseDB.ref("users/");
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
    print(errorMessage);
    return errorMessage;
  }

  Future<String> register(user ,email, senha) async {
    String errorMessage = "";
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: senha);
          login(email, senha);
          auth.currentUser?.updateDisplayName(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
    }
    return errorMessage;
  }

  Future<void> retrieveData(String path) async {
    //   final snapshot = await userData.child(path).get();
    // print(snapshot);
  }

  void singOut() async {
    await auth.signOut();
  }

  //FirebaseDataBase
  Object returnData(String email) {
    return userData.child(email);
  }
}
