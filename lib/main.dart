import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgrocery/Login1.dart';
import 'package:smartgrocery/WelcomeScreen.dart';
import 'Signup.dart';
import 'Login2.dart';

import 'CategoryScreen.dart';
import 'ProductsScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/categories': (context) => const  CategoryScreen(),
        '/products': (context) => const  ProductsScreen(),
        // '/welcome': (context) => const  WelcomeScreen(),
        // '/welcome': (context) => const  WelcomeScreen(),
        // '/welcome': (context) => const  WelcomeScreen(),
        // '/welcome': (context) => const  WelcomeScreen(),

        
       
        
      },
    );
  }
}
