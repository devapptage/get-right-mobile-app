import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Profile screen - Social media style profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Obx(() {
          final notificationController = Get.find<NotificationController>();
          final unreadCount = notificationController.unreadCount;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                    ),
                    Container(
                      width: 25,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                    ),
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(color: Color(0xFF29603C), borderRadius: BorderRadius.circular(2)),
                    ),
                  ],
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ).paddingOnly(left: 10),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        }),
        title: Text('Profile', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.onPrimary),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppColors.primaryGrayLight.withOpacity(0.3), borderRadius: BorderRadius.circular(14)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.85)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.onAccent,
                unselectedLabelColor: AppColors.onSurface.withOpacity(0.6),
                labelStyle: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
                unselectedLabelStyle: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'Public'),
                  Tab(text: 'Personal'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_buildPublicProfile(), _buildPersonalProfile()]),
    );
  }

  Widget _buildPublicProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Profile Picture
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person, size: 50, color: AppColors.accent),
                  ),
                ),
                const SizedBox(width: 30),
                // Stats
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_buildStatColumn('6', 'Posts'), _buildStatColumn('1247', 'Followers'), _buildStatColumn('342', 'Following')],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Username and Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'brogan seier',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Fitness enthusiast | Powerlifter | Always pushing limits', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
                const SizedBox(height: 4),
                Text('Training for strength and building a better version of myself every day.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
                const SizedBox(height: 4),
                Text(
                  'getright.com/brogan',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Personal Records Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Records',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildPersonalRecordCard('Bench Press', '315 lbs', 'Dec 12, 2024')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPersonalRecordCard('Squat', '405 lbs', 'Dec 10, 2024')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Posts Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posts',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        onPressed: _showCreatePostOptions,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPostsGrid(),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPersonalProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        child: Icon(Icons.person, size: 50, color: AppColors.accent),
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
          const SizedBox(height: 24),

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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 16), _buildLogoutCard(), const SizedBox(height: 24)]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
      ],
    );
  }

  Widget _buildPersonalRecordCard(String title, String value, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(date, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
        ],
      ),
    );
  }

  Widget _buildPostsGrid() {
    // Mock posts data with more realistic content
    final posts = [
      {
        'id': '1',
        'isVideo': true,
        'thumbnail': 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400',
        'title': 'Perfect Squat Form',
        'description': 'Master your squat technique with these tips!',
        'likes': 315,
        'comments': 42,
        'saves': 89,
        'shares': 23,
        'duration': '1:24',
        'timestamp': '2 days ago',
        'tags': ['#fitness', '#squat', '#formcheck'],
      },
      {
        'id': '2',
        'isVideo': false,
        'thumbnail': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
        'title': 'Gym Progress',
        'description': '6 months of consistent training!',
        'likes': 428,
        'comments': 67,
        'saves': 124,
        'shares': 31,
        'timestamp': '5 days ago',
        'tags': ['#progress', '#transformation', '#dedication'],
      },
      {
        'id': '3',
        'isVideo': true,
        'thumbnail': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400',
        'title': 'Deadlift PR',
        'description': 'New personal record: 405 lbs!',
        'likes': 892,
        'comments': 134,
        'saves': 267,
        'shares': 89,
        'duration': '0:45',
        'timestamp': '1 week ago',
        'tags': ['#deadlift', '#pr', '#powerlifting'],
      },
      {
        'id': '4',
        'isVideo': false,
        'thumbnail': 'https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400',
        'title': 'Meal Prep Sunday',
        'description': 'High protein meals for the week',
        'likes': 234,
        'comments': 28,
        'saves': 156,
        'shares': 45,
        'timestamp': '1 week ago',
        'tags': ['#mealprep', '#nutrition', '#healthy'],
      },
      {
        'id': '5',
        'isVideo': true,
        'thumbnail': 'https://images.unsplash.com/photo-1549576490-b0b4831ef60a?w=400',
        'title': 'Morning Cardio',
        'description': 'Starting the day right!',
        'likes': 167,
        'comments': 19,
        'saves': 43,
        'shares': 12,
        'duration': '2:15',
        'timestamp': '2 weeks ago',
        'tags': ['#cardio', '#morning', '#running'],
      },
      {
        'id': '6',
        'isVideo': false,
        'thumbnail': 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400',
        'title': 'Gym Selfie',
        'description': 'Post-workout pump!',
        'likes': 521,
        'comments': 89,
        'saves': 78,
        'shares': 23,
        'timestamp': '2 weeks ago',
        'tags': ['#fitness', '#gym', '#motivation'],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 1),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () => _navigateToPostDetail(post),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Post Image/Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post['thumbnail'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.accent, AppColors.accent.withOpacity(0.6)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Gradient overlay for better icon visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)]),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Video play icon
              if (post['isVideo'] as bool)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                    child: Icon(Icons.play_arrow, color: Colors.white.withOpacity(0.9), size: 28),
                  ),
                ),
              // Engagement stats overlay
              Positioned(
                bottom: 4,
                left: 4,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 14,
                      shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _formatCount(post['likes'] as int),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _navigateToPostDetail(Map<String, dynamic> post) {
    // Add creator info to post data
    final postWithCreator = {...post, 'creator': 'brogan seier', 'creatorInitials': 'BS', 'isLiked': false, 'isSaved': false};
    Get.toNamed(AppRoutes.postDetail, arguments: postWithCreator);
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

  void _showCreatePostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Create Post',
                      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Options
              _buildCreatePostOption(
                icon: Icons.videocam,
                title: 'Record Video',
                subtitle: 'Capture a new video with your camera',
                gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.createPost, arguments: {'type': 'record'});
                },
              ),
              _buildCreatePostOption(
                icon: Icons.video_library,
                title: 'Upload Video',
                subtitle: 'Choose a video from your gallery',
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.createPost, arguments: {'type': 'video'});
                },
              ),
              _buildCreatePostOption(
                icon: Icons.image,
                title: 'Upload Photo',
                subtitle: 'Share a photo from your gallery',
                gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.createPost, arguments: {'type': 'image'});
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatePostOption({required IconData icon, required String title, required String subtitle, required Gradient gradient, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: gradient.colors.first.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.primaryGray, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
