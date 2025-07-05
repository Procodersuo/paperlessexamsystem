import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textforcard.dart';
import 'package:get/get.dart';

class StudentSubmissionListScreen extends StatelessWidget {
  static const id = "/StudentSubmissionList";

  const StudentSubmissionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paperId = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Submitted Students")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("submissions")
            .doc(paperId)
            .collection("StudentsPaperssubmissions")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No submissions yet."));
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final doc = students[index];
              final data = doc.data() as Map<String, dynamic>;
              final studentId = doc.id;

              return Card(
                  elevation: 5,
                  color: Colors.amber.shade100,
                  child: const SizedBox(
                    height: 150,
                    child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MyTextWidget(
                                  myText: "Exam Title:",
                                ),
                                MyTextWidget(myText: "Student Name"),
                              ],
                            ),
                            MyButton(
                                bgColor: Colors.green,
                                foregrngColor: Colors.white,
                                myText: "View Ppaer")
                          ],
                        )),
                  )
                  // child: ListTile(
                  //   title: Text("Student ID: $studentId"),
                  //   subtitle: Text("Submitted at: ${data['submittedAt'].toDate()}"),

                  // ),
                  );
            },
          );
        },
      ),
    );
  }
}
