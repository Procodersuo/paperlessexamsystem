import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ViewStudentSubmissionScreen extends StatefulWidget {
  static const id = "/ViewStudentSubmission";
  const ViewStudentSubmissionScreen({super.key});
  @override
  State<ViewStudentSubmissionScreen> createState() =>
      _ViewStudentSubmissionScreenState();
}

class _ViewStudentSubmissionScreenState
    extends State<ViewStudentSubmissionScreen> {
  final TextEditingController marksController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final paperId = args['paperId'];
    final studentId = args['studentId'];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Student's Submission",
            style: TextStyle(color: Colors.white),
          )),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("submissions")
            .doc(paperId)
            .collection("StudentsPaperssubmissions")
            .doc(studentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Submission not found"));
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List answers = data['response'] ?? [];
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final q = answers[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Q${index + 1}: ${q['question']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Ans: ${q['answer']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: marksController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Enter Marks", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    try {
                      EasyLoading.show();
                      await FirebaseFirestore.instance
                          .collection("Results")
                          .add({
                        'stuID': studentId,
                        'StuName': data['name'],
                        'Marks': marksController.text.toString(),
                        'Paper Title': data['Papertitle'],
                        'submittedAt': Timestamp.now(),
                      });
                      EasyLoading.dismiss();
                      Get.snackbar("Saved", "Marks saved successfully");
                      Get.back();
                    } catch (e) {
                      EasyLoading.dismiss();
                      Get.snackbar("Error", e.toString());
                    }
                  },
                  child: const Text(
                    "Submit Marks",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
