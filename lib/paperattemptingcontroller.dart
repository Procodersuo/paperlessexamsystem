import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AttemptController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<Map<String, dynamic>> paper = Rxn<Map<String, dynamic>>();
  final List<TextEditingController> answerControllers = [];

  late Stream<QuerySnapshot> paperStream;

  @override
  void onInit() {
    super.onInit();
    setupPaperStream();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("Studentsdata")
        .doc(uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      final box = GetStorage();
      box.write("student_department", data["department"]);
      box.write("student_semester", data["semester"]);
      box.write("student_section", data["section"]);
    }
  }

  void setupPaperStream() {
    final box = GetStorage();
    final String department = box.read("student_department") ?? "";
    final String semester = box.read("student_semester") ?? "";
    final String section = box.read("student_section") ?? "";

    final now = Timestamp.now();
    print("🕓 Current Device Time: ${DateTime.now()}");

    paperStream = FirebaseFirestore.instance
        .collection("papers")
        .where("department", isEqualTo: "BSSE")
        .where("semester", isEqualTo: "1")
        .where("section", isEqualTo: "M")
        .where("visibleAt", isLessThanOrEqualTo: now)
        .orderBy("visibleAt", descending: true)
        .limit(1)
        .snapshots();

    // 🔁 Real-time stream
  }

  /// Use this to update controllers when the paper arrives
  void updateControllersFromPaper(Map<String, dynamic> paperData) {
    final List questions = paperData["questions"];
    answerControllers.clear();
    for (int i = 0; i < questions.length; i++) {
      answerControllers.add(TextEditingController());
    }
  }
}
