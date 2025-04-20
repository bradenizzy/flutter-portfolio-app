import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class NutritionWidget extends StatefulWidget {
  final Nutrition nutrition;
  final bool isEditable;
  final Function(Nutrition updated)? onNutritionChanged;

  const NutritionWidget({
    Key? key,
    required this.nutrition,
    this.isEditable = false,
    this.onNutritionChanged,
  }) : super(key: key);

  @override
  State<NutritionWidget> createState() => _NutritionWidgetState();
}

class _NutritionWidgetState extends State<NutritionWidget> {
  late Nutrition _editableNutrition;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _editableNutrition = widget.nutrition.copyWith();
  }

  @override
  void didUpdateWidget(NutritionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nutrition != oldWidget.nutrition) {
      setState(() {
        _editableNutrition = widget.nutrition.copyWith();
      });
    }
  }

  String _displayValue(double? value, {String? unit}) {
    if (value == null) return '?';
    return unit != null ? '$value$unit' : value.toString();
  }

  void _updateValue(String field, String newValue) {
    final bool shouldRemove = newValue.trim().isEmpty;
    final double? parsed = shouldRemove ? null : double.tryParse(newValue);

    setState(() {
      _editableNutrition = switch (field) {
        'calories' => _editableNutrition.copyWith(
          calories: parsed, removeCalories: shouldRemove),
        'fat' => _editableNutrition.copyWith(
          fat: parsed, removeFat: shouldRemove),
        'carbs' => _editableNutrition.copyWith(
          carbs: parsed, removeCarbs: shouldRemove),
        'protein' => _editableNutrition.copyWith(
          protein: parsed, removeProtein: shouldRemove),
        'sugar' => _editableNutrition.copyWith(
          sugar: parsed, removeSugar: shouldRemove),
        'fiber' => _editableNutrition.copyWith(
          fiber: parsed, removeFiber: shouldRemove),
        _ => _editableNutrition,
      };
    });
    widget.onNutritionChanged?.call(_editableNutrition);
  }

  Widget _buildEditableRow(String label, double? value, String field, {String unit = 'g'}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          SizedBox(
            width: 100,
            child: TextFormField(
              initialValue: value?.toString() ?? '',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) => _updateValue(field, val),
              decoration: InputDecoration(
                suffixText: field == 'calories' ? 'cal' : unit,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayRow(String label, double? value, {String unit = ' g'}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            _displayValue(value, unit: label == 'Calories' ? ' cal' : unit),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nutrition Info',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(_isExpanded ? Icons.remove : Icons.add, color: theme.colorScheme.primary),
                label: Text(
                  _isExpanded ? 'Hide Info' : 'Show Info',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
          if (_isExpanded)
            Column(
              children: [
                const SizedBox(height: 16),
                widget.isEditable
                    ? _buildEditableRow('Calories', _editableNutrition.calories, 'calories')
                    : _buildDisplayRow('Calories', _editableNutrition.calories),
                const Divider(),
                widget.isEditable
                    ? _buildEditableRow('Fat', _editableNutrition.fat, 'fat')
                    : _buildDisplayRow('Fat', _editableNutrition.fat),
                const Divider(),
                widget.isEditable
                    ? _buildEditableRow('Carbs', _editableNutrition.carbs, 'carbs')
                    : _buildDisplayRow('Carbs', _editableNutrition.carbs),
                const Divider(),
                widget.isEditable
                    ? _buildEditableRow('Protein', _editableNutrition.protein, 'protein')
                    : _buildDisplayRow('Protein', _editableNutrition.protein),
                const Divider(),
                widget.isEditable
                    ? _buildEditableRow('Sugar', _editableNutrition.sugar, 'sugar')
                    : _buildDisplayRow('Sugar', _editableNutrition.sugar),
                const Divider(),
                widget.isEditable
                    ? _buildEditableRow('Fiber', _editableNutrition.fiber, 'fiber')
                    : _buildDisplayRow('Fiber', _editableNutrition.fiber),
                const SizedBox(height: 20),
                const Text(
                  'Estimated values based on one serving size.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

// class NutritionWidget extends StatefulWidget {
//   final Nutrition nutrition;

//   const NutritionWidget({
//     Key? key,
//     required this.nutrition,
//   }) : super(key: key);

//   @override
//   State<NutritionWidget> createState() => _NutritionWidgetState();
// }

// class _NutritionWidgetState extends State<NutritionWidget> {
//   bool _isExpanded = false;

//   String _formatValue(dynamic value, {String? unit}) {
//     if (value == null) return 'Unknown';
//     return unit != null ? '$value$unit' : value.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         children: [
//           // Header Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Nutrition Info',
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () => setState(() => _isExpanded = !_isExpanded),
//                 icon: Icon(
//                   _isExpanded ? Icons.remove : Icons.add,
//                   color: theme.colorScheme.primary,
//                 ),
//                 label: Text(
//                   _isExpanded ? 'Hide Info' : 'Show Info',
//                   style: TextStyle(color: theme.colorScheme.primary),
//                 ),
//               ),
//             ],
//           ),
//           if (_isExpanded) ...[
//             const SizedBox(height: 20),
//             _buildNutritionRow('Calories', _formatValue(widget.nutrition.calories)),
//             _buildDivider(),
//             _buildNutritionRow('Fat', _formatValue(widget.nutrition.fat, unit: 'g')),
//             _buildDivider(),
//             _buildNutritionRow('Carbs', _formatValue(widget.nutrition.carbs, unit: 'g')),
//             _buildDivider(),
//             _buildNutritionRow('Protein', _formatValue(widget.nutrition.protein, unit: 'g')),
//             _buildDivider(),
//             _buildNutritionRow('Sugar', _formatValue(widget.nutrition.sugar, unit: 'g')),
//             _buildDivider(),
//             _buildNutritionRow('Fiber', _formatValue(widget.nutrition.fiber, unit: 'g')),
//             const SizedBox(height: 20),
//             const Text(
//               'Estimated values based on one serving size.',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildNutritionRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16)),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(color: Colors.grey.shade300, thickness: 1);
//   }
// }