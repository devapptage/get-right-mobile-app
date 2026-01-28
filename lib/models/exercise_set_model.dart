/// Exercise Set Model
/// Represents a single set within an exercise
class ExerciseSetModel {
  final String id;
  final int setNumber;
  final int? reps; // null if AMRAP or timed
  final String? repsType; // 'standard', 'AMRAP', null for timed
  final int? timeSeconds; // null if not timed
  final double? weight; // null if bodyweight
  final String? weightType; // 'standard', 'BW' (bodyweight), 'percentage'
  final double? percentage; // if weightType is 'percentage'
  final double? distance; // for distance-based sets (meters/miles)
  final String? distanceUnit; // 'meters', 'miles', 'km'
  final String? notes; // Optional notes for this set

  ExerciseSetModel({
    required this.id,
    required this.setNumber,
    this.reps,
    this.repsType,
    this.timeSeconds,
    this.weight,
    this.weightType,
    this.percentage,
    this.distance,
    this.distanceUnit,
    this.notes,
  });

  factory ExerciseSetModel.fromJson(Map<String, dynamic> json) {
    return ExerciseSetModel(
      id: json['id'] ?? '',
      setNumber: json['setNumber'] ?? 0,
      reps: json['reps']?.toInt(),
      repsType: json['repsType'],
      timeSeconds: json['timeSeconds']?.toInt(),
      weight: json['weight']?.toDouble(),
      weightType: json['weightType'],
      percentage: json['percentage']?.toDouble(),
      distance: json['distance']?.toDouble(),
      distanceUnit: json['distanceUnit'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setNumber': setNumber,
      'reps': reps,
      'repsType': repsType,
      'timeSeconds': timeSeconds,
      'weight': weight,
      'weightType': weightType,
      'percentage': percentage,
      'distance': distance,
      'distanceUnit': distanceUnit,
      'notes': notes,
    };
  }

  ExerciseSetModel copyWith({
    String? id,
    int? setNumber,
    int? reps,
    String? repsType,
    int? timeSeconds,
    double? weight,
    String? weightType,
    double? percentage,
    double? distance,
    String? distanceUnit,
    String? notes,
  }) {
    return ExerciseSetModel(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      repsType: repsType ?? this.repsType,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      weight: weight ?? this.weight,
      weightType: weightType ?? this.weightType,
      percentage: percentage ?? this.percentage,
      distance: distance ?? this.distance,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      notes: notes ?? this.notes,
    );
  }

  /// Check if this set is timed
  bool get isTimed => timeSeconds != null && timeSeconds! > 0;

  /// Check if this set is distance-based
  bool get isDistanceBased => distance != null && distance! > 0;

  /// Check if this set uses bodyweight
  bool get isBodyweight => weightType == 'BW';

  /// Check if this set uses percentage
  bool get isPercentage => weightType == 'percentage' && percentage != null;

  /// Check if this set is AMRAP
  bool get isAMRAP => repsType == 'AMRAP';
}

