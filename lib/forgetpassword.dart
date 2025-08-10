import 'package:flutter/material.dart';
import 'package:fyppaperless/authcontrollers/forgetpasswordcontroller.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Forgetpassword extends StatelessWidget {
  static const id = "/forgetPassword";
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController forgetPassword = TextEditingController();
    final ForgetpasswordController controller =
        Get.put(ForgetpasswordController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Forget Password",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assests/forgetpassword.json", height: 350),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                mycontroller: forgetPassword,
                hinttext: "Enter Your Email",
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                  bgColor: Colors.green,
                  foregrngColor: Colors.white,
                  myText: "Forget Password",
                  onTap: () {
                    controller.forgetPassword(
                        email: forgetPassword.text.toString());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
