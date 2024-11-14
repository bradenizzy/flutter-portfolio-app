// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/blackjack/providers/game_provider.dart';
import '../lib/blackjack/widgets/blackjack_celebration.dart';
import '../lib/blackjack/models/playing_card.dart';

void main() {
  testWidgets('Blackjack celebration should trigger when player has "A, K"', (WidgetTester tester) async {
    // Set up the GameProvider with a blackjack hand
    final gameProvider = GameProvider();

    // Set up a Provider for testing
    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return gameProvider.isBlackjack ? BlackjackCelebration() : SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    // Simulate a blackjack hand for the player
    gameProvider.playerHands[0].addCard(PlayingCard(suit: "♠", rank: "A"));
    gameProvider.playerHands[0].addCard(PlayingCard(suit: "♠", rank: "K"));

    // Manually trigger the blackjack check
    gameProvider.checkPlayerBlackjack();

    // Rebuild the widget with the new provider state
    await tester.pump();

    // Verify that the isBlackjack flag is true
    expect(gameProvider.isBlackjack, isTrue);

    // Verify that the BlackjackCelebration widget is shown
    expect(find.byType(BlackjackCelebration), findsOneWidget);
  });
}
