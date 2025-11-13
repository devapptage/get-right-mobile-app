import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/settings_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Account Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Account',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ),

          // Enable Notifications Toggle
          Obx(
            () => SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined, color: AppColors.onBackground),
              title: Text('Enable Notifications', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
              subtitle: Text('Receive workout reminders and updates', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
              value: controller.notificationsEnabled,
              activeColor: AppColors.accent,
              onChanged: controller.toggleNotifications,
            ),
          ),

          // Notifications Settings
          ListTile(
            leading: const Icon(Icons.tune, color: AppColors.onBackground),
            title: Text('Notification Preferences', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: () => Get.toNamed(AppRoutes.notifications),
          ),

          // const Divider(height: 32),

          // // Trainer Section
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          //   child: Text(
          //     'Trainer',
          //     style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
          //   ),
          // ),

          // Become a Trainer Toggle
          // Obx(
          //   () => SwitchListTile(
          //     secondary: Icon(Icons.fitness_center, color: controller.isTrainer ? AppColors.accent : AppColors.onBackground),
          //     title: Text('Trainer Mode', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
          //     subtitle: Text(
          //       controller.isTrainer ? 'You are a trainer on Get Right' : 'Become a trainer and earn money',
          //       style: AppTextStyles.labelSmall.copyWith(color: controller.isTrainer ? AppColors.accent : AppColors.primaryGray),
          //     ),
          //     value: controller.isTrainer,
          //     activeColor: AppColors.accent,
          //     onChanged: controller.toggleTrainerMode,
          //   ),
          // ),

          // const Divider(height: 32),

          // General Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'General',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
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

          const Divider(height: 32),

          // Account Actions Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Account Actions',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.onBackground),
            title: Text('Logout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
            onTap: controller.logout,
          ),

          // Delete Account
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: Text(
              'Delete Account',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Permanently delete your account and data', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
            onTap: controller.deleteAccount,
          ),

          const SizedBox(height: 24),

          // Version Info
          Center(
            child: Text('Get Right v1.0.0', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
