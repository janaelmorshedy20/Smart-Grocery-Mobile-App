// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:smartgrocery/login1.dart';
import 'package:smartgrocery/welcomescreen.dart';
import 'signup.dart';
import 'login2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
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
        // '/login': (context) => const LoginScreen(),
        '/login2': (context) => const LoginScreen2(), 
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}
