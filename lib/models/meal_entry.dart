import 'package:get_right/models/food_item.dart';

/// Type of meal
enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snacks:
        return 'Snacks';
    }
  }

  String get icon {
    switch (this) {
      case MealType.breakfast:
        return '🌅';
      case MealType.lunch:
        return '☀️';
      case MealType.dinner:
        return '🌙';
      case MealType.snacks:
        return '🍎';
    }
  }
}

/// Model for a meal entry (logged food)
class MealEntry {
  final String id;
  final FoodItem foodItem;
  final double quantity;
  final MealType mealType;
  final DateTime timestamp;
  final String? notes;

  MealEntry({
    required this.id,
    required this.foodItem,
    required this.quantity,
    required this.mealType,
    DateTime? timestamp,
    this.notes,
  }) : timestamp = timestamp ?? DateTime.now();

  // Calculate total nutrition for this entry
  Map<String, double> getTotalNutrition() {
    return foodItem.calculateForQuantity(quantity);
  }

  double get totalCalories => getTotalNutrition()['calories']!;
  double get totalProtein => getTotalNutrition()['protein']!;
  double get totalCarbs => getTotalNutrition()['carbs']!;
  double get totalFats => getTotalNutrition()['fats']!;

  // From JSON
  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] ?? '',
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: (json['quantity'] ?? 1.0).toDouble(),
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['mealType'],
        orElse: () => MealType.snacks,
      ),
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      notes: json['notes'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'mealType': mealType.name,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  // Copy with
  MealEntry copyWith({
    String? id,
    FoodItem? foodItem,
    double? quantity,
    MealType? mealType,
    DateTime? timestamp,
    String? notes,
  }) {
    return MealEntry(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      mealType: mealType ?? this.mealType,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }
}

