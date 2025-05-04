// user_profile_provider.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

/// Provider: UserProfileProvider (with Favorites logic)
class UserProfileProvider extends ChangeNotifier {
  final RecipeService recipeService = RecipeService();
  UserProfile? _userProfile;
  List<Recipe> _favoriteRecipes = [];
  bool _hasMoreFavorites = true;
  String? _lastFavoriteId;

  UserProfile? get userProfile => _userProfile;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  bool get hasMoreFavorites => _hasMoreFavorites;

  /// Initialize or update the user profile
  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    _favoriteRecipes.clear();
    _hasMoreFavorites = true;
    _lastFavoriteId = null;
    notifyListeners();
    loadFavorites();
  }

  /// Load favorites with optional refresh
  Future<void> loadFavorites({bool refresh = false}) async {
    if (_userProfile == null) return;
    if (refresh) {
      _favoriteRecipes.clear();
      _lastFavoriteId = null;
      _hasMoreFavorites = true;
    }
    if (!_hasMoreFavorites) return;

    final allIds = _userProfile!.favoriteRecipeIds;
    final startIndex = _lastFavoriteId == null
        ? 0
        : allIds.indexOf(_lastFavoriteId!) + 1;
    final batchIds = allIds.skip(startIndex).take(10).toList();

    if (batchIds.isEmpty) {
      _hasMoreFavorites = false;
      notifyListeners();
      return;
    }

    final recipes = await recipeService.fetchRecipesByIds(batchIds);
    _favoriteRecipes.addAll(recipes);

    _lastFavoriteId = batchIds.last;
    _hasMoreFavorites = startIndex + batchIds.length < allIds.length;
    notifyListeners();
  }

  /// Load the next page of favorites
  Future<void> loadMoreFavorites() async => loadFavorites(refresh: false);

  /// Toggle favorite status locally and in Firestore
  Future<void> toggleFavorite(String recipeId) async {
    if (_userProfile == null) return;
    final userId = _userProfile!.userId;
    final ids = List<String>.from(_userProfile!.favoriteRecipeIds);

    if (ids.contains(recipeId)) {
      // Unfavorite
      ids.remove(recipeId);
      _favoriteRecipes.removeWhere((r) => r.id == recipeId);
      await recipeService.unfavoriteRecipe(userId, recipeId);
    } else {
      // Favorite
      ids.insert(0, recipeId);
      await recipeService.favoriteRecipe(userId, recipeId);

      // Fetch and add full recipe model to _favoriteRecipes
      final recipe = await recipeService.fetchRecipe(recipeId);
      _favoriteRecipes.insert(0, recipe);
    }

    _userProfile = _userProfile!.copyWith(favoriteRecipeIds: ids);
    notifyListeners();
  }

  /// Clear all user data
  void clear() {
    _userProfile = null;
    _favoriteRecipes.clear();
    _hasMoreFavorites = true;
    _lastFavoriteId = null;
    notifyListeners();
  }
}