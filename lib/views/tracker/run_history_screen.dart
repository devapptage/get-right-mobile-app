import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_right/models/run_model.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Run History Screen - Display all completed runs
class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key});

  @override
  State<RunHistoryScreen> createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  final StorageService _storageService = Get.find<StorageService>();
  List<RunModel> _runs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRuns();
  }

  Future<void> _loadRuns() async {
    setState(() => _isLoading = true);
    final runs = await _storageService.getRuns();
    setState(() {
      _runs = runs..sort((a, b) => b.startTime.compareTo(a.startTime));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Run History', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _runs.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildStatsHeader(),
                Expanded(child: _buildRunList()),
              ],
            ),
    );
  }

  /// Build stats header
  Widget _buildStatsHeader() {
    final totalDistance = _runs.fold(0.0, (sum, run) => sum + run.distanceMeters);
    final totalDuration = _runs.fold(Duration.zero, (sum, run) => sum + run.duration);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.15), AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${_runs.length}', 'Total Runs'),
          Container(width: 1, height: 40, color: AppColors.primaryGray.withOpacity(0.3)),
          _buildStatItem('${(totalDistance / 1000).toStringAsFixed(1)} km', 'Total Distance'),
          Container(width: 1, height: 40, color: AppColors.primaryGray.withOpacity(0.3)),
          _buildStatItem(_formatTotalDuration(totalDuration), 'Total Time'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontSize: 11)),
      ],
    );
  }

  /// Build run list
  Widget _buildRunList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _runs.length,
      itemBuilder: (context, index) {
        return _buildRunCard(_runs[index], index);
      },
    );
  }

  /// Build individual run card
  Widget _buildRunCard(RunModel run, int index) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.runDetail, arguments: run),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.directions_run_rounded, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateFormat.format(run.startTime),
                              style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${timeFormat.format(run.startTime)} - ${timeFormat.format(run.endTime)}',
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primaryGray),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRunStat(Icons.straighten_rounded, '${(run.distanceMeters / 1000).toStringAsFixed(2)} km'),
                      _buildRunStat(Icons.timer_rounded, _formatDuration(run.duration)),
                      if (run.averagePace != null) _buildRunStat(Icons.speed_rounded, '${run.averagePace!.toStringAsFixed(0)}\'/km'),
                      if (run.elevationGain != null) _buildRunStat(Icons.terrain_rounded, '${run.elevationGain!.toStringAsFixed(0)}m'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRunStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), shape: BoxShape.circle),
              child: const Icon(Icons.directions_run_rounded, size: 60, color: AppColors.accent),
            ),
            const SizedBox(height: 24),
            Text(
              'No Runs Yet',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Start your first run to see it here!',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('Start Running', style: AppTextStyles.buttonLarge),
            ),
          ],
        ),
      ),
    );
  }

  /// Format duration
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }

  /// Format total duration
  String _formatTotalDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
