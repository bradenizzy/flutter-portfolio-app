// recipie_home.dart
import 'package:flutter/material.dart';

class RecipieHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipie App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chef_chat');
          },
          child: Text('Go to Chef Assistant'),
        ),
      ),
    );
  }
}