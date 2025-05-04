// recipe_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _firestore.collection('recipes').doc(recipe.id).update(recipe.toJson());
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  Future<Recipe> fetchRecipe(String recipeId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('recipes').doc(recipeId).get();
      if (!doc.exists) {
        throw Exception('Recipe not found');
      }
      return Recipe.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }

  Future<void> favoriteRecipe(String userId, String recipeId) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('user_profiles').doc(userId);

      await userDocRef.update({
        'favoriteRecipeIds': FieldValue.arrayUnion([recipeId]),
      });
    } catch (e) {
      throw Exception('Failed to favorite recipe: $e');
    }
  }

  Future<void> unfavoriteRecipe(String userId, String recipeId) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('user_profiles').doc(userId);

      await userDocRef.update({
        'favoriteRecipeIds': FieldValue.arrayRemove([recipeId]),
      });
    } catch (e) {
      throw Exception('Failed to unfavorite recipe: $e'); 
    }
  }

  Future<List<Recipe>> fetchRecipesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // Firestore whereIn supports up to 10 items per query
    final List<List<String>> chunks = [];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    }

    final List<Recipe> fetched = [];
    for (var chunk in chunks) {
      final snapshot = await _firestore
          .collection('recipes')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      fetched.addAll(snapshot.docs.map(
        (doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>),
      ));
    }

    // Preserve the order of incoming IDs
    final mapById = {for (var r in fetched) r.id: r};
    return ids
        .map((id) => mapById[id])
        .whereType<Recipe>()
        .toList();
  }

  // TODO: For when we implement a "revert to original" feature
  // Future<Recipe> fetchOriginalBackup(String recipeId) async {
  //   final doc = await _firestore.collection('recipes_backup').doc(recipeId).get();
  //   if (!doc.exists) throw Exception("Original backup not found");
  //   return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  // }

}

