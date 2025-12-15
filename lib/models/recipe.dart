/// Model for a recipe ingredient
class RecipeIngredient {
  final String name;
  final String quantity;
  final String? unit;

  RecipeIngredient({required this.name, required this.quantity, this.unit});

  String get displayText => unit != null ? '$quantity $unit $name' : '$quantity $name';

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(name: json['name'] ?? '', quantity: json['quantity'] ?? '', unit: json['unit']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'unit': unit};
  }
}

/// Model for recipe cooking instructions
class RecipeInstruction {
  final int step;
  final String instruction;

  RecipeInstruction({required this.step, required this.instruction});

  factory RecipeInstruction.fromJson(Map<String, dynamic> json) {
    return RecipeInstruction(step: json['step'] ?? 0, instruction: json['instruction'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'step': step, 'instruction': instruction};
  }
}

/// Recipe category tags
enum RecipeCategory {
  breakfast,
  lunch,
  dinner,
  bodybuilding,
  lowCarb,
  highProtein,
  vegetarian,
  vegan,
  budgetFriendly,
  quickPrep;

  String get displayName {
    switch (this) {
      case RecipeCategory.breakfast:
        return 'Breakfast';
      case RecipeCategory.lunch:
        return 'Lunch';
      case RecipeCategory.dinner:
        return 'Dinner';
      case RecipeCategory.bodybuilding:
        return 'Bodybuilding';
      case RecipeCategory.lowCarb:
        return 'Low Carb';
      case RecipeCategory.highProtein:
        return 'High Protein';
      case RecipeCategory.vegetarian:
        return 'Vegetarian';
      case RecipeCategory.vegan:
        return 'Vegan';
      case RecipeCategory.budgetFriendly:
        return 'Budget-Friendly';
      case RecipeCategory.quickPrep:
        return 'Quick Prep';
    }
  }
}

/// Model for a cookbook recipe
class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<RecipeCategory> categories;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final List<RecipeIngredient> ingredients;
  final List<RecipeInstruction> instructions;
  final double caloriesPerServing;
  final double proteinPerServing;
  final double carbsPerServing;
  final double fatsPerServing;
  final double? estimatedCost;
  final double? costPerServing;
  final String? videoUrl;
  final bool isPremium;
  final bool isFeatured;
  final DateTime? createdAt;
  final int? popularity;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.categories,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.caloriesPerServing,
    required this.proteinPerServing,
    required this.carbsPerServing,
    required this.fatsPerServing,
    this.estimatedCost,
    this.costPerServing,
    this.videoUrl,
    this.isPremium = false,
    this.isFeatured = false,
    this.createdAt,
    this.popularity,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  // Calculate nutrition for multiple servings
  Map<String, double> calculateForServings(double servingCount) {
    return {
      'calories': caloriesPerServing * servingCount,
      'protein': proteinPerServing * servingCount,
      'carbs': carbsPerServing * servingCount,
      'fats': fatsPerServing * servingCount,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      categories: (json['categories'] as List<dynamic>?)?.map((cat) => RecipeCategory.values.firstWhere((e) => e.name == cat, orElse: () => RecipeCategory.dinner)).toList() ?? [],
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((i) => RecipeIngredient.fromJson(i)).toList() ?? [],
      instructions: (json['instructions'] as List<dynamic>?)?.map((i) => RecipeInstruction.fromJson(i)).toList() ?? [],
      caloriesPerServing: (json['caloriesPerServing'] ?? 0).toDouble(),
      proteinPerServing: (json['proteinPerServing'] ?? 0).toDouble(),
      carbsPerServing: (json['carbsPerServing'] ?? 0).toDouble(),
      fatsPerServing: (json['fatsPerServing'] ?? 0).toDouble(),
      estimatedCost: json['estimatedCost']?.toDouble(),
      costPerServing: json['costPerServing']?.toDouble(),
      videoUrl: json['videoUrl'],
      isPremium: json['isPremium'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      popularity: json['popularity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories.map((c) => c.name).toList(),
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions.map((i) => i.toJson()).toList(),
      'caloriesPerServing': caloriesPerServing,
      'proteinPerServing': proteinPerServing,
      'carbsPerServing': carbsPerServing,
      'fatsPerServing': fatsPerServing,
      'estimatedCost': estimatedCost,
      'costPerServing': costPerServing,
      'videoUrl': videoUrl,
      'isPremium': isPremium,
      'isFeatured': isFeatured,
      'createdAt': createdAt?.toIso8601String(),
      'popularity': popularity,
    };
  }
}

