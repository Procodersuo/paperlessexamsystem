import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AttemptController extends GetxController {
  /// ⏳ Countdown timer
  final Rx<Duration> timeLeft = Duration.zero.obs;
  Timer? countdownTimer;
  bool countdownStarted = false;

  /// 📝 Paper data and answers
  final Rxn<Map<String, dynamic>> paper = Rxn<Map<String, dynamic>>();
  final List<TextEditingController> answerControllers = [];

  /// 🔊 Speech-to-text
  final SpeechToText speech = SpeechToText();
  RxBool isListening = false.obs;

  /// 🔁 Firestore live paper stream
  late Stream<QuerySnapshot> paperStream;

  /// 🧠 Load stream of papers for logged-in student
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

  /// ⏰ Get exact server time
  Future<DateTime> getServerTime() async {
    final docRef =
        FirebaseFirestore.instance.collection('serverTime').doc('now');
    await docRef.set(
        {'timestamp': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    final snapshot = await docRef.get();
    final timestamp = snapshot.data()?['timestamp'] as Timestamp;
    return timestamp.toDate();
  }

  Future<void> startCountdownUsingServerTime(DateTime endTime) async {
    final now = await getServerTime();
    final remaining = endTime.difference(now);
    print(now);
    print(endTime);
    if (remaining.isNegative) {
      timeLeft.value = Duration.zero;
      return;
    }

    // Set countdown to remaining time between now and endTime
    timeLeft.value = remaining;

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value.inSeconds <= 1) {
        timeLeft.value = Duration.zero;
        timer.cancel();
      } else {
        timeLeft.value -= const Duration(seconds: 1);
      }
    });
  }

  /// 🎤 Toggle voice input
  Future<void> toggleListening(TextEditingController controller) async {
    await requestMic();

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

  /// 🎤 Ask mic permission
  Future<void> requestMic() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  /// 🔐 Current logged-in UID
  String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  /// 📌 Initialize answer fields
  void updateControllersFromPaper(Map<String, dynamic> paperData) {
    final List questions = paperData["questions"];
    answerControllers.clear();
    for (int i = 0; i < questions.length; i++) {
      answerControllers.add(TextEditingController());
    }
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }
}
