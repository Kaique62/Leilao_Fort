import 'package:flutter/material.dart';

void main() {
  runApp(LoginAndRegister());
}

class LoginAndRegister extends StatefulWidget{
  LoginAndRegister({super.key});

  @override
  State<LoginAndRegister> createState() => LoginAndRegisterState();
}

class LoginAndRegisterState extends State<LoginAndRegister> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoginScreen()
        )
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email'
            )),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email'
            )),
          ElevatedButton(
            onPressed: () {

              }, 
            child: Text("Login")),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                    body: Center(child: RegisterScreen(),)
                      

                    );
                  }
));
          },
            child: Text('Cadastrar'),)
    ]),
      width: 300,
    );
  }
}

class RegisterScreen extends StatelessWidget {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: 
        SizedBox( 
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email'
              )),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email'
              )),
            ElevatedButton(
              onPressed: () {

                }, 
              child: Text("Cadastrar")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
            },
              child: Text('Login'),)
      ]),
        width: 300,
            )
          )
        )
      );
    } 
}