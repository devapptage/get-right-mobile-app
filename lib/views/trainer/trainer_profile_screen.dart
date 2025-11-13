import 'package:flutter/material.dart';
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
                              Get.snackbar(
                                'Chat',
                                'Opening chat with ${trainer['name']}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.accent,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
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
                      ..._getMockReviews().take(3).map((review) => _buildReviewCard(review)),
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

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 1,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppColors.primaryGray.withOpacity(0.2), Colors.transparent])),
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
      margin: const EdgeInsets.only(bottom: 16),
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
            ...programs.map((program) => _buildProgramCard(program)),
        ],
      ),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.programDetail, arguments: program),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: AppColors.primaryGray.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent.withOpacity(0.1), AppColors.accentVariant.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program['title'],
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          program['description'],
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, height: 1.5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Text(
                      '\$${program['price']}',
                      style: AppTextStyles.titleSmall.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Stats section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildProgramStat(Icons.schedule_rounded, program['duration']),
                  const SizedBox(width: 16),
                  _buildProgramStat(Icons.people_rounded, '${program['students']}'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.upcoming.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: AppColors.upcoming),
                        const SizedBox(width: 4),
                        Text(
                          '${program['rating']}',
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 14, color: AppColors.accent),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600),
        ),
      ],
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
        'price': 49.99,
        'duration': '12 weeks',
        'students': 1250,
        'rating': 4.8,
        'category': 'Strength',
        'status': 'active',
      },
      {
        'title': 'Weight Loss Challenge',
        'description': 'Transform your body with this intensive 8-week weight loss program',
        'price': 39.99,
        'duration': '8 weeks',
        'students': 890,
        'rating': 4.9,
        'category': 'Weight Loss',
        'status': 'active',
      },
      {
        'title': 'Functional Fitness',
        'description': 'Improve everyday movement and build practical strength',
        'price': 44.99,
        'duration': '10 weeks',
        'students': 650,
        'rating': 4.7,
        'category': 'Functional',
        'status': 'active',
      },
      {
        'title': 'Beginner Bootcamp',
        'description': 'Perfect introduction to fitness for newcomers',
        'price': 29.99,
        'duration': '6 weeks',
        'students': 1100,
        'rating': 4.6,
        'category': 'Beginner',
        'status': 'completed',
      },
      {
        'title': 'Advanced Athletics',
        'description': 'Take your performance to the next level',
        'price': 59.99,
        'duration': '16 weeks',
        'students': 420,
        'rating': 4.9,
        'category': 'Advanced',
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
