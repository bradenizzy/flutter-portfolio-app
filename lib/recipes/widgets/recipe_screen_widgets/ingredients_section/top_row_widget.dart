// top_row_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/ingredients_section/scaling_ingredients_widget.dart';

class TopRowWidget extends StatelessWidget {
  final double servings;
  final double scalingMultiplier;
  final Function(double) onScalingChanged;

  const TopRowWidget({
    Key? key, 
    required this.servings,
    required this.scalingMultiplier,
    required this.onScalingChanged,
  }) : super(key: key);

  void _openScalingPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ScalingPickerOverlay(
        currentMultiplier: scalingMultiplier,
        onDone: onScalingChanged,
        onRevert: () => onScalingChanged(1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate scaled servings
    double scaledServings = servings * scalingMultiplier;
    String formattedServings = scaledServings.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Ingredients for $formattedServings servings",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.scale),
              onPressed: () => _openScalingPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // TODO: ADD INGREDIENTS TO A SHOPPING LIST
              },
            ),
          ],
        ),
      ],
    );
  }
}