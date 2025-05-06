// recipe_list_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe_list.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Provider: RecipeListsProvider
class RecipeListsProvider extends ChangeNotifier {
  final RecipeService recipeService;
  final FirebaseAuth auth;

  List<RecipeList> _lists = [];
  Map<String, List<Recipe>> _listRecipes = {}; // Map listId -> list of full Recipe models

  List<RecipeList> get lists => _lists;
  List<Recipe> getRecipesForList(String listId) => _listRecipes[listId] ?? [];

  RecipeListsProvider({required this.recipeService, required this.auth});

  Future<void> loadLists() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    _lists = await recipeService.fetchRecipeLists(userId);
    _listRecipes.clear();

    for (final list in _lists) {
      final recipes = await recipeService.fetchRecipesByIds(list.recipeIds);
      _listRecipes[list.listId] = recipes;
    }

    notifyListeners();
  }

  Future<void> createNewList(String title) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;
    await recipeService.createRecipeList(userId, title);
    await loadLists();
  }

  Future<void> addRecipeToList(String listId, String recipeId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;
    await recipeService.addRecipeToList(userId, listId, recipeId);
    await loadLists();
  }

  Future<void> removeRecipeFromList(String listId, String recipeId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;
    await recipeService.removeRecipeFromList(userId, listId, recipeId);
    await loadLists();
  }

  Future<void> deleteList(String listId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;
    await recipeService.deleteRecipeList(userId, listId);
    await loadLists();
  }

  void clear() {
    _lists.clear();
    _listRecipes.clear();
    notifyListeners();
  }
}