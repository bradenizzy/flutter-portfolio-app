// blackjack_home.dart

import 'package:flutter/material.dart';
import '../widgets/to_mode_button_widget.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';

class BlackjackHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: blackjackTheme, // Apply the blackjack theme
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blackjack Basic Strategy App'),
          centerTitle: true,
           elevation: 0, // Remove shadow for a cleaner divider effect
        ),
        body: Column(
          children: [
            CustomDivider(),
            SizedBox(height: 32),
            Text(
              'Welcome to Blackjack!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Choose Your Game Mode',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      ToModeButtonWidget(modeName: 'Traditional', routeName: '/traditional'),
                      SizedBox(height: 16),
                      ToModeButtonWidget(modeName: 'Soft Hands', routeName: '/'), // TODO: ADD THESE MODES
                      SizedBox(height: 16),
                      ToModeButtonWidget(modeName: 'Split Hands', routeName: '/'), // TODO: ADD THESE MODES
                      SizedBox(height: 16),
                      ToModeButtonWidget(modeName: 'Double Downs', routeName: '/'), // TODO: ADD THESE MODES
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
