import 'package:flutter/material.dart';
import 'package:fyppaperless/authcontrollers/signup_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'layouthelper/textfieldwidget.dart';
import 'layouthelper/dropdown.dart';
import 'layouthelper/button.dart';

class SignupScreen extends StatelessWidget {
  static const id = "/SignupScreen";
  SignupScreen({
    super.key,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString department = ''.obs;
  final RxString semester = ''.obs;
  final RxString section = ''.obs;

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextField(
            mycontroller: nameController,
            hinttext: "Enter Your Name",
          ),
          MyTextField(
            mycontroller: emailController,
            hinttext: "Enter Your Email",
          ),
          MyTextField(
            mycontroller: rollNumberController,
            hinttext: "Enter Your Roll Call",
          ),
          MyTextField(
            mycontroller: passwordController,
            hinttext: "Password",
            isPassword: true,
          ),
          Row(
            children: [
              Expanded(
                child: Obx(() => MySimpleDropdown(
                      items: const ["BSSE", "BSIT", "BSCS", "BSDS"],
                      hintTxt: "Department",
                      selectedValue: department.value,
                      onChanged: (val) => department.value = val,
                    )),
              ),
              Expanded(
                child: Obx(() => MySimpleDropdown(
                      items: const ["1", "2", "3", "4", "5", "6", "7", "8"],
                      hintTxt: "Semester",
                      selectedValue: semester.value,
                      onChanged: (val) => semester.value = val,
                    )),
              ),
              Expanded(
                child: Obx(() => MySimpleDropdown(
                      items: const ["M", "E-A", "E-B", "E-C"],
                      hintTxt: "Section",
                      selectedValue: section.value,
                      onChanged: (val) => section.value = val,
                    )),
              )
            ],
          ),
          const SizedBox(height: 20),
          MyButton(
            myText: "Register",
            bgColor: Colors.blue,
            foregrngColor: Colors.white,
            onTap: () {
              controller.signup(
                name: nameController.text.trim(),
                email: emailController.text.trim(),
                roll: rollNumberController.text.trim(),
                department: department.value,
                semester: semester.value,
                section: section.value,
                password: passwordController.text.trim(),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Already Have an Account",
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
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
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
