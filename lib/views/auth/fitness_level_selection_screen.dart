import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

class FitnessLevelSelectionScreen extends StatefulWidget {
  const FitnessLevelSelectionScreen({super.key});

  @override
  State<FitnessLevelSelectionScreen> createState() =>
      _FitnessLevelSelectionScreenState();
}

class _FitnessLevelSelectionScreenState
    extends State<FitnessLevelSelectionScreen> {
  String? _selectedLevel;

  final List<Map<String, String>> _levels = [
    {
      'title': 'Beginner',
      'description': 'New to fitness or getting back into it',
    },
    {
      'title': 'Intermediate',
      'description': 'Regular exercise, comfortable with basics',
    },
    {
      'title': 'Advanced',
      'description': 'Experienced athlete or fitness enthusiast',
    },
  ];

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
                  icon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.accent,
                    size: 28,
                  ),
                  onPressed: () => Get.back(),
                ),
                TextButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < 3
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.3),
                  ),
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
                        'What\'s your fitness level?',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.accent,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'We\'ll adjust recommendations based on your experience',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onBackground.withOpacity(0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Options
                    ..._levels.map(
                      (level) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLevelCard(
                          title: level['title']!,
                          description: level['description']!,
                          isSelected: _selectedLevel == level['title'],
                          onTap: () =>
                              setState(() => _selectedLevel = level['title']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: 'Continue',
                      onPressed: _selectedLevel != null
                          ? () {
                              final existingArgs =
                                  Get.arguments as Map<String, dynamic>?;
                              final args = <String, dynamic>{
                                ...?existingArgs,
                                'index': 3,
                              };
                              Get.toNamed(
                                AppRoutes.exerciseFrequencySelection,
                                arguments: args,
                              );
                            }
                          : null,
                      backgroundColor: _selectedLevel != null
                          ? AppColors.accent
                          : AppColors.primaryGray,
                      textColor: Colors.white,
                    ),
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

  Widget _buildLevelCard({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : const Color(0xFF666666),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: isSelected ? AppColors.accent : AppColors.onBackground,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.accent.withOpacity(0.8)
                    : AppColors.onBackground.withOpacity(0.7),
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
