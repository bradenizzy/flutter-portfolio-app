// recipe_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeList {
  final String listId;
  final String title;
  final String ownerId; // For sharing & permissions
  final List<String> recipeIds;

  RecipeList({
    required this.listId,
    required this.title,
    required this.ownerId,
    required this.recipeIds,
  });

  factory RecipeList.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeList(
      listId: doc.id,
      title: data['title'] ?? '',
      ownerId: data['ownerId'] ?? '',
      recipeIds: List<String>.from(data['recipeIds'] ?? []),
    );
  }

  // Writing TO Firestore (no need to duplicate listId)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ownerId': ownerId,
      'recipeIds': recipeIds,
    };
  }

  RecipeList copyWith({String? title, List<String>? recipeIds}) {
    return RecipeList(
      listId: listId,
      title: title ?? this.title,
      ownerId: ownerId,
      recipeIds: recipeIds ?? this.recipeIds,
    );
  }
}