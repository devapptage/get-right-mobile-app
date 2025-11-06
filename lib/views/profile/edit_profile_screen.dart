import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/utils/validators.dart';
import 'package:get_right/widgets/common/custom_button.dart';
import 'package:get_right/widgets/common/custom_text_field.dart';

/// Edit profile screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;
  String? _selectedGoal;
  List<String> _selectedWorkoutTypes = [];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save profile to API
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile photo
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.secondary, // Green (secondary)
                      child: Icon(Icons.person, size: 50, color: AppColors.onSecondary), // White
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.secondary, // Green (secondary)
                        child: Icon(Icons.camera_alt, size: 16, color: AppColors.onSecondary), // White
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // First name
              CustomTextField(controller: _firstNameController, labelText: 'First Name', validator: Validators.validateName),
              const SizedBox(height: 16),

              // Last name
              CustomTextField(controller: _lastNameController, labelText: 'Last Name', validator: Validators.validateName),
              const SizedBox(height: 16),

              // Age
              CustomTextField(controller: _ageController, labelText: 'Age', keyboardType: TextInputType.number, validator: Validators.validateAge),
              const SizedBox(height: 16),

              // Gender - White on black
              Text('Gender', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppConstants.genderOptions.map((gender) {
                  final isSelected = _selectedGender == gender;
                  return ChoiceChip(
                    label: Text(gender),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = selected ? gender : null;
                      });
                    },
                    selectedColor: AppColors.secondary, // Green (secondary)
                    labelStyle: TextStyle(color: isSelected ? AppColors.onSecondary : AppColors.onBackground), // White on green, white otherwise
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Fitness goal - White on black
              Text('Fitness Goal', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceLight, // Gray background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGray, width: 1),
                  ),
                ),
                dropdownColor: AppColors.surface, // Dark dropdown
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceLight), // Black text on gray
                items: AppConstants.fitnessGoals.map((goal) {
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(goal, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)), // White text
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Preferred workout types - White on black
              Text('Preferred Workout Types', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.workoutTypes.map((type) {
                  final isSelected = _selectedWorkoutTypes.contains(type);
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedWorkoutTypes.add(type);
                        } else {
                          _selectedWorkoutTypes.remove(type);
                        }
                      });
                    },
                    selectedColor: AppColors.secondary, // Green (secondary)
                    labelStyle: TextStyle(color: isSelected ? AppColors.onSecondary : AppColors.onBackground), // White on green, white otherwise
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save button
              CustomButton(text: 'Save Changes', onPressed: _saveProfile),
            ],
          ),
        ),
      ),
    );
  }
}
