import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';

class SignupScreen extends StatelessWidget {
  static const id = "SignupScreen";

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          MyTextField(
            mycontroller: nameController,
            hinttext: "Enter Your Name",
          ),
          MyTextField(
            mycontroller: emailController,
            hinttext: "Enter Your Email",
          )
        ],
      ),
    );
  }
}
