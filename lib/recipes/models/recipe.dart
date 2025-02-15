// recipe.dart

// TODO: ADD PUBLIC ATTRIBUTES TO RECIPE MODEL (e.g. publicImages, ... )
class Recipe {
  final String id; // Unique ID for the recipe
  final List<String> images; // URLs for recipe images
  final String title; // Recipe title (required)
  final String prepTime; // Prep time
  final String cookTime; // Cook time
  final String restTime; // Rest time
  final String totalTime; // Total time
  final double rating; // Overall rating
  final int reviewsCount; // Number of reviews
  final int servings; // Number of servings
  final String servingsUnit; // Unit for servings (default: "Servings")
  final List<String> tags; // Tags (e.g., "Dinner", "Quick")
  final String description; // Recipe description
  final List<Ingredient> ingredients; // List of ingredients
  final String ingredientsFormat; // Format (e.g., US Customary, Metric)
  final List<String> equipment; // List of equipment needed
  final List<InstructionSection> instructions; // Instructions (divided into sections if applicable)
  Notes notes; // Notes for the recipe
  Nutrition nutrition; // Nutrition details
  final String link; // Original source link
  final String author; // Author of the recipe
  final String source; // Source type (e.g., Instagram, Website)
  final bool isPublic; // True if the recipe is public, false if private

  Recipe({
    required this.id,
    required this.images,
    required this.title,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.totalTime,
    required this.rating,
    required this.reviewsCount,
    required this.servings,
    this.servingsUnit = "Servings", // Default value
    required this.tags,
    required this.description,
    required this.ingredients,
    required this.ingredientsFormat,
    required this.equipment,
    required this.instructions,
    required this.notes,
    required this.nutrition,
    required this.link,
    required this.author,
    required this.source,
    this.isPublic = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'title': title,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'restTime': restTime,
      'totalTime': totalTime,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'servings': servings,
      'servingsUnit': servingsUnit,
      'tags': tags,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'ingredientsFormat': ingredientsFormat,
      'equipment': equipment,
      'instructions': instructions.map((i) => i.toJson()).toList(),
      'notes': notes.toJson(),
      'nutrition': nutrition.toJson(),
      'link': link,
      'author': author,
      'source': source,
      'isPublic': isPublic,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      images: List<String>.from(json['images']),
      title: json['title'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      restTime: json['restTime'],
      totalTime: json['totalTime'],
      rating: json['rating'].toDouble(),
      reviewsCount: json['reviewsCount'],
      servings: json['servings'],
      servingsUnit: json['servingsUnit'] ?? "Servings",
      tags: List<String>.from(json['tags']),
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      ingredientsFormat: json['ingredientsFormat'],
      equipment: List<String>.from(json['equipment']),
      instructions: (json['instructions'] as List)
          .map((i) => InstructionSection.fromJson(i))
          .toList(),
      notes: Notes.fromJson(json['notes']),
      nutrition: Nutrition.fromJson(json['nutrition']),
      link: json['link'],
      author: json['author'],
      source: json['source'],
      isPublic: json['isPublic'] ?? false,
    );
  }

  // Add a method to update notes
  void updateNotes(Notes newNotes) {
    notes = newNotes;
  }
}

class Ingredient {
  final String quantity; // e.g., "½"
  final String unit; // e.g., "tbsp"
  final String name; // e.g., "olive oil"

  Ingredient({
    required this.quantity,
    required this.unit,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      quantity: json['quantity'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'unit': unit,
      'name': name,
    };
  }

  @override
  String toString() {
    return '$quantity $unit $name';
  }
}


class InstructionSection {
  final String sectionTitle; // e.g., "Cheese Filling"
  final List<String> steps; // List of steps for this section

  InstructionSection({
    required this.sectionTitle,
    required this.steps,
  });

   Map<String, dynamic> toJson() {
    return {
      'sectionTitle': sectionTitle,
      'steps': steps,
    };
  }

  factory InstructionSection.fromJson(Map<String, dynamic> json) {
    return InstructionSection(
      sectionTitle: json['sectionTitle'],
      steps: List<String>.from(json['steps']),
    );
  }
}


class Notes {
  final List<String> personalNotes; // User-added personal notes
  final List<String> proTips;
  final List<String> storage;
  final List<String> makeAheadMethod;
  final List<String> reheatingLeftovers;
  final List<String> other;

  Notes({
    this.personalNotes = const [],
    this.proTips = const [],
    this.storage = const [],
    this.makeAheadMethod = const [],
    this.reheatingLeftovers = const [],
    this.other = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'personalNotes': personalNotes,
      'proTips': proTips,
      'storage': storage,
      'makeAheadMethod': makeAheadMethod,
      'reheatingLeftovers': reheatingLeftovers,
      'other': other,
    };
  }

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      personalNotes: List<String>.from(json['personalNotes'] ?? []),
      proTips: List<String>.from(json['proTips'] ?? []),
      storage: List<String>.from(json['storage'] ?? []),
      makeAheadMethod: List<String>.from(json['makeAheadMethod'] ?? []),
      reheatingLeftovers: List<String>.from(json['reheatingLeftovers'] ?? []),
      other: List<String>.from(json['other'] ?? []),
    );
  }
}

class Nutrition {
  final double? calories; // Total calories
  final double? fat; // Fat content in grams
  final double? protein; // Protein content in grams
  final double? carbs; // Carbohydrate content in grams
  final double? sugar; // Sugar content in grams
  final double? fiber; // Fiber content in grams

  Nutrition({
    this.calories,
    this.fat,
    this.protein,
    this.carbs,
    this.sugar,
    this.fiber,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbs': carbs,
      'sugar': sugar,
      'fiber': fiber,
    };
  }

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'],
      fat: json['fat']?.toDouble(),
      protein: json['protein']?.toDouble(),
      carbs: json['carbs']?.toDouble(),
      sugar: json['sugar']?.toDouble(),
      fiber: json['fiber']?.toDouble(),
    );
  }
}
