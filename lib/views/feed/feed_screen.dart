import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Community Feed - Social Media Platform for fitness content
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _storageService = Get.find<StorageService>();

  // Mock feed data
  final List<Map<String, dynamic>> _feedPosts = [
    {
      'id': '1',
      'creator': 'Sarah Johnson',
      'creatorImage': 'SJ',
      'isTrainer': true,
      'isFollowing': true,
      'title': '5 Essential Squat Form Tips',
      'description': 'Master your squat technique with these crucial tips! 💪',
      'category': 'Workout',
      'tags': ['#squats', '#formcheck', '#legs'],
      'videoUrl': 'https://example.com/video1.mp4',
      'thumbnail': 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400',
      'likes': 2847,
      'comments': 156,
      'shares': 89,
      'saves': 421,
      'isLiked': false,
      'isSaved': false,
      'timestamp': '2 hours ago',
      'duration': '45s',
    },
    {
      'id': '2',
      'creator': 'Mike Chen',
      'creatorImage': 'MC',
      'isTrainer': true,
      'isFollowing': false,
      'title': 'Meal Prep Sunday: High Protein Bowls',
      'description': 'Easy meal prep for the week! 🍗🥗',
      'category': 'Nutrition',
      'tags': ['#mealprep', '#nutrition', '#healthyeating'],
      'videoUrl': 'https://example.com/video2.mp4',
      'thumbnail': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      'likes': 1923,
      'comments': 87,
      'shares': 145,
      'saves': 892,
      'isLiked': true,
      'isSaved': true,
      'timestamp': '4 hours ago',
      'duration': '1:15',
    },
    {
      'id': '3',
      'creator': 'Emma Davis',
      'creatorImage': 'ED',
      'isTrainer': false,
      'isFollowing': true,
      'title': 'Morning Run Motivation',
      'description': 'Nothing beats a sunrise run! 🌅🏃‍♀️',
      'category': 'Running',
      'tags': ['#running', '#motivation', '#morningrun'],
      'videoUrl': 'https://example.com/video3.mp4',
      'thumbnail': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=400',
      'likes': 3421,
      'comments': 234,
      'shares': 67,
      'saves': 156,
      'isLiked': false,
      'isSaved': false,
      'timestamp': '8 hours ago',
      'duration': '30s',
    },
    {
      'id': '4',
      'creator': 'Alex Rodriguez',
      'creatorImage': 'AR',
      'isTrainer': true,
      'isFollowing': true,
      'title': 'Basketball Dribbling Drills',
      'description': 'Level up your handles with these drills! 🏀',
      'category': 'Sports',
      'tags': ['#basketball', '#training', '#skills'],
      'videoUrl': 'https://example.com/video4.mp4',
      'thumbnail': 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'likes': 1567,
      'comments': 92,
      'shares': 78,
      'saves': 234,
      'isLiked': true,
      'isSaved': false,
      'timestamp': '1 day ago',
      'duration': '1:00',
    },
    {
      'id': '5',
      'creator': 'Lisa Thompson',
      'creatorImage': 'LT',
      'isTrainer': true,
      'isFollowing': false,
      'title': 'Full Body Mobility Routine',
      'description': 'Improve flexibility and reduce injury risk 🧘‍♀️',
      'category': 'Mobility',
      'tags': ['#mobility', '#flexibility', '#recovery'],
      'videoUrl': 'https://example.com/video5.mp4',
      'thumbnail': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      'likes': 2134,
      'comments': 143,
      'shares': 112,
      'saves': 567,
      'isLiked': false,
      'isSaved': true,
      'timestamp': '1 day ago',
      'duration': '1:20',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFD6D6D6), Color(0xFFE8E8E8), Color(0xFFC0C0C0)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          title: Text(
            'Community Feed',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.accent),
              onPressed: () {
                // TODO: Implement search
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.accent),
              onPressed: () {
                // TODO: Show notifications
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: const Color(0xFF404040),
            labelStyle: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyles.titleSmall,
            tabs: const [
              Tab(text: 'For You'),
              Tab(text: 'Following'),
              Tab(text: 'Explore'),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [_buildForYouFeed(), _buildFollowingFeed(), _buildExplorePage()]),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreatePostOptions,
          backgroundColor: AppColors.accent,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildForYouFeed() {
    return ListView.builder(
      itemCount: _feedPosts.length,
      itemBuilder: (context, index) {
        return _buildFeedPost(_feedPosts[index]);
      },
    );
  }

  Widget _buildFollowingFeed() {
    final followingPosts = _feedPosts.where((post) => post['isFollowing'] == true).toList();

    if (followingPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: AppColors.primaryGray.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No posts from followed creators', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _tabController.animateTo(2);
              },
              child: const Text('Discover Creators'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: followingPosts.length,
      itemBuilder: (context, index) {
        return _buildFeedPost(followingPosts[index]);
      },
    );
  }

  Widget _buildExplorePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildCategorySection('Workout Tips', Icons.fitness_center, AppColors.accent),
          _buildCategorySection('Nutrition', Icons.restaurant, AppColors.completed),
          _buildCategorySection('Running', Icons.directions_run, AppColors.upcoming),
          _buildCategorySection('Sports Training', Icons.sports_basketball, AppColors.error),
          _buildCategorySection('Mobility', Icons.self_improvement, AppColors.accent),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Show all in category
                  },
                  child: Text('See All', style: TextStyle(color: color)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildExploreCard(_feedPosts[index % _feedPosts.length]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () => _showPostDetail(post),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        post['thumbnail'],
                        width: 140,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 140,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF9333EA), const Color(0xFFFBBF24)]),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)]),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(child: Icon(Icons.play_circle_filled, color: Colors.white.withOpacity(0.9), size: 50)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                    child: Text(post['duration'], style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post['title'],
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedPost(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: GestureDetector(
              onTap: () => _navigateToCreatorProfile(post),
              child: CircleAvatar(
                backgroundColor: AppColors.accent.withOpacity(0.2),
                child: Text(post['creatorImage'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent)),
              ),
            ),
            title: InkWell(
              onTap: () => _navigateToCreatorProfile(post),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Text(
                    post['creator'],
                    style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                  ),
                  if (post['isTrainer'])
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.verified, color: AppColors.completed, size: 16),
                    ),
                ],
              ),
            ),
            subtitle: Text('${post['timestamp']} • ${post['category']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: AppColors.primaryGray),
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('Save Post'), value: 'save'),
                PopupMenuItem(child: Text('Share'), value: 'share'),
                if (!post['isFollowing']) PopupMenuItem(child: Text('Follow ${post['creator']}'), value: 'follow'),
                PopupMenuItem(child: Text('Report'), value: 'report'),
              ],
              onSelected: (value) {
                _handlePostAction(value.toString(), post);
              },
            ),
          ),

          GestureDetector(
            onTap: () => _showPostDetail(post),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Image.network(
                      post['thumbnail'],
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF9333EA), const Color(0xFFFBBF24)]),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.5)]),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(child: Icon(Icons.play_circle_filled, size: 80, color: Colors.white.withOpacity(0.9))),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'],
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post['description'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                    child: Text(post['duration'], style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildInteractionButton(
                        icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                        label: _formatCount(post['likes']),
                        color: post['isLiked'] ? AppColors.error : AppColors.primaryGray,
                        onTap: () {
                          setState(() {
                            post['isLiked'] = !post['isLiked'];
                            post['likes'] += post['isLiked'] ? 1 : -1;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildInteractionButton(icon: Icons.comment_outlined, label: _formatCount(post['comments']), color: AppColors.primaryGray, onTap: () => _showComments(post)),
                      const SizedBox(width: 16),
                      _buildInteractionButton(
                        icon: post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                        label: _formatCount(post['saves']),
                        color: post['isSaved'] ? AppColors.accent : AppColors.primaryGray,
                        onTap: () async {
                          final isSaved = post['isSaved'] ?? false;
                          setState(() {
                            post['isSaved'] = !isSaved;
                            post['saves'] += !isSaved ? 1 : -1;
                          });
                          if (!isSaved) {
                            await _storageService.addSavedPost(post);
                          } else {
                            await _storageService.removeSavedPost(post['id']);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildInteractionButton(icon: Icons.share_outlined, label: _formatCount(post['shares']), color: AppColors.primaryGray, onTap: () => _showShareOptions(post)),
                    ],
                  ),
                ),
                if (post['isTrainer']) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to trainer profile with hire option
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      textStyle: AppTextStyles.labelSmall.copyWith(fontSize: 12),
                    ),
                    child: const Text('Hire Me'),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: (post['tags'] as List<String>).map((tag) {
                return Text(
                  tag,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _navigateToCreatorProfile(Map<String, dynamic> post) {
    final String creatorName = (post['creator'] ?? 'Creator').toString();
    final String initials = (post['creatorImage'] ?? 'UT').toString();
    final bool isTrainer = post['isTrainer'] == true;
    final String category = (post['category'] ?? 'Fitness').toString();

    final trainerData = <String, dynamic>{
      'id': creatorName.toLowerCase().replaceAll(' ', '_'),
      'name': creatorName,
      'initials': initials,
      'bio': isTrainer
          ? 'Certified trainer sharing ${category.toLowerCase()} tips and routines to help you reach your goals.'
          : 'Fitness enthusiast sharing ${category.toLowerCase()} content with the community.',
      'specialties': <String>[category, 'Training', if (isTrainer) 'Coaching'],
      'yearsOfExperience': isTrainer ? 6 : 2,
      'certified': isTrainer,
      'certifications': isTrainer ? ['Certified Personal Trainer'] : null,
      'hourlyRate': 75.0,
      'rating': 4.8,
      'totalReviews': 127,
      'students': 1250,
      'activePrograms': 5,
      'completedPrograms': 12,
      'totalPrograms': 17,
    };

    Get.toNamed(AppRoutes.trainerProfile, arguments: trainerData);
  }

  Widget _buildInteractionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
        ],
      ),
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

  void _showCreatePostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create Post', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 24),
            _buildCreateOption(Icons.videocam, 'Record Video', 'Capture a new video', () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.createPost, arguments: {'type': 'record'});
            }),
            _buildCreateOption(Icons.video_library, 'Upload Video', 'Choose from gallery', () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.createPost, arguments: {'type': 'video'});
            }),
            _buildCreateOption(Icons.image, 'Upload Photo', 'Share a static image', () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.createPost, arguments: {'type': 'image'});
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.accent),
      ),
      title: Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
      subtitle: Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
      onTap: onTap,
    );
  }

  void _showPostDetail(Map<String, dynamic> post) {
    Get.snackbar('Post Detail', 'Opening ${post['title']}', backgroundColor: AppColors.accent, colorText: AppColors.onAccent, snackPosition: SnackPosition.BOTTOM);
  }

  void _showComments(Map<String, dynamic> post) {
    Get.snackbar('Comments', '${post['comments']} comments', backgroundColor: AppColors.accent, colorText: AppColors.onAccent, snackPosition: SnackPosition.BOTTOM);
  }

  void _showShareOptions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share Post', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildShareIcon(Icons.message, 'Message', () {}), _buildShareIcon(Icons.link, 'Copy Link', () {}), _buildShareIcon(Icons.share, 'More', () {})],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShareIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface)),
        ],
      ),
    );
  }

  void _handlePostAction(String action, Map<String, dynamic> post) async {
    switch (action) {
      case 'save':
        final isSaved = post['isSaved'] ?? false;
        setState(() {
          post['isSaved'] = !isSaved;
        });
        if (!isSaved) {
          await _storageService.addSavedPost(post);
        } else {
          await _storageService.removeSavedPost(post['id']);
        }
        Get.snackbar(
          !isSaved ? 'Saved' : 'Unsaved',
          !isSaved ? 'Post saved to your collection' : 'Post removed from collection',
          backgroundColor: AppColors.accent,
          colorText: AppColors.onAccent,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'follow':
        setState(() {
          post['isFollowing'] = true;
        });
        Get.snackbar(
          'Following',
          'You are now following ${post['creator']}',
          backgroundColor: AppColors.completed,
          colorText: AppColors.onError,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'report':
        _showReportDialog(post);
        break;
      case 'share':
        _showShareOptions(post);
        break;
    }
  }

  void _showReportDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Report Post', style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildReportOption('Inappropriate content'), _buildReportOption('Misleading advice'), _buildReportOption('Spam'), _buildReportOption('Harassment')],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.primaryGray)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String reason) {
    return ListTile(
      title: Text(reason, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
      onTap: () {
        Navigator.pop(context);
        Get.snackbar(
          'Report Submitted',
          'Thank you for keeping our community safe',
          backgroundColor: AppColors.completed,
          colorText: AppColors.onError,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
