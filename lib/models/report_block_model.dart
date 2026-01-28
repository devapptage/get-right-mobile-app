/// Report and Block models for trainer reporting functionality
class ReportModel {
  final String id;
  final String conversationId;
  final String reporterId; // User who reported
  final String reportedUserId; // Trainer who was reported
  final String reason;
  final String? description;
  final DateTime reportedAt;
  final ReportStatus status;
  final String? adminNotes;
  final DateTime? reviewedAt;

  ReportModel({
    required this.id,
    required this.conversationId,
    required this.reporterId,
    required this.reportedUserId,
    required this.reason,
    this.description,
    required this.reportedAt,
    this.status = ReportStatus.pending,
    this.adminNotes,
    this.reviewedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      reporterId: json['reporterId'] ?? '',
      reportedUserId: json['reportedUserId'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'],
      reportedAt: json['reportedAt'] != null ? DateTime.parse(json['reportedAt']) : DateTime.now(),
      status: ReportStatus.fromString(json['status'] ?? 'pending'),
      adminNotes: json['adminNotes'],
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'description': description,
      'reportedAt': reportedAt.toIso8601String(),
      'status': status.toString(),
      'adminNotes': adminNotes,
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }
}

enum ReportStatus {
  pending,
  underReview,
  resolved,
  dismissed;

  static ReportStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return ReportStatus.pending;
      case 'under_review':
      case 'underreview':
        return ReportStatus.underReview;
      case 'resolved':
        return ReportStatus.resolved;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        return ReportStatus.pending;
    }
  }

  @override
  String toString() {
    switch (this) {
      case ReportStatus.pending:
        return 'pending';
      case ReportStatus.underReview:
        return 'under_review';
      case ReportStatus.resolved:
        return 'resolved';
      case ReportStatus.dismissed:
        return 'dismissed';
    }
  }
}

/// Block model - represents a blocked user
class BlockModel {
  final String id;
  final String blockerId; // User who blocked
  final String blockedUserId; // User who was blocked (trainer)
  final DateTime blockedAt;
  final String? reason;

  BlockModel({required this.id, required this.blockerId, required this.blockedUserId, required this.blockedAt, this.reason});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'] ?? '',
      blockerId: json['blockerId'] ?? '',
      blockedUserId: json['blockedUserId'] ?? '',
      blockedAt: json['blockedAt'] != null ? DateTime.parse(json['blockedAt']) : DateTime.now(),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'blockerId': blockerId, 'blockedUserId': blockedUserId, 'blockedAt': blockedAt.toIso8601String(), 'reason': reason};
  }
}

/// Report reasons constants
class ReportReasons {
  static const String inappropriateContent = 'inappropriate_content';
  static const String harassment = 'harassment';
  static const String spam = 'spam';
  static const String fakeProfile = 'fake_profile';
  static const String other = 'other';

  static List<String> get all => [inappropriateContent, harassment, spam, fakeProfile, other];

  static String getDisplayName(String reason) {
    switch (reason) {
      case inappropriateContent:
        return 'Inappropriate Content';
      case harassment:
        return 'Harassment';
      case spam:
        return 'Spam';
      case fakeProfile:
        return 'Fake Profile';
      case other:
        return 'Other';
      default:
        return 'Other';
    }
  }
}
