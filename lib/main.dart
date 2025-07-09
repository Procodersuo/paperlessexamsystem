import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/attemptingscreen.dart';
import 'package:fyppaperless/editprofile.dart';
import 'package:fyppaperless/firebase_options.dart';
import 'package:fyppaperless/forgetpassword.dart';
import 'package:fyppaperless/home_screen.dart';
import 'package:fyppaperless/login_scrren.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:fyppaperless/resultscree.dart';
import 'package:fyppaperless/signup_screen.dart';
import 'package:fyppaperless/teacherside/paperEdittingScreen.dart';
import 'package:fyppaperless/teacherside/stusubmissionlist.dart';
import 'package:fyppaperless/teacherside/teacherhomescreen.dart';
import 'package:fyppaperless/teacherside/teachersignupscreen.dart';
import 'package:fyppaperless/teacherside/myuploadedpaper.dart';
import 'package:fyppaperless/teacherside/uploadpaper.dart';
import 'package:fyppaperless/teacherside/vieweachstupaper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final role = box.read("role");
    String initialRoute;
    if (user != null && user.emailVerified) {
      if (role == "Teacher") {
        initialRoute = '/TeacherHomeScreen';
      } else if (role == "stu") {
        final controller = Get.put(AttemptController(), permanent: true);
        controller.setupPaperStream();
        initialRoute = '/StudentHomeScreen';
      } else {
        initialRoute = '/LoginScreen'; // fallback
      }
    } else {
      initialRoute = '/LoginScreen';
    }
    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: SignupScreen.id, page: () => SignupScreen()),
        GetPage(name: LoginScreen.id, page: () => const LoginScreen()),
        GetPage(name: StudnetHomeScreen().id, page: () => StudnetHomeScreen()),
        GetPage(
          name: PaperUploadScreen.id,
          page: () => PaperUploadScreen(),
        ),
        GetPage(name: AttemptScreen.id, page: () => AttemptScreen()),
        GetPage(
            name: teachersignupscreen.id, page: () => teachersignupscreen()),
        GetPage(
            name: TeacherHomeScreen.id, page: () => const TeacherHomeScreen()),
        GetPage(
            name: UploadedPaperViewScreen.id,
            page: () => UploadedPaperViewScreen()),
        GetPage(
            name: PaperEdittingScreen.id, page: () => PaperEdittingScreen()),
        GetPage(
            name: StudentSubmissionListScreen.id,
            page: () => const StudentSubmissionListScreen()),
        GetPage(
            name: ViewStudentSubmissionScreen.id,
            page: () => const ViewStudentSubmissionScreen()),
        GetPage(name: Forgetpassword.id, page: () => const Forgetpassword()),
        GetPage(name: editProfile.id, page: () => const editProfile()),
        GetPage(name: Resultscreen.id, page: () => const Resultscreen()),
      ],
    );
  }
}
