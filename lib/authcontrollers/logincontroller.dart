import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Logincontroller extends GetxController {
  Future<void> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? " Please Try again");
    }
  }
}
