// game_stats_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(8.0), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, 
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game Statistics:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Hands Played: ${gameProvider.handsPlayed}',
                  style: TextStyle(fontSize: 20),
                  ),
                Text('Correct Actions: ${gameProvider.correctActions}',
                  style: TextStyle(fontSize: 20),
                  ),
                Text('Incorrect Actions: ${gameProvider.incorrectActions}',
                  style: TextStyle(fontSize: 20),
                  ),
                Text('Wins: ${gameProvider.wins}',
                  style: TextStyle(fontSize: 20),
                  ),
                Text('Losses: ${gameProvider.losses}',
                  style: TextStyle(fontSize: 20),
                  ),
                Text('Ties: ${gameProvider.ties}',
                  style: TextStyle(fontSize: 20),
                  ),
        ],
      ),
    );
  }
}
