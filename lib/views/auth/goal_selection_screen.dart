import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final List<String> _selectedGoals = [];

  final List<String> _goals = [
    'Lose Weight',
    'Build Muscle',
    'Stay Healthy',
    'Improve Performance',
    'Track Progress',
    'Build Habits',
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
                    color: index < 2
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'What\'s your main goal?',
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
                        'This helps us recommend the best features for you \n Select all that apply',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onBackground.withOpacity(0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Options
                    ..._goals.map(
                      (goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildGoalButton(goal),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: 'Continue',
                      onPressed: _selectedGoals.isNotEmpty
                          ? () {
                              final args =
                                  Get.arguments as Map<String, dynamic>?;
                              Get.toNamed(
                                AppRoutes.fitnessLevelSelection,
                                arguments: args,
                              );
                            }
                          : null,
                      backgroundColor: _selectedGoals.isNotEmpty
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

  Widget _buildGoalButton(String goal) {
    final isSelected = _selectedGoals.contains(goal);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGoals.remove(goal);
          } else {
            _selectedGoals.add(goal);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : const Color(0xFF666666),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              goal,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.onBackground,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
