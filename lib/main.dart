import 'package:flutter/material.dart';
import 'package:fyppaperless/home_screen.dart';
import 'package:fyppaperless/login_scrren.dart';
import 'package:fyppaperless/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        SignupScreen.id: (context) => const SignupScreen()
      },
    );
  }
}
