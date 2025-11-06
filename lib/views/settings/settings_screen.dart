import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: AppColors.onBackground),
            title: Text('Notifications', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppColors.onBackground),
            title: Text('Help & Feedback', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.helpFeedback),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.onBackground),
            title: Text('Terms & Conditions', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.termsConditions),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.onBackground),
            title: Text('Privacy Policy', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.onBackground),
            title: Text('About', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.about),
          ),
        ],
      ),
    );
  }
}
