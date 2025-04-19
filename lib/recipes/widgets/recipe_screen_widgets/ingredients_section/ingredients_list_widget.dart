// ingredients_list_widget.dart

import 'package:flutter/material.dart';
import 'single_ingredient_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsListWidget extends StatefulWidget {
  final List<Ingredient> ingredients;
  final bool isEditable;
  final double scalingMultiplier;

  // TESTING
  final Function(List<Ingredient>)? onIngredientsChanged;

  const IngredientsListWidget({
    Key? key,
    required this.ingredients,
    required this.isEditable,
    required this.scalingMultiplier,

    // TESTING
    this.onIngredientsChanged,
  }) : super(key: key);

  @override
  _IngredientsListWidgetState createState() => _IngredientsListWidgetState();
}

class _IngredientsListWidgetState extends State<IngredientsListWidget> {

  @override
  void initState() {
    super.initState();
  }

  // TESTING
  void _addIngredient() {
    final updatedIngredients = List<Ingredient>.from(widget.ingredients)
      ..add(Ingredient(quantity: '1', unit: 'unit', name: 'New Ingredient'));
    widget.onIngredientsChanged?.call(updatedIngredients);
  }

  void _removeIngredient(int index) {
    final updatedIngredients = List<Ingredient>.from(widget.ingredients)
      ..removeAt(index);
    widget.onIngredientsChanged?.call(updatedIngredients);
  }
  // void _addIngredient() {
  //   setState(() {
  //     widget.ingredients.add(Ingredient(quantity: '1', unit: 'unit', name: 'New Ingredient'));
  //   });
  // }

  // void _removeIngredient(int index) {
  //   setState(() {
  //     widget.ingredients.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.ingredients.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey("${widget.ingredients[index].name}_$index"),
              direction: widget.isEditable ? DismissDirection.endToStart : DismissDirection.none,
              onDismissed: (direction) => _removeIngredient(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: SingleIngredientWidget(
                ingredient: widget.ingredients[index],
                isEditable: widget.isEditable,
                scalingMultiplier: widget.scalingMultiplier,
              ),
            );
          },
        ),
        if (widget.isEditable)
          ElevatedButton.icon(
            onPressed: _addIngredient,
            icon: const Icon(Icons.add),
            label: const Text("Add Ingredient"),
          ),
      ],
    );
  }
}
