import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UploadController extends GetxController {
  /// Upload paper to Firestore
  Future<void> uploadPaper({
    required String department,
    required String semester,
    required String section,
    required String paperTitle,
    required List<Map<String, TextEditingController>> qaList,
    required DateTime? visibleAt,
    required DateTime? endTime,
  }) async {
    if (visibleAt == null) {
      Get.snackbar("Error", "Please select a release time");
      return;
    }

    if (endTime == null) {
      Get.snackbar("Error", "Please select a Ending Time time");
      return;
    }
    // Extract only non-empty questions/answers
    List<Map<String, String>> questions = [];
    for (var pair in qaList) {
      String question = pair['question']?.text.trim() ?? '';

      if (question.isNotEmpty) {
        questions.add({
          'question': question,
        });
      }
    }

    if (department.isEmpty ||
        semester.isEmpty ||
        section.isEmpty ||
        paperTitle.isEmpty ||
        questions.isEmpty) {
      Get.snackbar("Error", "Please fill all fields and at least one Q/A");
      return;
    }

    try {
      EasyLoading.show(status: "Loadin....");
      final uid = FirebaseAuth.instance.currentUser?.uid;

      await FirebaseFirestore.instance.collection('papers').doc().set({
        'teacherId': uid,
        'department': department,
        'semester': semester,
        'section': section,
        'title': paperTitle,
        'questions': questions,
        'createdAt': FieldValue.serverTimestamp(),
        'visibleAt': Timestamp.fromDate(visibleAt.toUtc()),
        'endTime': Timestamp.fromDate(endTime.toUtc()),
      });
      EasyLoading.dismiss();
      Get.snackbar("Success", "Paper uploaded successfully ✅");
      Get.offAllNamed("/TeacherHomeScreen");
    } catch (e) {
      Get.snackbar("Upload Failed", e.toString());
    }
  }
}
