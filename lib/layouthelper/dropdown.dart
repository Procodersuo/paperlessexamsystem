import 'package:flutter/material.dart';

class MySimpleDropdown extends StatefulWidget {
  final List<String>? items;
  final String? hintTxt;
  const MySimpleDropdown(
      {super.key, required this.items, required this.hintTxt});

  @override
  State<MySimpleDropdown> createState() => _MySimpleDropdownState();
}

class _MySimpleDropdownState extends State<MySimpleDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.9, color: Colors.black),
            borderRadius: BorderRadius.circular(12)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(widget.hintTxt ?? 'Select An Item'),
            ),
            value: selectedItem,
            items: (widget.items ?? []).map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem = newValue;
              });
            },
          ),
        ),
      ),
    );
  }
}
