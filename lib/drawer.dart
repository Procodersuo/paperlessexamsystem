import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    GetStorage.init();
    final box = GetStorage();
    // String semester= box.read("student_semester");
    // String section =box.read("student_section");
    String name = box.read("student_name");
    String rollNumber = box.read("student_rollnumber");
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            accountName: Text(
              name,
              style: const TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              rollNumber,
              style: const TextStyle(
                color: Colors.white,
              ),
            )),
        ListTile(
          leading: const Icon(Icons.fact_check, color: Colors.red),
          title:
              const Text('View Result', style: TextStyle(color: Colors.green)),
          onTap: () {
            Get.toNamed('/ResultScreen');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.red),
          title:
          const Text('Edit Profile', style: TextStyle(color: Colors.green)),
          onTap: () {
            Get.toNamed('/EditProfile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Get.offAllNamed('/LoginScreen');
          },
        ),
      ],
    ));
  }
}
