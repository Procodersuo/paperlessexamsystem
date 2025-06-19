import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';

class LoginScreen extends StatelessWidget {
  static const id = "LoginScreen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
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
