import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For orientation control
import 'package:firebase_core/firebase_core.dart'; // For Firebase
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/userprofile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomePage.dart';
import 'ocr.dart';
import 'addProduct.dart';
// import 'addproducts.dart';
import 'signup.dart';
import 'Login.dart';
import 'welcomeScreen.dart';
import 'categoryScreen.dart';
import 'productsScreen.dart';
import 'productDetailsScreen.dart';
import 'products.dart';
import 'admindashboard.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper widget binding for async operations
  await Firebase.initializeApp(); // Initialize Firebase

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://gralztxksbzwiprnipoj.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyYWx6dHhrc2J6d2lwcm5pcG9qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczMzkxMjcsImV4cCI6MjA1MjkxNTEyN30.UTTiCnNEtezAz2iZ5lkaufbETnzcB1quVShfMf-29fM");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isAdmin = prefs.getBool('isAdmin') ?? false; // Get isAdmin flag

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((fn) {
    runApp(
      ProviderScope(
        child: MyApp(isLoggedIn: isLoggedIn, isAdmin: isAdmin),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const MyApp({Key? key, required this.isLoggedIn, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: isLoggedIn
          ? (isAdmin ? '/admindashboard' : '/categories') // Admin gets admin dashboard
          : '/login2', // Use '/HomePage' if user is logged in
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login2': (context) => const LoginScreen2(),
        '/welcome': (context) => const WelcomeScreen(),
        '/HomePage': (context) => const HomePage(),
        '/categories': (context) => const CategoryScreen(),
        '/products': (context) => const ProductsScreen(categoryId: '',),
        '/productDetails': (context) => const ProductDetailsScreen(productId: 'wCHMHvZQ2GhBdP7c5oaw'),
        '/addProduct': (context) => const AddProductScreen(),
        '/admindashboard': (context) => AdminDashboard(),
        '/adminProducts': (context) => const ProductsPage(),
        '/ocr': (context) => ShoppingListScreen(),
        '/userprofile': (context) => const UserProfileScreen(),
      },
    );
  }
}
