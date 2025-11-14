/// Enrolled Program Model - Represents a program that a user has enrolled in
class EnrolledProgramModel {
  final String id;
  final String programId;
  final String programTitle;
  final String trainerId;
  final String trainerName;
  final String? trainerImage;
  final double price;
  final String category;
  final int durationWeeks;
  final DateTime startDate;
  final DateTime endDate;
  final ProgramStatus status;
  final int progress; // 0-100
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final ModificationRequest? pendingModification;
  final Review? review;

  EnrolledProgramModel({
    required this.id,
    required this.programId,
    required this.programTitle,
    required this.trainerId,
    required this.trainerName,
    this.trainerImage,
    required this.price,
    required this.category,
    required this.durationWeeks,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.progress = 0,
    required this.enrolledAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.pendingModification,
    this.review,
  });

  factory EnrolledProgramModel.fromJson(Map<String, dynamic> json) {
    return EnrolledProgramModel(
      id: json['id'] ?? '',
      programId: json['programId'] ?? '',
      programTitle: json['programTitle'] ?? '',
      trainerId: json['trainerId'] ?? '',
      trainerName: json['trainerName'] ?? '',
      trainerImage: json['trainerImage'],
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      durationWeeks: json['durationWeeks'] ?? 0,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      status: ProgramStatus.fromString(json['status'] ?? 'active'),
      progress: json['progress'] ?? 0,
      enrolledAt: json['enrolledAt'] != null ? DateTime.parse(json['enrolledAt']) : DateTime.now(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      cancellationReason: json['cancellationReason'],
      pendingModification: json['pendingModification'] != null ? ModificationRequest.fromJson(json['pendingModification']) : null,
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'programTitle': programTitle,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'trainerImage': trainerImage,
      'price': price,
      'category': category,
      'durationWeeks': durationWeeks,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.toString(),
      'progress': progress,
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'pendingModification': pendingModification?.toJson(),
      'review': review?.toJson(),
    };
  }
}

/// Program Status Enum
enum ProgramStatus {
  active,
  cancelled,
  completed,
  scheduled;

  static ProgramStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ProgramStatus.active;
      case 'cancelled':
        return ProgramStatus.cancelled;
      case 'completed':
        return ProgramStatus.completed;
      case 'scheduled':
        return ProgramStatus.scheduled;
      default:
        return ProgramStatus.active;
    }
  }

  @override
  String toString() {
    return name;
  }
}

/// Modification Request Model
class ModificationRequest {
  final String id;
  final String enrolledProgramId;
  final DateTime requestedAt;
  final DateTime? newStartDate;
  final DateTime? newEndDate;
  final String? newScheduleTimes; // JSON string or formatted string
  final String reason;
  final String? additionalNotes;
  final ModificationStatus status;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;

  ModificationRequest({
    required this.id,
    required this.enrolledProgramId,
    required this.requestedAt,
    this.newStartDate,
    this.newEndDate,
    this.newScheduleTimes,
    required this.reason,
    this.additionalNotes,
    this.status = ModificationStatus.pending,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  factory ModificationRequest.fromJson(Map<String, dynamic> json) {
    return ModificationRequest(
      id: json['id'] ?? '',
      enrolledProgramId: json['enrolledProgramId'] ?? '',
      requestedAt: json['requestedAt'] != null ? DateTime.parse(json['requestedAt']) : DateTime.now(),
      newStartDate: json['newStartDate'] != null ? DateTime.parse(json['newStartDate']) : null,
      newEndDate: json['newEndDate'] != null ? DateTime.parse(json['newEndDate']) : null,
      newScheduleTimes: json['newScheduleTimes'],
      reason: json['reason'] ?? '',
      additionalNotes: json['additionalNotes'],
      status: ModificationStatus.fromString(json['status'] ?? 'pending'),
      approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt']) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt']) : null,
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrolledProgramId': enrolledProgramId,
      'requestedAt': requestedAt.toIso8601String(),
      'newStartDate': newStartDate?.toIso8601String(),
      'newEndDate': newEndDate?.toIso8601String(),
      'newScheduleTimes': newScheduleTimes,
      'reason': reason,
      'additionalNotes': additionalNotes,
      'status': status.toString(),
      'approvedAt': approvedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}

enum ModificationStatus {
  pending,
  approved,
  rejected;

  static ModificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return ModificationStatus.pending;
      case 'approved':
        return ModificationStatus.approved;
      case 'rejected':
        return ModificationStatus.rejected;
      default:
        return ModificationStatus.pending;
    }
  }

  @override
  String toString() {
    return name;
  }
}

/// Review Model for Completed Programs
class Review {
  final String id;
  final String enrolledProgramId;
  final double rating; // 1-5
  final String comment;
  final List<String> mediaUrls; // URLs to uploaded images/videos
  final DateTime createdAt;
  final DateTime? updatedAt;

  Review({required this.id, required this.enrolledProgramId, required this.rating, required this.comment, this.mediaUrls = const [], required this.createdAt, this.updatedAt});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      enrolledProgramId: json['enrolledProgramId'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      mediaUrls: json['mediaUrls'] != null ? List<String>.from(json['mediaUrls']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrolledProgramId': enrolledProgramId,
      'rating': rating,
      'comment': comment,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
