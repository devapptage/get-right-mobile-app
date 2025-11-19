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

  // Streak analytics data
  final int _currentStreak = 12;
  final int _longestStreak = 28;
  final List<bool> _weeklyStreak = [true, true, true, true, true, false, true]; // Last 7 days

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
      'id': '1',
      'date': 'Nov 5, 2025',
      'time': '6:30 AM',
      'entry': 'Had an intense leg workout today! Feeling strong.',
      'mood': 'Motivated 🔥',
      'type': 'Workout',
      'icon': Icons.fitness_center,
      'duration': '45 mins',
    },
    {
      'id': '2',
      'date': 'Nov 4, 2025',
      'time': '10:00 AM',
      'entry': 'Took a rest day. Focused on hydration and stretching.',
      'mood': 'Relaxed 😌',
      'type': 'Rest Day',
      'icon': Icons.self_improvement,
      'duration': '30 mins',
    },
    {
      'id': '3',
      'date': 'Nov 3, 2025',
      'time': '5:45 AM',
      'entry': 'Morning cardio + meal prep for the week.',
      'mood': 'Productive ✅',
      'type': 'Cardio',
      'icon': Icons.directions_run,
      'duration': '60 mins',
    },
  ];

  void _showEntryOptions(Map<String, dynamic> entry, int index) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.primaryGray, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  entry['type'] as String,
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('${entry['date']} • ${entry['time']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.edit, color: AppColors.accent, size: 20),
                ),
                title: Text(
                  'Edit Entry',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.back();
                  _editEntry(entry, index);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ),
                title: Text(
                  'Delete Entry',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.back();
                  _showDeleteConfirmation(entry, index);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _editEntry(Map<String, dynamic> entry, int index) {
    final entryType = entry['type'] as String;

    // Navigate to appropriate edit screen based on entry type
    if (entryType == 'Workout') {
      Get.toNamed(AppRoutes.addWorkout, arguments: {'edit': true, 'entry': entry});
    } else if (entryType == 'Cardio' || entryType == 'Run') {
      Get.toNamed(AppRoutes.logRun, arguments: {'edit': true, 'entry': entry});
    } else if (entryType == 'Meal') {
      Get.toNamed(AppRoutes.logMeal, arguments: {'edit': true, 'entry': entry});
    } else if (entryType == 'Note' || entryType == 'Rest Day') {
      Get.toNamed(AppRoutes.writeNote, arguments: {'edit': true, 'entry': entry});
    } else {
      Get.snackbar(
        'Edit Entry',
        'Edit functionality for this entry type is coming soon!',
        backgroundColor: AppColors.accent,
        colorText: AppColors.onAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> entry, int index) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 60),
              const SizedBox(height: 20),
              Text(
                'Delete Entry?',
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete this journal entry? This action cannot be undone.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${entry['type']} • ${entry['date']}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppColors.primaryGray, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.onBackground)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _deleteEntry(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Delete', style: AppTextStyles.buttonMedium.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteEntry(int index) {
    setState(() {
      _journalEntries.removeAt(index);
    });

    Get.snackbar(
      'Entry Deleted',
      'Journal entry has been deleted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.completed,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

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

            // Day Streak Analytics - Dark Theme
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.local_fire_department, color: AppColors.accent, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day Streak',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                              ),
                              Text('Keep the fire burning!', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildStreakStat('Current Streak', '$_currentStreak', 'days', Icons.whatshot, AppColors.accent)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStreakStat('Longest Streak', '$_longestStreak', 'days', Icons.emoji_events, const Color(0xFFFFD700))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'This Week',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.onPrimary.withOpacity(0.8), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final isActive = _weeklyStreak[index];
                        final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return _buildStreakDay(dayLabels[index], isActive, index == 2); // Today is at index 2
                      }),
                    ),
                  ],
                ),
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
                      onTap: () => _showEntryOptions(entry, index),
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
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.more_vert, color: AppColors.primaryGray, size: 20),
                                  onPressed: () => _showEntryOptions(entry, index),
                                  tooltip: 'More options',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
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

  Widget _buildStreakStat(String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.onPrimary.withOpacity(0.7)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(unit, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onPrimary.withOpacity(0.6))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakDay(String dayLabel, bool isActive, bool isToday) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? (isToday ? AppColors.accent : AppColors.accent.withOpacity(0.3)) : AppColors.primaryVariant.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: isToday ? AppColors.accent : Colors.transparent, width: 2),
      ),
      child: Center(
        child: Text(
          dayLabel,
          style: AppTextStyles.labelMedium.copyWith(
            color: isActive ? AppColors.onAccent : AppColors.onPrimary.withOpacity(0.4),
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
