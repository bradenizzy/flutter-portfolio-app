// single_ingredient_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class SingleIngredientWidget extends StatelessWidget {
  final Ingredient ingredient;
  final bool isEditable;
  final double scalingMultiplier;

  const SingleIngredientWidget({
    Key? key,
    required this.ingredient,
    required this.isEditable,
    required this.scalingMultiplier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaledQuantity = _calculateScaledQuantity(ingredient.quantity);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: isEditable
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(initialValue: ingredient.name),
                  ),
                  const SizedBox(width: 10),
                  _buildTextField(initialValue: ingredient.quantity, width: 50),
                  const SizedBox(width: 10),
                  _buildTextField(initialValue: ingredient.unit, width: 60),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    "$scaledQuantity ${ingredient.unit}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
        ),
        const Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildTextField({required String initialValue, double? width}) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    );
  }

  double _calculateScaledQuantity(String quantity) {
    try {
      return double.parse(quantity) * scalingMultiplier;
    } catch (e) {
      return 0.0; // Handle cases where quantity is not numeric
    }
  }
}
