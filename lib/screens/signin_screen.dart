import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hub_style/screens/admin_screen.dart';

import 'package:hub_style/screens/reset_password.dart';
import 'package:hub_style/screens/shirt_product.dart';
import 'package:hub_style/screens/signup_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Define text editing controllers to store the values of the email and password inputs
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the width and height of the container to the device's width and height
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // Set the decoration of the container to a gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Set the direction of the gradient to start from the top and end at the bottom
            colors: [
              hexStringtoColor("535353"),
              hexStringtoColor("373737"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              // Set the top padding to 5% of the device's height
              MediaQuery.of(context).size.height * 0.05,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                // Add a logo to the screen using the logoWidget function defined below
                logoWidget("assets/images/StyleHubLogo.png"),
                const SizedBox(
                  height: 30,
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Add a reusable text field for the email input
                reusableTextField("Enter your Email", Icons.person_outline,
                    false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                // Add a reusable text field for the password input
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),

                firebaseButton(context, "Sign In", () async {
                  try {
                    final userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    final user = userCredential.user;
                    if (user != null) {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();

                      if (userDoc.exists) {
                        final userData = userDoc.data();
                        final isAdmin = userData?['isAdmin'] as bool? ?? false;

                        if (isAdmin) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminScreen()),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShirtProduct()),
                          );
                        }
                      }
                    }
                  } catch (error) {
                    // Handle sign-in errors
                  }
                }),

                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?",
            style: TextStyle(color: Color(0xFF9B9B9B))),
        // When the GestureDetector is tapped, navigate to the SignUpScreen.
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF9B9B9B),
          ),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RestPassword()));
        },
      ),
    );
  }
// Define a function to create an Image widget from an image file name
}
