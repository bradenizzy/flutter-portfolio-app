// next_round_button_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class NextRoundButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
        gameProvider.startRound();
      },
          child: Text('Next Round'),
        ),
      ],
    );
  }
}