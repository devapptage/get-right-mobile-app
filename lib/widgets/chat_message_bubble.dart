import 'package:flutter/material.dart';
import 'package:get_right/models/chat_message_model.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:intl/intl.dart';

/// Chat message bubble widget
class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isCurrentUser;
  final String? currentUserId;

  const ChatMessageBubble({super.key, required this.message, required this.isCurrentUser, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(
            16,
          ).copyWith(bottomRight: isCurrentUser ? const Radius.circular(4) : null, bottomLeft: !isCurrentUser ? const Radius.circular(4) : null),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message content based on type
            _buildMessageContent(),
            const SizedBox(height: 4),
            // Timestamp
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimestamp(message.timestamp),
                  style: AppTextStyles.labelSmall.copyWith(color: isCurrentUser ? AppColors.onAccent.withOpacity(0.7) : AppColors.onSurface.withOpacity(0.7)),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(message.isRead ? Icons.done_all : Icons.done, size: 14, color: message.isRead ? AppColors.onAccent.withOpacity(0.7) : AppColors.onAccent.withOpacity(0.5)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.fileUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.fileUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(width: 200, height: 200, color: AppColors.primaryGray, child: const Icon(Icons.broken_image, size: 48)),
                ),
              ),
            if (message.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(message.message, style: AppTextStyles.bodyMedium.copyWith(color: isCurrentUser ? AppColors.onAccent : AppColors.onSurface)),
            ],
          ],
        );
      case 'video':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.fileUrl != null)
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(color: AppColors.primaryGray, borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.play_circle_outline, size: 48, color: AppColors.onPrimary),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.blackOverlay, borderRadius: BorderRadius.circular(4)),
                        child: Text('Video', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onPrimary)),
                      ),
                    ),
                  ],
                ),
              ),
            if (message.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(message.message, style: AppTextStyles.bodyMedium.copyWith(color: isCurrentUser ? AppColors.onAccent : AppColors.onSurface)),
            ],
          ],
        );
      case 'audio':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 20, color: isCurrentUser ? AppColors.onAccent : AppColors.onSurface),
            const SizedBox(width: 8),
            Text(message.message, style: AppTextStyles.bodyMedium.copyWith(color: isCurrentUser ? AppColors.onAccent : AppColors.onSurface)),
          ],
        );
      default:
        return Text(message.message, style: AppTextStyles.bodyMedium.copyWith(color: isCurrentUser ? AppColors.onAccent : AppColors.onSurface));
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE HH:mm').format(timestamp);
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
