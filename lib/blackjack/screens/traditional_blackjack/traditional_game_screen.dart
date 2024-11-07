// traditional_game_screen.dart

import 'package:flutter/material.dart';
import '../../../blackjack/widgets/dealer_hand_widget.dart';
import '../../../blackjack/widgets/player_hand_widget.dart';
import '../../../blackjack/widgets/feedback_widget.dart';
import '../../../blackjack/widgets/action_buttons_widget.dart';
import '../../../blackjack/providers/game_provider.dart';
import 'package:provider/provider.dart';
import '../../../blackjack/widgets/next_round_button_widget.dart';
import '../../../portfolio_app/other/themes.dart';

class TraditionalGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameOver = gameProvider.isGameOver;
    final isRoundOver = gameProvider.isRoundOver;

    if (gameOver) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/traditional_game_results'));
    }

    return Theme(
      data: blackjackTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Good Luck!'),
        centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DealerHandWidget(),

              SizedBox(height: 20),
              PlayerHandWidget(),

              SizedBox(height: 20),
              FeedbackWidget(),

              SizedBox(height: 20),
              isRoundOver ? NextRoundButton() : ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
