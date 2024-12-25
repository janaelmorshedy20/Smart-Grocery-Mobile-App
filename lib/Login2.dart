import 'package:flutter/material.dart';
import 'package:smartgrocery/Signup.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  State<LoginScreen2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends State<LoginScreen2> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to our',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'E-Grocery',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text('Forget Password?',
              //         style: TextStyle(color: Colors.green)),
              //   ),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: const Text('Login', style: TextStyle(color:Colors.black))
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                    label: const Text('Google'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.apple, color: Colors.black),
                    label: const Text('Apple'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have Account? ", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15)),
                  GestureDetector(
                    onTap: () {
                     Navigator.push(context,MaterialPageRoute(builder:(context)=>const SignUpScreen()),
                  );
                  }, // Navigate to Sign Up Screen
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
