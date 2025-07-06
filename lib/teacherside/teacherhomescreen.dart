import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomeScreen extends StatelessWidget {
  static String id = "/TeacherHomeScreen";
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/LoginScreen');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome, Teacher 👋", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            /// QUICK ACTION BUTTONS
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _DashboardButton(
                  title: "Upload Paper",
                  icon: Icons.upload_file,
                  onTap: () => Get.toNamed("/PaperUploadScreen"),
                ),
                _DashboardButton(
                  title: "My Papers",
                  icon: Icons.folder,
                  onTap: () =>
                      Get.toNamed("/UploadedPaperViewScreen", arguments: false),
                ),
                _DashboardButton(
                  title: "Submissions",
                  icon: Icons.assignment_turned_in,
                  onTap: () =>
                      Get.toNamed("/UploadedPaperViewScreen", arguments: true),
                ),

              ],
            ),
            const SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
