import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class _CombinedJournalScreenState extends State<CombinedJournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update UI when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD6D6D6), Color(0xFFE8E8E8), Color(0xFFC0C0C0)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Column(
                  children: [
                    Text(
                      'Workout Journal',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: _tabController.index == 0
                            ? AppColors.accent
                            : const Color(0xFF000000),
                        fontWeight: _tabController.index == 0
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    if (_tabController.index == 0)
                      Container(
                        height: 3,
                        width: 120,
                        margin: const EdgeInsets.only(top: 2),
                        color: AppColors.accent,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Column(
                  children: [
                    Text(
                      'Runner Log',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: _tabController.index == 1
                            ? AppColors.accent
                            : const Color(0xFF000000),
                        fontWeight: _tabController.index == 1
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    if (_tabController.index == 1)
                      Container(
                        height: 3,
                        width: 90,
                        margin: const EdgeInsets.only(top: 2),
                        color: AppColors.accent,
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Color(0xFF000000)),
              onPressed: () {
                Get.toNamed('/planner');
              },
            ),
          ],
          centerTitle: true,
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            WorkoutJournalScreen(isEmbedded: true),
            RunTrackerScreen(),
          ],
        ),
      ),
    );
  }
}
