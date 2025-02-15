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
// class NutritionWidget extends StatefulWidget {
//   final Nutrition nutrition;

//   /// Whether the fields are editable or read-only.
//   final bool isEditable;

//   /// Callback to notify parent of any changes in the Nutrition fields.
//   /// In practice, you might just pass in an entire updated Nutrition object
//   /// or pass each field value one by one. Below we do an example that
//   /// passes field, newValue, so the parent can update the model accordingly.
//   final void Function(String fieldName, String newValue)? onNutritionChanged;

//   const NutritionWidget({
//     Key? key,
//     required this.nutrition,
//     this.isEditable = false,
//     this.onNutritionChanged,
//   }) : super(key: key);

//   @override
//   State<NutritionWidget> createState() => _NutritionWidgetState();
// }

// class _NutritionWidgetState extends State<NutritionWidget> {
//   bool _isExpanded = false;

//   late TextEditingController _caloriesController;
//   late TextEditingController _fatController;
//   late TextEditingController _carbsController;
//   late TextEditingController _proteinController;
//   late TextEditingController _sugarController;
//   late TextEditingController _fiberController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   /// Initialize each field from the widget.nutrition values.
//   void _initializeControllers() {
//     _caloriesController = TextEditingController(
//       text: widget.nutrition.calories.toString(),
//     );
//     _fatController = TextEditingController(
//       text: widget.nutrition.fat.toString(),
//     );
//     _carbsController = TextEditingController(
//       text: widget.nutrition.carbs.toString(),
//     );
//     _proteinController = TextEditingController(
//       text: widget.nutrition.protein.toString(),
//     );
//     _sugarController = TextEditingController(
//       text: widget.nutrition.sugar.toString(),
//     );
//     _fiberController = TextEditingController(
//       text: widget.nutrition.fiber.toString(),
//     );
//   }

//   /// If the parent replaces the entire nutrition object with a new one,
//   /// we may want to re-initialize the controllers. One naive approach:
//   @override
//   void didUpdateWidget(NutritionWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.nutrition != oldWidget.nutrition) {
//       _initializeControllers();
//     }
//   }

//   @override
//   void dispose() {
//     _caloriesController.dispose();
//     _fatController.dispose();
//     _carbsController.dispose();
//     _proteinController.dispose();
//     _sugarController.dispose();
//     _fiberController.dispose();
//     super.dispose();
//   }

//   /// Helper: If in read-only mode, just display text.
//   /// If in edit mode, display a TextField with an onChanged that
//   /// notifies the parent.
//   Widget _buildValueWidget({
//     required String fieldName,
//     required TextEditingController controller,
//     String? unit,
//   }) {
//     if (!widget.isEditable) {
//       // Read-only mode
//       String displayValue = controller.text;
//       if (displayValue.isEmpty) {
//         displayValue = 'Unknown';
//       }
//       return Text(
//         unit != null ? '$displayValue$unit' : displayValue,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//     } else {
//       // Edit mode
//       return SizedBox(
//         width: 80, // Adjust as needed
//         child: TextField(
//           controller: controller,
//           style: const TextStyle(color: Colors.white, fontSize: 18),
//           keyboardType: TextInputType.number, // if you want numeric only
//           decoration: InputDecoration(
//             // Show "g" or "cal" etc. within the field? Up to you.
//             hintText: unit != null ? 'Enter $fieldName ($unit)' : 'Enter $fieldName',
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.white54),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.pink),
//             ),
//           ),
//           onChanged: (value) {
//             // Notify parent about changes, so it can update the model
//             widget.onNutritionChanged?.call(fieldName, value);
//           },
//         ),
//       );
//     }
//   }

//   Widget _buildNutritionRow(
//     String label,
//     TextEditingController controller, {
//     String? unit,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Label on the left
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//             ),
//           ),
//           // Value or editable field on the right
//           _buildValueWidget(
//             fieldName: label,
//             controller: controller,
//             unit: unit,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       height: 1,
//       color: Colors.grey[800],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           // Row with "Nutrition Info" and Show/Hide button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Nutrition Info',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _isExpanded = !_isExpanded;
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     Text(
//                       _isExpanded ? 'Hide Info' : 'Show Info',
//                       style: TextStyle(
//                         color: Colors.pink[300],
//                         fontSize: 18,
//                       ),
//                     ),
//                     Icon(
//                       _isExpanded ? Icons.remove : Icons.add,
//                       color: Colors.pink[300],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (_isExpanded) ...[
//             const SizedBox(height: 20),
//             _buildNutritionRow('calories', _caloriesController),
//             _buildDivider(),
//             _buildNutritionRow('fat', _fatController, unit: 'g'),
//             _buildDivider(),
//             _buildNutritionRow('carbs', _carbsController, unit: 'g'),
//             _buildDivider(),
//             _buildNutritionRow('protein', _proteinController, unit: 'g'),
//             _buildDivider(),
//             _buildNutritionRow('sugar', _sugarController, unit: 'g'),
//             _buildDivider(),
//             _buildNutritionRow('fiber', _fiberController, unit: 'g'),
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
// }
