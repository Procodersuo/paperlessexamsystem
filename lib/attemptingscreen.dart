import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AttemptScreen extends StatelessWidget {
  static const id = "/AttemptingScreen";
  final AttemptController controller = Get.find();
  AttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paperData = Get.arguments as Map<String, dynamic>;
    final List questions = paperData["questions"];
    final endTime = (paperData['endTime'] as Timestamp).toDate();
    // ✅ Only update paper and controllers if not same paper
    if (controller.paper.value == null ||
        controller.paper.value!['id'] != paperData['id']) {
      controller.paper.value = paperData;
      controller.updateControllersFromPaper(paperData);
      controller.countdownStarted = false;
    }

    // ✅ Start countdown after build only if not already started
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.countdownStarted) {
        controller.countdownStarted = true;
        controller
            .startCountdownUsingServerTime(endTime); // ✅ runs now → endTime
      }
    });
    const String geminiApiKey = "AIzaSyBMoPHfc04IcCFOvLTvmhK7r6brwGdzYGg";

    Future<double> getAIScore(List<Map<String, String>> combinedQA) async {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$geminiApiKey",
      );

      // Prepare prompt
      String prompt =
          "You are a strict teacher. Evaluate the following answers. "
          "Return only the total score out of 10.\n\n";
      for (var i = 0; i < combinedQA.length; i++) {
        prompt += "Q${i + 1}: ${combinedQA[i]["question"]}\n";
        prompt += "Student Answer: ${combinedQA[i]["answer"]}\n\n";
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiText = data["candidates"][0]["content"]["parts"][0]["text"];
        final scoreMatch = RegExp(r"(\d+(\.\d+)?)").firstMatch(aiText);
        if (scoreMatch != null) {
          return double.tryParse(scoreMatch.group(1)!) ?? 0.0;
        }
      }
      return 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title:
            const Text("Attempt Paper", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Subject: ${paperData["title"]}",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text("Paper will automatically submit after:"),
            const SizedBox(height: 8),

            /// Countdown Timer Display
            Obx(() {
              final time = controller.timeLeft.value;
              final minutes =
                  time.inMinutes.remainder(60).toString().padLeft(2, '0');
              final seconds =
                  time.inSeconds.remainder(60).toString().padLeft(2, '0');

              // ✅ Only auto-submit once
              if (time == Duration.zero && controller.countdownStarted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.countdownStarted = false;
                  submitPaper(paperData);
                });
              }

              return Text("⏰ $minutes:$seconds",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red));
            }),

            const SizedBox(height: 20),

            /// Questions List
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (_, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Q${index + 1}: ${questions[index]["question"]}"),
                      const SizedBox(height: 8),
                      MyTextField(
                        mycontroller: controller.answerControllers[index],
                        hinttext: "Write Your Answer Here ",
                        lines: 5,
                        enableVoice: true,
                        voiceAnswer: () {
                          controller.toggleListening(
                              controller.answerControllers[index]);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  final questions = paperData["questions"];
                  final answers =
                      controller.answerControllers.map((e) => e.text).toList();

                  final combinedQA = List.generate(
                    questions.length,
                    (i) => {
                      "question": questions[i]["question"].toString(),
                      "answer": answers[i].toString(),
                    },
                  );

                  EasyLoading.show(status: "Evaluating with AI...");
                  double aiScore = await getAIScore(combinedQA);
                  EasyLoading.dismiss();

                  Get.snackbar(
                    "AI Evaluation Complete",
                    "Your AI Score: $aiScore / 10",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text("AI Evaluate")),

            const SizedBox(
              height: 10,
            ),

            /// Manual Submit Button
            ElevatedButton(
              onPressed: () => submitPaper(paperData),
              child: const Text("Submit Answers"),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Final Submission Function
  void submitPaper(Map<String, dynamic> paperData) async {
    try {
      EasyLoading.show();
      final questions = paperData["questions"];
      final box = GetStorage();
      final department = box.read("student_department");
      final semester = box.read("student_semester");
      final section = box.read("student_section");
      final name = box.read("student_name");
      final rollcall = box.read("student_rollnumber");
      final studentId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final teacherId = paperData['teacherId'];
      final paperId = paperData['id'];
      final answers = controller.answerControllers.map((e) => e.text).toList();
      final combinedQA = List.generate(
        questions.length,
        (i) => {
          "question": questions[i]["question"],
          "answer": answers[i],
        },
      );
      await FirebaseFirestore.instance
          .collection("submissions")
          .doc(paperId)
          .collection("StudentsPaperssubmissions")
          .doc(studentId)
          .set({
        'response': combinedQA,
        'submittedAt': FieldValue.serverTimestamp(),
        'studentId': studentId,
        'teacherId': teacherId,
        'department': department,
        'semester': semester,
        'section': section,
        'name': name,
        'rollcall': rollcall,
        'Papertitle': paperData["title"]
      });
      EasyLoading.dismiss();
      Get.snackbar("Submitted", "Your paper has been submitted successfully");
      controller.setupPaperStream();
      Get.offAllNamed("/StudentHomeScreen");
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString());
    }
  }
}
