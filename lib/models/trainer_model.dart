/// Trainer model
class TrainerModel {
  final String id;
  final String name;
  final String initials;
  final String bio;
  final List<String> specialties;
  final int yearsOfExperience;
  final bool isCertified;
  final List<String>? certifications;
  final double hourlyRate;
  final double rating;
  final int totalReviews;
  final int totalStudents;
  final int activePrograms;
  final int completedPrograms;
  final String? profileImage;

  TrainerModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.bio,
    required this.specialties,
    required this.yearsOfExperience,
    required this.isCertified,
    this.certifications,
    required this.hourlyRate,
    required this.rating,
    required this.totalReviews,
    required this.totalStudents,
    required this.activePrograms,
    required this.completedPrograms,
    this.profileImage,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      initials: json['initials'] ?? '',
      bio: json['bio'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      isCertified: json['isCertified'] ?? false,
      certifications: json['certifications'] != null ? List<String>.from(json['certifications']) : null,
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      activePrograms: json['activePrograms'] ?? 0,
      completedPrograms: json['completedPrograms'] ?? 0,
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'bio': bio,
      'specialties': specialties,
      'yearsOfExperience': yearsOfExperience,
      'isCertified': isCertified,
      'certifications': certifications,
      'hourlyRate': hourlyRate,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalStudents': totalStudents,
      'activePrograms': activePrograms,
      'completedPrograms': completedPrograms,
      'profileImage': profileImage,
    };
  }
}

/// Review model
class ReviewModel {
  final String id;
  final String userName;
  final String userInitials;
  final double rating;
  final String comment;
  final String date;
  final String programName;

  ReviewModel({required this.id, required this.userName, required this.userInitials, required this.rating, required this.comment, required this.date, required this.programName});
}
