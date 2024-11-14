// blackjack_celebration.dart

import 'dart:math';
import 'package:flutter/material.dart';

class BlackjackCelebration extends StatefulWidget {
  @override
  _BlackjackCelebrationState createState() => _BlackjackCelebrationState();
}

class _BlackjackCelebrationState extends State<BlackjackCelebration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Start the animation
    _controller.forward();
  }

  Widget _buildFallingObject(double delay) {
    double startX = _random.nextDouble() * MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double animationValue = (_controller.value + delay) % 1.0;
        double offsetY = animationValue * MediaQuery.of(context).size.height;

        return Positioned(
          top: offsetY - 100,
          left: startX,
          child: Icon(
            Icons.attach_money,
            color: const Color.fromARGB(255, 69, 244, 78),
            size: 30,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...List.generate(15, (index) {
          double delay = index * 0.05;
          return _buildFallingObject(delay);
        }),
        
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Blackjack!!!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
