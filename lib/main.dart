import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/firebase_options.dart';
import 'package:fyppaperless/home_screen.dart';
import 'package:fyppaperless/login_scrren.dart';
import 'package:fyppaperless/signup_screen.dart';
import 'package:fyppaperless/teacherside/uploadpaper.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: SignupScreen.id,
      getPages: [
        GetPage(name: SignupScreen.id, page: () => SignupScreen()),
        GetPage(name: LoginScreen.id, page: () => const LoginScreen()),
        GetPage(name: HomeScreen.id, page: () => const HomeScreen()),
        GetPage(
          name: PaperUploadScreen.id,
          page: () => PaperUploadScreen(),
        ),
      ],
    );
  }
}
