// chef_chat_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/services/chef_service.dart';

class ChefChatButton extends StatefulWidget {
  @override
  _ChefChatButtonState createState() => _ChefChatButtonState();
}

class _ChefChatButtonState extends State<ChefChatButton> {
  final ChefService chefService = ChefService();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.keyboard_voice,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {
            chefService.startChatSession();
          },
        ),
      ),
    );
  }
}

