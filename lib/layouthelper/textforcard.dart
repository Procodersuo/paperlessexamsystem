import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextWidget extends StatelessWidget {
  final String myText;
  const MyTextWidget({super.key, required this.myText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        myText,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
