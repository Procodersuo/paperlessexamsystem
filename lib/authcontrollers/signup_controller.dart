// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyppaperless/login_scrren.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Future<void> signup(
      {required String name,
      required String email,
      required String roll,
      required String department,
      required String semester,
      required String section,
      required String password}) async {
    if (email.isEmpty ||
        password.isEmpty ||
        roll.isEmpty ||
        department.isEmpty ||
        semester.isEmpty ||
        section.isEmpty ||
        password.isEmpty) {
      
      Get.snackbar("Erro", "Please Fill All The Fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.FLOATING,
          colorText: Colors.white);
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();

      await FirebaseFirestore.instance.collection("StudentsData").doc().set({
        'Name': name,
        'Email': email,
        'department': department,
        'Section': section,
        'Roll Number': roll
      });

      Get.snackbar("Success", "Verification email sent to $email");
      FirebaseAuth.instance.signOut();
      Get.to(const LoginScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Signup Failed', e.message ?? 'Unknown error');
    } finally {}
  }
}
