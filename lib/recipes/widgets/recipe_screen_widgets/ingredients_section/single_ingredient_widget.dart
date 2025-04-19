// single_ingredient_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class SingleIngredientWidget extends StatefulWidget {
  final Ingredient ingredient;
  final bool isEditable;
  final double scalingMultiplier;
  final Function(Ingredient)? onChanged;

  const SingleIngredientWidget({
    Key? key,
    required this.ingredient,
    required this.isEditable,
    required this.scalingMultiplier,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SingleIngredientWidget> createState() => _SingleIngredientWidgetState();
}

class _SingleIngredientWidgetState extends State<SingleIngredientWidget> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredient.name);
    _quantityController = TextEditingController(text: widget.ingredient.quantity);
    _unitController = TextEditingController(text: widget.ingredient.unit);
  }

  @override
  void didUpdateWidget(covariant SingleIngredientWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update controllers if the ingredient changed (prevents reset during editing)
    if (widget.ingredient != oldWidget.ingredient) {
      _nameController.text = widget.ingredient.name;
      _quantityController.text = widget.ingredient.quantity;
      _unitController.text = widget.ingredient.unit;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scaledQuantity = _calculateScaledQuantity(widget.ingredient.quantity);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: widget.isEditable
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildTextField(controller: _nameController, onChanged: (value) {
                        widget.onChanged?.call(widget.ingredient.copyWith(name: value));
                      }),
                    ),
                    const SizedBox(width: 10),
                    _buildTextField(
                      controller: _quantityController,
                      width: 50,
                      onChanged: (value) {
                        widget.onChanged?.call(widget.ingredient.copyWith(quantity: value));
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildTextField(
                      controller: _unitController,
                      width: 60,
                      onChanged: (value) {
                        widget.onChanged?.call(widget.ingredient.copyWith(unit: value));
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.ingredient.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      "$scaledQuantity ${widget.ingredient.unit}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
        ),
        const Divider(height: 1, thickness: 0.5, color: Colors.grey),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    double? width,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  double _calculateScaledQuantity(String quantity) {
    try {
      return double.parse(quantity) * widget.scalingMultiplier;
    } catch (e) {
      return 0.0;
    }
  }
}