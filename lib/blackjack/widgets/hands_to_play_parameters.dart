// split_hands_parameters.dart

import 'package:flutter/material.dart';
import 'number_of_hands_widget.dart';
import '../../../blackjack/providers/game_provider.dart';
import 'package:provider/provider.dart';

class NumHandsParameters extends StatefulWidget {
  @override
  _NumHandsParametersState createState() => _NumHandsParametersState();
}

class _NumHandsParametersState extends State<NumHandsParameters> {
  final TextEditingController _controller = TextEditingController();
  int? numberOfHands;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Column(
      children: [
        Text(
          'How many hands would you like to play?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        NumberOfHandsInput(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              numberOfHands = value;
            });
          },
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: numberOfHands != null && numberOfHands! > 0
              ? () {
                  gameProvider.setNumberOfHands(numberOfHands!);
                  gameProvider.startGame();
                  Navigator.pushNamed(context, '/bj_game');
                }
              : null, // Disable button if input is invalid
          style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
          child: Text(
            'Play Now',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}