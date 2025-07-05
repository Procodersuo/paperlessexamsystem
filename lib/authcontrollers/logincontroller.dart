import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

      /// 🔥 Always fetch role from Firestore (not just for new users)
      final userDoc = await FirebaseFirestore.instance
          .collection("StudentsData")
          .doc(user.uid)
          .get();

      final data = await FirebaseFirestore.instance
          .collection("StudentsData")
          .doc(user.uid)
          .get();
      final box = GetStorage();
      box.write("student_department", data["department"]);
      box.write("student_semester", data["semester"]);
      box.write("student_section", data["Section"]);
      box.write("student_name", data["Name"]);
      box.write("student_rollnumber", data["Roll Number"]);

      if (!userDoc.exists || userDoc.data()?['role'] == null) {
        EasyLoading.dismiss();
        Get.snackbar("Error", "User role not found. Contact admin.");
        return;
      }

      final role = userDoc['role'];
      box.write("role", role);

      EasyLoading.dismiss();

      if (role == "teacher") {
        Get.offNamed('/TeacherHomeScreen');
      } else if (role == "stu") {
        final controller = Get.put(AttemptController()); // initialize here
        controller
            .setupPaperStream(); // 🔥 call it manually AFTER writing to GetStorage
        Get.offNamed('/StudentHomeScreen');
      } else {
        Get.snackbar("Error", "Unknown role assigned.");
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.message ?? " Please try again");
    }
  }
}
