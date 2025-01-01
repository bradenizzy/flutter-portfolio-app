// chef_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/chef_chat_button.dart';

class ChefChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chef Chat')),
      body: Center(child: ChefChatButton()),
    );
  }
}
