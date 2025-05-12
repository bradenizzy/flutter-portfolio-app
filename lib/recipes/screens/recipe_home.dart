// recipie_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/new_recipe_widgets/new_recipe_button.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';
import 'package:flutter_portfolio_app/recipes/screens/complete_recipe_screen.dart';
import 'package:flutter_portfolio_app/recipes/screens/loading_screen.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_bottom_nav_bar.dart';
import 'package:flutter_portfolio_app/recipes/widgets/custom_drawer.dart';

class RecipieHome extends StatelessWidget {
  final RecipeService recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipie App'),
      ),
      drawer: CustomDrawer(),
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
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadingScreen(),
                  ),
                );
                
                final recipe = await recipeService.fetchRecipe("testing_complete_recipe");
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteRecipeScreen(recipe: recipe),
                  ),
                );
              },
              child: Text('Completed Recipe Screen'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RecipeBottomNavBar(),
    );
  }
}