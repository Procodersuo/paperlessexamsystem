import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetpasswordController extends GetxController {
  Future<void> forgetPassword({required String email}) async {
    try {
      EasyLoading.show(status: "LOADING");
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.toString());
      Get.snackbar("Error", "Please Check Your Email");
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.message ?? " Please Try again");
    }
  }
}
