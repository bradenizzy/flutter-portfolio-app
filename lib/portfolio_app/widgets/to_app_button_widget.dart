// to_app_button_widget.dart

import 'package:flutter/material.dart';

class ToAppButtonWidget extends StatelessWidget {
  final String appName;
  final String routeName;

  ToAppButtonWidget({required this.appName, required this.routeName});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(appName, style: TextStyle(color: Colors.white)),
    );
  }
}