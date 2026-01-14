import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// My Programs Screen - Shows active and scheduled programs
class MyProgramsScreen extends StatefulWidget {
  const MyProgramsScreen({super.key});

  @override
  State<MyProgramsScreen> createState() => _MyProgramsScreenState();
}

class _MyProgramsScreenState extends State<MyProgramsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock enrolled programs
  final List<Map<String, dynamic>> _activePrograms = [
    {
      'id': '1',
      'title': 'Complete Strength Program',
      'trainer': 'Sarah Johnson',
      'trainerImage': 'SJ',
      'price': 49.99,
      'duration': '12 weeks',
      'category': 'Strength',
      'startDate': DateTime.now().subtract(const Duration(days: 14)),
      'endDate': DateTime.now().add(const Duration(days: 70)),
      'progress': 35,
      'status': 'active',
    },
    {
      'id': '2',
      'title': 'Cardio Blast Challenge',
      'trainer': 'Mike Chen',
      'trainerImage': 'MC',
      'price': 29.99,
      'duration': '8 weeks',
      'category': 'Cardio',
      'startDate': DateTime.now().subtract(const Duration(days: 7)),
      'endDate': DateTime.now().add(const Duration(days: 49)),
      'progress': 15,
      'status': 'active',
    },
  ];

  final List<Map<String, dynamic>> _scheduledPrograms = [
    {
      'id': '3',
      'title': 'Yoga for Athletes',
      'trainer': 'Emma Davis',
      'trainerImage': 'ED',
      'price': 39.99,
      'duration': '6 weeks',
      'category': 'Flexibility',
      'startDate': DateTime.now().add(const Duration(days: 7)),
      'endDate': DateTime.now().add(const Duration(days: 49)),
      'progress': 0,
      'status': 'scheduled',
    },
    {
      'id': '4',
      'title': 'Marathon Prep',
      'trainer': 'Lisa Thompson',
      'trainerImage': 'LT',
      'price': 59.99,
      'duration': '16 weeks',
      'category': 'Running',
      'startDate': DateTime.now().add(const Duration(days: 14)),
      'endDate': DateTime.now().add(const Duration(days: 126)),
      'progress': 0,
      'status': 'scheduled',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Check if user just enrolled
    final args = Get.arguments;
    if (args != null && args is Map && args['enrolled'] == true) {
      // Add the newly enrolled program to scheduled programs
      final program = args['program'];
      if (program != null) {
        // Ensure dates are properly set
        final startDate = program['startDate'] ?? DateTime.now().add(const Duration(days: 1));
        final calculatedEndDate = startDate is DateTime ? startDate.add(const Duration(days: 84)) : DateTime.now().add(const Duration(days: 85));
        final endDate = program['endDate'] ?? calculatedEndDate;

        // Ensure all required string fields have defaults
        _scheduledPrograms.insert(0, {
          ...program,
          'id': program['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'title': program['title']?.toString() ?? 'Program',
          'trainer': program['trainer']?.toString() ?? 'Trainer',
          'trainerImage': program['trainerImage']?.toString() ?? 'UT',
          'duration': program['duration']?.toString() ?? '12 weeks',
          'category': program['category']?.toString() ?? 'General',
          'progress': 0,
          'status': 'scheduled',
          'startDate': startDate,
          'endDate': endDate,
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _viewProgramDetails(Map<String, dynamic> program) {
    Get.toNamed(AppRoutes.programDetail, arguments: program);
  }

  void _showCancelDialog(Map<String, dynamic> program) {
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
                'Cancel Program?',
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to cancel this program?',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  program['title'] ?? '',
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
                      child: Text('No', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.onBackground)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _cancelProgram(program);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Yes, Cancel', style: AppTextStyles.buttonMedium.copyWith(color: Colors.white)),
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

  void _cancelProgram(Map<String, dynamic> program) {
    final programId = program['id']?.toString();
    if (programId == null) return;

    setState(() {
      _scheduledPrograms.removeWhere((p) => p['id']?.toString() == programId);
      _activePrograms.removeWhere((p) => p['id']?.toString() == programId);
    });

    Get.snackbar(
      'Program Cancelled',
      'Your enrollment in ${program['title']?.toString() ?? 'program'} has been cancelled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.completed,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent, size: 18),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('My Programs', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withOpacity(0.6),
          labelStyle: AppTextStyles.titleSmall,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Scheduled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Programs Tab
          _buildProgramsList(_activePrograms, isActive: true),

          // Scheduled Programs Tab
          _buildProgramsList(_scheduledPrograms, isActive: false),
        ],
      ),
    );
  }

  Widget _buildProgramsList(List<Map<String, dynamic>> programs, {required bool isActive}) {
    if (programs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? Icons.fitness_center : Icons.event_available, size: 80, color: AppColors.primaryGray.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(isActive ? 'No Active Programs' : 'No Scheduled Programs', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 8),
            Text('Explore the marketplace to find programs', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.marketplace),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              icon: const Icon(Icons.explore),
              label: const Text('Browse Programs'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return _buildProgramCard(program, isActive: isActive);
      },
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program, {required bool isActive}) {
    // Handle null dates safely
    final startDate = program['startDate'] is DateTime
        ? program['startDate'] as DateTime
        : program['startDate'] != null && program['startDate'] is String
        ? DateTime.parse(program['startDate'] as String)
        : DateTime.now().add(const Duration(days: 1));

    final endDate = program['endDate'] is DateTime
        ? program['endDate'] as DateTime
        : program['endDate'] != null && program['endDate'] is String
        ? DateTime.parse(program['endDate'] as String)
        : DateTime.now().add(const Duration(days: 84));

    final progress = program['progress'] ?? 0;
    final canCancel = !isActive || startDate.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? AppColors.accent.withOpacity(0.3) : AppColors.primaryGray.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent,
                child: Text(program['trainerImage']?.toString() ?? 'UT', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onAccent)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['title']?.toString() ?? 'Program',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                    ),
                    Text('by ${program['trainer']?.toString() ?? 'Trainer'}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: isActive ? AppColors.completed.withOpacity(0.1) : AppColors.upcoming.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  isActive ? 'Active' : 'Scheduled',
                  style: AppTextStyles.labelSmall.copyWith(color: isActive ? AppColors.completed : AppColors.upcoming, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar (for active programs)
          if (isActive) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                Text(
                  '$progress%',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress / 100, backgroundColor: AppColors.primaryGray.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent)),
            const SizedBox(height: 16),
          ],

          // Dates
          Row(
            children: [
              Expanded(child: _buildDateInfo(Icons.play_circle_outline, 'Start', _formatDate(startDate))),
              const SizedBox(width: 12),
              Expanded(child: _buildDateInfo(Icons.flag_outlined, 'End', _formatDate(endDate))),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewProgramDetails(program),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: AppColors.accent, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(Icons.visibility, size: 18, color: AppColors.accent),
                  label: Text('View Details', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent)),
                ),
              ),
              if (canCancel) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCancelDialog(program),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                    label: Text('Cancel', style: AppTextStyles.labelMedium.copyWith(color: Colors.red)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String label, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGray),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                Text(
                  date,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
