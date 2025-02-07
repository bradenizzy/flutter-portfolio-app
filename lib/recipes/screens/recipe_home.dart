// recipie_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/new_recipe_button.dart';

class RecipieHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipie App'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chef_chat');
              },
              child: Text('Go to Chef Assistant'),
            ),
            NewRecipeButton(context: context),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/complete_recipe');
              },
              child: Text('Completed Recipe Screen'),
            ),
          ],
        ),
      ),
    );
  }
}