// feedback_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class FeedbackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final feedback = context.watch<GameProvider>().feedback;

    return feedback != null
        ? Container(
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
            child: Text(
              feedback,
              style: TextStyle(
                color: feedback.contains('Incorrect') ? Colors.red : Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
