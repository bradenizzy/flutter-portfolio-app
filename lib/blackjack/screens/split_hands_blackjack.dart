// split_hands_blackjack.dart

import 'package:flutter/material.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';
import '../widgets/welcome_to_mode.dart';
import '../widgets/split_hands_parameters.dart';

class SplitHandsBlackjack extends StatelessWidget {
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
            SplitHandsParameters(),
          ],
        ),
      ),
    );
  }
}