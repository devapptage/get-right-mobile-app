import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:table_calendar/table_calendar.dart';

/// Program Enrollment Date Selection Screen
class ProgramEnrollmentScreen extends StatefulWidget {
  const ProgramEnrollmentScreen({super.key});

  @override
  State<ProgramEnrollmentScreen> createState() => _ProgramEnrollmentScreenState();
}

class _ProgramEnrollmentScreenState extends State<ProgramEnrollmentScreen> {
  final Map<String, dynamic> program = Get.arguments ?? {};

  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Set default start date to tomorrow
    _startDate = DateTime.now().add(const Duration(days: 1));
    // Calculate end date based on program duration
    if (program['duration'] != null && _startDate != null) {
      final durationWeeks = _parseDuration(program['duration']);
      _endDate = _startDate!.add(Duration(days: durationWeeks * 7));
    }
  }

  int _parseDuration(String duration) {
    // Parse "12 weeks" to 12
    final match = RegExp(r'(\d+)').firstMatch(duration);
    if (match != null && match.group(1) != null) {
      return int.parse(match.group(1)!);
    }
    return 12;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Only allow selecting dates from today onwards
    if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      Get.snackbar('Invalid Date', 'Please select a date from today onwards', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() {
      _focusedDay = focusedDay;
      _startDate = selectedDay;
      // Recalculate end date
      if (program['duration'] != null && _startDate != null) {
        final durationWeeks = _parseDuration(program['duration']);
        _endDate = _startDate!.add(Duration(days: durationWeeks * 7));
      }
    });
  }

  void _proceedToCheckout() {
    if (_startDate == null || _endDate == null) {
      Get.snackbar('Incomplete', 'Please select start date', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Pass program data with selected dates to purchase details screen
    Get.toNamed(AppRoutes.purchaseDetails, arguments: {...program, 'startDate': _startDate, 'endDate': _endDate});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Program Dates', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program['title'] ?? 'Program',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.primaryGray),
                      const SizedBox(width: 4),
                      Text(program['trainer'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                      const SizedBox(width: 12),
                      Icon(Icons.schedule, size: 16, color: AppColors.primaryGray),
                      const SizedBox(width: 4),
                      Text(program['duration'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${program['price']}',
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select when you want to start this program. The end date will be calculated automatically.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Calendar
            Text(
              'Select Start Date',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_startDate, day),
                onDaySelected: _onDaySelected,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface),
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.accent),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.accent),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  selectedTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
                  todayTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
                  defaultTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
                  weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                  outsideTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray.withOpacity(0.5)),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
                  weekendStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selected Dates Summary
            if (_startDate != null && _endDate != null) ...[
              Text(
                'Program Duration',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    if (_startDate != null) _buildDateRow('Start Date', _formatDate(_startDate!), Icons.play_circle_outline),
                    const Divider(height: 24),
                    if (_endDate != null) _buildDateRow('End Date', _formatDate(_endDate!), Icons.flag_outlined),
                    const Divider(height: 24),
                    _buildDateRow('Duration', program['duration'] ?? '', Icons.schedule),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _proceedToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Next', style: AppTextStyles.buttonLarge.copyWith(color: AppColors.onAccent)),
          ),
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
