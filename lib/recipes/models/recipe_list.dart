// recipe_list.dart

class RecipeList {
  final String id;
  final String title;
  final String ownerId; // For sharing & permissions
  final List<String> recipeIds;

  RecipeList({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.recipeIds,
  });

  factory RecipeList.fromMap(String id, Map<String, dynamic> data) {
    return RecipeList(
      id: id,
      title: data['title'] ?? '',
      ownerId: data['ownerId'] ?? '',
      recipeIds: List<String>.from(data['recipeIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ownerId': ownerId,
      'recipeIds': recipeIds,
    };
  }

  RecipeList copyWith({String? title, List<String>? recipeIds}) {
    return RecipeList(
      id: id,
      title: title ?? this.title,
      ownerId: ownerId,
      recipeIds: recipeIds ?? this.recipeIds,
    );
  }
}
