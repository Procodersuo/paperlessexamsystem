import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? mycontroller;
  final String? hinttext;
  final Icon? sfxIcon;
  const MyTextField(
      {super.key, required this.mycontroller, this.hinttext, this.sfxIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: mycontroller,
        decoration: InputDecoration(
            suffixIcon: sfxIcon,
            hintText: hinttext,
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
