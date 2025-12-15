import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:image_picker/image_picker.dart';

/// Planner screen - workout plans and calendar with color-coded entries
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  final ImagePicker _imagePicker = ImagePicker();

  // Mock workout data for calendar (status: completed, incomplete, rest)
  final Map<DateTime, Map<String, dynamic>> _dayData = {
    DateTime(2025, 12, 3): {
      'workoutStatus': 'completed', // completed, incomplete, rest
      'hasProgressPhoto': true,
      'workout': {'duration': '30:00', 'exercises': 4, 'sets': 12, 'calories': 300},
      'run': null,
      'nutrition': null,
      'notes': '',
    },
    DateTime(2025, 12, 5): {
      'workoutStatus': 'completed',
      'hasProgressPhoto': true,
      'workout': {'duration': '30:00', 'exercises': 4, 'sets': 12, 'calories': 300},
      'run': {'distance': '3.00 km', 'time': '20:00', 'pace': '4:00 /km', 'calories': 250},
      'nutrition': {'calories': '1800/2200', 'protein': '150g', 'carbs': '200g', 'fats': '60g'},
      'notes': 'Great workout today!',
    },
    DateTime(2025, 12, 7): {'workoutStatus': 'rest', 'hasProgressPhoto': false, 'workout': null, 'run': null, 'nutrition': null, 'notes': 'Rest day - recovery'},
    DateTime(2025, 12, 11): {
      'workoutStatus': 'incomplete',
      'hasProgressPhoto': false,
      'workout': {'duration': '30:00', 'exercises': 4, 'sets': 12, 'calories': 300},
      'run': null,
      'nutrition': null,
      'notes': '',
    },
  };

  Map<String, dynamic>? _getDataForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _dayData[key];
  }

  Color _getDateColor(DateTime date) {
    final data = _getDataForDate(date);
    if (data == null) return Colors.transparent;

    final status = data['workoutStatus'];

    if (status == 'completed') return const Color(0xFF90EE90); // Light green
    if (status == 'incomplete') return const Color(0xFF29603C); // Dark green
    if (status == 'rest') return const Color(0xFF4A90E2); // Blue

    return Colors.transparent;
  }

  bool _hasProgressPhoto(DateTime date) {
    final data = _getDataForDate(date);
    return data?['hasProgressPhoto'] ?? false;
  }

  Future<void> _addProgressPhoto() async {
    // Check if selected date is in the future
    final now = DateTime.now();
    final selectedDateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final nowDateOnly = DateTime(now.year, now.month, now.day);

    if (selectedDateOnly.isAfter(nowDateOnly)) {
      Get.snackbar(
        'Invalid Date',
        'Progress photos are not allowed for future dates',
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show options for front or side photo
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Progress Photo', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.camera_front, color: AppColors.accent),
              title: Text('Front Photo', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto('front');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.accent),
              title: Text('Side Photo', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto('side');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePhoto(String type) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);

      if (photo != null) {
        // TODO: Upload photo to backend
        setState(() {
          final key = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
          if (_dayData[key] != null) {
            _dayData[key]!['hasProgressPhoto'] = true;
          } else {
            _dayData[key] = {'workoutStatus': null, 'hasProgressPhoto': true, 'workout': null, 'run': null, 'nutrition': null, 'notes': ''};
          }
        });

        Get.snackbar('Success', '$type photo added successfully', backgroundColor: AppColors.completed, colorText: AppColors.onError, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture photo: $e', backgroundColor: AppColors.error, colorText: AppColors.onError, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _navigateToJournalWithDate() {
    // Navigate to workout journal with selected date
    Get.toNamed(AppRoutes.journal, arguments: {'selectedDate': _selectedDate});
  }

  void _showAddWorkoutDialog() {
    // Check if date is in the past or future for different options
    final now = DateTime.now();
    final selectedDateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final nowDateOnly = DateTime(now.year, now.month, now.day);

    final isFuture = selectedDateOnly.isAfter(nowDateOnly);

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
            Text(
              isFuture ? 'Plan for ${_formatDate(_selectedDate)}' : 'Add to ${_formatDate(_selectedDate)}',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.accent),
              title: Text('Add Workout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
              onTap: () {
                Navigator.pop(context);
                _navigateToJournalWithDate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_run, color: AppColors.accent),
              title: Text('Add Run', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.logRun, arguments: {'selectedDate': _selectedDate});
              },
            ),
            if (!isFuture)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.accent),
                title: Text('Add Progress Photo', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
                onTap: () {
                  Navigator.pop(context);
                  _addProgressPhoto();
                },
              ),
            ListTile(
              leading: const Icon(Icons.note_alt_outlined, color: AppColors.accent),
              title: Text('Add Notes', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
              onTap: () {
                Navigator.pop(context);
                _showNotesDialog();
              },
            ),
            if (isFuture)
              ListTile(
                leading: const Icon(Icons.bedtime, color: const Color(0xFF4A90E2)),
                title: Text('Mark as Rest Day', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
                onTap: () {
                  Navigator.pop(context);
                  _markAsRestDay();
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showNotesDialog() {
    final data = _getDataForDate(_selectedDate);
    final currentNotes = data?['notes'] ?? '';
    final notesController = TextEditingController(text: currentNotes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Daily Notes', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
        content: TextField(
          controller: notesController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Add notes for this day...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final key = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
                if (_dayData[key] != null) {
                  _dayData[key]!['notes'] = notesController.text;
                } else {
                  _dayData[key] = {'workoutStatus': null, 'hasProgressPhoto': false, 'workout': null, 'run': null, 'nutrition': null, 'notes': notesController.text};
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _markAsRestDay() {
    setState(() {
      final key = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      _dayData[key] = {'workoutStatus': 'rest', 'hasProgressPhoto': false, 'workout': null, 'run': null, 'nutrition': null, 'notes': _dayData[key]?['notes'] ?? ''};
    });

    Get.snackbar('Success', 'Day marked as rest day', backgroundColor: const Color(0xFF4A90E2), colorText: AppColors.onError, snackPosition: SnackPosition.BOTTOM);
  }

  void _showShareOptions() {
    final data = _getDataForDate(_selectedDate);
    if (data == null || (data['workout'] == null && data['run'] == null)) {
      Get.snackbar('No Data', 'No workout or run data to share for this date', backgroundColor: AppColors.error, colorText: AppColors.onError, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share Options', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 24),
            if (data['workout'] != null)
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.accent),
                title: Text('Share Summary', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                subtitle: Text('Share workout summary to social media', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                onTap: () {
                  Navigator.pop(context);
                  _showSharePreview('summary');
                },
              ),
            if (data['workout'] != null)
              ListTile(
                leading: const Icon(Icons.download, color: AppColors.accent),
                title: Text('Share Workout Download', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                subtitle: Text('Share workout details with a friend', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                onTap: () {
                  Navigator.pop(context);
                  _showSharePreview('download');
                },
              ),
            if (data['run'] != null)
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.accent),
                title: Text('Share Run Summary', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                subtitle: Text('Share run summary to social media', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                onTap: () {
                  Navigator.pop(context);
                  _showSharePreview('run');
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSharePreview(String type) {
    final data = _getDataForDate(_selectedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.onPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      type == 'download' ? 'Workout Download Preview' : 'Share Preview',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Preview Content
            Expanded(
              child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _buildSharePreviewContent(type, data)),
            ),
            // Share Button
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement actual sharing functionality
                  Navigator.pop(context);
                  Get.snackbar('Shared', 'Content shared successfully', backgroundColor: AppColors.completed, colorText: AppColors.onError, snackPosition: SnackPosition.BOTTOM);
                },
                icon: const Icon(Icons.share),
                label: Text(type == 'download' ? 'Share Workout Download' : 'Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharePreviewContent(String type, Map<String, dynamic>? data) {
    if (type == 'download') {
      // Workout Download Preview
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.blackOverlay, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center, color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Workout',
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatDate(_selectedDate), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 24),
            // Mock exercise details
            _buildExerciseDetail('Overhead Press', 'Set 1: Reps: 10 - Weight: 165'),
            _buildExerciseDetail('', 'Set 2: Reps: 12 - Weight: 165'),
            _buildExerciseDetail('', 'Set 3: Reps: 14 - Weight: 165'),
            const SizedBox(height: 16),
            const Divider(color: AppColors.primaryGray),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('Duration: ${data?['workout']?['duration'] ?? 'N/A'}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('Calories: ${data?['workout']?['calories'] ?? 'N/A'}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accent),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Recipients can import this workout into their calendar', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (type == 'run') {
      // Run Summary Preview
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.blackOverlay, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_run, color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Running Summary',
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatDate(_selectedDate), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 24),
            _buildRunStat(Icons.route, 'Distance', data?['run']?['distance'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildRunStat(Icons.timer, 'Time', data?['run']?['time'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildRunStat(Icons.speed, 'Pace', data?['run']?['pace'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildRunStat(Icons.local_fire_department, 'Calories', data?['run']?['calories'].toString() ?? 'N/A'),
          ],
        ),
      );
    } else {
      // Workout Summary Preview
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.blackOverlay, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center, color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Workout',
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatDate(_selectedDate), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 24),
            _buildWorkoutStat('Duration', data?['workout']?['duration'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildWorkoutStat('Exercises', data?['workout']?['exercises'].toString() ?? 'N/A'),
            const SizedBox(height: 16),
            _buildWorkoutStat('Sets', data?['workout']?['sets'].toString() ?? 'N/A'),
            const SizedBox(height: 16),
            _buildWorkoutStat('Calories', data?['workout']?['calories'].toString() ?? 'N/A'),
          ],
        ),
      );
    }
  }

  Widget _buildExerciseDetail(String name, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (name.isNotEmpty) const Icon(Icons.fiber_manual_record, size: 8, color: AppColors.accent),
          if (name.isNotEmpty) const SizedBox(width: 8),
          if (name.isEmpty) const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty) Text(name, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                Text(detail, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
              Text(value, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutStat(String label, String value) {
    return Row(
      children: [
        Icon(
          label == 'Duration'
              ? Icons.timer
              : label == 'Exercises'
              ? Icons.fitness_center
              : label == 'Sets'
              ? Icons.repeat
              : Icons.local_fire_department,
          color: AppColors.accent,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
              Text(value, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Calendar', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Navigate to Progress Gallery
              Get.snackbar('Coming Soon', 'Progress Gallery feature', backgroundColor: AppColors.accent, colorText: AppColors.onAccent, snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Calendar Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(const Color(0xFF29603C), 'Incomplete'),
                  const SizedBox(width: 12),
                  _buildLegendItem(const Color(0xFF90EE90), 'Completed'),
                  const SizedBox(width: 12),
                  _buildLegendItem(const Color(0xFF4A90E2), 'Rest Day'),
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

            // Selected date header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDate(_selectedDate), style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
                  TextButton(
                    onPressed: _navigateToJournalWithDate,
                    child: Text('Select Date', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Day detail view
            _buildDayDetailView(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

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
          final hasPhoto = _hasProgressPhoto(date);

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
                color: isSelected ? AppColors.accent.withOpacity(0.2) : (dateColor != Colors.transparent ? dateColor : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: AppColors.accent, width: 2)
                    : isSelected
                    ? Border.all(color: AppColors.accent, width: 1)
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '$day',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected || isToday ? AppColors.onBackground : (dateColor != Colors.transparent ? AppColors.onSurface : AppColors.primaryGray),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasPhoto)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
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

  Widget _buildDayDetailView() {
    final data = _getDataForDate(_selectedDate);

    if (data == null ||
        (data['workout'] == null && data['run'] == null && data['nutrition'] == null && (data['notes'] == null || data['notes'].toString().isEmpty) && !data['hasProgressPhoto'])) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_today_outlined, size: 60, color: AppColors.primaryGray.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text('No data for this day', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
              const SizedBox(height: 8),
              TextButton(onPressed: _showAddWorkoutDialog, child: const Text('Add Data')),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Progress Photos
          if (data['hasProgressPhoto']) _buildProgressPhotosSection(),

          // Workout Summary
          if (data['workout'] != null) _buildWorkoutSummarySection(data['workout']),

          // Run Summary
          if (data['run'] != null) _buildRunSummarySection(data['run']),

          // Nutrition Summary
          if (data['nutrition'] != null) _buildNutritionSummarySection(data['nutrition']),

          // Notes Section
          if (data['notes'] != null && data['notes'].toString().isNotEmpty) _buildNotesSection(data['notes']),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showAddWorkoutDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showShareOptions,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPhotosSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Pictures',
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: View photo
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(color: AppColors.primaryGrayLight, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_front, size: 40, color: AppColors.primaryGray),
                        const SizedBox(height: 8),
                        Text('Front Photo', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: View photo
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(color: AppColors.primaryGrayLight, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt, size: 40, color: AppColors.primaryGray),
                        const SizedBox(height: 8),
                        Text('Side Photo', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _addProgressPhoto,
              child: Text('Swipe left for Summary', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutSummarySection(Map<String, dynamic> workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Workout Summary',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '30:00',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.fitness_center, 'Exercises', workout['exercises'].toString()),
              _buildStatItem(Icons.repeat, 'Sets', workout['sets'].toString()),
              _buildStatItem(Icons.local_fire_department, 'Calories', workout['calories'].toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRunSummarySection(Map<String, dynamic> run) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_run, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Running Summary',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.route, 'Distance', run['distance']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.timer, 'Time', run['time']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.speed, 'Pace', run['pace']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.local_fire_department, 'Calories', run['calories'].toString()),
        ],
      ),
    );
  }

  Widget _buildNutritionSummarySection(Map<String, dynamic> nutrition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.upcoming, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant, color: AppColors.upcoming, size: 24),
              const SizedBox(width: 8),
              Text(
                'Nutrition',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.local_fire_department, 'Calories', nutrition['calories']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.fitness_center, 'Protein', nutrition['protein']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.rice_bowl, 'Carbs', nutrition['carbs']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.water_drop, 'Fats', nutrition['fats']),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note_alt_outlined, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Notes',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: AppColors.primaryGray),
                onPressed: _showNotesDialog,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(notes, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGray, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGray, size: 18),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
        ),
      ],
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
