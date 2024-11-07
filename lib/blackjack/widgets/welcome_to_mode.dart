// welcome_to_mode.dart

import 'package:flutter/material.dart';

class WelcomeToMode extends StatelessWidget {
  final String modeName;

  WelcomeToMode({required this.modeName});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome to $modeName',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}