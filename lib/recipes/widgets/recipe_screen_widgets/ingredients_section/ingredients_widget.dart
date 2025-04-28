// ingredients_widget.dart
import 'package:flutter/material.dart';
import 'top_row_widget.dart';
import 'ingredients_list_widget.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class IngredientsWidget extends StatefulWidget {
  final bool isEditable;
  final List<Ingredient> ingredients;
  final double servings;
  final String servingsUnit;
  final Function(List<Ingredient>)? onIngredientsChanged;
  final Function(double)? onServingsChanged;
  final Function(String)? onServingsUnitChanged;
  

  const IngredientsWidget({
    Key? key,
    this.isEditable = false,
    required this.ingredients,
    required this.servings,
    required this.servingsUnit,
    this.onIngredientsChanged,
    this.onServingsChanged,
    this.onServingsUnitChanged,
  }) : super(key: key);

  @override
  _IngredientsWidgetState createState() => _IngredientsWidgetState();
}

class _IngredientsWidgetState extends State<IngredientsWidget> {
  double _scalingMultiplier = 1.0;
  late List<Ingredient> _editableIngredients;
  late double _editableServings;

  @override
  void initState() {
    super.initState();
    _resetIngredients();
  }

  @override
  void didUpdateWidget(covariant IngredientsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ingredients != oldWidget.ingredients) {
      _resetIngredients();
    }
  }

  void _resetIngredients() {
    _scalingMultiplier = 1.0;
    _editableIngredients = List.from(widget.ingredients);
    _editableServings = widget.servings;
  }

  void _updateScalingMultiplier(double newMultiplier) {
    if (!widget.isEditable) {
      setState(() {
        _scalingMultiplier = newMultiplier;
      });
    }
  }

  void _updateServings(String newServings) {
    final parsed = double.tryParse(newServings);
    if (parsed != null) {
      setState(() {
        _editableServings = parsed;
      });
      widget.onServingsChanged?.call(parsed);
    }
  }

  void _updateIngredients(List<Ingredient> newIngredients) {
    setState(() {
      _editableIngredients = newIngredients;
    });
    widget.onIngredientsChanged?.call(newIngredients);
  }

  void _updateServingsUnit(String newServingsUnit) {
    setState(() {
      widget.onServingsUnitChanged?.call(newServingsUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditable) {
      _resetIngredients();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TopRowWidget(
          servings: _editableServings,
          servingsUnit: widget.servingsUnit,
          scalingMultiplier: _scalingMultiplier,
          isEditable: widget.isEditable,
          onScalingChanged: _updateScalingMultiplier,
          onServingsChanged: _updateServings,
          onServingsUnitChanged: _updateServingsUnit,
        ),
        const SizedBox(height: 16),
        IngredientsListWidget(
          ingredients: _editableIngredients,
          isEditable: widget.isEditable,
          scalingMultiplier: _scalingMultiplier,
          onIngredientsChanged: _updateIngredients,
        ),
      ],
    );
  }
}