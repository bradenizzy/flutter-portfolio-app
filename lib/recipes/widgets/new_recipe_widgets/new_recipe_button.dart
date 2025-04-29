// new_recipe_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/widgets/new_recipe_widgets/recipe_source_selection.dart';
import 'package:flutter_portfolio_app/recipes/widgets/new_recipe_widgets/recipe_title_widget.dart';

class NewRecipeButton extends StatelessWidget {
  final BuildContext context;

  const NewRecipeButton({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          isScrollControlled: true,
          builder: (_) => CreateRecipeSourceWidget(
            onCameraSelected: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeTitleWidget(source: 'Camera'),
              ),
            );
          },
          onPhotosSelected: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeTitleWidget(source: 'Photos'),
              ),
            );
          },
          onManuallySelected: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeTitleWidget(source: 'Manually'),
              ),
            );
          },
          ),
        ),
      child: Text('New Recipe'),
    );
  }
}
