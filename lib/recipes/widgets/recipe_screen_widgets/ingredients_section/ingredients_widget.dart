// ingredients_widget.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'top_row_widget.dart';
import 'ingredients_list_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsWidget extends StatelessWidget {
  final bool isEditable; // Passed from the parent widget or state
  final List<Ingredient> ingredients;

  const IngredientsWidget({Key? key, this.isEditable = false, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Getting to IngredientsWidget");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Scaling and Edit Buttons
        TopRowWidget(),
        const SizedBox(height: 16),
        // Ingredients List
        IngredientsListWidget(
          ingredients: ingredients,
          isEditable: isEditable,
          scalingMultiplier: 1.0,
        ),
      ],
    );
  }
}