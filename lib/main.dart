// main.dart
import 'package:flutter/material.dart';
import 'package:smartgrocery/Login1.dart';
import 'package:smartgrocery/WelcomeScreen.dart';
import 'Signup.dart';
import 'Login2.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/welcome',
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/login2': (context) => const  LoginScreen2(),
        '/welcome': (context) => const  WelcomeScreen(),

        
       
        
      },
    );
  }
}
