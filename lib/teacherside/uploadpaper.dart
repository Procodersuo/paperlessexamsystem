import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/teacherside/datetimepicker.dart';
import 'package:fyppaperless/teacherside/endtimepicker.dart';
import 'package:fyppaperless/teacherside/paperuploadcontroller.dart';
import 'package:get/get.dart';
import '../layouthelper/dropdown.dart';

class PaperUploadScreen extends StatelessWidget {
  static String id = "/PaperUploadScreen";
  PaperUploadScreen({super.key});
  final RxString department = ''.obs;
  final RxString semester = ''.obs;
  final RxString section = ''.obs;
  final TextEditingController paperTitleController = TextEditingController();
  final RxList<Map<String, TextEditingController>> qaList =
      <Map<String, TextEditingController>>[].obs;
  // Date Time Picking
  final UploadController controller = Get.put(UploadController());
  final Datetimepicker controllerDateTime = Get.put(Datetimepicker());
  final Endtimepicker controllerEndTime = Get.put(Endtimepicker());
  void addQuestion() {
    qaList.add({
      'question': TextEditingController(),
    });
  }

  void removeLastQuestion() {
    qaList.removeLast();
  }

  void resetPaper() {
    qaList.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (qaList.isEmpty) {
      addQuestion(); // add first one
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: const Text(
            "Upload Paper",
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// DROPDOWNS
              Row(
                children: [
                  Expanded(
                    child: Obx(() => MySimpleDropdown(
                          items: const [
                            "BSSE",
                            "BSIT",
                            "BSCS",
                            "BSDS",
                          ],
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
                  ),
                ],
              ),

              const SizedBox(height: 20),

              MyTextField(
                mycontroller: paperTitleController,
                hinttext: "Please Enter Subject Name",
              ),

              /// QUESTIONS + ANSWERS
              Obx(() => Column(
                    children: List.generate(qaList.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Question ${index + 1}"),
                            MyTextField(
                              lines: 1,
                              mycontroller: qaList[index]['question'],
                              hinttext: "Please Enter Answer For The Questions",
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    }),
                  )),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: MyButton(
                        bgColor: Colors.green,
                        foregrngColor: Colors.white,
                        myText: "ADD Question",
                        onTap: () {
                          addQuestion();
                        }),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: MyButton(
                        bgColor: Colors.green,
                        foregrngColor: Colors.white,
                        myText: "Remove Last",
                        onTap: () {
                          removeLastQuestion();
                        }),
                  )
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  controllerDateTime
                      .pickVisibleTime(); // ✅ logic handled in controller
                },
                child: Obx(() => Text(
                      controllerDateTime.visibleAt.value == null
                          ? "Pick Paper Release Time"
                          : "Releases: ${controllerDateTime.visibleAt.value!.toLocal()}",
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  controllerEndTime
                      .pickVisibleTime(); // ✅ logic handled in controller
                },
                child: Obx(() => Text(
                      controllerEndTime.endingTimw.value == null
                          ? "Pick Paper Ending Time"
                          : "Releases: ${controllerEndTime.endingTimw.value!.toLocal()}",
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(height: 20),

              MyButton(
                  bgColor: Colors.green,
                  foregrngColor: Colors.white,
                  myText: "Upload Your Paper",
                  onTap: () {
                    controller.uploadPaper(
                      department: department.value,
                      semester: semester.value,
                      section: section.value,
                      paperTitle: paperTitleController.text.trim(),
                      qaList: qaList,
                      visibleAt: controllerDateTime.visibleAt.value,
                      endTime: controllerEndTime.endingTimw.value,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
