// ingredients_list_widget.dart

import 'package:flutter/material.dart';
import 'single_ingredient_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsListWidget extends StatefulWidget {
  final List<Ingredient> ingredients;
  final bool isEditable;
  final double scalingMultiplier;

  const IngredientsListWidget({
    Key? key,
    required this.ingredients,
    required this.isEditable,
    required this.scalingMultiplier,
  }) : super(key: key);

  @override
  _IngredientsListWidgetState createState() => _IngredientsListWidgetState();
}

class _IngredientsListWidgetState extends State<IngredientsListWidget> {
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = List.from(widget.ingredients); // Create a modifiable list copy
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add(Ingredient(quantity: '1', unit: 'unit', name: 'New Ingredient'));
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _ingredients.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey("${_ingredients[index].name}_$index"),
              //key: ValueKey(_ingredients[index]),
              direction: widget.isEditable ? DismissDirection.endToStart : DismissDirection.none,
              onDismissed: (direction) => _removeIngredient(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: SingleIngredientWidget(
                ingredient: _ingredients[index],
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
