import 'package:get/get.dart';

enum ReportType { user, post }

class BlockedUser {
  final String id;
  final String name;
  final String username;
  final DateTime blockedAt;

  const BlockedUser({
    required this.id,
    required this.name,
    required this.username,
    required this.blockedAt,
  });
}

class ReportItem {
  final String id;
  final ReportType type;
  final String title;
  final String subtitle;
  final String reason;
  final DateTime createdAt;
  final String status; // e.g. Pending/Resolved

  const ReportItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.reason,
    required this.createdAt,
    required this.status,
  });
}

/// Safety Center controller for blocked users + reports.
///
/// Note: This is currently backed by in-memory mock data. Replace `_loadMockData`
/// with API / persistence when available.
class SafetyCenterController extends GetxController {
  final RxList<BlockedUser> blockedUsers = <BlockedUser>[].obs;
  final RxList<ReportItem> reportedUsers = <ReportItem>[].obs;
  final RxList<ReportItem> reportedPosts = <ReportItem>[].obs;

  final RxString blockedQuery = ''.obs;
  final RxString reportsQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();

    blockedUsers.assignAll([
      BlockedUser(id: 'u_1', name: 'Alex Johnson', username: '@alexj', blockedAt: now.subtract(const Duration(days: 3))),
      BlockedUser(id: 'u_2', name: 'Priya Shah', username: '@priya', blockedAt: now.subtract(const Duration(days: 10))),
      BlockedUser(id: 'u_3', name: 'Chris Lee', username: '@chrislee', blockedAt: now.subtract(const Duration(days: 24))),
    ]..sort((a, b) => b.blockedAt.compareTo(a.blockedAt)));

    reportedUsers.assignAll([
      ReportItem(
        id: 'r_u_1',
        type: ReportType.user,
        title: 'User: @spam_account',
        subtitle: 'Repeated spam comments',
        reason: 'Spam',
        createdAt: now.subtract(const Duration(days: 2)),
        status: 'Pending',
      ),
      ReportItem(
        id: 'r_u_2',
        type: ReportType.user,
        title: 'User: @toxic_gymbro',
        subtitle: 'Harassment in DMs',
        reason: 'Harassment',
        createdAt: now.subtract(const Duration(days: 18)),
        status: 'Resolved',
      ),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

    reportedPosts.assignAll([
      ReportItem(
        id: 'r_p_1',
        type: ReportType.post,
        title: 'Post report',
        subtitle: '“DM me for steroids…”',
        reason: 'Illegal / harmful content',
        createdAt: now.subtract(const Duration(hours: 20)),
        status: 'Pending',
      ),
      ReportItem(
        id: 'r_p_2',
        type: ReportType.post,
        title: 'Post report',
        subtitle: 'Off-topic scam link',
        reason: 'Spam',
        createdAt: now.subtract(const Duration(days: 6)),
        status: 'Resolved',
      ),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  List<BlockedUser> get filteredBlockedUsers {
    final q = blockedQuery.value.trim().toLowerCase();
    if (q.isEmpty) return blockedUsers;
    return blockedUsers.where((u) => u.name.toLowerCase().contains(q) || u.username.toLowerCase().contains(q)).toList();
  }

  List<ReportItem> filteredReportsFor(ReportType type) {
    final q = reportsQuery.value.trim().toLowerCase();
    final source = type == ReportType.user ? reportedUsers : reportedPosts;
    if (q.isEmpty) return source;
    return source
        .where(
          (r) =>
              r.title.toLowerCase().contains(q) ||
              r.subtitle.toLowerCase().contains(q) ||
              r.reason.toLowerCase().contains(q) ||
              r.status.toLowerCase().contains(q),
        )
        .toList();
  }

  void unblock(String userId) {
    blockedUsers.removeWhere((u) => u.id == userId);
  }

  void removeReport({required ReportType type, required String reportId}) {
    if (type == ReportType.user) {
      reportedUsers.removeWhere((r) => r.id == reportId);
    } else {
      reportedPosts.removeWhere((r) => r.id == reportId);
    }
  }
}


