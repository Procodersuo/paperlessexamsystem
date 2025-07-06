import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../paperattemptingcontroller.dart';

class Logincontroller extends GetxController {
  Future<void> login({required String email, required String password}) async {
    try {
      EasyLoading.show();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user == null) throw FirebaseAuthException(code: 'user-not-found');

      if (!user.emailVerified) {
        EasyLoading.dismiss();
        FirebaseAuth.instance.signOut();
        Get.snackbar("Error", "Please verify your email");
        return;
      }

      /// 🔥 Always fetch role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("StudentsData")
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data()?['role'] == null) {
        EasyLoading.dismiss();
        Get.snackbar("Error", "User role not found. Contact admin.");
        return;
      }

      final role = userDoc['role'];
      final box = GetStorage();
      box.write("role", role);

      /// ✅ If user is a student, fetch and store student-related fields
      if (role == "stu") {
        final data = userDoc.data()!;
        box.write("student_department", data["department"]);
        box.write("student_semester", data["semester"]);
        box.write("student_section", data["Section"]);
        box.write("student_name", data["Name"]);
        box.write("student_rollnumber", data["Roll Number"]);

        final controller = Get.put(AttemptController());
        controller.setupPaperStream(); // manually call after writing GetStorage

        EasyLoading.dismiss();
        Get.offNamed('/StudentHomeScreen');
      }

      /// ✅ If user is a teacher, just redirect
      else if (role == "teacher") {
        EasyLoading.dismiss();
        Get.offNamed('/TeacherHomeScreen');
      }

      /// ❌ Unknown role
      else {
        EasyLoading.dismiss();
        Get.snackbar("Error", "Unknown role assigned.");
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.message ?? " Please try again");
    }
  }
}
