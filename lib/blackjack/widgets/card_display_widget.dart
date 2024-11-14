// card_display_widget.dart

import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import 'suit_icons.widget.dart';
class CardWidget extends StatelessWidget {
  final PlayingCard card;
  final Color borderColor;

  CardWidget({required this.card, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.rank,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SuitIcon(suit: card.suit),
        ],
      ),
    );
  }
}
