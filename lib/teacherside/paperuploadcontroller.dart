import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  }) async {
    print(visibleAt);
    if (visibleAt == null) {
      Get.snackbar("Error", "Please select a release time");
      return;
    }
    // Extract only non-empty questions/answers
    List<Map<String, String>> questions = [];
    for (var pair in qaList) {
      String question = pair['question']?.text.trim() ?? '';
      String answer = pair['answer']?.text.trim() ?? '';

      if (question.isNotEmpty && answer.isNotEmpty) {
        questions.add({'question': question, 'answer': answer});
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
      final uid = FirebaseAuth.instance.currentUser?.uid;

      await FirebaseFirestore.instance.collection('papers').doc().set({
        'teacherId': uid,
        'department': department,
        'semester': semester,
        'section': section,
        'title': paperTitle,
        'questions': questions,
        'createdAt': FieldValue.serverTimestamp(),
        'visibleAt': Timestamp.fromDate(visibleAt),
      });

      Get.snackbar("Success", "Paper uploaded successfully ✅");
    } catch (e) {
      Get.snackbar("Upload Failed", e.toString());
    }
  }
}
