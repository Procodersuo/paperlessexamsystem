import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AttemptScreen extends StatelessWidget {
  static const id = "/AttemptingScreen";
  final AttemptController controller = Get.find();
  AttemptScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final paperData = Get.arguments as Map<String, dynamic>;
    controller.paper.value = paperData;
    controller.updateControllersFromPaper(paperData);
    final List questions = paperData["questions"];
    DateTime endTime = (paperData['endTime'] as Timestamp).toDate();
    controller.startCountdown(endTime);
    final box = GetStorage();
    final String department = box.read("student_department") ?? "";
    final String semester = box.read("student_semester") ?? "";
    final String section = box.read("student_section") ?? "";
    final String name = box.read("student_name") ?? "";
    final String rollcall = box.read("student_rollnumber") ?? "";

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: const Text(
            "Attempt Paper",
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Subject: ${paperData["title"]}",
                style: Theme.of(context).textTheme.titleLarge),
            const Text("Paper will automatically submit after"),
            Obx(() => Text(
              "⏳ Time left: ${_formatDuration(controller.timeLeft.value)}",
              style: TextStyle(fontSize: 16, color: Colors.red),
            )),

            const SizedBox(height: 20),

            /// Questions
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
                        enableVoice: true, // only show mic for answer fields
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
            ElevatedButton(
              onPressed: () async {
                  try {
                  EasyLoading.show();
                  final paperData = controller.paper.value!;
                  final paperId = paperData['id'];
                  final teacherId = paperData['teacherId'];

                  final studentId = controller.currentUserId();

                  final answers =
                  controller.answerControllers.map((e) => e.text).toList();

                  final combinedQuestionsAnswers =
                  List.generate(questions.length, (index) {
                    return {
                      "question": questions[index]["question"],
                      "answer": answers[index],
                    };
                  });
// controller.submitPaper(name,rollcall,paperData['title'],department,semester,section,paperId, studentId, combinedQuestionsAnswers )
                  await FirebaseFirestore.instance
                      .collection("submissions")
                      .doc(paperId)
                      .collection("StudentsPaperssubmissions")
                      .doc(studentId)
                      .set({
                    'response': combinedQuestionsAnswers,
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

                  Get.snackbar("Submitted",
                      "Your paper has been submitted successfully");
                  Get.back();
                } on FirebaseException catch (e) {
                  EasyLoading.dismiss();
                  Get.snackbar("Error", e.message.toString());
                }
                },


              child: const Text("Submit Answers"),
            ),
          ],
        ),
      ),
    );
  }
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }


}
