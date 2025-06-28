import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/button.dart';
import 'package:fyppaperless/layouthelper/textforcard.dart';
class HomeScreen extends StatelessWidget {
  static const id = "/HomeScreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Heloo !!! ",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      color: Colors.amber,
                      child: SizedBox(
                        height: 200,
                        child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextWidget(myText: "Exam Name"),
                                        MyTextWidget(myText: "Teacher Name"),
                                        MyTextWidget(myText: "Exam Name"),
                                        MyTextWidget(myText: "Exam Name"),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextWidget(
                                            myText: "BIG Data Analysis"),
                                        MyTextWidget(myText: "Sidra Zulfiqar"),
                                        MyTextWidget(myText: "Exam Name"),
                                        MyTextWidget(myText: "Exam Name"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyButton(
                                      bgColor: Colors.green,
                                      foregrngColor: Colors.white,
                                      myText: "Attempt",
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    MyButton(
                                        bgColor: Colors.red,
                                        foregrngColor: Colors.white,
                                        myText: "Cancel")
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
