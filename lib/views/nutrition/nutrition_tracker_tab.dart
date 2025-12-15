import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/nutrition_controller.dart';
import 'package:get_right/models/meal_entry.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/views/nutrition/add_food_screen.dart';

/// Nutrition Tracker Tab - Shows daily calorie and macro tracking
class NutritionTrackerTab extends StatelessWidget {
  const NutritionTrackerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NutritionController>();

    return GetBuilder<NutritionController>(
      builder: (controller) {
        final currentDay = controller.currentDay;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calories Overview Card
              _buildCaloriesCard(currentDay.totalCalories, currentDay.calorieGoal, currentDay.calorieProgress),

              const SizedBox(height: 16),

              // Macros Overview
              Row(
                children: [
                  Expanded(
                    child: _buildMacroCard(
                      'Protein',
                      currentDay.totalProtein,
                      currentDay.proteinGoal,
                      currentDay.proteinProgress,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard(
                      'Carbs',
                      currentDay.totalCarbs,
                      currentDay.carbsGoal,
                      currentDay.carbsProgress,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard(
                      'Fats',
                      currentDay.totalFats,
                      currentDay.fatsGoal,
                      currentDay.fatsProgress,
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Daily Progress Section
              Text(
                'Daily Progress',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              _buildProgressBar('Protein', currentDay.totalProtein, currentDay.proteinGoal, Colors.blue),
              const SizedBox(height: 8),
              _buildProgressBar('Carbs', currentDay.totalCarbs, currentDay.carbsGoal, Colors.orange),
              const SizedBox(height: 8),
              _buildProgressBar('Fats', currentDay.totalFats, currentDay.fatsGoal, Colors.purple),

              const SizedBox(height: 24),

              // Food Log Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Food Log',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Add Food',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Meal Sections
              _buildMealSection(controller, MealType.breakfast),
              const SizedBox(height: 12),
              _buildMealSection(controller, MealType.lunch),
              const SizedBox(height: 12),
              _buildMealSection(controller, MealType.dinner),
              const SizedBox(height: 12),
              _buildMealSection(controller, MealType.snacks),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCaloriesCard(double consumed, double goal, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Calories',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                consumed.toStringAsFixed(0),
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${goal.toStringAsFixed(0)} kcal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(goal - consumed).toStringAsFixed(0)} kcal remaining',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double consumed, double goal, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            consumed.toStringAsFixed(0),
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '/ ${goal.toStringAsFixed(0)} g',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, double goal, Color color) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            '${value.toStringAsFixed(0)}/${goal.toStringAsFixed(0)} g',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(NutritionController controller, MealType mealType) {
    final meals = controller.currentDay.getMealsByType(mealType);
    final totalCalories = controller.currentDay.getCaloriesByMealType(mealType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => AddFoodScreen(mealType: mealType));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    mealType.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealType.displayName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        if (meals.isNotEmpty)
                          Text(
                            '${totalCalories.toStringAsFixed(0)} kcal',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.mediumGray,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (meals.isEmpty)
                    const Icon(Icons.add, color: AppColors.accent, size: 24)
                  else
                    Text(
                      '${meals.length} ${meals.length == 1 ? 'item' : 'items'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (meals.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.lightGray),
            ...meals.map((meal) => _buildMealItem(controller, meal)),
          ],
        ],
      ),
    );
  }

  Widget _buildMealItem(NutritionController controller, MealEntry meal) {
    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controller.removeMealEntry(meal.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            if (meal.foodItem.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meal.foodItem.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    color: AppColors.lightGray,
                    child: const Icon(Icons.restaurant, color: AppColors.mediumGray),
                  ),
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.mediumGray),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.foodItem.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.quantity} ${meal.foodItem.servingUnit}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.totalCalories.toStringAsFixed(0)} kcal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'P${meal.totalProtein.toStringAsFixed(0)} C${meal.totalCarbs.toStringAsFixed(0)} F${meal.totalFats.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

