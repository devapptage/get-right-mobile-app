import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/constants/app_constants.dart';

/// Helper utility functions
class Helpers {
  Helpers._(); // Private constructor

  /// Show success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.completed,
      colorText: AppColors.white,
      duration: AppConstants.snackbarDuration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Show error snackbar
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      duration: AppConstants.snackbarDuration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Show info snackbar
  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      duration: AppConstants.snackbarDuration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Show warning snackbar
  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.upcoming,
      colorText: AppColors.white,
      duration: AppConstants.snackbarDuration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Show loading dialog
  static void showLoading([String? message]) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.green),
                if (message != null) ...[const SizedBox(height: 16), Text(message)],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmation({required String title, required String message, String confirmText = 'Confirm', String cancelText = 'Cancel'}) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text(cancelText)),
          ElevatedButton(onPressed: () => Get.back(result: true), child: Text(confirmText)),
        ],
      ),
    );
    return result ?? false;
  }

  /// Format date
  static String formatDate(DateTime date, {String? format}) {
    return DateFormat(format ?? AppConstants.dateFormat).format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime, {String? format}) {
    return DateFormat(format ?? AppConstants.dateTimeFormat).format(dateTime);
  }

  /// Format time
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    return DateFormat(use24Hour ? AppConstants.timeFormat24Hour : AppConstants.timeFormat12Hour).format(time);
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format duration (e.g., "1h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format distance (meters to km/miles)
  static String formatDistance(double meters, {bool useMiles = false}) {
    if (useMiles) {
      final miles = meters / 1609.34;
      return '${miles.toStringAsFixed(2)} mi';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(2)} km';
    }
  }

  /// Format pace (min/km or min/mile)
  static String formatPace(Duration duration, double distanceMeters, {bool useMiles = false}) {
    final distance = useMiles ? distanceMeters / 1609.34 : distanceMeters / 1000;
    if (distance == 0) return '0:00';

    final paceMinutes = duration.inSeconds / 60 / distance;
    final minutes = paceMinutes.floor();
    final seconds = ((paceMinutes - minutes) * 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}/${useMiles ? 'mi' : 'km'}';
  }

  /// Format number with commas
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Calculate BMI
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Generate random color
  static Color generateColor(String seed) {
    final hash = seed.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;
    return Color.fromRGBO(r, g, b, 1);
  }
}
