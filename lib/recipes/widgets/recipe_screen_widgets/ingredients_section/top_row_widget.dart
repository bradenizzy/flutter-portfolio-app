// top_row_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/ingredients_section/scaling_ingredients_widget.dart';


class TopRowWidget extends StatefulWidget {
  @override
  _TopRowWidgetState createState() => _TopRowWidgetState();
}

class _TopRowWidgetState extends State<TopRowWidget> {
  double _scalingMultiplier = 1.0; // Default multiplier

  void _openScalingPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure full visibility
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ScalingPickerOverlay(
        currentMultiplier: _scalingMultiplier,
        onDone: (double multiplier) {
          setState(() {
            _scalingMultiplier = multiplier;
          });
        },
        onRevert: () {
          setState(() {
            _scalingMultiplier = 1.0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the multiplier to show at most 2 decimal places and remove trailing zeros
    String formattedMultiplier = _scalingMultiplier.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Ingredients for $formattedMultiplier servings",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.scale),
              onPressed: _openScalingPicker,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Handle edit action TODO: ADD EDIT ACTION
              },
            ),
          ],
        ),
      ],
    );
  }
}