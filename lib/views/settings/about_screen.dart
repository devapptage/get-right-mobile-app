import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// About Screen - App information for Alpha
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(24)),
              child: Center(
                child: Text('GR', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onAccent, fontSize: 48)),
              ),
            ),

            const SizedBox(height: 24),

            // App Name & Version
            Text(
              'Get Right',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Version 1.0.0 (Alpha)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),

            const SizedBox(height: 32),

            // Description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGray, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Get Right', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 12),
                  Text(
                    'Get Right is your ultimate fitness companion. Track your workouts, plan your training, and achieve your fitness goals with our comprehensive fitness platform.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features
            _buildFeatureItem(icon: Icons.fitness_center, title: 'Workout Tracking', description: 'Log and monitor your fitness progress'),
            _buildFeatureItem(icon: Icons.directions_run, title: 'GPS Run Tracking', description: 'Track your runs with real-time GPS'),
            _buildFeatureItem(icon: Icons.calendar_today, title: 'Workout Planning', description: 'Plan and schedule your training'),
            _buildFeatureItem(icon: Icons.store, title: 'Program Marketplace', description: 'Browse and purchase training programs'),

            const SizedBox(height: 32),

            // Legal
            Text(
              '© 2025 Get Right. All rights reserved.',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
