// number_of_hands_widget.dart

import 'package:flutter/material.dart';

class NumberOfHandsInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;

  NumberOfHandsInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter number of hands',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        onChanged: (value) {
          onChanged(int.tryParse(value));
        },
      ),
    );
  }
}
