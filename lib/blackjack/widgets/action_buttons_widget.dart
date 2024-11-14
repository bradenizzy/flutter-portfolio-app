// action_buttons_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final isPlayerTurn = gameProvider.isPlayerTurn;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            //_buildActionButton(context, isPlayerTurn, 'Surrender', gameProvider.surrender),
            _buildActionButton(context, isPlayerTurn, 'Double', gameProvider.doubleDown),
            _buildActionButton(context, isPlayerTurn, 'Split', gameProvider.split),
            _buildActionButton(context, isPlayerTurn, 'Stand', gameProvider.stand),
            _buildActionButton(context, isPlayerTurn, 'Hit', gameProvider.hit),
          ],
        ),
        //SizedBox(height: 10),
        // Fifth, or whatever odd button centered below the grid
      ],
    );
  }
  // Helper method to create a styled action button
  Widget _buildActionButton(BuildContext context, bool isEnabled, String label, VoidCallback action) {
    return SizedBox(
      width: 150, 
      height: 75, 
      child: ElevatedButton(
        onPressed: isEnabled ? action : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), 
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}