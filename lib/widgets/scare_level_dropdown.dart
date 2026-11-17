
import 'package:flutter/material.dart';

class ScareLevelDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const ScareLevelDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      isExpanded: true,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}
