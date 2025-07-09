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
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: const Text(
            "Submitted Students",
            style: TextStyle(color: Colors.white),
          )),
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

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                    elevation: 5,
                    color: Colors.amber.shade100,
                    child: SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyTextWidget(myText: "Student Name:"),
                                MyTextWidget(myText: data['name'] ?? 'N/A'),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyTextWidget(myText: "Roll No:"),
                                MyTextWidget(myText: data['rollcall'] ?? 'N/A'),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyTextWidget(myText: "Department:"),
                                MyTextWidget(
                                    myText: data['department'] ?? 'N/A'),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyTextWidget(
                                    myText: "Semester & Section:"),
                                MyTextWidget(
                                  myText:
                                      "${data['semester'] ?? 'N/A'} - ${data['section'] ?? 'N/A'}",
                                ),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: MyButton(
                                bgColor: Colors.green,
                                foregrngColor: Colors.white,
                                myText: "View Paper",
                                onTap: () {
                                  Get.toNamed('/ViewStudentSubmission',
                                      arguments: {
                                        "paperId": paperId,
                                        "studentId": studentId,
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                    // child: ListTile(
                    //   title: Text("Student ID: $studentId"),
                    //   subtitle: Text("Submitted at: ${data['submittedAt'].toDate()}"),

                    // ),
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
