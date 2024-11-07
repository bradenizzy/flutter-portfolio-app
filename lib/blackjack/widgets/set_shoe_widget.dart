// set_shoe_widget.dart

import 'package:flutter/material.dart';
import 'deck_selector_drop_down.dart';

class SetShoe extends StatefulWidget {
  @override
  _SetShoeState createState() => _SetShoeState();
}

class _SetShoeState extends State<SetShoe> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select the Number of Decks to Play With',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        DeckSelectorDropdown(),
      ],
    );
  }
}