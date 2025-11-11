import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Run Tracker - GPS tracking and run history
class RunTrackerScreen extends StatelessWidget {
  const RunTrackerScreen({super.key});

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
        title: Text('Run Tracker', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Show run history
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Run icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.directions_run, size: 60, color: AppColors.accent),
            ),
            const SizedBox(height: 32),

            // Title
            Text('Ready to Run?', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 12),
            Text(
              'Track your distance, pace, route, and elevation in real-time',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Quick Stats Preview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGray, width: 1),
              ),
              child: Column(
                children: [
                  Text('Your Running Stats', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_buildStatItem('0', 'km', 'Total Distance'), _buildStatItem('0', 'runs', 'This Week'), _buildStatItem('0:00', 'avg', 'Pace')],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Start Run Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.runTracking),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent),
                icon: const Icon(Icons.play_arrow, size: 28),
                label: Text('Start Run', style: AppTextStyles.buttonLarge),
              ),
            ),
            const SizedBox(height: 16),

            // View History Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Show run history
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGray, width: 2),
                  foregroundColor: AppColors.onBackground,
                ),
                icon: const Icon(Icons.history),
                label: Text('View History', style: AppTextStyles.buttonLarge.copyWith(color: AppColors.onBackground)),
              ),
            ),
            const SizedBox(height: 32),

            // Feature List
            _buildFeatureItem(Icons.gps_fixed, 'Live GPS Tracking'),
            _buildFeatureItem(Icons.speed, 'Real-time Pace & Distance'),
            _buildFeatureItem(Icons.map, 'Route Visualization'),
            _buildFeatureItem(Icons.terrain, 'Elevation Tracking'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String unit, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(unit, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
