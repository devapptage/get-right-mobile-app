import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent, size: 18),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Nutrition',
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(25)),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.mediumGray,
              labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Tracker'),
                Tab(text: 'Recipes'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [NutritionTrackerTab(), RecipesTab()]),
    );
  }
}
