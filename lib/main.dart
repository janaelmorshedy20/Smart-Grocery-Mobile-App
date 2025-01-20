import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For orientation control
import 'package:firebase_core/firebase_core.dart'; // For Firebase
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgrocery/userprofile.dart';
import 'HomePage.dart';
import 'ocr.dart';
import 'addproducts.dart';
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
          ? (isAdmin ? '/admindashboard' : '/userprofile') // Admin gets admin dashboard
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
