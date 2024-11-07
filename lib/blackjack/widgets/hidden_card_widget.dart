// hidden_card_widget.dart

import 'package:flutter/material.dart';

class HiddenCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[400], // Use a solid color for the back of the card
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Center(
        child: Text(
          '?', // Display a placeholder character for the hidden card
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
