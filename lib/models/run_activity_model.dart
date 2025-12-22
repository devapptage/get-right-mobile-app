import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Run Activity Model
/// Represents a completed or in-progress run/walk/bike activity
class RunActivityModel {
  final String id;
  final String userId;
  final DateTime date;
  final String activityType; // 'Walk', 'Jog', 'Run', 'Bike'
  final int durationSeconds;
  final double distanceMeters;
  final double averagePace; // minutes per km
  final double maxPace;
  final int? caloriesBurned;
  final List<LatLng> routePoints;
  final List<RunSplit> splits;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? elevationGain;
  final double? elevationLoss;

  RunActivityModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.activityType,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.averagePace,
    required this.maxPace,
    this.caloriesBurned,
    required this.routePoints,
    this.splits = const [],
    this.notes,
    this.startedAt,
    this.completedAt,
    this.elevationGain,
    this.elevationLoss,
  });

  factory RunActivityModel.fromJson(Map<String, dynamic> json) {
    return RunActivityModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      activityType: json['activityType'] ?? 'Run',
      durationSeconds: json['durationSeconds'] ?? 0,
      distanceMeters: (json['distanceMeters'] ?? 0.0).toDouble(),
      averagePace: (json['averagePace'] ?? 0.0).toDouble(),
      maxPace: (json['maxPace'] ?? 0.0).toDouble(),
      caloriesBurned: json['caloriesBurned'],
      routePoints: (json['routePoints'] as List<dynamic>?)
              ?.map((p) => LatLng(p['lat'] as double, p['lng'] as double))
              .toList() ??
          [],
      splits: (json['splits'] as List<dynamic>?)
              ?.map((s) => RunSplit.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'],
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      elevationGain: json['elevationGain']?.toDouble(),
      elevationLoss: json['elevationLoss']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'activityType': activityType,
      'durationSeconds': durationSeconds,
      'distanceMeters': distanceMeters,
      'averagePace': averagePace,
      'maxPace': maxPace,
      'caloriesBurned': caloriesBurned,
      'routePoints': routePoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
      'splits': splits.map((s) => s.toJson()).toList(),
      'notes': notes,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'elevationGain': elevationGain,
      'elevationLoss': elevationLoss,
    };
  }

  RunActivityModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? activityType,
    int? durationSeconds,
    double? distanceMeters,
    double? averagePace,
    double? maxPace,
    int? caloriesBurned,
    List<LatLng>? routePoints,
    List<RunSplit>? splits,
    String? notes,
    DateTime? startedAt,
    DateTime? completedAt,
    double? elevationGain,
    double? elevationLoss,
  }) {
    return RunActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      activityType: activityType ?? this.activityType,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      averagePace: averagePace ?? this.averagePace,
      maxPace: maxPace ?? this.maxPace,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      routePoints: routePoints ?? this.routePoints,
      splits: splits ?? this.splits,
      notes: notes ?? this.notes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      elevationGain: elevationGain ?? this.elevationGain,
      elevationLoss: elevationLoss ?? this.elevationLoss,
    );
  }

  /// Get distance in kilometers
  double get distanceKm => distanceMeters / 1000;

  /// Get distance in miles
  double get distanceMiles => distanceMeters / 1609.34;

  /// Get duration formatted as HH:MM:SS
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get average pace formatted as MM:SS per km
  String get formattedAveragePace {
    final minutes = averagePace.floor();
    final seconds = ((averagePace - minutes) * 60).round();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Run Split Model
/// Represents a per-km or per-mile split
class RunSplit {
  final int splitNumber;
  final double distance; // in meters
  final int timeSeconds;
  final double pace; // minutes per km

  RunSplit({
    required this.splitNumber,
    required this.distance,
    required this.timeSeconds,
    required this.pace,
  });

  factory RunSplit.fromJson(Map<String, dynamic> json) {
    return RunSplit(
      splitNumber: json['splitNumber'] ?? 0,
      distance: (json['distance'] ?? 0.0).toDouble(),
      timeSeconds: json['timeSeconds'] ?? 0,
      pace: (json['pace'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'splitNumber': splitNumber,
      'distance': distance,
      'timeSeconds': timeSeconds,
      'pace': pace,
    };
  }

  /// Get formatted pace (MM:SS per km)
  String get formattedPace {
    final minutes = pace.floor();
    final seconds = ((pace - minutes) * 60).round();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted time
  String get formattedTime {
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Planned Route Model
/// Represents a saved/planned running route
class PlannedRouteModel {
  final String id;
  final String userId;
  final String name;
  final List<LatLng> routePoints;
  final double estimatedDistance; // in meters
  final DateTime? plannedDate;
  final DateTime createdAt;
  final double? elevationGain;

  PlannedRouteModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.routePoints,
    required this.estimatedDistance,
    this.plannedDate,
    required this.createdAt,
    this.elevationGain,
  });

  factory PlannedRouteModel.fromJson(Map<String, dynamic> json) {
    return PlannedRouteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      routePoints: (json['routePoints'] as List<dynamic>?)
              ?.map((p) => LatLng(p['lat'] as double, p['lng'] as double))
              .toList() ??
          [],
      estimatedDistance: (json['estimatedDistance'] ?? 0.0).toDouble(),
      plannedDate: json['plannedDate'] != null ? DateTime.parse(json['plannedDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      elevationGain: json['elevationGain']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'routePoints': routePoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
      'estimatedDistance': estimatedDistance,
      'plannedDate': plannedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'elevationGain': elevationGain,
    };
  }

  /// Get distance in kilometers
  double get distanceKm => estimatedDistance / 1000;

  /// Get distance in miles
  double get distanceMiles => estimatedDistance / 1609.34;
}

