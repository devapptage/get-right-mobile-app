import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/favorites_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Program Detail Screen
class ProgramDetailScreen extends StatefulWidget {
  const ProgramDetailScreen({super.key});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  final FavoritesController _favoritesController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> program = Get.arguments ?? _getMockProgramData();
    final programId = (program['id']?.toString() ?? program['title']?.toString() ?? 'unknown_program').replaceAll(' ', '_');

    // Ensure required fields have defaults
    final safeProgram = {
      'id': programId,
      'title': program['title'] ?? 'Program',
      'trainer': program['trainer'] ?? 'Unknown Trainer',
      'trainerImage': program['trainerImage'] ?? 'UT',
      'price': program['price'] ?? 0.0,
      'duration': program['duration'] ?? '12 weeks',
      'category': program['category'] ?? 'General',
      'goal': program['goal'] ?? 'Fitness',
      'certified': program['certified'] ?? false,
      'rating': program['rating'] ?? 0.0,
      'students': program['students'] ?? 0,
      'reviews': program['reviews'] ?? 0,
      'description': program['description'] ?? 'No description available',
      ...program, // Keep any additional fields
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Program Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            actions: [
              // Favorite Icon
              Obx(() {
                final isFavorite = _favoritesController.isFavorite(programId);
                return IconButton(
                  onPressed: () {
                    _favoritesController.toggleFavorite(programId, {...safeProgram, 'type': 'program'});
                    Get.snackbar(
                      isFavorite ? 'Removed' : 'Added',
                      isFavorite ? 'Removed from favorites' : 'Added to favorites',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: isFavorite ? AppColors.primaryGray : AppColors.completed,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : AppColors.onPrimary),
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.8), AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Center(child: Icon(Icons.fitness_center, size: 80, color: AppColors.onAccent.withOpacity(0.3))),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.background]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Program Title
                  Text(
                    safeProgram['title'] ?? 'Program',
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Trainer Section (Tappable)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.trainerProfile, arguments: _getMockTrainerData());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.accent,
                            child: Text(safeProgram['trainerImage'] ?? 'UT', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onAccent)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(safeProgram['trainer'] ?? 'Trainer', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
                                    if (safeProgram['certified'] == true)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Icon(Icons.verified, color: AppColors.completed, size: 18),
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: AppColors.upcoming, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${safeProgram['rating']}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface)),
                                    const SizedBox(width: 8),
                                    Text('${safeProgram['students']} students', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Info Cards
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard(Icons.schedule, 'Duration', safeProgram['duration'] ?? '12 weeks')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(Icons.category, 'Category', safeProgram['category'] ?? 'General')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(Icons.flag, 'Goal', safeProgram['goal'] ?? 'Fitness')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About This Program',
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(safeProgram['description'] ?? 'No description available', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, height: 1.6)),
                  const SizedBox(height: 24),

                  // What's Included
                  Text(
                    'What\'s Included',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(Icons.fitness_center, 'Full workout plans and schedules'),
                  _buildFeatureItem(Icons.video_library, 'Video demonstrations for all exercises'),
                  _buildFeatureItem(Icons.track_changes, 'Progress tracking and analytics'),
                  _buildFeatureItem(Icons.chat, 'Direct messaging with trainer'),
                  _buildFeatureItem(Icons.library_books, 'Nutrition guide included'),
                  _buildFeatureItem(Icons.calendar_today, 'Lifetime access to program'),
                  const SizedBox(height: 24),

                  // Program Structure

                  // Student Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Reviews',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.upcoming, size: 20),
                          const SizedBox(width: 4),
                          Text('${safeProgram['rating']} (${safeProgram['reviews']} reviews)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._getMockReviews().take(2).map((review) => _buildReviewCard(review)),
                  const SizedBox(height: 20), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Purchase Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray)),
                  Text(
                    '\$${safeProgram['price']}',
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.purchaseDetails);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.school, size: 20),
                  label: Text('Enroll Now', style: AppTextStyles.labelLarge.copyWith(color: AppColors.onAccent)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accent,
                child: Text(review['userInitials'], style: AppTextStyles.labelMedium.copyWith(color: AppColors.onAccent)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['userName'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                    Row(children: List.generate(5, (index) => Icon(index < review['rating'] ? Icons.star : Icons.star_border, size: 14, color: AppColors.upcoming))),
                  ],
                ),
              ),
              Text(review['date'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMockProgramData() {
    return {
      'id': 'mock_program_1',
      'title': 'Complete Strength Program',
      'trainer': 'Sarah Johnson',
      'trainerImage': 'SJ',
      'price': 49.99,
      'duration': '12 weeks',
      'category': 'Strength',
      'goal': 'Muscle Building',
      'certified': true,
      'rating': 4.8,
      'students': 1250,
      'reviews': 247,
      'description':
          'Transform your body with this comprehensive 12-week strength training program. Designed for intermediate to advanced lifters, this program combines proven powerlifting techniques with hypertrophy-focused training to help you build serious muscle and strength.\n\nYou\'ll follow a structured progressive overload protocol, ensuring continuous gains throughout the program. Each workout is meticulously planned with exercise selection, sets, reps, and rest periods optimized for maximum results.',
    };
  }

  Map<String, dynamic> _getMockTrainerData() {
    return {
      'id': '1',
      'name': 'Sarah Johnson',
      'initials': 'SJ',
      'bio': 'Certified personal trainer with over 8 years of experience',
      'specialties': ['Strength Training', 'Weight Loss'],
      'yearsOfExperience': 8,
      'certified': true,
      'certifications': ['NASM Certified Personal Trainer'],
      'hourlyRate': 75.0,
      'rating': 4.8,
      'totalReviews': 127,
      'students': 1250,
      'activePrograms': 5,
      'completedPrograms': 12,
      'totalPrograms': 17,
    };
  }

  List<Map<String, dynamic>> _getMockReviews() {
    return [
      {
        'userName': 'John Doe',
        'userInitials': 'JD',
        'rating': 5.0,
        'comment': 'Amazing program! I gained 15 pounds of muscle and my strength skyrocketed. Best investment I\'ve made.',
        'date': '1 week ago',
      },
      {
        'userName': 'Emily Davis',
        'userInitials': 'ED',
        'rating': 5.0,
        'comment': 'The program is challenging but the results speak for themselves. Sarah is always available for questions.',
        'date': '2 weeks ago',
      },
    ];
  }
}
