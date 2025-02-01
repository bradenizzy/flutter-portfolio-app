// recipe_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_bottom_nav_bar.dart';

class RecipeEditScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipe ID:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.id,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'More features coming soon!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RecipeBottomNavBar(),
    );
  }
}