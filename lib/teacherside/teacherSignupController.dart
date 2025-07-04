// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/login_scrren.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Teachersignupcontroller extends GetxController {
  Future<void> signup(
      {required String name,
      required String email,
      required String password}) async {
    if (email.isEmpty || password.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please Fill All The Fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.FLOATING,
          colorText: Colors.white);
      return;
    }
    try {
      EasyLoading.show();
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection("StudentsData").doc(uid).set({
        'Name': name,
        'Email': email,
        'role': "Teacher",
      });
      final box = GetStorage();
      box.write("role", "Teacher");
      EasyLoading.dismiss();
      Get.snackbar("Success", "Verification email sent to $email");
      FirebaseAuth.instance.signOut();
      Get.to(const LoginScreen());
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Signup Failed', e.message ?? 'Unknown error');
    }
  }
}
