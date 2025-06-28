import 'package:get/get.dart';

class Passwordcontroller extends GetxController {
  RxBool isObsecure = true.obs;

  void showHide() {
    isObsecure.toggle();
  }
}
