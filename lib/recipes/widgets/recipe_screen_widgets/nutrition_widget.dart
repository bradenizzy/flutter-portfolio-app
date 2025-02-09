// nutrition_widget.dart

import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class NutritionWidget extends StatefulWidget {
  final Nutrition nutrition;

  const NutritionWidget({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  @override
  State<NutritionWidget> createState() => _NutritionWidgetState();
}

class _NutritionWidgetState extends State<NutritionWidget> {
  bool _isExpanded = false;

  String _formatValue(dynamic value, {String? unit}) {
    if (value == null) return 'Unknown';
    return unit != null ? '$value$unit' : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nutrition Info',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      _isExpanded ? 'Hide Info' : 'Show Info',
                      style: TextStyle(
                        color: Colors.pink[300],
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.remove : Icons.add,
                      color: Colors.pink[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 20),
            _buildNutritionRow('calories', _formatValue(widget.nutrition.calories)),
            _buildDivider(),
            _buildNutritionRow('fat', _formatValue(widget.nutrition.fat, unit: 'g')),
            _buildDivider(),
            _buildNutritionRow('carbs', _formatValue(widget.nutrition.carbs, unit: 'g')),
            _buildDivider(),
            _buildNutritionRow('protein', _formatValue(widget.nutrition.protein, unit: 'g')),
            _buildDivider(),
            _buildNutritionRow('sugar', _formatValue(widget.nutrition.sugar, unit: 'g')),
            _buildDivider(),
            _buildNutritionRow('fiber', _formatValue(widget.nutrition.fiber, unit: 'g')),
            const SizedBox(height: 20),
            const Text(
              'Estimated values based on one serving size.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[800],
    );
  }
}