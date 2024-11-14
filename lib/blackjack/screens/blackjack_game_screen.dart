// blackjack_game_screen.dart

import 'package:flutter/material.dart';
import '../../../blackjack/widgets/dealer_hand_widget.dart';
import '../../../blackjack/widgets/player_hand_widget.dart';
import '../../../blackjack/widgets/feedback_widget.dart';
import '../../../blackjack/widgets/action_buttons_widget.dart';
import '../../../blackjack/providers/game_provider.dart';
import 'package:provider/provider.dart';
import '../../../blackjack/widgets/next_round_button_widget.dart';
import '../../../portfolio_app/other/themes.dart';
import '../../../blackjack/widgets/blackjack_celebration.dart';
import '../../../portfolio_app/widgets/custom_nav_bar.dart';
import '../other/custom_divider.dart';

class BJGameScreen extends StatefulWidget {
  @override
  _BJGameScreenState createState() => _BJGameScreenState();
}

class _BJGameScreenState extends State<BJGameScreen> {
  bool showCelebration = false;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/blackjack');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameOver = gameProvider.isGameOver;
    final isRoundOver = gameProvider.isRoundOver;

    if (gameOver) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/game_results'));
    }

    return Theme(
      data: blackjackTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Good Luck!'),
        centerTitle: true,
        ),
        body: Stack(
          children: [
            CustomDivider(),
            SizedBox(height: 32),
            SingleChildScrollView(
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
          // Overlay with animation when isBlackjack is true
          if (gameProvider.isBlackjack)
            Container(
              color: Colors.transparent, 
              alignment: Alignment.center,
              child: BlackjackCelebration(),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemSelected: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Blackjack'),
          ],
        ),
      ),
    );
  }
}
