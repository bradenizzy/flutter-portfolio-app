// recipe_list_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe_list.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider: RecipeListsProvider
class RecipeListsProvider extends ChangeNotifier {
  final RecipeService recipeService;
  final FirebaseAuth auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<RecipeList> _lists = [];
  Map<String, List<Recipe>> _listRecipes = {}; // Map listId -> list of full Recipe models

  List<RecipeList> get lists => _lists;
  List<Recipe> getRecipesForList(String listId) => _listRecipes[listId] ?? [];

  RecipeListsProvider({required this.recipeService, required this.auth});

  Future<void> loadLists() async {
      final user = auth.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('user_profiles')
          .doc(user.uid)
          .collection('lists')
          .orderBy('order') // 📌 sort by custom order
          .get();

      _lists = snapshot.docs.map((doc) {
        return RecipeList.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Load recipes for each list
      for (var list in _lists) {
        if (list.recipeIds.isNotEmpty) {
          final recipes = await recipeService.fetchRecipesByIds(list.recipeIds);
          _listRecipes[list.listId] = recipes;
        } else {
          _listRecipes[list.listId] = [];
        }
      }

      notifyListeners();
    }

  Future<void> createNewList(String title) async {
    final user = auth.currentUser;
    if (user == null) return;

    // Get the highest current order value
    int maxOrder = _lists.isEmpty ? 0 : _lists.map((list) => list.order).reduce((a, b) => a > b ? a : b);

    final newListRef = _firestore
        .collection('user_profiles')
        .doc(user.uid)
        .collection('lists')
        .doc(); // auto-ID

    final newList = RecipeList(
      listId: newListRef.id,
      title: title,
      order: maxOrder + 1,
      ownerId: user.uid,
      recipeIds: [],
    );

    await newListRef.set(newList.toMap());

    _lists.add(newList);
    notifyListeners();
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

  void removeRecipeFromLists(String recipeId) {
    _listRecipes.forEach((listId, recipes) {
      _listRecipes[listId] = recipes.where((r) => r.id != recipeId).toList();
    });

    _lists = _lists.map((list) {
      return list.copyWith(
        recipeIds: list.recipeIds.where((id) => id != recipeId).toList(),
      );
    }).toList();

    notifyListeners();
  }

  Future<void> deleteList(String listId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    await recipeService.deleteRecipeList(userId, listId);
    _lists.removeWhere((list) => list.listId == listId);

    // Reindex remaining lists
    for (int i = 0; i < _lists.length; i++) {
      _lists[i] = _lists[i].copyWith(order: i);
      await _firestore
          .collection('user_profiles')
          .doc(userId)
          .collection('lists')
          .doc(_lists[i].listId)
          .update({'order': i});
    }

    notifyListeners();
  }

  Future<void> reorderLists(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final list = _lists.removeAt(oldIndex);
    _lists.insert(newIndex, list);

    // Reindex order fields
    for (int i = 0; i < _lists.length; i++) {
      _lists[i] = _lists[i].copyWith(order: i);
      await _firestore
          .collection('user_profiles')
          .doc(auth.currentUser!.uid)
          .collection('lists')
          .doc(_lists[i].listId)
          .update({'order': i});
    }

    notifyListeners();
  }

  void clear() {
    _lists.clear();
    _listRecipes.clear();
    notifyListeners();
  }

  // TODO: add an UNDO function to the delete list function???
}