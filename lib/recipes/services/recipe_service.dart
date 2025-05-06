import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../models/recipe_list.dart';

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
      DocumentSnapshot doc = await _firestore.collection('recipes').doc(recipeId).get();
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
      final userDocRef = _firestore.collection('user_profiles').doc(userId);

      await userDocRef.update({
        'favoriteRecipeIds': FieldValue.arrayUnion([recipeId]),
      });
    } catch (e) {
      throw Exception('Failed to favorite recipe: $e');
    }
  }

  Future<void> unfavoriteRecipe(String userId, String recipeId) async {
    try {
      final userDocRef = _firestore.collection('user_profiles').doc(userId);

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

  // ───────────────────────────────────────────────────────────────
  // Recipe Lists (Cookbooks)
  // ───────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _userListsRef(String userId) {
    return _firestore.collection('user_profiles').doc(userId).collection('lists');
  }

  Future<List<RecipeList>> fetchRecipeLists(String userId) async {
    try {
      final snapshot = await _userListsRef(userId).get();
      return snapshot.docs
          .map((doc) => RecipeList.fromDoc(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recipe lists: $e');
    }
  }

  Future<void> createRecipeList(String userId, String title) async {
    try {
      await _userListsRef(userId).add({
        'title': title,
        'ownerId': userId,
        'recipeIds': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create recipe list: $e');
    }
  }

  Future<void> addRecipeToList(String userId, String listId, String recipeId) async {
    try {
      final listRef = _userListsRef(userId).doc(listId);
      await listRef.update({
        'recipeIds': FieldValue.arrayUnion([recipeId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add recipe to list: $e');
    }
  }

  Future<void> removeRecipeFromList(String userId, String listId, String recipeId) async {
    try {
      final listRef = _userListsRef(userId).doc(listId);
      await listRef.update({
        'recipeIds': FieldValue.arrayRemove([recipeId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove recipe from list: $e');
    }
  }

  Future<void> deleteRecipeList(String userId, String listId) async {
    try {
      await _userListsRef(userId).doc(listId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe list: $e');
    }
  }

  // TODO: For when we implement a "revert to original" feature
  // Future<Recipe> fetchOriginalBackup(String recipeId) async {
  //   final doc = await _firestore.collection('recipes_backup').doc(recipeId).get();
  //   if (!doc.exists) throw Exception("Original backup not found");
  //   return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  // }
}

// // recipe_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/recipe.dart';

// class RecipeService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> updateRecipe(Recipe recipe) async {
//     try {
//       await _firestore.collection('recipes').doc(recipe.id).update(recipe.toJson());
//     } catch (e) {
//       throw Exception('Failed to update recipe: $e');
//     }
//   }

//   Future<Recipe> fetchRecipe(String recipeId) async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance.collection('recipes').doc(recipeId).get();
//       if (!doc.exists) {
//         throw Exception('Recipe not found');
//       }
//       return Recipe.fromJson(doc.data() as Map<String, dynamic>);
//     } catch (e) {
//       throw Exception('Failed to fetch recipe: $e');
//     }
//   }

//   Future<void> favoriteRecipe(String userId, String recipeId) async {
//     try {
//       final userDocRef = FirebaseFirestore.instance.collection('user_profiles').doc(userId);

//       await userDocRef.update({
//         'favoriteRecipeIds': FieldValue.arrayUnion([recipeId]),
//       });
//     } catch (e) {
//       throw Exception('Failed to favorite recipe: $e');
//     }
//   }

//   Future<void> unfavoriteRecipe(String userId, String recipeId) async {
//     try {
//       final userDocRef = FirebaseFirestore.instance.collection('user_profiles').doc(userId);

//       await userDocRef.update({
//         'favoriteRecipeIds': FieldValue.arrayRemove([recipeId]),
//       });
//     } catch (e) {
//       throw Exception('Failed to unfavorite recipe: $e'); 
//     }
//   }

//   Future<List<Recipe>> fetchRecipesByIds(List<String> ids) async {
//     if (ids.isEmpty) return [];

//     // Firestore whereIn supports up to 10 items per query
//     final List<List<String>> chunks = [];
//     for (var i = 0; i < ids.length; i += 10) {
//       chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
//     }

//     final List<Recipe> fetched = [];
//     for (var chunk in chunks) {
//       final snapshot = await _firestore
//           .collection('recipes')
//           .where(FieldPath.documentId, whereIn: chunk)
//           .get();
//       fetched.addAll(snapshot.docs.map(
//         (doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>),
//       ));
//     }

//     // Preserve the order of incoming IDs
//     final mapById = {for (var r in fetched) r.id: r};
//     return ids
//         .map((id) => mapById[id])
//         .whereType<Recipe>()
//         .toList();
//   }

//   // TODO: For when we implement a "revert to original" feature
//   // Future<Recipe> fetchOriginalBackup(String recipeId) async {
//   //   final doc = await _firestore.collection('recipes_backup').doc(recipeId).get();
//   //   if (!doc.exists) throw Exception("Original backup not found");
//   //   return Recipe.fromJson(doc.data() as Map<String, dynamic>);
//   // }
// }