import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'layouthelper/button.dart';
import 'layouthelper/dropdown.dart';

class SignupScreen extends StatelessWidget {
  static const id = "SignupScreen";

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController rollNumber = TextEditingController();
    return Scaffold(
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
            mycontroller: rollNumber,
            hinttext: "Enter Your Roll Call",
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MySimpleDropdown(
                    items: ["BSSE", "BSIT", "BSCS", "BSDS"],
                    hintTxt: "Department",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Expanded(
                      child: MySimpleDropdown(
                    items: ["1", "2", "3", "4", "5", "6", "7", "8"],
                    hintTxt: "Semester",
                  )),
                ),
                Expanded(
                    child: MySimpleDropdown(
                  items: ["M", "E-A", "E-B", "E-C"],
                  hintTxt: "Section",
                )),
              ],
            ),
          ),
          const MyButton(
              bgColor: Colors.blue,
              foregrngColor: Colors.white,
              myText: "Register")
        ],
      ),
    );
  }
}
