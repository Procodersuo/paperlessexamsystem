import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textforcard.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudnetHomeScreen extends StatelessWidget {
  final String id = "/StudentHomeScreen";
  final AttemptController controller = Get.put(AttemptController());
  @override
  Widget build(BuildContext context) {
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
                    final paperData =
                        papers[index].data() as Map<String, dynamic>;

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
                                    /// Left column: labels
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
                                        MyTextWidget(
                                            myText: paperData['teacherId'] ??
                                                "N/A"),
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
                                      myText: "Attempt",
                                      onTap: () {
                                        controller.updateControllersFromPaper(
                                            paperData);
                                        Get.toNamed("/AttemptingScreen",
                                            arguments: paperData);
                                      },
                                    ),
                                    const SizedBox(width: 30),
                                    MyButton(
                                      bgColor: Colors.red,
                                      foregrngColor: Colors.white,
                                      myText: "Cancel",
                                      onTap: () {
                                        Get.snackbar("Cancelled",
                                            "You cancelled the attempt.");
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
