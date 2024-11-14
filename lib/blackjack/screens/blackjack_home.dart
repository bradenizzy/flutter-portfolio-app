// blackjack_home.dart

import 'package:flutter/material.dart';
import '../widgets/to_mode_button_widget.dart';
import '../../portfolio_app/other/themes.dart';
import '../other/custom_divider.dart';
import '../../portfolio_app/widgets/custom_nav_bar.dart';

class BlackjackHome extends StatefulWidget {
  @override
  _BlackjackHomeState createState() => _BlackjackHomeState();
}

class _BlackjackHomeState extends State<BlackjackHome> {
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
        appBar: AppBar(
          title: Text('Blackjack Basic Strategy App'),
          centerTitle: true,
           elevation: 0,
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
                      ToModeButtonWidget(modeName: 'Soft Hands', routeName: '/soft_hands'), 
                      SizedBox(height: 16),
                      ToModeButtonWidget(modeName: 'Split Hands', routeName: '/split_hands'),
                      SizedBox(height: 16),
                      ToModeButtonWidget(modeName: 'Double Downs', routeName: '/double_downs'),
                    ],
                  ),
                ),
              ),
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
