import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

class PreferenceSelectionScreen extends StatefulWidget {
  const PreferenceSelectionScreen({super.key});

  @override
  State<PreferenceSelectionScreen> createState() => _PreferenceSelectionScreenState();
}

class _PreferenceSelectionScreenState extends State<PreferenceSelectionScreen> {
  String? _selectedPreference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.accent, size: 35),
                  onPressed: () => Get.back(),
                ),
                TextButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            // Progress indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: index == 0 ? AppColors.accent : AppColors.accent.withOpacity(0.3)),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'What\'s your preference?',
                        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Choose your primary focus to personalize your experience',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Options
                    _buildOptionCard(
                      title: 'Strength Training',
                      description: 'I love lifting weights and building strength',
                      isSelected: _selectedPreference == 'Strength Training',
                      onTap: () => setState(() => _selectedPreference = 'Strength Training'),
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      title: 'Running & Cardio',
                      description: 'I prefer running, jogging, and cardio activities',
                      isSelected: _selectedPreference == 'Running & Cardio',
                      onTap: () => setState(() => _selectedPreference = 'Running & Cardio'),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'Continue',
                      onPressed: _selectedPreference != null ? () => Get.toNamed(AppRoutes.goalSelection, arguments: {'preference': _selectedPreference}) : null,
                      backgroundColor: _selectedPreference != null ? AppColors.accent : AppColors.primaryGray,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Continue button
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({required String title, required String description, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.accent : const Color(0xFF666666), width: isSelected ? 2 : 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: isSelected ? AppColors.accent : AppColors.onBackground, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.accent.withOpacity(0.8) : AppColors.onBackground.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
