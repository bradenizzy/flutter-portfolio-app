// favorite_button_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';

class FavoriteButtonWidget extends StatefulWidget {
  final String userId;
  final String recipeId;
  final RecipeService recipeService;
  final List<String> currentFavoriteIds; // Pass the user's favorite list
  final void Function(List<String> updatedFavorites)? onFavoritesChanged; // Optional callback if you want to react in parent widget

  const FavoriteButtonWidget({
    Key? key,
    required this.userId,
    required this.recipeId,
    required this.currentFavoriteIds,
    required this.recipeService,
    this.onFavoritesChanged,
  }) : super(key: key);

  @override
  _FavoriteButtonWidgetState createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.currentFavoriteIds.contains(widget.recipeId);
  }

  Future<void> _toggleFavorite() async {
    try {
      if (isFavorited) {
        await widget.recipeService.unfavoriteRecipe(widget.userId, widget.recipeId);
      } else {
        await widget.recipeService.favoriteRecipe(widget.userId, widget.recipeId);
      }

      setState(() {
        isFavorited = !isFavorited;
      });

      if (widget.onFavoritesChanged != null) {
        List<String> updatedFavorites = List.from(widget.currentFavoriteIds);
        if (isFavorited) {
          updatedFavorites.add(widget.recipeId);
        } else {
          updatedFavorites.remove(widget.recipeId);
        }
        widget.onFavoritesChanged!(updatedFavorites);
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      // You might want to show a snackbar or other error UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.star : Icons.star_border,
        color: isFavorited ? Colors.yellow : Colors.grey,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
