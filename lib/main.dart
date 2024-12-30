import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For orientation control
import 'package:firebase_core/firebase_core.dart'; // For Firebase
import 'package:smartgrocery/admindashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartgrocery/HomePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/WelcomeScreen.dart';
import 'Signup.dart';
import 'Login.dart';
import 'WelcomeScreen.dart';
import 'CategoryScreen.dart';
import 'ProductsScreen.dart';
import 'ProductDetailsScreen.dart';
import 'addProduct.dart';
import 'package:smartgrocery/admindashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();// Ensures proper widget binding for async operations
   await Firebase.initializeApp(); // Initialize Firebase
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,DeviceOrientation.landscapeRight,  DeviceOrientation.landscapeLeft, // Locking to portrait mode
  ]).then((fn) {
    runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
  });
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
      
      initialRoute: '/welcome', // Define the initial screen
      routes: {
        '/signup': (context) => const SignUpScreen(),
        // '/login': (context) => const LoginScreen(),
        '/login2': (context) => const LoginScreen2(),
        '/welcome': (context) => const WelcomeScreen(),
        '/HomePage': (context) => const HomePage(),
        '/categories': (context) => const CategoryScreen(),
        '/products': (context) => const ProductsScreen(),
        '/productDetails': (context) => const ProductDetailsScreen(productId: 'wCHMHvZQ2GhBdP7c5oaw'),
        '/addProduct': (context) => const AddProductScreen(),
        '/admindashboard': (context) => AdminDashboard(),
      },
    );
  }
}
