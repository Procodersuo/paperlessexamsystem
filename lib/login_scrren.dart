import 'package:flutter/material.dart';
import 'package:fyppaperless/authcontrollers/logincontroller.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  static const id = "/LoginScreen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    Logincontroller controller = Get.put(Logincontroller());
    // List
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextField(
            mycontroller: nameController,
            hinttext: "Enter Your Email",
          ),
          MyTextField(
            mycontroller: emailController,
            hinttext: "Enter Your Password",
            isPassword: true,
          ),
          const SizedBox(
            height: 50,
          ),
          MyButton(
            bgColor: Colors.blue,
            foregrngColor: Colors.white,
            myText: "LOGIN",
            onTap: () {
              controller.login(
                  email: nameController.toString(),
                  password: emailController.toString());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "Login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
