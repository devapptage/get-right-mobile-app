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
  bool _isSelectingStartDate = true; // Track which date is being selected

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

      if (_isSelectingStartDate) {
        _startDate = selectedDay;
        // If end date exists and is before new start date, clear it
        if (_endDate != null && _endDate!.isBefore(selectedDay)) {
          _endDate = null;
        }
        // Auto-calculate end date if not set
        if (_endDate == null && program['duration'] != null) {
          final durationWeeks = _parseDuration(program['duration']);
          _endDate = _startDate!.add(Duration(days: durationWeeks * 7));
        }
      } else {
        // Selecting end date
        if (_startDate == null) {
          Get.snackbar(
            'Select Start Date First',
            'Please select a start date before selecting an end date',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
        if (selectedDay.isBefore(_startDate!)) {
          Get.snackbar('Invalid Date', 'End date must be after start date', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
        _endDate = selectedDay;
      }
    });
  }

  void _proceedToCheckout() {
    if (_startDate == null || _endDate == null) {
      Get.snackbar('Incomplete', 'Please select both start and end dates', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      Get.snackbar('Invalid Dates', 'End date must be after start date', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
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
                      'Select your program start and end dates. You can customize both dates or let us calculate the end date automatically.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isSelectingStartDate = true;
                        if (_startDate != null) {
                          _focusedDay = _startDate!;
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: _isSelectingStartDate ? AppColors.accent : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_outline, size: 18, color: _isSelectingStartDate ? AppColors.onAccent : AppColors.primaryGray),
                            const SizedBox(width: 8),
                            Text(
                              'Start Date',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _isSelectingStartDate ? AppColors.onAccent : AppColors.onBackground,
                                fontWeight: _isSelectingStartDate ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_startDate == null) {
                          Get.snackbar(
                            'Select Start Date First',
                            'Please select a start date before selecting an end date',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        setState(() {
                          _isSelectingStartDate = false;
                          if (_endDate != null) {
                            _focusedDay = _endDate!;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: !_isSelectingStartDate ? AppColors.accent : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flag_outlined, size: 18, color: !_isSelectingStartDate ? AppColors.onAccent : AppColors.primaryGray),
                            const SizedBox(width: 8),
                            Text(
                              'End Date',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: !_isSelectingStartDate ? AppColors.onAccent : AppColors.onBackground,
                                fontWeight: !_isSelectingStartDate ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Calendar
            Text(
              _isSelectingStartDate ? 'Select Start Date' : 'Select End Date',
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
                selectedDayPredicate: (day) => isSameDay(_startDate, day) || isSameDay(_endDate, day),
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
                    if (_startDate != null) _buildDateRow('Start Date', _formatDate(_startDate!), Icons.play_circle_outline, isSelected: _isSelectingStartDate),
                    const Divider(height: 24),
                    if (_endDate != null) _buildDateRow('End Date', _formatDate(_endDate!), Icons.flag_outlined, isSelected: !_isSelectingStartDate),
                    const Divider(height: 24),
                    _buildDateRow('Duration', _calculateDuration(), Icons.schedule),
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

  Widget _buildDateRow(String label, String value, IconData icon, {bool isSelected = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent.withOpacity(0.2) : AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: AppColors.accent, width: 1.5) : null,
          ),
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
                style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? AppColors.accent : AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (isSelected)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: AppColors.onAccent),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _calculateDuration() {
    if (_startDate == null || _endDate == null) {
      return program['duration'] ?? 'N/A';
    }
    final difference = _endDate!.difference(_startDate!);
    final totalDays = difference.inDays;
    final weeks = totalDays ~/ 7; // Integer division
    final days = totalDays % 7; // Remainder

    if (weeks > 0 && days > 0) {
      return '$weeks week${weeks > 1 ? 's' : ''} ${days} day${days > 1 ? 's' : ''}';
    } else if (weeks > 0) {
      return '$weeks week${weeks > 1 ? 's' : ''}';
    } else {
      return '$days day${days > 1 ? 's' : ''}';
    }
  }
}
