import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Journal screen - workout logs and daily tracking
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedDateIndex = 2; // Today is at index 2

  // Mock data for dates (showing 7 days)
  final List<Map<String, dynamic>> _dates = [
    {'day': 'Mon', 'date': 3},
    {'day': 'Tue', 'date': 4},
    {'day': 'Wed', 'date': 5}, // Today
    {'day': 'Thu', 'date': 6},
    {'day': 'Fri', 'date': 7},
    {'day': 'Sat', 'date': 8},
    {'day': 'Sun', 'date': 9},
  ];

  // Mock journal entries with more details
  final List<Map<String, dynamic>> _journalEntries = [
    {
      'date': 'Nov 5, 2025',
      'time': '6:30 AM',
      'entry': 'Had an intense leg workout today! Feeling strong.',
      'mood': 'Motivated 🔥',
      'type': 'Workout',
      'icon': Icons.fitness_center,
      'duration': '45 mins',
    },
    {
      'date': 'Nov 4, 2025',
      'time': '10:00 AM',
      'entry': 'Took a rest day. Focused on hydration and stretching.',
      'mood': 'Relaxed 😌',
      'type': 'Rest Day',
      'icon': Icons.self_improvement,
      'duration': '30 mins',
    },
    {
      'date': 'Nov 3, 2025',
      'time': '5:45 AM',
      'entry': 'Morning cardio + meal prep for the week.',
      'mood': 'Productive ✅',
      'type': 'Cardio',
      'icon': Icons.directions_run,
      'duration': '60 mins',
    },
  ];

  void _showAddEntryOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.primaryGray, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 24),
                Text('New Journal Entry', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 8),
                Text('What would you like to log today?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                const SizedBox(height: 24),
                _buildEntryOption(
                  icon: Icons.fitness_center,
                  title: 'Log Workout',
                  subtitle: 'Record exercise details',
                  color: AppColors.accent,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.addWorkout);
                  },
                ),
                const SizedBox(height: 12),
                _buildEntryOption(
                  icon: Icons.directions_run,
                  title: 'Log Run',
                  subtitle: 'Track your running session',
                  color: AppColors.completed,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.logRun);
                  },
                ),
                const SizedBox(height: 12),
                _buildEntryOption(
                  icon: Icons.restaurant,
                  title: 'Log Meal',
                  subtitle: 'Record your nutrition',
                  color: const Color(0xFFFF9800),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.logMeal);
                  },
                ),
                const SizedBox(height: 12),
                _buildEntryOption(
                  icon: Icons.notes,
                  title: 'Write Note',
                  subtitle: 'Add thoughts or reflections',
                  color: const Color(0xFF9C27B0),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.writeNote);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildEntryOption({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primaryGray, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text('My Journal', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.calendar_month, color: AppColors.accent, size: 20),
              ),
              onPressed: () {
                Get.snackbar(
                  'Coming Soon',
                  'Calendar view will be available soon!',
                  backgroundColor: AppColors.accent,
                  colorText: AppColors.onAccent,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Date Selector Row
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final dateInfo = _dates[index];
                  final isSelected = index == _selectedDateIndex;
                  final isToday = index == 2;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppColors.accent : AppColors.primaryGray, width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateInfo['day'],
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected ? AppColors.onAccent : AppColors.primaryGray,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${dateInfo['date']}',
                            style: AppTextStyles.titleLarge.copyWith(color: isSelected ? AppColors.onAccent : AppColors.onSurface, fontWeight: FontWeight.bold),
                          ),
                          if (isToday) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: isSelected ? AppColors.onAccent : AppColors.accent, shape: BoxShape.circle),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Daily Summary Card with Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.insights, color: AppColors.accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Today\'s Summary', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildSummaryItem(Icons.local_fire_department, 'Calories', '420', 'kcal', AppColors.accent)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSummaryItem(Icons.directions_walk, 'Steps', '7,850', '', AppColors.completed)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildSummaryItem(Icons.timer, 'Workout', '45', 'mins', const Color(0xFFFF9800))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSummaryItem(Icons.emoji_events, 'Mood', 'Great', '💪', const Color(0xFF9C27B0))),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 16),

            const SizedBox(height: 28),

            // Journal Entries Section with Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.history, color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Recent Entries', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
                    ],
                  ),
                  Text('${_journalEntries.length} entries', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Journal Entries List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _journalEntries.length,
              itemBuilder: (context, index) {
                final entry = _journalEntries[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGray, width: 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Get.snackbar(
                          'Entry Details',
                          'View entry details coming soon!',
                          backgroundColor: AppColors.accent,
                          colorText: AppColors.onAccent,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                  child: Icon(entry['icon'] as IconData, color: AppColors.accent, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry['type'] as String,
                                        style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text('${entry['date']} • ${entry['time']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    entry['duration'] as String,
                                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(entry['entry'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.9))),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryVariant,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryGray, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Mood: ', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                                  Text(entry['mood'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'journal_fab',
        onPressed: _showAddEntryOptions,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        icon: const Icon(Icons.add),
        label: const Text('Add Entry', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.15)),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 1),
                  child: Text(unit, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
