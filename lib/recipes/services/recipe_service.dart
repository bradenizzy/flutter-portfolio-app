// recipe_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _firestore.collection('recipes').doc(recipe.id).update(recipe.toJson());
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }
}

Future<void> showDiscardChangesDialog(BuildContext context, VoidCallback onDiscard) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to discard them?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDiscard();
            },
            child: Text('Discard'),
          ),
        ],
      );
    },
  );
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


