// welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:smartgrocery/Login1.dart';
import 'package:smartgrocery/Login2.dart';
import 'package:smartgrocery/Signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
         Image.asset(
          'assets/nn.jpg',  
          fit: BoxFit.fill

               ),

          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               const SizedBox(height: 40),
              
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
                ),),
                
                const SizedBox(height: 450),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>const LoginScreen2()),);
                  },
                  child: const Text('Continue with Email or Phone' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15 , color: Colors.black)),
                ),
                const SizedBox(height: 11),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.10),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(25), // Rounded corners
                   side: BorderSide(
                     color: Colors.white, // Border color
                           width: 1.5,)), // Border width

                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>const SignUpScreen()),);
                  },
                  child: const Text('Create an account' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15 , color: Colors.black)),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
