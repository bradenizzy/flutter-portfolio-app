// favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/recipe_preview_card.dart';
import '../widgets/recipe_bottom_nav_bar.dart';
import 'package:flutter_portfolio_app/recipes/screens/complete_recipe_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Initial load
    context.read<UserProfileProvider>().loadFavorites();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<UserProfileProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        provider.hasMoreFavorites) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await context.read<UserProfileProvider>().loadMoreFavorites();
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, favProv, child) {
          final favorites = favProv.favoriteRecipes;

          if (favorites.isEmpty) {
            return Center(
              child: Text('You haven\'t added any favorites yet.'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: favorites.length + (favProv.hasMoreFavorites ? 1 : 0),
            itemBuilder: (ctx, index) {
              if (index < favorites.length) {
                final recipe = favorites[index];
                return RecipePreviewCard(
                  recipe: recipe,
                  onUnfavorite: () => favProv.toggleFavorite(recipe.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteRecipeScreen(recipe: recipe),
                    ),
                  ),
                );
              }

              // Show loading indicator at bottom
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
     bottomNavigationBar: RecipeBottomNavBar(),
    );
  }
}

