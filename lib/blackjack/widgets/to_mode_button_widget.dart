// to_mode_button_widget.dart

import 'package:flutter/material.dart';

class ToModeButtonWidget extends StatelessWidget {
  final String modeName;
  final String routeName;

  ToModeButtonWidget({required this.modeName, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Set the desired fixed width for all buttons
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.9),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(modeName, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}