// recipe_preview.dart

// TODO: implement the menu item functions
// TODO: remove a recipe from a list using the menu?

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/user_profile_provider.dart';

/// Shows a thumbnail, title, subtitle, unfavorite button, and an overflow menu for actions.
class RecipePreviewCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;
  final VoidCallback? onShare;
  final VoidCallback? onAddToList;

  const RecipePreviewCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    required this.onUnfavorite,
    this.onShare,
    this.onAddToList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: want a thumbnail? need to set a "main picture" type url or just grab the first url in "images" list
              // // Thumbnail
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: recipe.imageUrl != null
              //       ? Image.network(
              //           recipe.imageUrl!,
              //           width: 80,
              //           height: 80,
              //           fit: BoxFit.cover,
              //         )
              //       : Container(
              //           width: 80,
              //           height: 80,
              //           color: Colors.grey.shade200,
              //           child: Icon(Icons.image, size: 40, color: Colors.grey),
              //         ),
              // ),
              //const SizedBox(width: 12),

              // Title & metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Favorite button
              Consumer<UserProfileProvider>(
                builder: (context, userProfileProvider, child) {
                  final isFavorited = userProfileProvider.favoriteRecipes.any((r) => r.id == recipe.id);
                  return IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: onUnfavorite,
                    tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
                  );
                },
              ),
              // Overflow menu for additional actions
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'share':
                      if (onShare != null) onShare!();
                      break;
                    case 'add':
                      if (onAddToList != null) onAddToList!();
                      break;
                    case 'remove':
                      //if (onRemoveFromList != null) onRemoveFromList!();
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Text('Share'),
                  ),
                  PopupMenuItem(
                    value: 'add',
                    child: Text('Add to List'),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove from List'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
