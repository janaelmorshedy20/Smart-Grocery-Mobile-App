import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:smartgrocery/login1.dart';
import 'package:smartgrocery/welcomescreen.dart';
import 'signup.dart';
import 'login2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:smartgrocery/Login1.dart';
import 'package:smartgrocery/WelcomeScreen.dart';
import 'Signup.dart';
import 'Login2.dart';

import 'CategoryScreen.dart';
import 'ProductsScreen.dart';
import 'ProductDetailsScreen.dart';
import 'addProduct.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
>>>>>>> 1e02d6309f1d0ccdeb14340235a36d57dace7ed6
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
<<<<<<< HEAD
        // '/login': (context) => const LoginScreen(),
        '/login2': (context) => const LoginScreen2(), 
        '/welcome': (context) => const WelcomeScreen(),
=======
        '/login': (context) => const LoginScreen(),
        '/login2': (context) => const  LoginScreen2(),
        '/welcome': (context) => const  WelcomeScreen(),
        '/categories': (context) => const  CategoryScreen(),
        '/products': (context) => const  ProductsScreen(),
        '/productDetails': (context) => const ProductDetailsScreen(productId: 'wCHMHvZQ2GhBdP7c5oaw'),
        '/addProduct': (context) => const  AddProductScreen(),
        
       
        
>>>>>>> 1e02d6309f1d0ccdeb14340235a36d57dace7ed6
      },
    );
  }
}
