import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/teacherside/tpapereditcontroler.dart';
import 'package:get/get.dart';

class PaperEdittingScreen extends StatelessWidget {
  static const id = "/PaperEdittingScreen";
  final Tpapereditcontroler controller = Get.put(Tpapereditcontroler());

  PaperEdittingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paperData = Get.arguments as Map<String, dynamic>;

    controller.paper.value = paperData;
    controller.updateControllersFromPaper(paperData);

    final List questions = paperData["questions"];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Attempt Paper",)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Subject: ${paperData["title"]}",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            /// Questions
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (_, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Q${index + 1}"),
                      MyTextField(
                        mycontroller: controller.qaList[index]['question'],
                      ),
                      Text("Answer${index + 1}"),
                      const SizedBox(height: 8),
                      MyTextField(
                        mycontroller: controller.qaList[index]['answer'],
                        lines: 5,
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
                  final List<Map<String, String>> updatedQuestionsAnswers =
                      controller.qaList.map((qa) {
                    return {
                      'question': qa['question']!.text.trim(),
                      'answer': qa['answer']!.text.trim(),
                    };
                  }).toList();

                  await FirebaseFirestore.instance
                      .collection("papers")
                      .doc(paperId)
                      .update({
                    'questions': updatedQuestionsAnswers,
                    'submittedAt': FieldValue.serverTimestamp(),
                  });

                  EasyLoading.dismiss();

                  Get.snackbar(
                      "Submitted", "Your paper has been Edited successfully");
                  Get.back();
                } on FirebaseException catch (e) {
                  EasyLoading.dismiss();
                  Get.snackbar("Error", e.message.toString());
                }
                // or navigate to home screen
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
