import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';
import 'package:get_right/widgets/common/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

/// Profile Setup screen - post-signup profile completion
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _phoneController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();

  String? _selectedGender;
  String? _selectedFitnessGoal;
  String? _selectedActivityLevel;
  String? _selectedUnits = 'Metric'; // Default to metric
  List<String> _selectedWorkoutTypes = [];
  String? _profileImagePath;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _phoneController.dispose();
    _medicalConditionsController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _pickProfileImage() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Profile Picture',
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackground, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),

              // Gallery option
              InkWell(
                onTap: () async {
                  Get.back();
                  await _pickImageFromSource(ImageSource.gallery);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.photo_library_rounded, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gallery',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text('Choose from your photos', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.primaryGray),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Camera option
              InkWell(
                onTap: () async {
                  Get.back();
                  await _pickImageFromSource(ImageSource.camera);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.camera_alt_rounded, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Camera',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text('Take a new photo', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.primaryGray),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cancel button
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });

        Get.snackbar(
          'Success',
          'Profile picture selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.accent,
          colorText: AppColors.onAccent,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void _completeProfile() {
    // TODO: Save profile data via authController
    // final authController = Get.find<AuthController>();
    // authController.saveProfileData(...);

    Get.snackbar(
      'Success',
      'Profile setup completed!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.accent,
      colorText: AppColors.onAccent,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(center: Alignment.topLeft, radius: 1.2, colors: [AppColors.accent.withOpacity(0.05), AppColors.background]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Header
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Complete Your Profile',
                          style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Let\'s personalize your fitness experience',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.2),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Profile Picture
                    _buildProfilePicturePicker(),
                    const SizedBox(height: 32),

                    // Name fields
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(controller: _firstNameController, labelText: 'First Name', hintText: 'John', prefixIcon: const Icon(Icons.person_outline_rounded)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(controller: _lastNameController, labelText: 'Last Name', hintText: 'Doe', prefixIcon: const Icon(Icons.person_outline_rounded)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Age
                    CustomTextField(
                      controller: _ageController,
                      labelText: 'Age',
                      hintText: 'Enter your age',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.cake_outlined),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),

                    // Phone Number
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Contact Number',
                      hintText: '+1 234 567 8900',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    const SizedBox(height: 20),

                    // Gender dropdown
                    _buildDropdownField(
                      label: 'Gender',
                      value: _selectedGender,
                      items: AppConstants.genderOptions,
                      icon: Icons.wc_outlined,
                      onChanged: (value) => setState(() => _selectedGender = value),
                    ),
                    const SizedBox(height: 20),

                    // Units preference
                    _buildDropdownField(
                      label: 'Units',
                      value: _selectedUnits,
                      items: AppConstants.unitsOptions,
                      icon: Icons.straighten_outlined,
                      onChanged: (value) => setState(() => _selectedUnits = value),
                    ),
                    const SizedBox(height: 20),

                    // Height and Weight
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _heightController,
                            labelText: _selectedUnits == 'Metric' ? 'Height (cm)' : 'Height (ft)',
                            hintText: _selectedUnits == 'Metric' ? '170' : '5.7',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: const Icon(Icons.height_outlined),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _weightController,
                            labelText: _selectedUnits == 'Metric' ? 'Weight (kg)' : 'Weight (lbs)',
                            hintText: _selectedUnits == 'Metric' ? '70' : '154',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: const Icon(Icons.monitor_weight_outlined),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Fitness Goal dropdown
                    _buildDropdownField(
                      label: 'Fitness Goal',
                      value: _selectedFitnessGoal,
                      items: AppConstants.fitnessGoals,
                      icon: Icons.flag_outlined,
                      onChanged: (value) => setState(() => _selectedFitnessGoal = value),
                    ),
                    const SizedBox(height: 20),

                    // Target Weight (optional)
                    if (_selectedFitnessGoal == 'Weight Loss' || _selectedFitnessGoal == 'Muscle Gain')
                      Column(
                        children: [
                          CustomTextField(
                            controller: _targetWeightController,
                            labelText: _selectedUnits == 'Metric' ? 'Target Weight (kg)' : 'Target Weight (lbs)',
                            hintText: _selectedUnits == 'Metric' ? '65' : '143',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: const Icon(Icons.track_changes_outlined),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                    // Activity Level dropdown
                    _buildDropdownField(
                      label: 'Activity Level',
                      value: _selectedActivityLevel,
                      items: AppConstants.activityLevels,
                      icon: Icons.directions_run_outlined,
                      onChanged: (value) => setState(() => _selectedActivityLevel = value),
                    ),
                    const SizedBox(height: 20),

                    // Preferred Workout Types (multi-select chips)
                    _buildWorkoutTypesSection(),
                    const SizedBox(height: 32),

                    // Medical & Emergency Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.health_and_safety_outlined, color: AppColors.accent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Health & Safety Information',
                          style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Medical Conditions (Optional)
                    CustomTextField(
                      controller: _medicalConditionsController,
                      labelText: 'Medical Conditions (Optional)',
                      hintText: 'e.g., Asthma, Diabetes, Allergies',
                      maxLines: 3,
                      prefixIcon: const Icon(Icons.health_and_safety_outlined),
                    ),
                    const SizedBox(height: 20),

                    // Emergency Contact Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.emergency_outlined, color: AppColors.accent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Emergency Contact',
                          style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact Name

                    // Emergency Contact Phone
                    CustomTextField(
                      controller: _emergencyContactPhoneController,
                      labelText: 'Emergency Contact Phone',
                      hintText: '+1 234 567 8900',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_in_talk_outlined),
                    ),
                    const SizedBox(height: 32),

                    // Complete Profile button
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return CustomButton(
                          text: 'Complete Profile',
                          onPressed: _completeProfile,
                          isLoading: controller.isLoading,
                          icon: const Icon(Icons.check_circle_outline_rounded),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Skip button
                    TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.home),
                      child: Text(
                        'Skip for now',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicturePicker() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 2),
              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 8))],
            ),
            child: _profileImagePath == null
                ? Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.primaryGray)
                : ClipOval(
                    child: Image.file(
                      File(_profileImagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person_outline_rounded, size: 50, color: AppColors.primaryGray);
                      },
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 18, color: AppColors.onAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String? value, required List<String> items, required IconData icon, required ValueChanged<String?> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(icon, color: AppColors.primaryGray, size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, fontSize: 15, fontWeight: FontWeight.w500),
          floatingLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground, fontSize: 15, fontWeight: FontWeight.w500),
        dropdownColor: AppColors.surface,
        icon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGray),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.1), AppColors.surface], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.fitness_center_rounded, size: 20, color: AppColors.primaryGray),
              const SizedBox(width: 8),
              Text(
                'Preferred Workout Types',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.workoutTypes.map((type) {
            final isSelected = _selectedWorkoutTypes.contains(type);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWorkoutTypes.remove(type);
                  } else {
                    _selectedWorkoutTypes.add(type);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.accent : AppColors.primaryGray.withOpacity(0.3), width: 1.5),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 8, spreadRadius: 0, offset: const Offset(0, 2))] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.check_circle_rounded, size: 16, color: AppColors.onAccent),
                      ),
                    Text(
                      type,
                      style: AppTextStyles.labelMedium.copyWith(color: isSelected ? AppColors.onAccent : AppColors.onBackground, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
