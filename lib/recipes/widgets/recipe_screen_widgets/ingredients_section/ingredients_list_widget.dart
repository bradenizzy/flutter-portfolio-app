// ingredients_list_widget.dart
import 'package:flutter/material.dart';
import 'single_ingredient_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsListWidget extends StatefulWidget {
  final List<Ingredient> ingredients;
  final bool isEditable;
  final double scalingMultiplier;

  final Function(List<Ingredient>)? onIngredientsChanged;

  const IngredientsListWidget({
    Key? key,
    required this.ingredients,
    required this.isEditable,
    required this.scalingMultiplier,
    this.onIngredientsChanged,
  }) : super(key: key);

  @override
  _IngredientsListWidgetState createState() => _IngredientsListWidgetState();
}

class _IngredientsListWidgetState extends State<IngredientsListWidget> {

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

  void _updateIngredientAtIndex(int index, Ingredient updated) {
    final updatedIngredients = List<Ingredient>.from(widget.ingredients);
    updatedIngredients[index] = updated;
    widget.onIngredientsChanged?.call(updatedIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.ingredients.length,
          itemBuilder: (context, index) {
            final ingredient = widget.ingredients[index];

            return Dismissible(
              key: ValueKey(ingredient.id),
              direction: widget.isEditable ? DismissDirection.endToStart : DismissDirection.none,
              onDismissed: (_) => _removeIngredient(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: SingleIngredientWidget(
                ingredient: ingredient,
                isEditable: widget.isEditable,
                scalingMultiplier: widget.scalingMultiplier,
                onChanged: widget.isEditable
                    ? (updatedIngredient) => _updateIngredientAtIndex(index, updatedIngredient)
                    : null,
              ),
            );
          },
        ),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
            ),
          ),
      ],
    );
  }
}