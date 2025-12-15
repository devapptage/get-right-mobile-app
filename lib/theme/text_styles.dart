import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';

/// Get Right Typography System
///
/// Updated according to Design & Typography Guidelines (Section 3.3)
/// - Primary Typeface: Clean, geometric sans-serif (Inter/SF Pro)
/// - Headers: Bold or semibold weight
/// - Sub headers & Labels: Medium weight with increased letter spacing
/// - Body Text: Regular weight
/// - Buttons & CTAs: Semibold with clear spacing

class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Font Families
  static const String primaryFont = 'Inter'; // Clean, geometric sans-serif

  // Heading Styles - Bold or semibold for section titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.secondary, // Black (secondary accent)
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.secondary, // Black
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.secondary, // Black
  );

  // Title Styles - Bold or semibold
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.secondary, // Black
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.secondary, // Black
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.secondary, // Black
  );

  // Sub headers & Labels - Medium weight with increased letter spacing
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium weight
    height: 1.4,
    letterSpacing: 0.75, // Increased letter spacing
    color: AppColors.secondary, // Black
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium weight
    height: 1.4,
    letterSpacing: 0.5, // Increased letter spacing
    color: AppColors.secondary, // Black
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium weight
    height: 1.4,
    letterSpacing: 0.5, // Increased letter spacing
    color: AppColors.darkGray,
  );

  // Body Text - Regular weight for instructions, details, and stats
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.normal, // Regular weight
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.secondary, // Black
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.normal, // Regular weight
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.secondary, // Black
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular weight
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.darkGray,
  );

  // Button & CTA Styles - Semibold with clear spacing and strong contrast
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.2,
    letterSpacing: 0.75, // Clear spacing
    color: AppColors.onAccent, // White on green (strong contrast)
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.2,
    letterSpacing: 0.5, // Clear spacing
    color: AppColors.onAccent, // White on green
  );

  // Specialized Styles
  static const TextStyle caption = TextStyle(fontFamily: primaryFont, fontSize: 12, fontWeight: FontWeight.normal, height: 1.3, letterSpacing: 0.4, color: AppColors.darkGray);

  static const TextStyle overline = TextStyle(fontFamily: primaryFont, fontSize: 10, fontWeight: FontWeight.w500, height: 1.6, letterSpacing: 1.5, color: AppColors.darkGray);

  // Workout-specific Styles
  static const TextStyle statNumber = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.1,
    letterSpacing: -1,
    color: AppColors.accent, // Green for stats
  );

  static const TextStyle statLabel = TextStyle(fontFamily: primaryFont, fontSize: 12, fontWeight: FontWeight.normal, height: 1.3, letterSpacing: 0.5, color: AppColors.darkGray);
}
