// favorite_button_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final String recipeId;

  const FavoriteButtonWidget({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = context.watch<UserProfileProvider>();
    final isFavorited = userProfileProvider.userProfile?.favoriteRecipeIds.contains(recipeId) ?? false;

    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        userProfileProvider.toggleFavorite(recipeId);
      },
    );
  }
}