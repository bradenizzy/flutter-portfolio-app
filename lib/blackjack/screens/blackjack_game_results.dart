// traditional_game_results.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_stats_widget.dart';
import '../../portfolio_app/other/themes.dart';
import '../../portfolio_app/widgets/custom_nav_bar.dart';
import '../other/custom_divider.dart';

class GameResultsScreen extends StatefulWidget {
  @override
  _GameResultsScreenState createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen> {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDivider(),
              SizedBox(height: 32),
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
