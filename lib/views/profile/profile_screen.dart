import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/services/storage_service.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, String?>> _getUserData() async {
    final storage = await StorageService.getInstance();
    return {'name': storage.getName(), 'email': storage.getEmail()};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => Get.toNamed(AppRoutes.settings))],
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          final userData = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.secondary, // Green (secondary)
                      child: Text(userData?['name']?.substring(0, 1).toUpperCase() ?? 'U', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onSecondary)), // White text
                    ),
                    const SizedBox(height: 16),
                    Text(userData?['name'] ?? 'User Name', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground)),
                    const SizedBox(height: 4),
                    Text(userData?['email'] ?? 'user@example.com', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                    const SizedBox(height: 16),
                    OutlinedButton(onPressed: () => Get.toNamed(AppRoutes.editProfile), child: const Text('Edit Profile')),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [_buildStatCard('150', 'Workouts'), _buildStatCard('45', 'Day Streak'), _buildStatCard('28', 'Programs')],
              ),
              const SizedBox(height: 32),

              // Menu items
              _buildMenuItem(icon: Icons.fitness_center, title: 'My Workouts', onTap: () => Get.toNamed(AppRoutes.journal)),
              _buildMenuItem(icon: Icons.school_outlined, title: 'My Programs', onTap: () => Get.toNamed(AppRoutes.myPrograms)),
              _buildMenuItem(icon: Icons.chat_outlined, title: 'Messages', onTap: () => Get.toNamed(AppRoutes.chatList)),
              _buildMenuItem(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () => Get.toNamed(AppRoutes.notifications)),
              _buildMenuItem(icon: Icons.help_outline, title: 'Help & Feedback', onTap: () => Get.toNamed(AppRoutes.helpFeedback)),
              const Divider(height: 32),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: AppColors.error,
                onTap: () {
                  final authController = Get.find<AuthController>();
                  authController.logout();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.statNumber.copyWith(color: AppColors.secondary)), // Green numbers
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.statLabel.copyWith(color: AppColors.primaryGray)), // Gray labels
      ],
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, Color? iconColor, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.onBackground), // White icons
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)), // White text
      trailing: Icon(Icons.chevron_right, color: AppColors.primaryGray), // Gray chevron
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
