import 'package:firebase_auth/firebase_auth.dart';

class AutenticationManager {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  register({
    required String email, 
    required String password}) 
    {
      _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
}