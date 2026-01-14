import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

class ExerciseFrequencySelectionScreen extends StatefulWidget {
  const ExerciseFrequencySelectionScreen({super.key});

  @override
  State<ExerciseFrequencySelectionScreen> createState() => _ExerciseFrequencySelectionScreenState();
}

class _ExerciseFrequencySelectionScreenState extends State<ExerciseFrequencySelectionScreen> {
  String? _selectedFrequency;

  final List<String> _frequencies = ['Daily (7x/week)', '5 times per week', '3 times per week', '2 times per week', 'Once per week'];

  int get _currentIndex {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['index'] as int? ?? 0;
  }

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
                  icon: const Icon(Icons.chevron_left, color: AppColors.accent, size: 28),
                  onPressed: () => Get.back(),
                ),
                _currentIndex == 3
                    ? const SizedBox.shrink()
                    : TextButton(
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: index < 4 ? AppColors.accent : AppColors.accent.withOpacity(0.3)),
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
                        textAlign: TextAlign.center,
                        'How often do you plan to exercise?',
                        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'This helps us create realistic goals for you',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Options
                    ..._frequencies.map((frequency) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildFrequencyButton(frequency))),

                    const SizedBox(height: 25),
                    CustomButton(
                      text: 'Get Started',
                      onPressed: _selectedFrequency != null
                          ? () {
                              final args = Get.arguments as Map<String, dynamic>?;
                              final preference = args?['preference'] as String?;
                              Get.offAllNamed(AppRoutes.home, arguments: {'preference': preference});
                            }
                          : null,
                      backgroundColor: _selectedFrequency != null ? AppColors.accent : AppColors.primaryGray,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            // Get Started button
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyButton(String frequency) {
    final isSelected = _selectedFrequency == frequency;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.accent : const Color(0xFF666666), width: isSelected ? 2 : 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              frequency,
              style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? Colors.white : AppColors.onBackground, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
