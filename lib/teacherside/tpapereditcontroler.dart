import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tpapereditcontroler extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<Map<String, dynamic>> paper = Rxn<Map<String, dynamic>>();
  final List<TextEditingController> answerControllers = [];
  final List<TextEditingController> questionController = [];
  final RxList<Map<String, TextEditingController>> qaList =
      <Map<String, TextEditingController>>[].obs;

  late Stream<QuerySnapshot> paperStream;

  @override
  void onInit() {
    super.onInit();

    setupPaperStream();
  }

  void setupPaperStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    paperStream = FirebaseFirestore.instance
        .collection("papers")
        .where(
          "teacherId",
          isEqualTo: uid,
        )
        .snapshots();
  }

  /// Use this to update controllers when the paper arrives
  void updateControllersFromPaper(Map<String, dynamic> paperData) {
    final List questions = paperData["questions"];
    qaList.clear();
    for (int i = 0; i < questions.length; i++) {
      final qText = questions[i]['question'] ?? '';
      final aText = questions[i]['answer'] ?? '';
      qaList.add({
        'question': TextEditingController(text: qText),
        'answer': TextEditingController(text: aText),
      });
    }
  }
}
