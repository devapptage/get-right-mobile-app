import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Empty state widget for when no data is available
class EmptyState extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({super.key, this.icon, this.image, required this.title, this.subtitle, this.buttonText, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) Image.asset(image!, height: 200, width: 200) else if (icon != null) Icon(icon, size: 120, color: AppColors.primaryGray),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground),
              textAlign: TextAlign.center,
            ), // White text
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray), // Gray text
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[const SizedBox(height: 24), ElevatedButton(onPressed: onButtonPressed, child: Text(buttonText!))],
          ],
        ),
      ),
    );
  }
}
