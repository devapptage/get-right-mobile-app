import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/views/journal/workout_journal_screen.dart';
import 'package:get_right/views/tracker/run_tracker_screen.dart';
import 'package:get_right/views/home/dashboard_screen.dart';

/// Combined Journal Screen with tabs for Workout Journal and Runner Log
class CombinedJournalScreen extends StatefulWidget {
  const CombinedJournalScreen({super.key});

  @override
  State<CombinedJournalScreen> createState() => _CombinedJournalScreenState();
}

class _CombinedJournalScreenState extends State<CombinedJournalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final HomeNavigationController _navController;
  late final Worker _journalTabWorker;

  @override
  void initState() {
    super.initState();
    _navController = Get.find<HomeNavigationController>();
    _tabController = TabController(length: 2, vsync: this, initialIndex: _navController.journalTabIndex.value.clamp(0, 1));
    _tabController.addListener(() {
      // Keep controller in sync (and update UI)
      final idx = _tabController.index.clamp(0, 1);
      if (_navController.journalTabIndex.value != idx) {
        _navController.journalTabIndex.value = idx;
      }
      setState(() {});
    });

    // If something (e.g. dashboard quick actions) requests a specific tab, jump there.
    _journalTabWorker = ever<int>(_navController.journalTabIndex, (idx) {
      if (!mounted) return;
      final target = idx.clamp(0, 1);
      if (_tabController.index != target) {
        _tabController.animateTo(target);
      }
    });
  }

  @override
  void dispose() {
    _journalTabWorker.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFD6D6D6), Color(0xFFE8E8E8), Color(0xFFC0C0C0)]),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56,
          clipBehavior: Clip.none,

          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light),
          leading: Obx(() {
            final notificationController = Get.find<NotificationController>();
            final unreadCount = notificationController.unreadCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                      ),
                      Container(
                        width: 25,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                      ),
                      Container(
                        width: 20,
                        height: 3,
                        decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ).paddingOnly(left: 10),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Workout Journal',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16.sp,
                        color: _tabController.index == 0 ? AppColors.accent : const Color(0xFF000000),
                        fontWeight: _tabController.index == 0 ? FontWeight.w900 : FontWeight.w600,
                      ),
                    ),
                    if (_tabController.index == 0) Container(height: 3, width: 100, margin: const EdgeInsets.only(top: 2), color: AppColors.accent),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Runner Log',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16.sp,
                        color: _tabController.index == 1 ? AppColors.accent : const Color(0xFF000000),
                        fontWeight: _tabController.index == 1 ? FontWeight.w900 : FontWeight.w600,
                      ),
                    ),
                    if (_tabController.index == 1) Container(height: 3, width: 80, margin: const EdgeInsets.only(top: 2), color: AppColors.accent),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: AppColors.accent),
              onPressed: () {
                Get.toNamed('/planner');
              },
            ),
          ],
          centerTitle: true,
        ),
        body: TabBarView(controller: _tabController, children: const [WorkoutJournalScreen(isEmbedded: true), RunTrackerScreen()]),
      ),
    );
  }
}
