import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgetpasswordController extends GetxController {
  Future<void> forgetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.toString());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? " Please Try again");
    }
  }
}
