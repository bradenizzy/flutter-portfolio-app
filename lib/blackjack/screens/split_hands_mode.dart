// split_hands_blackjack.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';
import '../widgets/welcome_to_mode.dart';
import '../widgets/hands_to_play_parameters.dart';
import '../../portfolio_app/widgets/custom_nav_bar.dart';

class SplitHandsBlackjack extends StatefulWidget {
  @override
  _SplitHandsBlackjackState createState() => _SplitHandsBlackjackState();
}

class _SplitHandsBlackjackState extends State<SplitHandsBlackjack> {
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
        appBar: AppBar(title: Text('Split Hands Blackjack')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDivider(),
            SizedBox(height: 32),
            WelcomeToMode(modeName: 'Split Hands Blackjack'),
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