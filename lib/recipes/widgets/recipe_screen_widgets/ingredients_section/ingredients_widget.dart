// ingredients_widget.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'top_row_widget.dart';
import 'ingredients_list_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsWidget extends StatefulWidget {
  final bool isEditable;
  final List<Ingredient> ingredients;
  final double servings;
  
  const IngredientsWidget({
    Key? key, 
    this.isEditable = false, 
    required this.ingredients, 
    required this.servings
  }) : super(key: key);

  @override
  _IngredientsWidgetState createState() => _IngredientsWidgetState();
}

class _IngredientsWidgetState extends State<IngredientsWidget> {
  double _scalingMultiplier = 1.0;

  void _updateScalingMultiplier(double newMultiplier) {
    setState(() {
      _scalingMultiplier = newMultiplier;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Getting to IngredientsWidget");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Scaling and Edit Buttons
        TopRowWidget(
          servings: widget.servings,
          scalingMultiplier: _scalingMultiplier,
          onScalingChanged: _updateScalingMultiplier,
        ),
        const SizedBox(height: 16),
        // Ingredients List
        IngredientsListWidget(
          ingredients: widget.ingredients,
          isEditable: widget.isEditable,
          scalingMultiplier: _scalingMultiplier,
        ),
      ],
    );
  }
}