import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';

/// Get Right Typography System
///
/// This file defines all text styles using:
/// - Enra Sans (Bold) for headings and titles (FALLBACK TO INTER UNTIL FONT ADDED)
/// - Inter (Regular, 24pt base) for body text
///
/// Note: EnraSans font is not yet available. Inter is used for all text temporarily.
/// After adding EnraSans-Bold.ttf to assets/fonts/, uncomment the font in pubspec.yaml
/// and the text will automatically switch to use Enra Sans for headings.

class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Font Families
  // Note: Using Inter for headings until EnraSans font files are added
  static const String enraSans = 'Inter'; // Temporarily set to Inter
  static const String inter = 'Inter';

  // Heading Styles (Enra Sans Bold)
  static const TextStyle headlineLarge = TextStyle(fontFamily: enraSans, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: -0.5, color: AppColors.black);

  static const TextStyle headlineMedium = TextStyle(fontFamily: enraSans, fontSize: 28, fontWeight: FontWeight.bold, height: 1.3, letterSpacing: -0.3, color: AppColors.black);

  static const TextStyle headlineSmall = TextStyle(fontFamily: enraSans, fontSize: 24, fontWeight: FontWeight.bold, height: 1.3, letterSpacing: 0, color: AppColors.black);

  // Title Styles (Enra Sans Bold)
  static const TextStyle titleLarge = TextStyle(fontFamily: enraSans, fontSize: 22, fontWeight: FontWeight.bold, height: 1.4, letterSpacing: 0, color: AppColors.black);

  static const TextStyle titleMedium = TextStyle(fontFamily: enraSans, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4, letterSpacing: 0.15, color: AppColors.black);

  static const TextStyle titleSmall = TextStyle(fontFamily: enraSans, fontSize: 16, fontWeight: FontWeight.bold, height: 1.4, letterSpacing: 0.1, color: AppColors.black);

  // Body Styles (Inter Regular, 24pt base)
  static const TextStyle bodyLarge = TextStyle(fontFamily: inter, fontSize: 24, fontWeight: FontWeight.normal, height: 1.5, letterSpacing: 0.5, color: AppColors.black);

  static const TextStyle bodyMedium = TextStyle(fontFamily: inter, fontSize: 16, fontWeight: FontWeight.normal, height: 1.5, letterSpacing: 0.25, color: AppColors.black);

  static const TextStyle bodySmall = TextStyle(fontFamily: inter, fontSize: 14, fontWeight: FontWeight.normal, height: 1.5, letterSpacing: 0.4, color: AppColors.black);

  // Label Styles (Inter for UI elements)
  static const TextStyle labelLarge = TextStyle(fontFamily: inter, fontSize: 14, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.1, color: AppColors.black);

  static const TextStyle labelMedium = TextStyle(fontFamily: inter, fontSize: 12, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.5, color: AppColors.black);

  static const TextStyle labelSmall = TextStyle(fontFamily: inter, fontSize: 11, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.5, color: AppColors.darkGray);

  // Button Text Styles
  static const TextStyle buttonLarge = TextStyle(fontFamily: enraSans, fontSize: 16, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: 0.75, color: AppColors.white);

  static const TextStyle buttonMedium = TextStyle(fontFamily: enraSans, fontSize: 14, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: 0.5, color: AppColors.white);

  // Specialized Styles
  static const TextStyle caption = TextStyle(fontFamily: inter, fontSize: 12, fontWeight: FontWeight.normal, height: 1.3, letterSpacing: 0.4, color: AppColors.darkGray);

  static const TextStyle overline = TextStyle(fontFamily: inter, fontSize: 10, fontWeight: FontWeight.w500, height: 1.6, letterSpacing: 1.5, color: AppColors.darkGray);

  // Workout-specific Styles
  static const TextStyle statNumber = TextStyle(fontFamily: enraSans, fontSize: 36, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -1, color: AppColors.green);

  static const TextStyle statLabel = TextStyle(fontFamily: inter, fontSize: 12, fontWeight: FontWeight.normal, height: 1.3, letterSpacing: 0.5, color: AppColors.darkGray);
}
