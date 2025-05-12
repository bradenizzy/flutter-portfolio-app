// recipe_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeList {
  final String listId;
  final String title;
  final String ownerId; // For sharing & permissions
  final List<String> recipeIds;
  final int order; // New attribute for ordering lists

  RecipeList({
    required this.listId,
    required this.title,
    required this.ownerId,
    required this.recipeIds,
    required this.order,
  });

  factory RecipeList.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeList(
      listId: doc.id,
      title: data['title'] ?? '',
      ownerId: data['ownerId'] ?? '',
      recipeIds: List<String>.from(data['recipeIds'] ?? []),
      order: data['order'] ?? 0,
    );
  }

  // Writing TO Firestore (no need to duplicate listId)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ownerId': ownerId,
      'recipeIds': recipeIds,
      'order': order,
    };
  }

  factory RecipeList.fromMap(Map<String, dynamic> map, String id) {
    return RecipeList(
      listId: id,
      title: map['title'] ?? '',
      ownerId: map['ownerId'] ?? '',
      recipeIds: List<String>.from(map['recipeIds'] ?? []),
      order: map['order'] ?? 0,
    );
  }

  RecipeList copyWith({String? title, List<String>? recipeIds, int? order}) {
    return RecipeList(
      listId: listId,
      title: title ?? this.title,
      ownerId: ownerId,
      recipeIds: recipeIds ?? this.recipeIds,
      order: order ?? this.order,
    );
  }
}