import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/controllers/nutrition_controller.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/views/nutrition/nutrition_tracker_tab.dart';
import 'package:get_right/views/nutrition/recipes_tab.dart';

/// Main Nutrition Screen with Tracker and Recipes tabs
class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final nutritionController = Get.put(NutritionController());

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
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
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
          'Nutrition',
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 0,
              indicator: const BoxDecoration(),
              labelPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              tabs: [
                _CustomTab(icon: Icons.restaurant_menu, label: 'Tracker', controller: _tabController, index: 0),
                _CustomTab(icon: Icons.menu_book, label: 'Recipes', controller: _tabController, index: 1),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [NutritionTrackerTab(), RecipesTab()]),
    );
  }
}

class _CustomTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final TabController controller;
  final int index;

  const _CustomTab({required this.icon, required this.label, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isActive = controller.index == index;

        // Only use isActive for final selection state to avoid glitches
        final bool isSelected = isActive;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : AppColors.green, size: 20),
                isSelected ? const SizedBox.shrink() : SizedBox(width: 8),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: SizedBox(width: isSelected ? 8 : 0),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? Colors.white : AppColors.green, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
