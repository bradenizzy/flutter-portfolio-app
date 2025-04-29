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

  // TODO: For when we implement a "revert to original" feature
  // Future<Recipe> fetchOriginalBackup(String recipeId) async {
  //   final doc = await _firestore.collection('recipes_backup').doc(recipeId).get();
  //   if (!doc.exists) throw Exception("Original backup not found");
  //   return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  // }

}

