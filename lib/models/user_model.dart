/// User model
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final int? age;
  final String? gender;
  final String? fitnessGoal;
  final List<String>? preferredWorkoutTypes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.age,
    this.gender,
    this.fitnessGoal,
    this.preferredWorkoutTypes,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  /// From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImage: json['profileImage'],
      age: json['age'],
      gender: json['gender'],
      fitnessGoal: json['fitnessGoal'],
      preferredWorkoutTypes: json['preferredWorkoutTypes'] != null ? List<String>.from(json['preferredWorkoutTypes']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
      'age': age,
      'gender': gender,
      'fitnessGoal': fitnessGoal,
      'preferredWorkoutTypes': preferredWorkoutTypes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImage,
    int? age,
    String? gender,
    String? fitnessGoal,
    List<String>? preferredWorkoutTypes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      preferredWorkoutTypes: preferredWorkoutTypes ?? this.preferredWorkoutTypes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
