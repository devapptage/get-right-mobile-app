import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Planner screen - workout plans and calendar with color-coded entries
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  // Mock workout data for calendar (status: completed, upcoming, missed)
  final Map<DateTime, List<Map<String, dynamic>>> _workouts = {
    DateTime(2025, 11, 3): [
      {'name': 'Upper Body', 'time': '9:00 AM', 'status': 'completed'},
    ],
    DateTime(2025, 11, 5): [
      {'name': 'Leg Day', 'time': '9:00 AM', 'status': 'completed'},
      {'name': 'Evening Run', 'time': '6:00 PM', 'status': 'completed'},
    ],
    DateTime(2025, 11, 7): [
      {'name': 'Cardio', 'time': '7:00 AM', 'status': 'missed'},
    ],
    DateTime(2025, 11, 11): [
      {'name': 'Push Day', 'time': '9:00 AM', 'status': 'upcoming'},
      {'name': 'Core', 'time': '5:00 PM', 'status': 'upcoming'},
    ],
    DateTime(2025, 11, 12): [
      {'name': 'Pull Day', 'time': '9:00 AM', 'status': 'upcoming'},
    ],
    DateTime(2025, 11, 13): [
      {'name': 'Legs', 'time': '9:00 AM', 'status': 'upcoming'},
    ],
  };

  // Mock progress stats
  final Map<String, dynamic> _progressStats = {'currentStreak': 5, 'longestStreak': 12, 'completionRate': 85, 'totalWorkouts': 45};

  List<Map<String, dynamic>> _getWorkoutsForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _workouts[key] ?? [];
  }

  Color _getDateColor(DateTime date) {
    final workouts = _getWorkoutsForDate(date);
    if (workouts.isEmpty) return Colors.transparent;

    final hasCompleted = workouts.any((w) => w['status'] == 'completed');
    final hasMissed = workouts.any((w) => w['status'] == 'missed');
    final hasUpcoming = workouts.any((w) => w['status'] == 'upcoming');

    if (hasCompleted) return AppColors.completed; // Green
    if (hasMissed) return AppColors.missed; // Red
    if (hasUpcoming) return AppColors.upcoming; // Orange

    return Colors.transparent;
  }

  void _showAddWorkoutDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add to Calendar', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.accent),
              title: Text('Log Workout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.addWorkout);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: AppColors.upcoming),
              title: Text('Create Plan', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.createPlan);
              },
            ),
            const SizedBox(height: 16),
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
        title: Text('Workout Planner', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books_outlined, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Show templates
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Stats Card
            const SizedBox(height: 16),

            // Calendar Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(AppColors.completed, 'Completed'),
                  const SizedBox(width: 16),
                  _buildLegendItem(AppColors.upcoming, 'Upcoming'),
                  const SizedBox(width: 16),
                  _buildLegendItem(AppColors.missed, 'Missed'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Calendar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGray, width: 1),
              ),
              child: Column(
                children: [
                  // Month navigation
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: AppColors.onSurface),
                          onPressed: () {
                            setState(() {
                              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                            });
                          },
                        ),
                        Text('${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: AppColors.onSurface),
                          onPressed: () {
                            setState(() {
                              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Weekday headers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                          .map(
                            (day) => SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(day, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray)),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Calendar grid
                  _buildCalendarGrid(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selected date workouts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_formatDate(_selectedDate), style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
            ),
            const SizedBox(height: 12),

            // Workout list for selected date
            _buildWorkoutList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'planner_fab',
      //   onPressed: _showAddWorkoutDialog,
      //   backgroundColor: AppColors.accent,
      //   foregroundColor: AppColors.onAccent,
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  // Widget _buildProgressStat(String value, String label, IconData icon, Color color) {
  //   return Column(
  //     children: [
  //       Icon(icon, color: color, size: 24),
  //       const SizedBox(height: 8),
  //       Text(
  //         value,
  //         style: AppTextStyles.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
  //     ],
  //   );
  // }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
        itemCount: firstWeekday + daysInMonth,
        itemBuilder: (context, index) {
          if (index < firstWeekday) return const SizedBox();

          final day = index - firstWeekday + 1;
          final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
          final isSelected = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;
          final isToday = DateTime.now().year == date.year && DateTime.now().month == date.month && DateTime.now().day == date.day;
          final dateColor = _getDateColor(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            onLongPress: () {
              setState(() {
                _selectedDate = date;
              });
              _showAddWorkoutDialog();
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday ? Border.all(color: AppColors.accent, width: 2) : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('$day', style: AppTextStyles.bodyMedium.copyWith(color: isSelected || isToday ? AppColors.onBackground : AppColors.primaryGray)),
                  if (dateColor != Colors.transparent)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: dateColor, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutList() {
    final workouts = _getWorkoutsForDate(_selectedDate);

    if (workouts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_today_outlined, size: 60, color: AppColors.primaryGray.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text('No workouts scheduled', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
              const SizedBox(height: 8),
              TextButton(onPressed: _showAddWorkoutDialog, child: const Text('Add Workout')),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final status = workout['status'] as String;
        Color statusColor;
        IconData statusIcon;

        switch (status) {
          case 'completed':
            statusColor = AppColors.completed;
            statusIcon = Icons.check_circle;
            break;
          case 'missed':
            statusColor = AppColors.missed;
            statusIcon = Icons.cancel;
            break;
          default:
            statusColor = AppColors.upcoming;
            statusIcon = Icons.schedule;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Icon(statusIcon, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout['name'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                    const SizedBox(height: 4),
                    Text(workout['time'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                  ],
                ),
              ),
              Text(
                status.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today\'s Schedule';
    }
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }
}
