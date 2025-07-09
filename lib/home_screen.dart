import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyppaperless/drawer.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textforcard.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudnetHomeScreen extends StatelessWidget {
  final String id = "/StudentHomeScreen";
  // ✅ Get the existing controller
  final AttemptController controller = Get.put(AttemptController());
  StudnetHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offNamed('/LoginScreen');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.green,
        title: const Text("Available Papers",
            style: TextStyle(color: Colors.white)),
      ),
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
                                        MyTextWidget(myText: "Release Time:"),
                                        MyTextWidget(myText: "End Time:"),
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
                                          myText: (paperData['visibleAt']
                                                  as Timestamp)
                                              .toDate()
                                              .toLocal()
                                              .toString()
                                              .split('.')[0], // readable date
                                        ),
                                        const SizedBox(height: 4),
                                        MyTextWidget(
                                          myText: (paperData['endTime']
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
                                      onTap: () async {
                                        final serverTime =
                                            await controller.getServerTime();
                                        final releaseTime =
                                            (paperData['visibleAt']
                                                    as Timestamp)
                                                .toDate();
                                        final endTime =
                                            (paperData['endTime'] as Timestamp)
                                                .toDate();

                                        if (serverTime.isBefore(releaseTime)) {
                                          Get.snackbar("Not Yet",
                                              "You can attempt this paper after ${releaseTime.toLocal()}");
                                        } else if (serverTime
                                            .isAfter(endTime)) {
                                          Get.snackbar("Expired",
                                              "The paper is no longer available (expired at ${endTime.toLocal()})");
                                        } else {
                                          controller.updateControllersFromPaper(
                                              paperData);
                                          Get.toNamed("/AttemptingScreen",
                                              arguments: paperData);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 30),
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
          )
        ],
      ),
    );
  }
}
