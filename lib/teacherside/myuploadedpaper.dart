import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textforcard.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:fyppaperless/teacherside/tpapereditcontroler.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadedPaperViewScreen extends StatelessWidget {
  static String id = "/UploadedPaperViewScreen";
  final Tpapereditcontroler controller = Get.put(Tpapereditcontroler());

  UploadedPaperViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool editscreenorstusubmission = Get.arguments as bool;

    return Scaffold(
      appBar: AppBar(title: const Text("Available Papers")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.paperStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No papers available."));
                }

                final papers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: papers.length,
                  itemBuilder: (context, index) {
                    final paperDoc = papers[index];
                    final rawData = paperDoc.data() as Map<String, dynamic>;
                    final paperData = {
                      ...rawData,
                      'id': paperDoc.id,
                    };
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 5,
                        color: Colors.amber.shade100,
                        child: SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextWidget(
                                          myText: "Exam Title:",
                                        ),
                                        MyTextWidget(myText: "Teacher ID:"),
                                        MyTextWidget(myText: "Release Time:"),
                                        MyTextWidget(
                                            myText: "Total Questions:"),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextWidget(
                                            myText:
                                                paperData['title'] ?? "N/A"),
                                        const SizedBox(height: 4),
                                        const SizedBox(height: 4),
                                        MyTextWidget(
                                          myText: (paperData['visibleAt']
                                                  as Timestamp)
                                              .toDate()
                                              .toLocal()
                                              .toString()
                                              .split('.')[0], // readable date
                                        ),
                                        const SizedBox(height: 4),
                                        MyTextWidget(
                                          myText:
                                              "${(paperData['questions'] as List).length}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                /// Buttons Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyButton(
                                      bgColor: Colors.green,
                                      foregrngColor: Colors.white,
                                      myText: editscreenorstusubmission == true
                                          ? "View Submission"
                                          : "Edit Paper",
                                      onTap: () async {
                                        controller.updateControllersFromPaper(
                                            paperData);

                                        editscreenorstusubmission == true
                                            ? Get.toNamed(
                                                "/StudentSubmissionList",
                                                arguments: paperData['id'])
                                            : Get.toNamed(
                                                "/PaperEdittingScreen",
                                                arguments: paperData);
                                      },
                                    ),
                                    const SizedBox(width: 30),
                                    MyButton(
                                      bgColor: Colors.red,
                                      foregrngColor: Colors.white,
                                      myText: "Delete",
                                      onTap: () {
                                        Get.snackbar("Cancelled",
                                            "Delete Logic Will be Applied");
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
