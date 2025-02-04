//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

import 'firebase_stuff.dart';

void main() async{
  //Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  var firebaseStuff = FirebaseStuff();

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
    
    );
  }
}