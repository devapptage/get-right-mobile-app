import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Get Right App Theme Configuration
///
/// This file contains the complete ThemeData setup for the Get Right app.
/// It implements a clean, modern, and minimal design system with:
/// - Flat UI elements
/// - Ample white space
/// - Strong visual contrast
/// - Consistent spacing and typography

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// Light Theme (Primary theme for Get Right)
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3
      useMaterial3: true,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.gray,
        outlineVariant: AppColors.lightGray,
      ),

      // Scaffold Background - Black
      scaffoldBackgroundColor: AppColors.background, // Black background
      // App Bar Theme - Using Black background with White text
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary, // Black (primary)
        foregroundColor: AppColors.onPrimary, // White text/icons
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light, // Light icons for dark background
        titleTextStyle: AppTextStyles.titleLarge,
        iconTheme: IconThemeData(color: AppColors.onPrimary, size: 24), // White icons
      ),

      // Text Theme - White text on black backgrounds
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground), // White
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.onBackground),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.onBackground),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.onBackground),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.onBackground),
      ),

      // Button Themes
      // Primary buttons use Black (primary color)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Black
          foregroundColor: AppColors.onPrimary, // White
          textStyle: AppTextStyles.buttonLarge,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          minimumSize: const Size(120, 56),
        ),
      ),

      // Outlined buttons use Gray (primary gray) or Green (secondary) for accents
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary, // Black
          textStyle: AppTextStyles.buttonLarge,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          side: const BorderSide(color: AppColors.primaryGray, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(120, 56),
        ),
      ),

      // Text buttons use Green (secondary) for actions
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary, // Green
          textStyle: AppTextStyles.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration Theme - Using Gray (primary gray) for backgrounds on black
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight, // Gray background
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2), // Green focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceLight), // Black text on gray
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark),
        errorStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.error),
      ),

      // Card Theme - Using Dark Gray/Black surface with gray borders
      cardTheme: CardThemeData(
        color: AppColors.surface, // Dark gray/black surface
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.primaryGray, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button Theme - Using Green (secondary) for accent
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary, // Green
        foregroundColor: AppColors.onSecondary, // White
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme - Black background, Green secondary for selected
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary, // Black background
        selectedItemColor: AppColors.secondary, // Green (secondary) for selected
        unselectedItemColor: AppColors.primaryGray, // Gray (primary) for unselected
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Chip Theme - Gray (primary) for unselected, Green (secondary) for selected
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryGray, // Gray (primary)
        deleteIconColor: AppColors.onPrimaryGray, // Black
        disabledColor: AppColors.primaryGrayDark,
        selectedColor: AppColors.secondary, // Green (secondary) when selected
        secondarySelectedColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.onPrimaryGray), // Black text on gray
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.onSecondary), // White on green
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog Theme - Dark surface
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface, // Dark gray/black
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface), // White text
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface), // White text
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: AppColors.gray, thickness: 1, space: 24),

      // Icon Theme - White icons for dark backgrounds
      iconTheme: const IconThemeData(color: AppColors.onBackground, size: 24), // White icons
      // Switch Theme - Green (secondary) when selected, Gray (primary) when unselected
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onSecondary; // White
          }
          return AppColors.primaryGray; // Gray
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary; // Green (secondary)
          }
          return AppColors.primaryGrayDark; // Gray (primary)
        }),
      ),

      // Checkbox Theme - Green (secondary) when selected
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary; // Green (secondary)
          }
          return AppColors.secondaryWhite; // White
        }),
        checkColor: WidgetStateProperty.all(AppColors.onSecondary), // White check
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme - Green (secondary) when selected, Gray (primary) when unselected
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary; // Green (secondary)
          }
          return AppColors.primaryGrayDark; // Gray (primary)
        }),
      ),

      // Progress Indicator Theme - Green (secondary) for progress
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.secondary, // Green
        linearTrackColor: AppColors.primaryGray, // Gray track
        circularTrackColor: AppColors.primaryGray, // Gray track
      ),

      // Snackbar Theme - Using Black (primary) background
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary, // Black
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary), // White text
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Tab Bar Theme - Green (secondary) for selected, Gray (primary) for unselected
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.secondary, // Green (secondary) for selected
        unselectedLabelColor: AppColors.primaryGrayDark, // Gray (primary) for unselected
        labelStyle: AppTextStyles.titleSmall,
        unselectedLabelStyle: AppTextStyles.titleSmall,
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: AppColors.secondary, width: 3)), // Green indicator
      ),

      // Bottom Sheet Theme - Dark surface
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface, // Dark gray/black
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
    );
  }

  /// System UI Overlay Styles - Dark theme
  static const SystemUiOverlayStyle lightSystemOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // Light icons for dark background
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.primary, // Black navigation bar
    systemNavigationBarIconBrightness: Brightness.light, // Light icons
  );
}
