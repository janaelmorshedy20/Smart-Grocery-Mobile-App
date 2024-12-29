import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartgrocery/signup.dart';
import 'package:smartgrocery/welcomescreen.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  State<LoginScreen2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends State<LoginScreen2> {
  bool _obscurePassword = true;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
 
  Future login() async {
    try {
      // Attempt to sign in with the provided email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to home screen or dashboard after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // Replace with your actual home/dashboard screen
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors (e.g., invalid email or password)
      String errorMessage = '';

      // In case of other errors, handle them here
      if (e.code != 'user-not-found' && e.code != 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong email or password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<void> signInWithGoogle() async {
//           GoogleSignInAccount? googleSignInAccount= await _googleSignIn.signIn();
//           if(googleSignInAccount!=null){
//             print('succeffly :{googleSignInAccount.email}');

//           }
//           else{
//             print('no');
//           }

// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formstate, // The Form should have the GlobalKey<FormState>
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
                TextFormField(
                  controller: _emailController,
                  // keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Uncomment and implement the forget password button if needed
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: const Text('Forget Password?'),
                //   ),
                // ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                  
                    // login btn
                    if (formstate.currentState!.validate()) {
                      print("Valid");
                      login();
                    } else {
                      print("Not valid");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        //  signInWithGoogle();
                      },
                      icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                      label: const Text('Google'),
                    ),
                    const SizedBox(width: 10),
                    // OutlinedButton.icon(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.apple, color: Colors.black),
                    //   label: const Text('Apple'),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't Have Account? ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
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
      ),
    );
  }
}
