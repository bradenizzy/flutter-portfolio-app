// chef_chat_button.dart

import 'package:flutter/material.dart';  
import 'package:provider/provider.dart';
import 'package:flutter_portfolio_app/recipes/providers/recipe_provider.dart';

class ChefChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the RecipeProvider
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Center(
      child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: recipeProvider.isSessionActive ? Colors.green : Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.keyboard_voice,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () async {
                if (recipeProvider.isSessionActive) {
                  print("Stop button pressed");
                  await recipeProvider.stopChefChatSession();
                } else {
                  print("Start button pressed");
                  await recipeProvider.startChefChatSession();
                }
              },
            ),
          ),
    );
  }
}