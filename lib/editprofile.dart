import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'layouthelper/dropdown.dart';
class editProfile extends StatelessWidget {
  static String id ="/EditProfile";
  const editProfile({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage.init();
    final box = GetStorage();
    String name = box.read("student_name");
    String rollNumber = box.read("student_rollnumber");
    String semesterGet= box.read("student_semester");
    String sectionGet =box.read("student_section");
    String departmentGet =box.read("student_department");
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController rollNumberController = TextEditingController(text: rollNumber);
    final RxString department = departmentGet.obs;
    final RxString semester = semesterGet.obs;
    final RxString section = sectionGet.obs;

    return  Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text("Edit Your Profile",style: TextStyle(
          color: Colors.white
        ),),
      ),
      body:  Column(
        children: [
          MyTextField(mycontroller: nameController),
          const SizedBox( height: 10,),
          MyTextField(mycontroller: rollNumberController),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Obx(() => MySimpleDropdown(
                  items: const ["BSSE", "BSIT", "BSCS", "BSDS"],
                  hintTxt: "Depart",
                  selectedValue: department.value,
                  onChanged: (val) => department.value = val,
                )),
              ),
              Expanded(
                child: Obx(() => MySimpleDropdown(
                  items: const ["1", "2", "3", "4", "5", "6", "7", "8"],
                  hintTxt: "Semester",
                  selectedValue: semester.value,
                  onChanged: (val) => semester.value = val,
                )),
              ),
              Expanded(
                child: Obx(() => MySimpleDropdown(
                  items: const ["M", "E-A", "E-B", "E-C"],
                  hintTxt: "Section",
                  selectedValue: section.value,
                  onChanged: (val) => section.value = val,
                )),
              )
            ],
          ),

          const SizedBox(height: 10,),

          MyButton(bgColor: Colors.blue, foregrngColor: Colors.white, myText: "Update" ,
          onTap: () async {

            try {
              EasyLoading.show();
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              await FirebaseFirestore.instance.collection("StudentsData").doc(
                  uid).update({
                'Name': nameController.text.toString(),
                'department': department.value,
                'Section': section.value,
                'Roll Number': rollNumberController.text.toString(),
                'semester': semester.value
              });
              box.write("student_department", department.value);
              box.write("student_semester", semester.value);
              box.write("student_section", section.value);
              EasyLoading.dismiss();
              Get.snackbar("Updated", "Your profile was successfully updated Restart App");

            }
            on FirebaseAuthException catch (e) {
              EasyLoading.dismiss();
              Get.snackbar('Updation Failed', e.message ?? 'Unknown error');
            }
          }
          )
        ],
      ),
    );
  }
}
