import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'layouthelper/textforcard.dart';

class Resultscreen extends StatelessWidget {
  static String id = "/ResultScreen";
  const Resultscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Results"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Results")
            .where("stuID", isEqualTo: uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No results found."));
          }

          final resultDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: resultDocs.length,
            itemBuilder: (context, index) {
              final data = resultDocs[index].data() as Map<String, dynamic>;
              final examTitle = data["Paper Title"] ?? "Exam";
              final marks = data["Marks"] ?? "N/A";
              return Card(
                color: Colors.amberAccent,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 100,
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
                                MyTextWidget(myText: "Submit Time:"),
                                MyTextWidget(myText: "Marks")
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                MyTextWidget(
                                    myText:  examTitle,),
                                const SizedBox(height: 4),
                                const SizedBox(height: 4),
                                MyTextWidget(
                                  myText: (data['submittedAt']
                                  as Timestamp)
                                      .toDate()
                                      .toLocal()
                                      .toString()
                                      .split('.')[0], // readable date
                                ),
                                const SizedBox(height: 4),
                                MyTextWidget(
                                  myText: marks,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),


                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
