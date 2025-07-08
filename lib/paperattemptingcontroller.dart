import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AttemptController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<Map<String, dynamic>> paper = Rxn<Map<String, dynamic>>();
  final List<TextEditingController> answerControllers = [];
  late Stream<QuerySnapshot> paperStream;

  void setupPaperStream() {
    final box = GetStorage();
    final String department = box.read("student_department") ?? "";
    final String semester = box.read("student_semester") ?? "";
    final String section = box.read("student_section") ?? "";
    paperStream = FirebaseFirestore.instance
        .collection("papers")
        .where("department", isEqualTo: department)
        .where("semester", isEqualTo: semester)
        .where("section", isEqualTo: section)
        .where("endTime", isGreaterThan: Timestamp.now())
        .snapshots();

  }

  Future<DateTime> getServerTime() async {
    final docRef = FirebaseFirestore.instance.collection('serverTime').doc('now');
    await docRef.set({'timestamp': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    final snapshot = await docRef.get();
    final timestamp = snapshot.data()?['timestamp'] as Timestamp;
    return timestamp.toDate();
  }
  Future<void> requestMic() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }
  final SpeechToText speech = SpeechToText();
  RxBool isListening = false.obs;

  Future<void> toggleListening(TextEditingController controller) async {
    requestMic();
    if (isListening.value) {
      await speech.stop();
      isListening.value = false;
    } else {
      bool available = await speech.initialize();
      if (available) {
        isListening.value = true;
        String existingText = controller.text;

        await speech.listen(
          onResult: (result) {
            controller.text = "$existingText ${result.recognizedWords}".trim();
          },
        );
      }
    }
  }
  String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("⚠️ No user is currently logged in.");
      return '';
    }
    return user.uid;
  }
  void updateControllersFromPaper(Map<String, dynamic> paperData) {
    final List questions = paperData["questions"];
    answerControllers.clear();
    for (int i = 0; i < questions.length; i++) {
      answerControllers.add(TextEditingController());
    }
  }
  /// Use this to update controllers when the paper arrives



  final Rx<Duration> timeLeft = Duration.zero.obs;
  Timer? countdownTimer;

  void startCountdown(DateTime endTime) async {
    final currentTime = await getServerTime();
    Duration remaining = endTime.difference(currentTime);

    if (remaining.isNegative) {
      timeLeft.value = Duration.zero;
      return;
    }

    timeLeft.value = remaining;

    countdownTimer?.cancel(); // clear any existing timer
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value.inSeconds <= 1) {
        timer.cancel();
        timeLeft.value = Duration.zero;
      } else {
        timeLeft.value -= const Duration(seconds: 1);
      }
    });
  }
//
// void submitPaper(
//     String name,String rollcall,String title,
//     String department , String semester , String section,String teacherId,String paperId, String studentId, List<Map<String,dynamic>> combinedQuestionsAnswers)
// async {
//   try
//       {
//         await FirebaseFirestore.instance
//             .collection("submissions")
//             .doc(paperId)
//             .collection("StudentsPaperssubmissions")
//             .doc(studentId)
//             .set({
//           'response': combinedQuestionsAnswers,
//           'submittedAt': FieldValue.serverTimestamp(),
//           'studentId': studentId,
//           'teacherId': teacherId,
//           'department': department,
//           'semester': semester,
//           'section': section,
//           'name': name,
//           'rollcall': rollcall,
//           'Papertitle': title,
//         });
//         EasyLoading.dismiss();
//
//         Get.snackbar("Submitted",
//             "Your paper has been submitted successfully");
//         Get.back();
//       } on FirebaseException catch (e) {
//     EasyLoading.dismiss();
//     Get.snackbar("Error", e.message.toString());
//   }
// }


  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }


}




