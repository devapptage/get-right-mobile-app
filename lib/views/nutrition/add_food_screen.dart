import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/nutrition_controller.dart';
import 'package:get_right/models/food_item.dart';
import 'package:get_right/models/meal_entry.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Add Food Screen - Add food items to tracker
class AddFoodScreen extends StatefulWidget {
  final MealType mealType;

  const AddFoodScreen({super.key, required this.mealType});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<NutritionController>();

  // Custom food form controllers
  final nameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();
  final servingSizeController = TextEditingController(text: '1');
  final servingUnitController = TextEditingController(text: 'serving');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    servingSizeController.dispose();
    servingUnitController.dispose();
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
          icon: const Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add to ${widget.mealType.displayName}',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.mediumGray,
              labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Saved Items'),
                Tab(text: 'Custom'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavedItemsTab(),
          _buildCustomFoodTab(),
        ],
      ),
    );
  }

  Widget _buildSavedItemsTab() {
    return GetBuilder<NutritionController>(
      builder: (controller) {
        if (controller.savedFoodItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 80, color: AppColors.mediumGray),
                const SizedBox(height: 16),
                Text(
                  'No saved items yet',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add custom foods to save them for quick access',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.savedFoodItems.length,
          itemBuilder: (context, index) {
            final item = controller.savedFoodItems[index];
            return _buildSavedFoodCard(item);
          },
        );
      },
    );
  }

  Widget _buildSavedFoodCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => _showQuantityDialog(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.mediumGray, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.defaultServingSize} ${item.servingUnit}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.calories.toStringAsFixed(0)} kcal • P${item.protein.toStringAsFixed(0)}g C${item.carbs.toStringAsFixed(0)}g F${item.fats.toStringAsFixed(0)}g',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.mediumGray, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditFoodDialog(item);
                  } else if (value == 'delete') {
                    _showDeleteConfirmationDialog(item);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.accent, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFoodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Custom Food',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Food Name
          _buildTextField(
            controller: nameController,
            label: 'Food Name',
            hint: 'e.g., Chicken Breast',
          ),
          const SizedBox(height: 16),

          // Serving Size and Unit
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: servingSizeController,
                  label: 'Serving Size',
                  hint: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: servingUnitController,
                  label: 'Unit',
                  hint: 'serving',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calories
          _buildTextField(
            controller: caloriesController,
            label: 'Calories',
            hint: 'e.g., 200',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Macros Row
          Text(
            'Macronutrients',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: proteinController,
                  label: 'Protein (g)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: carbsController,
                  label: 'Carbs (g)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: fatsController,
                  label: 'Fats (g)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addCustomFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add to Tracker',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Save for Later Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _saveCustomFood,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save for Later',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _showQuantityDialog(FoodItem item) {
    double quantity = item.defaultServingSize;
    final quantityController = TextEditingController(text: quantity.toString());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Add ${item.name}',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How many servings?',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: AppColors.accent, size: 32),
                      onPressed: () {
                        if (quantity > 0.5) {
                          setState(() {
                            quantity -= 0.5;
                            quantityController.text = quantity.toString();
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        onChanged: (value) {
                          quantity = double.tryParse(value) ?? quantity;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.accent, size: 32),
                      onPressed: () {
                        setState(() {
                          quantity += 0.5;
                          quantityController.text = quantity.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildNutritionRow('Calories', '${(item.calories * quantity).toStringAsFixed(0)} kcal'),
                      _buildNutritionRow('Protein', '${(item.protein * quantity).toStringAsFixed(1)} g'),
                      _buildNutritionRow('Carbs', '${(item.carbs * quantity).toStringAsFixed(1)} g'),
                      _buildNutritionRow('Fats', '${(item.fats * quantity).toStringAsFixed(1)} g'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.buttonMedium.copyWith(color: AppColors.mediumGray),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _addFoodToTracker(item, quantity);
                  Get.back(); // Close dialog
                  Get.back(); // Go back to nutrition screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add',
                  style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _addFoodToTracker(FoodItem item, double quantity) {
    final entry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodItem: item,
      quantity: quantity,
      mealType: widget.mealType,
      timestamp: controller.selectedDate.value,
    );

    controller.addMealEntry(entry);

    Get.snackbar(
      'Success',
      '${item.name} added to ${widget.mealType.displayName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.accent,
      colorText: Colors.white,
    );
  }

  void _addCustomFood() {
    if (_validateCustomFood()) {
      final foodItem = _createFoodItem();
      _addFoodToTracker(foodItem, double.tryParse(servingSizeController.text) ?? 1.0);
    }
  }

  void _saveCustomFood() {
    if (_validateCustomFood()) {
      final foodItem = _createFoodItem();
      controller.saveFoodItem(foodItem);

      Get.snackbar(
        'Success',
        '${foodItem.name} saved for later use',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
      );

      // Clear form
      _clearForm();
    }
  }

  bool _validateCustomFood() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a food name', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (caloriesController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter calories', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  FoodItem _createFoodItem() {
    return FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      calories: double.tryParse(caloriesController.text) ?? 0,
      protein: double.tryParse(proteinController.text) ?? 0,
      carbs: double.tryParse(carbsController.text) ?? 0,
      fats: double.tryParse(fatsController.text) ?? 0,
      defaultServingSize: double.tryParse(servingSizeController.text) ?? 1.0,
      servingUnit: servingUnitController.text,
    );
  }

  void _clearForm() {
    nameController.clear();
    caloriesController.clear();
    proteinController.clear();
    carbsController.clear();
    fatsController.clear();
    servingSizeController.text = '1';
    servingUnitController.text = 'serving';
  }

  void _showEditFoodDialog(FoodItem item) {
    // Initialize controllers with current values
    final editNameController = TextEditingController(text: item.name);
    final editCaloriesController = TextEditingController(text: item.calories.toStringAsFixed(0));
    final editProteinController = TextEditingController(text: item.protein.toStringAsFixed(0));
    final editCarbsController = TextEditingController(text: item.carbs.toStringAsFixed(0));
    final editFatsController = TextEditingController(text: item.fats.toStringAsFixed(0));
    final editServingSizeController = TextEditingController(text: item.defaultServingSize.toStringAsFixed(1));
    final editServingUnitController = TextEditingController(text: item.servingUnit ?? 'serving');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Food Item',
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.primaryGray),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Food Name
                  _buildTextField(
                    controller: editNameController,
                    label: 'Food Name',
                    hint: 'e.g., Chicken Breast',
                  ),
                  const SizedBox(height: 16),
                  // Serving Size and Unit
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: editServingSizeController,
                          label: 'Serving Size',
                          hint: '1',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: editServingUnitController,
                          label: 'Unit',
                          hint: 'serving',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Calories
                  _buildTextField(
                    controller: editCaloriesController,
                    label: 'Calories',
                    hint: 'e.g., 200',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // Macros
                  Text(
                    'Macronutrients',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: editProteinController,
                          label: 'Protein (g)',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: editCarbsController,
                          label: 'Carbs (g)',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: editFatsController,
                          label: 'Fats (g)',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (editNameController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter a food name', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        if (editCaloriesController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter calories', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        final updatedItem = item.copyWith(
                          name: editNameController.text.trim(),
                          calories: double.tryParse(editCaloriesController.text) ?? item.calories,
                          protein: double.tryParse(editProteinController.text) ?? item.protein,
                          carbs: double.tryParse(editCarbsController.text) ?? item.carbs,
                          fats: double.tryParse(editFatsController.text) ?? item.fats,
                          defaultServingSize: double.tryParse(editServingSizeController.text) ?? item.defaultServingSize,
                          servingUnit: editServingUnitController.text.trim().isEmpty ? item.servingUnit : editServingUnitController.text.trim(),
                        );

                        controller.updateSavedFoodItem(updatedItem);

                        Navigator.pop(context);
                        Get.snackbar(
                          'Success',
                          '${updatedItem.name} updated successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.accent,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Save Changes',
                        style: AppTextStyles.buttonLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) {
      // Dispose controllers when dialog is closed
      editNameController.dispose();
      editCaloriesController.dispose();
      editProteinController.dispose();
      editCarbsController.dispose();
      editFatsController.dispose();
      editServingSizeController.dispose();
      editServingUnitController.dispose();
    });
  }

  void _showDeleteConfirmationDialog(FoodItem item) {
    Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Food Item',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${item.name}"?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.mediumGray),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Delete',
              style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        controller.removeSavedFoodItem(item.id);
        Get.snackbar(
          'Deleted',
          '${item.name} removed from saved items',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.accent,
          colorText: Colors.white,
        );
      }
    });
  }
}

