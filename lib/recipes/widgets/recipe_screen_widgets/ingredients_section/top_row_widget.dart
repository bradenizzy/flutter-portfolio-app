// top_row_widget.dart
import 'package:flutter/material.dart';
import 'scaling_ingredients_widget.dart';

class TopRowWidget extends StatelessWidget {
  final double servings;
  final String servingsUnit;
  final double scalingMultiplier;
  final Function(double) onScalingChanged;
  final bool isEditable;
  final Function(String)? onServingsChanged;
  final Function(String)? onServingsUnitChanged;

  const TopRowWidget({
    Key? key,
    required this.servings,
    required this.servingsUnit,
    required this.scalingMultiplier,
    required this.onScalingChanged,
    this.isEditable = false,
    this.onServingsChanged,
    this.onServingsUnitChanged,
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
    double scaledServings = servings * scalingMultiplier;
    String formattedServings = scaledServings.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    String displayServingsUnit = servingsUnit.isEmpty ? "Servings" : servingsUnit;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isEditable) ...[
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: servings.toString(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: onServingsChanged,
              decoration: const InputDecoration(
                labelText: "Servings",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: TextFormField(
              initialValue: displayServingsUnit,
              onChanged: onServingsUnitChanged,
              decoration: const InputDecoration(
                labelText: "Unit",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ] else
          Text(
            "$formattedServings $displayServingsUnit",
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
                // TODO: Implement shopping list
              },
            ),
          ],
        ),
      ],
    );
  }
}