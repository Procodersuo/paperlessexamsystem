import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Logincontroller extends GetxController {
  Future<void> login({required String email, required String password}) async {
    try {
      EasyLoading.show();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      EasyLoading.dismiss();
      if (user!.emailVerified) {
        Get.offNamed('/PaperUploadScreen');
      } else {
        EasyLoading.dismiss();
        FirebaseAuth.instance.signOut();
        Get.snackbar("Erorr", "Pleae Verify Your Email");
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.message ?? " Please Try again");
    }
  }
}
