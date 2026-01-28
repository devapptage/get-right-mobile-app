import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Loading indicator widget
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingIndicator({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: color ?? AppColors.secondary), // Green (secondary) default
          if (message != null) ...[const SizedBox(height: 16), Text(message!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)],
        ],
      ),
    );
  }
}

/// Fullscreen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackOverlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.secondary), // Green (secondary)
              if (message != null) ...[const SizedBox(height: 16), Text(message!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)],
            ],
          ),
        ),
      ),
    );
  }
}
