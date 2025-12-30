import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Trainer Profile Screen
class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get trainer data from arguments (in production, fetch from API)
    final Map<String, dynamic> trainer = Get.arguments ?? _getMockTrainerData();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Trainer Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.accent,
            elevation: 0,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () {
                if (Get.key.currentState?.canPop() ?? false) {
                  Get.back();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Profile Avatar with shadow
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: AppColors.surface,
                              child: Text(
                                trainer['initials'],
                                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 32),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Trainer Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              trainer['name'],
                              style: AppTextStyles.titleLarge.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 0.5),
                            ),
                            if (trainer['certified'])
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.completed,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: AppColors.completed.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))],
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Rating with elegant design
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.upcoming, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                '${trainer['rating']}',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Container(width: 1, height: 16, color: Colors.white.withOpacity(0.3)),
                              const SizedBox(width: 8),
                              Text(
                                '${trainer['totalReviews']} reviews',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent.withOpacity(0.95), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatChip(Icons.people_rounded, '${trainer['students']} Students'),
                            const SizedBox(width: 12),
                            _buildStatChip(Icons.fitness_center_rounded, '${trainer['yearsOfExperience']} Years'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]),
                            boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(AppRoutes.chatRoom, arguments: {'trainerId': trainer['id'], 'trainerName': trainer['name']});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.chat_bubble_rounded, size: 22),
                            label: Text(
                              'Message',
                              style: AppTextStyles.labelLarge.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.accent, width: 2),
                            boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'Book Session',
                                'Hourly Rate: \$${trainer['hourlyRate']}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.accent.withOpacity(0.1),
                                colorText: AppColors.accent,
                                duration: const Duration(seconds: 2),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: AppColors.surface,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.accent),
                            label: Text(
                              '\$${trainer['hourlyRate']}/hr',
                              style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Premium Subscription Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                                    ),
                                    child: Icon(Icons.workspace_premium_rounded, color: AppColors.upcoming, size: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Premium Access',
                                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Get direct contact details', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Benefits
                              _buildPremiumBenefit(Icons.phone_rounded, 'Direct phone number'),
                              const SizedBox(height: 12),
                              _buildPremiumBenefit(Icons.email_rounded, 'Personal email address'),
                              const SizedBox(height: 12),
                              _buildPremiumBenefit(Icons.location_on_rounded, 'Training location details'),
                              const SizedBox(height: 12),
                              _buildPremiumBenefit(Icons.schedule_rounded, 'Priority booking access'),
                              const SizedBox(height: 20),
                              // Subscribe Button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showSubscriptionDialog(context, trainer),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.diamond_rounded, color: AppColors.accent, size: 24),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Subscribe for \$9.99/month',
                                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accentVariant.withOpacity(0.1)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.person_outline_rounded, color: AppColors.accent, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'About',
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)),
                        ),
                        child: Text(trainer['bio'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.8), height: 1.7, letterSpacing: 0.3)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Specialties
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accentVariant.withOpacity(0.1)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.stars_rounded, color: AppColors.accent, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Specialties',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: (trainer['specialties'] as List? ?? []).map<Widget>((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.15), AppColors.accentVariant.withOpacity(0.1)]),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1.5),
                              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accent),
                                const SizedBox(width: 8),
                                Text(
                                  specialty.toString(),
                                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Certifications (if certified)
                if (trainer['certified'] && trainer['certifications'] != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.completed.withOpacity(0.2), AppColors.completed.withOpacity(0.1)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.verified_rounded, color: AppColors.completed, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Certifications',
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...(trainer['certifications'] as List? ?? []).map<Widget>(
                          (cert) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.completed.withOpacity(0.3)),
                              boxShadow: [BoxShadow(color: AppColors.completed.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.completed.withOpacity(0.1), shape: BoxShape.circle),
                                  child: Icon(Icons.workspace_premium_rounded, color: AppColors.completed, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    cert.toString(),
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                                  ),
                                ),
                                Icon(Icons.check_circle_rounded, color: AppColors.completed, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Reviews Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accentVariant.withOpacity(0.1)]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.rate_review_rounded, color: AppColors.accent, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Reviews',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.trainerReviews, arguments: trainer),
                            icon: Text(
                              'View All (${trainer['totalReviews']})',
                              style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                            ),
                            label: Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.accent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: _getMockReviews().length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Padding(padding: const EdgeInsets.only(right: 16), child: _buildReviewCard(_getMockReviews()[index])),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Programs Section
                _buildProgramsSection('Active Programs', trainer['activePrograms'], _getMockPrograms('active')),

                const SizedBox(height: 24),
                _buildProgramsSection('Completed Programs', trainer['completedPrograms'], _getMockPrograms('completed')),

                const SizedBox(height: 24),
                _buildProgramsSection('All Programs', trainer['totalPrograms'], _getMockPrograms('all')),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: AppColors.onAccent),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: AppColors.primaryGray.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    review['userInitials'],
                    style: AppTextStyles.titleSmall.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'],
                      style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              index < review['rating'] ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 16,
                              color: index < review['rating'] ? AppColors.upcoming : AppColors.primaryGray.withOpacity(0.4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review['comment'],
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.8), height: 1.6, letterSpacing: 0.2),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.fitness_center, size: 14, color: AppColors.accent.withOpacity(0.7)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  review['programName'],
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsSection(String title, int count, List<Map<String, dynamic>> programs) {
    IconData sectionIcon;
    if (title.contains('Active')) {
      sectionIcon = Icons.play_circle_rounded;
    } else if (title.contains('Completed')) {
      sectionIcon = Icons.check_circle_rounded;
    } else {
      sectionIcon = Icons.grid_view_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accentVariant.withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(sectionIcon, color: AppColors.accent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.15), AppColors.accentVariant.withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (programs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.primaryGray.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Text('No programs yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 285,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: programs.length + 1, // +1 for "See All" card
                itemBuilder: (context, index) {
                  if (index < programs.length) {
                    return SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: _buildProgramCard(programs[index]));
                  } else {
                    return SizedBox(width: MediaQuery.of(context).size.width * 0.4, child: _buildSeeAllProgramsCard(programs, title));
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.programDetail, arguments: program),
      child: Container(
        height: 285,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    program['imageUrl'] ?? 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&h=300&fit=crop',
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [const Color(0xFF9333EA), const Color(0xFFFBBF24)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: const Center(child: Icon(Icons.fitness_center, size: 40, color: Colors.white)),
                    ),
                  ),
                ),
                // Certified badge
                if (program['certified'] ?? false)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: AppColors.completed, shape: BoxShape.circle),
                      child: const Icon(Icons.verified, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      program['title'],
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Instructor
                    Text(
                      program['trainer'] ?? 'Trainer',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Rating
                    Row(
                      children: [
                        Text(
                          (program['rating'] ?? 0.0).toStringAsFixed(1),
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(
                          5,
                          (index) => Icon(index < ((program['rating'] ?? 0.0) as double).floor() ? Icons.star : Icons.star_border, color: const Color(0xFFE59819), size: 14),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '(${_formatNumber(program['students'] ?? 0)})',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 12, color: AppColors.primaryGray),
                            const SizedBox(width: 4),
                            Text(program['duration'] ?? 'N/A', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, fontSize: 11)),
                          ],
                        ),
                        Text(
                          '\$${(program['price'] ?? 0.0).toStringAsFixed(2)}',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildPremiumBenefit(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        Icon(Icons.check_circle_rounded, color: AppColors.upcoming, size: 20),
      ],
    );
  }

  static void _showSubscriptionDialog(BuildContext context, Map<String, dynamic> trainer) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: Icon(Icons.workspace_premium_rounded, color: AppColors.upcoming, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Premium Subscription',
                      style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get direct access to ${trainer['name']}',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$',
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '9.99',
                          style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 48),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('/month', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Benefits list
                    _buildDialogBenefit('Direct phone number access'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Personal email address'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Training location details'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Priority booking'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Exclusive content access'),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primaryGray.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.titleSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showContactDetails(context, trainer);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'Subscribe Now',
                                style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDialogBenefit(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppColors.completed.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.check_circle_rounded, color: AppColors.completed, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
        ),
      ],
    );
  }

  static void _showContactDetails(BuildContext context, Map<String, dynamic> trainer) {
    Get.snackbar(
      'Subscription Activated! 🎉',
      'You now have access to ${trainer['name']}\'s contact details',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.completed,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );

    // Show contact details in a bottom sheet
    Future.delayed(const Duration(milliseconds: 500), () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 24),
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.contact_phone_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Details',
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                          ),
                          Text(trainer['name'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Contact info cards
                _buildContactCard(Icons.phone_rounded, 'Phone', '+1 (555) 123-4567', AppColors.accent),
                const SizedBox(height: 12),
                _buildContactCard(Icons.email_rounded, 'Email', '${trainer['name'].toString().toLowerCase().replaceAll(' ', '.')}@fitness.com', AppColors.accentVariant),
                const SizedBox(height: 12),
                _buildContactCard(Icons.location_on_rounded, 'Location', '123 Fitness Street, Gym City, GC 12345', AppColors.completed),
                const SizedBox(height: 24),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Close',
                      style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static Widget _buildContactCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, color: color),
            onPressed: () {
              Get.snackbar(
                'Copied!',
                '$label copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: color.withOpacity(0.1),
                colorText: color,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllProgramsCard(List<Map<String, dynamic>> programs, String sectionTitle) {
    return GestureDetector(
      onTap: () {
        // Convert to a format that GetX can handle properly
        final List<dynamic> programsList = programs
            .map(
              (p) => {
                'title': p['title'] ?? '',
                'description': p['description'] ?? '',
                'trainer': p['trainer'] ?? '',
                'price': p['price'] ?? 0.0,
                'duration': p['duration'] ?? '',
                'students': p['students'] ?? 0,
                'rating': p['rating'] ?? 0.0,
                'category': p['category'] ?? '',
                'certified': p['certified'] ?? false,
                'imageUrl': p['imageUrl'] ?? '',
                'status': p['status'] ?? '',
              },
            )
            .toList();

        Get.toNamed(AppRoutes.trainerAllPrograms, arguments: {'programs': programsList, 'section': sectionTitle});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: AppColors.primaryVariant, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.grid_view_rounded, size: 30, color: AppColors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              'See All',
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${programs.length}+ programs', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
          ],
        ),
      ),
    );
  }

  // Mock data
  static Map<String, dynamic> _getMockTrainerData() {
    return {
      'id': '1',
      'name': 'Sarah Johnson',
      'initials': 'SJ',
      'bio':
          'Certified personal trainer with over 8 years of experience helping clients achieve their fitness goals. Specializing in strength training, weight loss, and functional fitness. Passionate about creating sustainable lifestyle changes.',
      'specialties': ['Strength Training', 'Weight Loss', 'Functional Fitness', 'Nutrition Coaching'],
      'yearsOfExperience': 8,
      'certified': true,
      'certifications': ['NASM Certified Personal Trainer', 'Precision Nutrition Level 1', 'CrossFit Level 2 Trainer'],
      'hourlyRate': 75.0,
      'rating': 4.8,
      'totalReviews': 127,
      'students': 1250,
      'activePrograms': 5,
      'completedPrograms': 12,
      'totalPrograms': 17,
    };
  }

  static List<Map<String, dynamic>> _getMockReviews() {
    return [
      {
        'id': '1',
        'userName': 'John Doe',
        'userInitials': 'JD',
        'rating': 5.0,
        'comment': 'Amazing trainer! Sarah helped me lose 30 pounds and build incredible strength. Her programs are well-structured and she\'s always available for questions.',
        'date': '2 days ago',
        'programName': 'Complete Strength Program',
      },
      {
        'id': '2',
        'userName': 'Emily Davis',
        'userInitials': 'ED',
        'rating': 5.0,
        'comment': 'Best investment I\'ve made in my fitness journey. The program is challenging but achievable, and Sarah\'s support is outstanding.',
        'date': '1 week ago',
        'programName': 'Weight Loss Challenge',
      },
      {
        'id': '3',
        'userName': 'Mike Chen',
        'userInitials': 'MC',
        'rating': 4.0,
        'comment': 'Great program with excellent results. Would recommend to anyone serious about their fitness goals.',
        'date': '2 weeks ago',
        'programName': 'Functional Fitness',
      },
    ];
  }

  static List<Map<String, dynamic>> _getMockPrograms(String type) {
    final allPrograms = [
      {
        'title': 'Complete Strength Program',
        'description': 'Build muscle and strength with this comprehensive 12-week program',
        'trainer': 'Sarah Johnson',
        'price': 49.99,
        'duration': '12 weeks',
        'students': 1250,
        'rating': 4.8,
        'category': 'Strength',
        'certified': true,
        'imageUrl': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        'status': 'active',
      },
      {
        'title': 'Weight Loss Challenge',
        'description': 'Transform your body with this intensive 8-week weight loss program',
        'trainer': 'Sarah Johnson',
        'price': 39.99,
        'duration': '8 weeks',
        'students': 890,
        'rating': 4.9,
        'category': 'Weight Loss',
        'certified': true,
        'imageUrl': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop',
        'status': 'active',
      },
      {
        'title': 'Functional Fitness',
        'description': 'Improve everyday movement and build practical strength',
        'trainer': 'Sarah Johnson',
        'price': 44.99,
        'duration': '10 weeks',
        'students': 650,
        'rating': 4.7,
        'category': 'Functional',
        'certified': true,
        'imageUrl': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=400&h=300&fit=crop',
        'status': 'active',
      },
      {
        'title': 'Beginner Bootcamp',
        'description': 'Perfect introduction to fitness for newcomers',
        'trainer': 'Sarah Johnson',
        'price': 29.99,
        'duration': '6 weeks',
        'students': 1100,
        'rating': 4.6,
        'category': 'Beginner',
        'certified': true,
        'imageUrl': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=400&h=300&fit=crop',
        'status': 'completed',
      },
      {
        'title': 'Advanced Athletics',
        'description': 'Take your performance to the next level',
        'trainer': 'Sarah Johnson',
        'price': 59.99,
        'duration': '16 weeks',
        'students': 420,
        'rating': 4.9,
        'category': 'Advanced',
        'certified': true,
        'imageUrl': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400&h=300&fit=crop',
        'status': 'completed',
      },
    ];

    if (type == 'active') {
      return allPrograms.where((p) => p['status'] == 'active').toList();
    } else if (type == 'completed') {
      return allPrograms.where((p) => p['status'] == 'completed').toList();
    }
    return allPrograms;
  }
}
