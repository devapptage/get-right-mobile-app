import 'package:flutter/material.dart';
import 'package:get_right/constants/asset_paths.dart';
import 'package:get_right/theme/color_constants.dart';

/// Reusable app logo widget
class AppLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final double borderRadius;
  final bool showShadow;
  final EdgeInsets? padding;

  const AppLogo({super.key, this.size = 80, this.backgroundColor, this.borderRadius = 16, this.showShadow = false, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // color: backgroundColor ?? AppColors.secondary, // Gray background by default
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow ? [BoxShadow(color: (backgroundColor ?? AppColors.secondary).withOpacity(0.3), blurRadius: 20, spreadRadius: 3, offset: const Offset(0, 5))] : null,
      ),
      child: Image.asset(
        AssetPaths.logo,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image not found
          return Icon(Icons.fitness_center, size: size * 0.10, color: backgroundColor == AppColors.primary ? AppColors.onPrimary : AppColors.onSecondary);
        },
      ),
    );
  }
}
