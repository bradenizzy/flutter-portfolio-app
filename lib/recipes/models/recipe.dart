// recipe.dart
import 'package:uuid/uuid.dart';

// TODO: ADD PUBLIC ATTRIBUTES TO RECIPE MODEL (e.g. publicImages, ... )
class Recipe {
  static final Uuid uuid = Uuid();
  final String id; // Unique ID for the recipe
  final List<String> images; // URLs for recipe images
  final String title; // Recipe title (required)
  final String prepTime; // Prep time
  final String cookTime; // Cook time
  final String restTime; // Rest time
  final String totalTime; // Total time
  final double rating; // Overall rating
  final int reviewsCount; // Number of reviews
  final double servings; // Number of servings
  final String servingsUnit; // Unit for servings (default: "Servings")
  final List<String> tags; // Tags (e.g., "Dinner", "Quick")
  final String description; // Recipe description
  final List<Ingredient> ingredients; // List of ingredients
  final String ingredientsFormat; // Format (e.g., US Customary, Metric)
  final List<EquipmentItem> equipment; // List of equipment needed
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
      'equipment': equipment.map((e) => e.toJson()).toList(),
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
      servings: json['servings'].toDouble(),
      servingsUnit: json['servingsUnit'] ?? "Servings",
      tags: List<String>.from(json['tags']),
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      ingredientsFormat: json['ingredientsFormat'],
      equipment: (json['equipment'] as List)
          .map((e) => EquipmentItem.fromJson(e))
          .toList(),
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

  Recipe copyWith({
    String? id,
    List<String>? images,
    String? title,
    String? prepTime,
    String? cookTime,
    String? restTime,
    String? totalTime,
    double? rating,
    int? reviewsCount,
    double? servings,
    String? servingsUnit,
    List<String>? tags,
    String? description,
    List<Ingredient>? ingredients,
    String? ingredientsFormat,
    List<EquipmentItem>? equipment,
    List<InstructionSection>? instructions,
    Notes? notes,
    Nutrition? nutrition,
    String? link,
    String? author,
    String? source,
    bool? isPublic,
  }) {
    return Recipe(
      id: id ?? this.id,
      images: images != null ? List.from(images) : List.from(this.images),
      title: title ?? this.title,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      restTime: restTime ?? this.restTime,
      totalTime: totalTime ?? this.totalTime,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      servings: servings ?? this.servings,
      servingsUnit: servingsUnit ?? this.servingsUnit,
      tags: tags != null ? List.from(tags) : List.from(this.tags),
      description: description ?? this.description,
      ingredients: ingredients != null
          ? ingredients.map((i) => i.copyWith()).toList()
          : this.ingredients.map((i) => i.copyWith()).toList(),
      ingredientsFormat: ingredientsFormat ?? this.ingredientsFormat,
      equipment: equipment != null 
          ? equipment.map((e) => e.copyWith()).toList()
          : this.equipment.map((e) => e.copyWith()).toList(),
      instructions: instructions != null
          ? instructions.map((s) => s.copyWith()).toList()
          : this.instructions.map((s) => s.copyWith()).toList(),
      notes: notes ?? this.notes.copyWith(),
      nutrition: nutrition ?? this.nutrition.copyWith(),
      link: link ?? this.link,
      author: author ?? this.author,
      source: source ?? this.source,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}


// TODO: CREATE A MASTER INGREDIENT ID SYSTEM TO ASSIGN UNIQUE IDS TO INGREDIENTS
class Ingredient {
  final String id;
  final String quantity;
  final String unit;
  final String name;

  Ingredient({
    String? id,
    required this.quantity,
    required this.unit,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      quantity: json['quantity'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'unit': unit,
      'name': name,
    };
  }

  @override
  String toString() {
    return '$quantity $unit $name';
  }

  Ingredient copyWith({
    String? id,
    String? quantity,
    String? unit,
    String? name,
  }) {
    return Ingredient(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      name: name ?? this.name,
    );
  }
}

// TODO: CREATE A MASTER EQUIPMENT ID SYSTEM TO ASSIGN UNIQUE IDS TO EQUIPMENT
class EquipmentItem {
  final String id;
  final String name;

  EquipmentItem({
    String? id,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  EquipmentItem copyWith({String? id, String? name}) {
    return EquipmentItem(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
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

  InstructionSection copyWith({
    String? sectionTitle,
    List<String>? steps,
  }) {
    return InstructionSection(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      steps: steps != null ? List.from(steps) : List.from(this.steps),
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

  Notes copyWith({
    List<String>? personalNotes,
    List<String>? proTips,
    List<String>? storage,
    List<String>? makeAheadMethod,
    List<String>? reheatingLeftovers, 
    List<String>? other,
  }) {
    return Notes(
      personalNotes: personalNotes != null ? List.from(personalNotes) : List.from(this.personalNotes),
      proTips: proTips != null ? List.from(proTips) : List.from(this.proTips),
      storage: storage != null ? List.from(storage) : List.from(this.storage),
      makeAheadMethod: makeAheadMethod != null ? List.from(makeAheadMethod) : List.from(this.makeAheadMethod),
      reheatingLeftovers: reheatingLeftovers != null ? List.from(reheatingLeftovers) : List.from(this.reheatingLeftovers),
      other: other != null ? List.from(other) : List.from(this.other),
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
      calories: json['calories'] != null ? (json['calories'] as num).toDouble() : null,
      fat: json['fat'] != null ? (json['fat'] as num).toDouble() : null,
      protein: json['protein'] != null ? (json['protein'] as num).toDouble() : null,
      carbs: json['carbs'] != null ? (json['carbs'] as num).toDouble() : null,
      sugar: json['sugar'] != null ? (json['sugar'] as num).toDouble() : null,
      fiber: json['fiber'] != null ? (json['fiber'] as num).toDouble() : null,
    );
  }

 Nutrition copyWith({
    double? calories,
    bool removeCalories = false,
    double? fat,
    bool removeFat = false,
    double? protein,
    bool removeProtein = false,
    double? carbs,
    bool removeCarbs = false,
    double? sugar,
    bool removeSugar = false,
    double? fiber,
    bool removeFiber = false,
  }) {
    return Nutrition(
      calories: removeCalories ? null : (calories ?? this.calories),
      fat: removeFat ? null : (fat ?? this.fat),
      protein: removeProtein ? null : (protein ?? this.protein),
      carbs: removeCarbs ? null : (carbs ?? this.carbs),
      sugar: removeSugar ? null : (sugar ?? this.sugar),
      fiber: removeFiber ? null : (fiber ?? this.fiber),
    );
  }
}
