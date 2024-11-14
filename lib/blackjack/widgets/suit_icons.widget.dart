// suit_icons.widget.dart

import 'package:flutter/material.dart';

class SuitIcon extends StatelessWidget {
  final String suit;

  SuitIcon({required this.suit});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;

    switch (suit.toLowerCase()) {
      case 'hearts':
        iconData = Icons.favorite; // Use the heart icon for hearts
        color = Colors.red;
        break;
      case 'diamonds':
        iconData = Icons.diamond; // Use diamond icon for diamonds (available in Flutter 2.5+)
        color = Colors.red;
        break;
      case 'clubs':
        iconData = Icons.spa; // Use spa icon as a close representation of clubs
        color = Colors.black;
        break;
      case 'spades':
        iconData = Icons.change_history; // Use triangle icon as a close representation of spades
        color = Colors.black;
        break;
      default:
        iconData = Icons.help; // Default to a help icon if suit is unrecognized
        color = Colors.grey;
    }

    return Icon(
      iconData,
      color: color,
      size: 24, // Adjust the size as needed
    );
  }
}
