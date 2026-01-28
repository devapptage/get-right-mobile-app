/// Transaction Model - Represents a financial transaction
class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final DateTime transactionDate;
  final String? description;
  final String? programId;
  final String? programTitle;
  final String? trainerId;
  final String? trainerName;
  final String? paymentMethod;
  final String? transactionReference;
  final String? refundReason;
  final DateTime? refundedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    required this.transactionDate,
    this.description,
    this.programId,
    this.programTitle,
    this.trainerId,
    this.trainerName,
    this.paymentMethod,
    this.transactionReference,
    this.refundReason,
    this.refundedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: TransactionType.fromString(json['type'] ?? 'purchase'),
      amount: json['amount']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      status: TransactionStatus.fromString(json['status'] ?? 'completed'),
      transactionDate: json['transactionDate'] != null ? DateTime.parse(json['transactionDate']) : DateTime.now(),
      description: json['description'],
      programId: json['programId'],
      programTitle: json['programTitle'],
      trainerId: json['trainerId'],
      trainerName: json['trainerName'],
      paymentMethod: json['paymentMethod'],
      transactionReference: json['transactionReference'],
      refundReason: json['refundReason'],
      refundedAt: json['refundedAt'] != null ? DateTime.parse(json['refundedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'amount': amount,
      'currency': currency,
      'status': status.toString(),
      'transactionDate': transactionDate.toIso8601String(),
      'description': description,
      'programId': programId,
      'programTitle': programTitle,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'paymentMethod': paymentMethod,
      'transactionReference': transactionReference,
      'refundReason': refundReason,
      'refundedAt': refundedAt?.toIso8601String(),
    };
  }
}

/// Transaction Type Enum
enum TransactionType {
  purchase,
  refund;

  static TransactionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'purchase':
        return TransactionType.purchase;
      case 'refund':
        return TransactionType.refund;
      default:
        return TransactionType.purchase;
    }
  }

  @override
  String toString() {
    return name;
  }
}

/// Transaction Status Enum
enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled;

  static TransactionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.completed;
    }
  }

  @override
  String toString() {
    return name;
  }
}
