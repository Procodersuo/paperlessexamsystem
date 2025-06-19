import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? bgColor;
  final Color? foregrngColor;
  final String myText;
  const MyButton(
      {super.key,
      required this.bgColor,
      required this.foregrngColor,
      required this.myText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Your button action here
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
