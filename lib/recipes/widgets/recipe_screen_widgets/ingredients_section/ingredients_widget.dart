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
  late List<Ingredient> _editableIngredients;

  @override
  void initState() {
    super.initState();
    _resetIngredients();
  }

  void _resetIngredients() {
    _scalingMultiplier = 1.0; // Reset scaling when entering edit mode
    _editableIngredients = List.from(widget.ingredients); // Make a modifiable copy
  }

  void _updateScalingMultiplier(double newMultiplier) {
    if (!widget.isEditable) {
      setState(() {
        _scalingMultiplier = newMultiplier;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditable) {
      _resetIngredients(); // Ensure reset when edit mode is activated
    }

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
          ingredients: _editableIngredients,
          isEditable: widget.isEditable,
          scalingMultiplier: _scalingMultiplier,
        ),
      ],
    );
  }
}