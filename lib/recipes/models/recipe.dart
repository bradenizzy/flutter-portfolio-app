// recipe.dart

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final List<Ingredient> ingredients;
  final List<String> directions;
  final int servings;
  final Duration prepTime;
  final Duration cookTime;
  final String difficulty; // e.g., "Easy", "Medium", "Hard"
  final List<String> tags; // e.g., ["Vegetarian", "Italian", "Quick"]
  final String? authorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.ingredients,
    required this.directions,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.difficulty,
    required this.tags,
    this.authorId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a Recipe from JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrls: List<String>.from(json['imageUrls']),
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      directions: List<String>.from(json['directions']),
      servings: json['servings'] as int,
      prepTime: Duration(minutes: json['prepTimeMinutes'] as int),
      cookTime: Duration(minutes: json['cookTimeMinutes'] as int),
      difficulty: json['difficulty'] as String,
      tags: List<String>.from(json['tags']),
      authorId: json['authorId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert Recipe to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'directions': directions,
      'servings': servings,
      'prepTimeMinutes': prepTime.inMinutes,
      'cookTimeMinutes': cookTime.inMinutes,
      'difficulty': difficulty,
      'tags': tags,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Get total time (prep + cook)
  Duration get totalTime => prepTime + cookTime;
}

class Ingredient {
  final String name;
  final double quantity;
  final String unit; // e.g., "cups", "grams", "tablespoons"

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      quantity: json['quantity'] as double,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  @override
  String toString() {
    return '$quantity $unit $name';
  }
}

