import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Trainer Profile Screen - Profile, Programs, and Training sections
class TrainerProfileScreen extends StatefulWidget {
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final Map<String, dynamic> trainer = Get.arguments ?? _getMockTrainerData();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withOpacity(0.25)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.accent, size: 18),
          ),
        ),
        title: Text(trainer['name'], style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.primaryGrayDark,
          labelStyle: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: AppTextStyles.titleSmall,
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Programs'),
            Tab(text: 'Training'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(trainer),
          _buildProgramsTab(trainer),
          _buildTrainingTab(trainer),
        ],
      ),
    );
  }

  Widget _buildProfileTab(Map<String, dynamic> trainer) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accent, width: 3)),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.surface,
                    child: Text(trainer['initials'], style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('${trainer['totalPrograms'] ?? 0}', 'Posts'),
                        _buildStatColumn('${trainer['students'] ?? 0}', 'Followers', onTap: () => Get.toNamed(AppRoutes.followers)),
                        _buildStatColumn('342', 'Following', onTap: () => Get.toNamed(AppRoutes.following)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trainer['name'], style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(trainer['bio'] ?? '', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground), maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Posts', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildTrainerPostsGrid(trainer),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label, {VoidCallback? onTap}) {
    final w = Column(
      children: [
        Text(count, style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
      ],
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: w) : w;
  }

  Widget _buildTrainerPostsGrid(Map<String, dynamic> trainer) {
    final posts = _getMockTrainerPosts();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 1),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final p = posts[i];
        return GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.postDetail, arguments: p),
          child: Image.network(
            p['thumbnail'] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.primaryGrayLight, child: const Icon(Icons.image)),
          ),
        );
      },
    );
  }

  static List<Map<String, dynamic>> _getMockTrainerPosts() {
    return [
      {'thumbnail': 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400'},
      {'thumbnail': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400'},
      {'thumbnail': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400'},
      {'thumbnail': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=400'},
      {'thumbnail': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400'},
      {'thumbnail': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400'},
    ];
  }

  Widget _buildProgramsTab(Map<String, dynamic> trainer) {
    final programs = _getMockPrograms('all');
    final bundles = _getMockTrainerBundles(trainer);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (bundles.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Bundles', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bundles.length,
                itemBuilder: (context, i) => _buildBundleCard(bundles[i]),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Programs', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: programs.isEmpty
                ? Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('No programs yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray))))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: programs.length,
                    itemBuilder: (context, i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildProgramListCard(programs[i])),
                  ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static List<Map<String, dynamic>> _getMockTrainerBundles(Map<String, dynamic> trainer) {
    return [
      {'id': 'b1', 'title': 'Strength & Conditioning Bundle', 'bundlePrice': 49.99, 'totalValue': 89.99, 'discount': 25, 'imageUrl': 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=400&h=300&fit=crop'},
      {'id': 'b2', 'title': 'Complete Fitness Package', 'bundlePrice': 79.99, 'totalValue': 129.99, 'discount': 38, 'imageUrl': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=300&fit=crop'},
    ];
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.bundleDetail, arguments: bundle),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                bundle['imageUrl'] ?? '',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 100, color: AppColors.primaryGrayLight, child: const Icon(Icons.image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bundle['title'] ?? '', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('\$${bundle['bundlePrice']}', style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramListCard(Map<String, dynamic> program) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.programDetail, arguments: program),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                program['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.primaryGrayLight, child: const Icon(Icons.fitness_center)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(program['title'] ?? '', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('\$${program['price']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTab(Map<String, dynamic> trainer) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.chatRoom, arguments: {'trainerId': trainer['id'], 'trainerName': trainer['name']}),
                    icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.snackbar('Book Session', 'Hourly Rate: \$${trainer['hourlyRate']}', snackPosition: SnackPosition.BOTTOM),
                    icon: Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.accent),
                    label: Text('\$${trainer['hourlyRate']}/hr', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.accent)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTrainingStatChip(Icons.star_rounded, '${trainer['rating']}', '${trainer['totalReviews']} reviews'),
                const SizedBox(width: 12),
                _buildTrainingStatChip(Icons.people_rounded, '${trainer['students']}', 'Students'),
                const SizedBox(width: 12),
                _buildTrainingStatChip(Icons.fitness_center_rounded, '${trainer['yearsOfExperience']}', 'Years'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPremiumAccessCard(trainer),
          const SizedBox(height: 24),
          _buildAboutSection(trainer),
          const SizedBox(height: 24),
          _buildSpecialtiesSection(trainer),
          if (trainer['certified'] == true && trainer['certifications'] != null) ...[const SizedBox(height: 24), _buildCertificationsSection(trainer)],
          const SizedBox(height: 24),
          _buildReviewsSection(trainer),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTrainingStatChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumAccessCard(Map<String, dynamic> trainer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: AppColors.upcoming, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium Access', style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('Get direct contact details', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPremiumBenefit(Icons.phone_rounded, 'Direct phone number'),
            const SizedBox(height: 8),
            _buildPremiumBenefit(Icons.email_rounded, 'Personal email address'),
            const SizedBox(height: 8),
            _buildPremiumBenefit(Icons.location_on_rounded, 'Training location details'),
            const SizedBox(height: 8),
            _buildPremiumBenefit(Icons.schedule_rounded, 'Priority booking access'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSubscriptionDialog(context, trainer),
                icon: const Icon(Icons.diamond_rounded),
                label: const Text('Subscribe for \$9.99/month'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBenefit(IconData icon, String text) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: Colors.white, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500))),
        Icon(Icons.check_circle_rounded, color: AppColors.upcoming, size: 20),
      ],
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> trainer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGray.withOpacity(0.2))),
            child: Text(trainer['bio'] ?? '', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, height: 1.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection(Map<String, dynamic> trainer) {
    final specialties = trainer['specialties'] as List? ?? [];
    if (specialties.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Specialties', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specialties.map<Widget>((s) => Chip(label: Text(s.toString()), backgroundColor: AppColors.accent.withOpacity(0.1))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection(Map<String, dynamic> trainer) {
    final certs = trainer['certifications'] as List? ?? [];
    if (certs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Certifications', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...certs.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.completed.withOpacity(0.3))),
                  child: Row(
                    children: [
                      Icon(Icons.verified_rounded, color: AppColors.completed, size: 24),
                      const SizedBox(width: 12),
                      Expanded(child: Text(c.toString(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface))),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(Map<String, dynamic> trainer) {
    final reviews = _getMockReviews();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews & Testimonials', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.trainerReviews, arguments: trainer),
                child: Text('View All (${trainer['totalReviews']})', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...reviews.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildReviewCard(r))),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context, Map<String, dynamic> trainer) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
                child: Column(
                  children: [
                    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(Icons.workspace_premium_rounded, color: AppColors.upcoming, size: 48)),
                    const SizedBox(height: 16),
                    Text('Premium Subscription', style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Get direct access to ${trainer['name']}', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9)), textAlign: TextAlign.center),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('\$', style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      Text('9.99', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 48)),
                      Padding(padding: const EdgeInsets.only(top: 8), child: Text('/month', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray))),
                    ]),
                    const SizedBox(height: 24),
                    _buildDialogBenefit('Direct phone number access'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Personal email address'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Training location details'),
                    const SizedBox(height: 12),
                    _buildDialogBenefit('Priority booking'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primaryGray.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Cancel', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showContactDetails(context, trainer);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: Text('Subscribe Now', style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildDialogBenefit(String text) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.completed.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.check_circle_rounded, color: AppColors.completed, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground))),
      ],
    );
  }

  void _showContactDetails(BuildContext context, Map<String, dynamic> trainer) {
    Get.snackbar('Subscription Activated! 🎉', 'You now have access to ${trainer['name']}\'s contact details', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.completed, colorText: Colors.white, duration: const Duration(seconds: 3), margin: const EdgeInsets.all(16), borderRadius: 12, icon: const Icon(Icons.check_circle_rounded, color: Colors.white));
    Future.delayed(const Duration(milliseconds: 500), () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => Container(
          decoration: BoxDecoration(color: AppColors.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]), shape: BoxShape.circle), child: const Icon(Icons.contact_phone_rounded, color: Colors.white, size: 24)),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Contact Details', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold)), Text(trainer['name'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray))])),
                  ],
                ),
                const SizedBox(height: 24),
                _buildContactCard(Icons.phone_rounded, 'Phone', '+1 (555) 123-4567', AppColors.accent),
                const SizedBox(height: 12),
                _buildContactCard(Icons.email_rounded, 'Email', '${trainer['name'].toString().toLowerCase().replaceAll(' ', '.')}@fitness.com', AppColors.accentVariant),
                const SizedBox(height: 12),
                _buildContactCard(Icons.location_on_rounded, 'Location', '123 Fitness Street, Gym City, GC 12345', AppColors.completed),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.surface, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Close', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)))),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContactCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w500)), const SizedBox(height: 4), Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600))])),
          IconButton(icon: Icon(Icons.copy_rounded, color: color), onPressed: () => Get.snackbar('Copied!', '$label copied to clipboard', snackPosition: SnackPosition.BOTTOM, backgroundColor: color.withOpacity(0.1), colorText: color)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGray.withOpacity(0.2)), boxShadow: [BoxShadow(color: AppColors.primaryGray.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundColor: AppColors.accent.withOpacity(0.2), child: Text(review['userInitials'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['userName'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(i < (review['rating'] as num).toInt() ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: i < (review['rating'] as num).toInt() ? AppColors.upcoming : AppColors.primaryGray.withOpacity(0.4))),
                        const SizedBox(width: 8),
                        Text(review['date'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(review['comment'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.8), height: 1.6), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(children: [Icon(Icons.fitness_center, size: 14, color: AppColors.accent.withOpacity(0.7)), const SizedBox(width: 6), Expanded(child: Text(review['programName'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))]),
        ],
      ),
    );
  }

  static Map<String, dynamic> _getMockTrainerData() {
    return {
      'id': '1',
      'name': 'Sarah Johnson',
      'initials': 'SJ',
      'bio': 'Certified personal trainer with over 8 years of experience helping clients achieve their fitness goals. Specializing in strength training, weight loss, and functional fitness. Passionate about creating sustainable lifestyle changes.',
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
      {'id': '1', 'userName': 'John Doe', 'userInitials': 'JD', 'rating': 5.0, 'comment': 'Amazing trainer! Sarah helped me lose 30 pounds and build incredible strength.', 'date': '2 days ago', 'programName': 'Complete Strength Program'},
      {'id': '2', 'userName': 'Emily Davis', 'userInitials': 'ED', 'rating': 5.0, 'comment': 'Best investment I\'ve made in my fitness journey. The program is challenging but achievable.', 'date': '1 week ago', 'programName': 'Weight Loss Challenge'},
      {'id': '3', 'userName': 'Mike Chen', 'userInitials': 'MC', 'rating': 4.0, 'comment': 'Great program with excellent results. Would recommend to anyone serious about their fitness goals.', 'date': '2 weeks ago', 'programName': 'Functional Fitness'},
    ];
  }

  static List<Map<String, dynamic>> _getMockPrograms(String type) {
    final allPrograms = [
      {'title': 'Complete Strength Program', 'description': 'Build muscle and strength', 'trainer': 'Sarah Johnson', 'price': 49.99, 'duration': '12 weeks', 'students': 1250, 'rating': 4.8, 'category': 'Strength', 'certified': true, 'imageUrl': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', 'status': 'active'},
      {'title': 'Weight Loss Challenge', 'description': 'Transform your body', 'trainer': 'Sarah Johnson', 'price': 39.99, 'duration': '8 weeks', 'students': 890, 'rating': 4.9, 'category': 'Weight Loss', 'certified': true, 'imageUrl': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop', 'status': 'active'},
      {'title': 'Functional Fitness', 'description': 'Improve everyday movement', 'trainer': 'Sarah Johnson', 'price': 44.99, 'duration': '10 weeks', 'students': 650, 'rating': 4.7, 'category': 'Functional', 'certified': true, 'imageUrl': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=400&h=300&fit=crop', 'status': 'active'},
      {'title': 'Beginner Bootcamp', 'description': 'Perfect introduction', 'trainer': 'Sarah Johnson', 'price': 29.99, 'duration': '6 weeks', 'students': 1100, 'rating': 4.6, 'category': 'Beginner', 'certified': true, 'imageUrl': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=400&h=300&fit=crop', 'status': 'completed'},
      {'title': 'Advanced Athletics', 'description': 'Take performance to next level', 'trainer': 'Sarah Johnson', 'price': 59.99, 'duration': '16 weeks', 'students': 420, 'rating': 4.9, 'category': 'Advanced', 'certified': true, 'imageUrl': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400&h=300&fit=crop', 'status': 'completed'},
    ];
    if (type == 'active') return allPrograms.where((p) => p['status'] == 'active').toList();
    if (type == 'completed') return allPrograms.where((p) => p['status'] == 'completed').toList();
    return allPrograms;
  }
}
