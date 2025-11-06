/// Run tracking model
class RunModel {
  final String id;
  final String userId;
  final double distanceMeters;
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  final List<LocationPoint>? routePoints;
  final double? elevationGain;
  final double? averagePace;
  final double? maxSpeed;
  final DateTime createdAt;

  RunModel({
    required this.id,
    required this.userId,
    required this.distanceMeters,
    required this.duration,
    required this.startTime,
    required this.endTime,
    this.routePoints,
    this.elevationGain,
    this.averagePace,
    this.maxSpeed,
    required this.createdAt,
  });

  /// Calculate average speed in m/s
  double get averageSpeed => distanceMeters / duration.inSeconds;

  /// From JSON
  factory RunModel.fromJson(Map<String, dynamic> json) {
    return RunModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      distanceMeters: json['distanceMeters']?.toDouble() ?? 0.0,
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : DateTime.now(),
      routePoints: json['routePoints'] != null ? (json['routePoints'] as List).map((point) => LocationPoint.fromJson(point)).toList() : null,
      elevationGain: json['elevationGain']?.toDouble(),
      averagePace: json['averagePace']?.toDouble(),
      maxSpeed: json['maxSpeed']?.toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'distanceMeters': distanceMeters,
      'durationSeconds': duration.inSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'routePoints': routePoints?.map((point) => point.toJson()).toList(),
      'elevationGain': elevationGain,
      'averagePace': averagePace,
      'maxSpeed': maxSpeed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Location point for route tracking
class LocationPoint {
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime timestamp;

  LocationPoint({required this.latitude, required this.longitude, this.altitude, required this.timestamp});

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      altitude: json['altitude']?.toDouble(),
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'altitude': altitude, 'timestamp': timestamp.toIso8601String()};
  }
}
