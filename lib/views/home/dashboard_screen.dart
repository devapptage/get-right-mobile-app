import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Home Dashboard - Central hub for Get Right app
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Mock motivational quotes
  final List<String> _quotes = const [
    "Your only limit is you.",
    "Push yourself, because no one else is going to do it for you.",
    "Great things never come from comfort zones.",
    "Dream it. Wish it. Do it.",
    "Success doesn't just find you. You have to go out and get it.",
  ];

  String get _todayQuote => _quotes[DateTime.now().day % _quotes.length];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.onPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Get Right', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.onPrimary),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text('Welcome back!', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 4),
            Text('Ready to crush your goals today?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 24),

            // Quick Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('15', 'Day Streak', Icons.local_fire_department, AppColors.accent)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('75%', 'Progress', Icons.trending_up, AppColors.accent)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('3', 'Upcoming', Icons.schedule, AppColors.upcoming)),
              ],
            ),
            const SizedBox(height: 24),

            // Motivational Quote Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote, color: AppColors.onAccent.withOpacity(0.8), size: 32),
                  const SizedBox(height: 8),
                  Text(
                    _todayQuote,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.onAccent, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  Text('— Your Daily Motivation', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onAccent.withOpacity(0.9))),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions Title
            Text('Quick Actions', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 16),

            // Shortcut Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildShortcutCard(
                  icon: Icons.fitness_center,
                  title: 'Log Workout',
                  subtitle: 'Track your session',
                  color: AppColors.accent,
                  onTap: () => Get.toNamed(AppRoutes.addWorkout),
                ),
                _buildShortcutCard(
                  icon: Icons.directions_run,
                  title: 'Start Run',
                  subtitle: 'GPS tracking',
                  color: AppColors.completed,
                  onTap: () => Get.toNamed(AppRoutes.runTracking),
                ),
                _buildShortcutCard(
                  icon: Icons.calendar_today,
                  title: 'Planner',
                  subtitle: 'View schedule',
                  color: AppColors.upcoming,
                  onTap: () {
                    // Switch to planner tab
                    Get.find<HomeNavigationController>().changeTab(2);
                  },
                ),
                _buildShortcutCard(
                  icon: Icons.store,
                  title: 'Marketplace',
                  subtitle: 'Browse programs',
                  color: AppColors.primaryGray,
                  onTap: () {
                    // Switch to marketplace tab
                    Get.find<HomeNavigationController>().changeTab(4);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Today's Schedule
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Schedule', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
                TextButton(
                  onPressed: () {
                    Get.find<HomeNavigationController>().changeTab(2);
                  },
                  child: Text('View All', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Today's Workouts
            _buildWorkoutItem('Upper Body Strength', '9:00 AM', 'Push day workout', true),
            _buildWorkoutItem('Cardio Session', '5:00 PM', '30 min run', false),
            _buildWorkoutItem('Evening Stretching', '8:00 PM', 'Recovery routine', false),
            const SizedBox(height: 24),

            // Recent Activity
            Text('Recent Activity', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 12),
            _buildActivityItem('Completed Leg Day', '2 hours ago', Icons.check_circle, AppColors.completed),
            _buildActivityItem('New program purchased', 'Yesterday', Icons.shopping_bag, AppColors.accent),
            _buildActivityItem('Achieved 10-day streak!', '2 days ago', Icons.emoji_events, AppColors.upcoming),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String title, String time, String description, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCompleted ? AppColors.completed : AppColors.primaryGray, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: isCompleted ? AppColors.completed.withOpacity(0.2) : AppColors.upcoming.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(isCompleted ? Icons.check_circle : Icons.schedule, color: isCompleted ? AppColors.completed : AppColors.upcoming),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                Text(time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Controller for managing home navigation
class HomeNavigationController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  void changeTab(int index) {
    _currentIndex.value = index;
  }
}
