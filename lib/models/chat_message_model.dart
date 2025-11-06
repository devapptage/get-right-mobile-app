/// Chat message model for trainer-client communication
class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String message;
  final String type; // 'text', 'image', 'file'
  final String? fileUrl;
  final String? fileName;
  final bool isRead;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.type = 'text',
    this.fileUrl,
    this.fileName,
    this.isRead = false,
    required this.timestamp,
  });

  /// From JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'text',
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      isRead: json['isRead'] ?? false,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Copy with
  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    String? fileUrl,
    String? fileName,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Conversation model
class ConversationModel {
  final String id;
  final String userId;
  final String trainerId;
  final String trainerName;
  final String? trainerImage;
  final String programId;
  final String programTitle;
  final ChatMessageModel? lastMessage;
  final int unreadCount;
  final DateTime createdAt;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.trainerName,
    this.trainerImage,
    required this.programId,
    required this.programTitle,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      trainerId: json['trainerId'] ?? '',
      trainerName: json['trainerName'] ?? '',
      trainerImage: json['trainerImage'],
      programId: json['programId'] ?? '',
      programTitle: json['programTitle'] ?? '',
      lastMessage: json['lastMessage'] != null ? ChatMessageModel.fromJson(json['lastMessage']) : null,
      unreadCount: json['unreadCount'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'trainerImage': trainerImage,
      'programId': programId,
      'programTitle': programTitle,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
