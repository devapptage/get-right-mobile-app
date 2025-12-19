import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_right/controllers/chat_controller.dart';
import 'package:get_right/models/chat_message_model.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/api_service.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Chat List Screen - Shows all conversations and allows starting new chats
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatController? _chatController;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      final apiService = await ApiService.getInstance();
      final storageService = await StorageService.getInstance();

      // Check if controller already exists
      if (Get.isRegistered<ChatController>()) {
        _chatController = Get.find<ChatController>();
      } else {
        _chatController = Get.put(ChatController(apiService, storageService));
      }

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        _chatController?.loadConversations();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  void _openChatRoom(ConversationModel conversation) {
    Get.toNamed(
      AppRoutes.chatRoom,
      arguments: {
        'conversationId': conversation.id,
        'trainerId': conversation.trainerId,
        'trainerName': conversation.trainerName,
        'programId': conversation.programId,
        'programTitle': conversation.programTitle,
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(timestamp);
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent, size: 18),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isInitializing || _chatController == null
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              final conversations = _chatController!.conversations;
              final isLoading = _chatController!.isLoading.value;

              if (isLoading && conversations.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (conversations.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 80, color: AppColors.primaryGray),
                        const SizedBox(height: 24),
                        Text('No Messages', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground)),
                        const SizedBox(height: 12),
                        Text(
                          'Start a conversation with your trainers from enrolled programs.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed(AppRoutes.myPrograms);
                          },
                          icon: const Icon(Icons.fitness_center),
                          label: const Text('View My Programs'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.onAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _chatController!.loadConversations(),
                child: ListView.builder(
                  itemCount: conversations.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    final lastMessage = conversation.lastMessage;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        child: conversation.trainerImage != null
                            ? Text(conversation.trainerImage!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent))
                            : Text(
                                conversation.trainerName.isNotEmpty ? conversation.trainerName[0].toUpperCase() : 'T',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent),
                              ),
                      ),
                      title: Text(conversation.trainerName, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(conversation.programTitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                          if (lastMessage != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              lastMessage.type == 'image'
                                  ? '📷 Photo'
                                  : lastMessage.type == 'video'
                                  ? '🎥 Video'
                                  : lastMessage.type == 'audio'
                                  ? '🎤 Audio'
                                  : lastMessage.message,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGrayDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (lastMessage != null) Text(_formatTimestamp(lastMessage.timestamp), style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark)),
                          if (conversation.unreadCount > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
                                style: AppTextStyles.labelSmall.copyWith(color: AppColors.onAccent),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () => _openChatRoom(conversation),
                    );
                  },
                ),
              );
            }),
    );
  }
}
