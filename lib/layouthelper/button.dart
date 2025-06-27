import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? bgColor;
  final Color? foregrngColor;
  final String myText;
  final VoidCallback? onTap;
  const MyButton(
      {super.key,
      required this.bgColor,
      required this.foregrngColor,
      required this.myText,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        onTap!();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor, // Background color
        foregroundColor: foregrngColor, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(myText),
    );
  }
}
