import 'package:flutter/material.dart';
import 'package:fyppaperless/authcontrollers/forgetpassword.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:get/get.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController forgetPassword = TextEditingController();
    final ForgetpasswordController controller =
        Get.put(ForgetpasswordController());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextField(
            mycontroller: forgetPassword,
            hinttext: "Enter Your Email",
          ),
          const SizedBox(
            height: 50,
          ),
          MyButton(
              bgColor: Colors.blue,
              foregrngColor: Colors.white,
              myText: "Forget Password",
              onTap: () {
                controller.forgetPassword(
                    email: forgetPassword.text.toString());
              })
        ],
      ),
    );
  }
}
