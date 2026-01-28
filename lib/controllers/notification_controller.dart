import 'package:get/get.dart';

/// Controller for managing notifications
class NotificationController extends GetxController {
  // Observable list of notifications
  final RxList<Map<String, dynamic>> _notifications = <Map<String, dynamic>>[].obs;

  // Mock notification data - in production, this would come from an API
  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  // Load notifications (mock data for now)
  void _loadNotifications() {
    _notifications.value = [
      {
        'id': 1,
        'type': 'reminder',
        'title': 'Workout Reminder',
        'message': 'Time for your Upper Body workout! Let\'s crush it 💪',
        'time': '10 minutes ago',
        'isRead': false,
        'icon': 'fitness_center',
      },
      {
        'id': 2,
        'type': 'achievement',
        'title': 'Achievement Unlocked! 🏆',
        'message': 'You\'ve completed 10 workouts this month. Keep going!',
        'time': '2 hours ago',
        'isRead': false,
        'icon': 'emoji_events',
      },
      {
        'id': 3,
        'type': 'streak',
        'title': 'Streak Alert! 🔥',
        'message': 'You\'re on a 7-day workout streak. Don\'t break it!',
        'time': '5 hours ago',
        'isRead': false,
        'icon': 'local_fire_department',
      },
      {
        'id': 4,
        'type': 'program',
        'title': 'New Program Available',
        'message': 'Check out "Advanced Strength Training" by Coach Sarah',
        'time': 'Yesterday',
        'isRead': true,
        'icon': 'library_books',
      },
      {'id': 5, 'type': 'social', 'title': 'Friend Activity', 'message': 'Mike completed a 10K run. Send some motivation!', 'time': 'Yesterday', 'isRead': true, 'icon': 'people'},
    ];
  }

  // Get all notifications
  List<Map<String, dynamic>> get notifications => _notifications;

  // Get unread notifications count
  int get unreadCount => _notifications.where((n) => n['isRead'] == false).length;

  // Check if there are unread notifications
  bool get hasUnreadNotifications => unreadCount > 0;

  // Mark notification as read
  void markAsRead(int id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      _notifications.refresh();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    _notifications.refresh();
  }

  // Refresh notifications (in production, would fetch from API)
  void refreshNotifications() {
    _loadNotifications();
  }
}
