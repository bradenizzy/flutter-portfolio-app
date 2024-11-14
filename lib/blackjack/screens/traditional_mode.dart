// traditional_blackjack.dart

import 'package:flutter/material.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';
import '../widgets/welcome_to_mode.dart';
import '../widgets/set_shoe_widget.dart';
import '../widgets/play_now_button.dart';
import '../../portfolio_app/widgets/custom_nav_bar.dart';

class TraditionalBlackjack extends StatefulWidget {
  @override
  _TraditionalBlackjackState createState() => _TraditionalBlackjackState();
}

class _TraditionalBlackjackState extends State<TraditionalBlackjack> {
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
        appBar: AppBar(title: Text('Traditional Blackjack')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDivider(),
            SizedBox(height: 32),
            WelcomeToMode(modeName: 'Traditional Blackjack'),
            SizedBox(height: 32),
            SetShoe(),
            SizedBox(height: 32),
            PlayNowButton(),
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