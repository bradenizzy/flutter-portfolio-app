// double_down_mode.dart

import 'package:flutter/material.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';
import '../widgets/welcome_to_mode.dart';
import '../widgets/hands_to_play_parameters.dart';
import '../../portfolio_app/widgets/custom_nav_bar.dart';

class DoubleDownBlackjack extends StatefulWidget {
  @override
  _DoubleDownBlackjackState createState() => _DoubleDownBlackjackState();
}

class _DoubleDownBlackjackState extends State<DoubleDownBlackjack> {
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
    return Theme(
      data: blackjackTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Double Down Blackjack')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDivider(),
            SizedBox(height: 32),
            WelcomeToMode(modeName: 'Double Down Blackjack'),
            SizedBox(height: 32),
            NumHandsParameters(),
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