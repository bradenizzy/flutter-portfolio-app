// traditional_game_results.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_stats_widget.dart';
import '../../portfolio_app/other/themes.dart';

class GameResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Theme(
      data: blackjackTheme,
      child: Scaffold(
          appBar: AppBar(
          title: Text('Game Results'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thanks for playing!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
              ),
              SizedBox(height: 20),
              GameStatsWidget(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  gameProvider.startGame();
                  Navigator.pushNamed(context, '/bj_game');
                },
                child: Text('Play Again'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  gameProvider.resetGame();
                  Navigator.pushReplacementNamed(context, '/blackjack');
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
