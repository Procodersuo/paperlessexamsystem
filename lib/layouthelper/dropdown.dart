// file: layouthelper/dropdown.dart
import 'package:flutter/material.dart';

class MySimpleDropdown extends StatelessWidget {
  final List<String>? items;
  final String? hintTxt;
  final String? selectedValue;
  final Function(String)? onChanged;

  const MySimpleDropdown({
    super.key,
    required this.items,
    required this.hintTxt,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.9, color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(hintTxt ?? 'Select An Item'),
            ),
            value: selectedValue?.isEmpty ?? true ? null : selectedValue,
            items: (items ?? []).map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null && onChanged != null) {
                onChanged!(newValue);
              }
            },
          ),
        ),
      ),
    );
  }
}
