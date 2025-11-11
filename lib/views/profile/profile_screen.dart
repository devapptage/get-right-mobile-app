import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/services/storage_service.dart';

/// Profile screen - Redesigned to match app theme
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
        title: Text('Profile', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.onPrimary),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final name = userData?['name'] ?? 'User Name';
          final email = userData?['email'] ?? 'user@example.com';
          final initial = name.substring(0, 1).toUpperCase();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    children: [
                      // Profile Avatar
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accent, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.accent.withOpacity(0.2),
                              child: Text(initial, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontSize: 36)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.editProfile),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.background, width: 2),
                                ),
                                child: const Icon(Icons.edit, size: 16, color: AppColors.onAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("John Doe", style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground)),
                      const SizedBox(height: 4),
                      Text("john.doe@example.com", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 180,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.toNamed(AppRoutes.editProfile),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, elevation: 0),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Personal Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal Information", style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGray, width: 1),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('First Name', 'John', Icons.person_outline),
                            const Divider(height: 24, color: AppColors.primaryGray),
                            _buildInfoRow('Last Name', 'Doe', Icons.person_outline),
                            const Divider(height: 24, color: AppColors.primaryGray),
                            _buildInfoRow('Age', '28 years', Icons.cake_outlined),
                            const Divider(height: 24, color: AppColors.primaryGray),
                            _buildInfoRow('Gender', 'Male', Icons.wc),
                            const Divider(height: 24, color: AppColors.primaryGray),
                            _buildInfoRow('Fitness Goal', 'Build Muscle', Icons.flag_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bio Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGray, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_note, color: AppColors.accent, size: 20),
                                const SizedBox(width: 8),
                                Text('Bio', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Passionate fitness enthusiast working towards building strength and maintaining a healthy lifestyle. Love outdoor running and strength training!',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Workout Preferences Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGray, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.fitness_center, color: AppColors.accent, size: 20),
                                const SizedBox(width: 8),
                                Text('Workout Preferences', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [_buildPreferenceChip('Strength'), _buildPreferenceChip('Cardio'), _buildPreferenceChip('HIIT'), _buildPreferenceChip('Running')],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Menu Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primaryGray)),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        icon: Icons.fitness_center,
                        title: 'My Workouts',
                        subtitle: 'View workout history',
                        color: AppColors.accent,
                        onTap: () => Get.toNamed(AppRoutes.journal),
                      ),
                      _buildMenuCard(
                        icon: Icons.school_outlined,
                        title: 'My Programs',
                        subtitle: 'Purchased programs',
                        color: AppColors.upcoming,
                        onTap: () => Get.toNamed(AppRoutes.myPrograms),
                      ),
                      _buildMenuCard(
                        icon: Icons.chat_outlined,
                        title: 'Messages',
                        subtitle: 'Chat with trainers',
                        color: AppColors.completed,
                        onTap: () => Get.toNamed(AppRoutes.chatList),
                      ),
                      const SizedBox(height: 24),
                      Text('Settings', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primaryGray)),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notifications',
                        color: AppColors.accent,
                        onTap: () => Get.toNamed(AppRoutes.notifications),
                      ),
                      _buildMenuCard(
                        icon: Icons.help_outline,
                        title: 'Help & Feedback',
                        subtitle: 'Get support',
                        color: AppColors.primaryGray,
                        onTap: () => Get.toNamed(AppRoutes.helpFeedback),
                      ),
                      const SizedBox(height: 16),
                      _buildLogoutCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primaryGray, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('Logout', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            content: Text('Are you sure you want to logout?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: AppColors.primaryGray)),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  final authController = Get.find<AuthController>();
                  authController.logout();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.onError),
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.logout, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logout', style: AppTextStyles.titleSmall.copyWith(color: AppColors.error)),
                  const SizedBox(height: 2),
                  Text('Sign out of your account', style: AppTextStyles.labelSmall.copyWith(color: AppColors.error.withOpacity(0.8))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.error, size: 24),
          ],
        ),
      ),
    );
  }
}
