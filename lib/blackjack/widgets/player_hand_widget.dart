// player_hand_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/card_display_widget.dart';
import '../utils/blackjack_ui_util.dart';

class PlayerHandWidget extends StatelessWidget {
  final BlackjackUiUtil ui_util = BlackjackUiUtil();
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final activeHandIndex = gameProvider.activeHandIndex;
    final playerHands = gameProvider.playerHands;
    final handResults = gameProvider.handResults;

    return Column(
      children: [
        Column(
          children: List.generate(playerHands.length, (index) {
            final hand = playerHands[index];
            final isActive = index == activeHandIndex;
            final result = handResults.isNotEmpty ? handResults[index] : null;
            final backgroundColor = _getBackgroundColorForResult(result);
            final resultText = result != null ? result.toUpperCase() : '';

            // split card display into rows of three
            final cardRows = ui_util.chunkList(hand.cards, 3);

            return Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isActive)
                        Icon(Icons.arrow_right, color: Colors.black),
                      Text(
                        'Hand ${index + 1} - $resultText',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Display each row of cards
                  Column(
                    children: cardRows.map((cardRow) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: cardRow.map((card) => CardWidget(
                              card: card,
                              borderColor: isActive ? Colors.black : Colors.grey,
                            )).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getBackgroundColorForResult(String? result) {
    switch (result) {
      case 'win':
        return Colors.green;//.withOpacity(0.2);
      case 'lose':
        return Colors.red;//.withOpacity(0.2);
      case 'bust':
        return Colors.orange;//.withOpacity(0.2);
      case 'surrender':
        return Colors.grey;//.withOpacity(0.2);
      case 'push':
        return Colors.yellow;//.withOpacity(0.2);
      default:
        return Colors.transparent;
    }
  }
}