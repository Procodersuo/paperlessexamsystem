import 'package:flutter/material.dart';
import 'package:fyppaperless/authcontrollers/passwordcontroller.dart';
import 'package:get/get.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? mycontroller;
  final String? hinttext;
  final Icon? sfxIcon;
  final bool isPassword;
  final int lines;

  const MyTextField(
      {super.key,
      required this.mycontroller,
      this.hinttext,
      this.sfxIcon,
      this.isPassword = false,
      this.lines = 1});

  @override
  Widget build(BuildContext context) {
    final Passwordcontroller controller = Get.put(Passwordcontroller());

    return Padding(
      padding: const EdgeInsets.all(10),
      child: isPassword
          ? Obx(() => TextFormField(
                controller: mycontroller,
                obscureText: controller.isObsecure.value,
                decoration: InputDecoration(
                  hintText: hinttext,
                  contentPadding: const EdgeInsets.all(8),
                  suffixIcon: IconButton(
                    onPressed: controller.showHide,
                    icon: Icon(
                      controller.isObsecure.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ))
          : TextFormField(
              maxLines: lines,
              controller: mycontroller,
              obscureText: false,
              decoration: InputDecoration(
                hintText: hinttext,
                contentPadding: const EdgeInsets.all(8),
                suffixIcon: sfxIcon,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
    );
  }
}
