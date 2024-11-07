// traditional_blackjack.dart

import 'package:flutter/material.dart';
import '../../../portfolio_app/other/themes.dart';
import '../../../blackjack/other/custom_divider.dart';
import '../../../blackjack/widgets/welcome_to_mode.dart';
import '../../../blackjack/widgets/set_shoe_widget.dart';
import '../../widgets/traditional_play_now_button.dart';

class TraditionalBlackjack extends StatelessWidget {
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
            TraditionalPlayNowButton(),
          ],
        ),
      ),
    );
  }
}