// recipe.dart
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
  final Notes notes; // Notes for the recipe
  final String personalNotes; // User-added personal notes
  final Nutrition nutrition; // Nutrition details
  final String link; // Original source link
  final String author; // Author of the recipe
  final String source; // Source type (e.g., Instagram, Website)

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
    this.personalNotes = "",
    required this.nutrition,
    required this.link,
    required this.author,
    required this.source,
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
      'personalNotes': personalNotes,
      'nutrition': nutrition.toJson(),
      'link': link,
      'author': author,
      'source': source,
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
      personalNotes: json['personalNotes'] ?? "",
      nutrition: Nutrition.fromJson(json['nutrition']),
      link: json['link'],
      author: json['author'],
      source: json['source'],
    );
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
  final String proTips;
  final String storage;
  final String makeAheadMethod;
  final String reheatingLeftovers;
  final String other;

  Notes({
    this.proTips = "",
    this.storage = "",
    this.makeAheadMethod = "",
    this.reheatingLeftovers = "",
    this.other = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'proTips': proTips,
      'storage': storage,
      'makeAheadMethod': makeAheadMethod,
      'reheatingLeftovers': reheatingLeftovers,
    };
  }

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      proTips: json['proTips'] ?? "",
      storage: json['storage'] ?? "",
      makeAheadMethod: json['makeAheadMethod'] ?? "",
      reheatingLeftovers: json['reheatingLeftovers'] ?? "",
    );
  }
}

class Nutrition {
  //TODO: add more fields
  final int calories; // Total calories
  final double fat; // Fat content in grams
  final double protein; // Protein content in grams
  final double carbs; // Carbohydrate content in grams

  Nutrition({
    this.calories = 0,
    this.fat = 0.0,
    this.protein = 0.0,
    this.carbs = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbs': carbs,
    };
  }

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'] ?? 0,
      fat: json['fat']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
    );
  }
}


