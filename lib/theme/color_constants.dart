import 'package:flutter/material.dart';

/// Get Right Brand Color Palette
///
/// This file contains all brand colors as defined in the Get Right Brand Guide.
/// Use these constants throughout the app to maintain consistent branding.

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Brand Colors
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xFF29603C);
  static const Color gray = Color(0xFFD6D6D6);
  static const Color white = Color(0xFFF4F4F4);

  // Primary Colors (Black and Gray)
  static const Color primary = black;
  static const Color primaryVariant = Color(0xFF1A1A1A); // Darker black for emphasis
  static const Color onPrimary = white; // Text/icons on black
  static const Color primaryGray = gray;
  static const Color primaryGrayDark = Color(0xFF9E9E9E); // Darker gray variant
  static const Color onPrimaryGray = black; // Text/icons on gray

  // Secondary Colors (Gray - Primary secondary color)
  static const Color secondary = primaryGray; // Gray as secondary
  static const Color secondaryVariant = primaryGrayDark; // Darker gray variant
  static const Color onSecondary = onPrimaryGray; // Black text/icons on gray
  static const Color secondaryWhite = white;
  static const Color onSecondaryWhite = black; // Text/icons on white

  // Accent Color (Green - Used sparingly for contrast)
  static const Color accent = green; // Green accent for contrast
  static const Color accentVariant = Color(0xFF1E4A2E); // Darker green
  static const Color onAccent = white; // Text/icons on green

  // Background and Surface - Black backgrounds
  static const Color background = primary; // Black background
  static const Color onBackground = onPrimary; // White text on black
  static const Color surface = primaryVariant; // Dark gray/black for cards
  static const Color onSurface = onPrimary; // White text on dark surfaces
  static const Color surfaceLight = primaryGray; // Light gray for alternate surfaces
  static const Color onSurfaceLight = onPrimaryGray; // Black text on light gray

  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);

  // Status Colors (for workout tracking)
  static const Color completed = Color(0xFF4CAF50); // Green for completed
  static const Color upcoming = Color(0xFFFF9800); // Orange for upcoming
  static const Color missed = Color(0xFFF44336); // Red for missed

  // Neutral Shades
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = gray;
  static const Color darkGray = Color(0xFF757575);

  // Transparent variants (for overlays)
  static const Color blackOverlay = Color(0x80000000);
  static const Color whiteOverlay = Color(0x80F4F4F4);
}
