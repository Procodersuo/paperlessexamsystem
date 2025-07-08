import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/teacherside/teacherSignupController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class teachersignupscreen extends StatelessWidget {
  static const id = "/TeacherSignupScreen";
  teachersignupscreen({
    super.key,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController securityKeyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Teachersignupcontroller controller = Get.put(Teachersignupcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assests/teacher.json"),
              MyTextField(
                mycontroller: securityKeyController,
                hinttext: "Enter Your Secret Code",
              ),
              MyTextField(
                mycontroller: nameController,
                hinttext: "Enter Your Name",
              ),
              MyTextField(
                mycontroller: emailController,
                hinttext: "Enter Your Email",
              ),
              MyTextField(
                mycontroller: passwordController,
                hinttext: "Password",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              MyButton(
                myText: "Register",
                bgColor: Colors.blue,
                foregrngColor: Colors.white,
                onTap: () {
                  if (securityKeyController.text.toString() == "THX09#21") {
                    controller.signup(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  } else {
                    Get.snackbar("Eroor", "Plese Contact Hod for Correct key");
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Already Have an Account",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offNamed('/LoginScreen');
                },
                child: Text(
                  "Login ",
                  style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
