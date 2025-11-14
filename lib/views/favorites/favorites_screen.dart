import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/favorites_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Favorites Screen - Shows all favorite programs and workouts
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesController _favoritesController = Get.put(FavoritesController());

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

  void _navigateToDetails(Map<String, dynamic> item) {
    final type = item['type'] ?? 'program';
    if (type == 'program') {
      Get.toNamed(AppRoutes.programDetail, arguments: item);
    } else if (type == 'workout') {
      Get.toNamed(AppRoutes.workoutDetail, arguments: item);
    }
  }

  void _removeFavorite(String id) {
    _favoritesController.removeFavorite(id);
    Get.snackbar(
      'Removed',
      'Removed from favorites',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryGray,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withOpacity(0.6),
          labelStyle: AppTextStyles.titleSmall,
          tabs: const [
            Tab(text: 'Programs'),
            Tab(text: 'Workouts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Programs Tab
          Obx(() => _buildFavoritesList(_favoritesController.getFavoritesByType('program'), 'program')),

          // Workouts Tab
          Obx(() => _buildFavoritesList(_favoritesController.getFavoritesByType('workout'), 'workout')),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Map<String, dynamic>> items, String type) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: AppColors.primaryGray.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No Favorites Yet', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGray)),
            const SizedBox(height: 8),
            Text(
              type == 'program' ? 'Mark programs as favorites to see them here' : 'Mark workouts as favorites to see them here',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (type == 'program') {
                  Get.toNamed(AppRoutes.marketplace);
                } else {
                  Get.toNamed(AppRoutes.journal);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              icon: Icon(type == 'program' ? Icons.explore : Icons.fitness_center),
              label: Text(type == 'program' ? 'Browse Programs' : 'View Workouts'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildFavoriteCard(item);
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    final type = item['type'] ?? 'program';
    final id = item['id']?.toString() ?? item['title']?.toString() ?? '';

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      onDismissed: (_) => _removeFavorite(id),
      child: GestureDetector(
        onTap: () => _navigateToDetails(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.8), AppColors.accentVariant]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(type == 'program' ? Icons.school : Icons.fitness_center, color: AppColors.onAccent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                        ),
                        if (item['trainer'] != null) Text('by ${item['trainer']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeFavorite(id),
                    icon: Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
              ),
              if (item['description'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  item['description'],
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (item['category'] != null)
                    Chip(label: Text(item['category']), padding: const EdgeInsets.symmetric(horizontal: 8), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  const SizedBox(width: 8),
                  if (item['duration'] != null) ...[
                    Icon(Icons.schedule, size: 14, color: AppColors.primaryGray),
                    const SizedBox(width: 4),
                    Text(item['duration'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                  ],
                  const Spacer(),
                  if (item['price'] != null)
                    Text(
                      '\$${item['price']}',
                      style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
