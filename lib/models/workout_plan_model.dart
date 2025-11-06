/// Workout plan model
class WorkoutPlanModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final List<PlannedWorkout> workouts;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isTemplate;
  final DateTime createdAt;

  WorkoutPlanModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.workouts,
    this.startDate,
    this.endDate,
    this.isTemplate = false,
    required this.createdAt,
  });

  /// From JSON
  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      workouts: json['workouts'] != null ? (json['workouts'] as List).map((workout) => PlannedWorkout.fromJson(workout)).toList() : [],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isTemplate: json['isTemplate'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'workouts': workouts.map((workout) => workout.toJson()).toList(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isTemplate': isTemplate,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Individual planned workout in a plan
class PlannedWorkout {
  final String exerciseName;
  final int sets;
  final int reps;
  final double? weight;
  final String? notes;
  final int dayOfWeek; // 1-7 (Monday-Sunday)
  final int? weekNumber;

  PlannedWorkout({required this.exerciseName, required this.sets, required this.reps, this.weight, this.notes, required this.dayOfWeek, this.weekNumber});

  factory PlannedWorkout.fromJson(Map<String, dynamic> json) {
    return PlannedWorkout(
      exerciseName: json['exerciseName'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: json['weight']?.toDouble(),
      notes: json['notes'],
      dayOfWeek: json['dayOfWeek'] ?? 1,
      weekNumber: json['weekNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'exerciseName': exerciseName, 'sets': sets, 'reps': reps, 'weight': weight, 'notes': notes, 'dayOfWeek': dayOfWeek, 'weekNumber': weekNumber};
  }
}
