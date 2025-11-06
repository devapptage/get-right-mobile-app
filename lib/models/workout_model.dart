/// Workout model for logging exercises
class WorkoutModel {
  final String id;
  final String userId;
  final String exerciseName;
  final int sets;
  final int reps;
  final double? weight;
  final String? notes;
  final List<String>? tags;
  final List<String>? progressPhotos;
  final DateTime date;
  final DateTime createdAt;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.weight,
    this.notes,
    this.tags,
    this.progressPhotos,
    required this.date,
    required this.createdAt,
  });

  /// From JSON
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      exerciseName: json['exerciseName'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: json['weight']?.toDouble(),
      notes: json['notes'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      progressPhotos: json['progressPhotos'] != null ? List<String>.from(json['progressPhotos']) : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'notes': notes,
      'tags': tags,
      'progressPhotos': progressPhotos,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Copy with
  WorkoutModel copyWith({
    String? id,
    String? userId,
    String? exerciseName,
    int? sets,
    int? reps,
    double? weight,
    String? notes,
    List<String>? tags,
    List<String>? progressPhotos,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      progressPhotos: progressPhotos ?? this.progressPhotos,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
