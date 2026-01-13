import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';
import 'package:get_right/widgets/common/custom_text_field.dart';

/// Profile Setup screen - post-signup profile completion
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _selectedGender;

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
    _fullNameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.accent, onPrimary: AppColors.onAccent, surface: Colors.white, onSurface: AppColors.onBackground),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _continue() {
    // Navigate to preference selection screen
    Get.toNamed(AppRoutes.preferenceSelection);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                      const SizedBox(height: 24),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     IconButton(
                      //       icon: Container(
                      //         padding: const EdgeInsets.all(8),
                      //         decoration: BoxDecoration(
                      //           color: AppColors.surface,
                      //           borderRadius: BorderRadius.circular(12),
                      //           border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1),
                      //         ),
                      //         child: const Icon(Icons.arrow_back_rounded, size: 20),
                      //       ),
                      //       onPressed: () => Get.offNamed(AppRoutes.otp),
                      //     ),
                      //   ],
                      // ),

                      // Header
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to GetRight',
                            style: AppTextStyles.headlineLarge.copyWith(color: AppColors.accent, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Create an account to access your personal fitness journal, workout programs, and more.',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w400, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithAsterisk('Full name'),

                          const SizedBox(height: 8),
                          CustomTextField(controller: _fullNameController, labelText: null, hintText: 'Full name', prefixIcon: null),
                          const SizedBox(height: 10),

                          // Date of Birth
                          _buildLabelWithAsterisk('Date of Birth'),
                          const SizedBox(height: 8),
                          _buildDateOfBirthField(),
                          const SizedBox(height: 10),

                          // Phone Number (Optional)
                          _buildLabelWithOptional('Phone Number'),
                          const SizedBox(height: 8),
                          CustomTextField(controller: _phoneController, labelText: null, hintText: 'Enter your phone number', keyboardType: TextInputType.phone, prefixIcon: null),
                          const SizedBox(height: 10),

                          // Gender dropdown
                          _buildLabelWithAsterisk('Gender'),
                          const SizedBox(height: 8),
                          _buildDropdownField(
                            label: null,
                            value: _selectedGender,
                            items: AppConstants.genderOptions,
                            icon: null,
                            onChanged: (value) => setState(() => _selectedGender = value),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                      // Terms and Conditions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text.rich(
                          TextSpan(
                            text: 'By continuing, you agree to GetRight\'s ',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Continue button
                      GetBuilder<AuthController>(
                        builder: (controller) {
                          return CustomButton(
                            text: 'Continue',
                            onPressed: _continue,
                            isLoading: controller.isLoading,
                            backgroundColor: AppColors.accent,
                            textColor: AppColors.onAccent,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Divider with "or"
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: AppColors.primaryGray.withOpacity(0.3))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(child: Container(height: 1, color: AppColors.primaryGray.withOpacity(0.3))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social login icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(Icons.apple_rounded, Colors.black, () {}),
                          const SizedBox(width: 20),
                          _buildSocialIcon(Icons.facebook_rounded, const Color(0xFF1877F2), () {}),
                          const SizedBox(width: 20),
                          _buildSocialIcon(Icons.g_mobiledata_rounded, Colors.white, () {}),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground, fontSize: 14, fontWeight: FontWeight.w500),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildLabelWithOptional(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground, fontSize: 14, fontWeight: FontWeight.w500),
        children: [
          TextSpan(
            text: ' (Optional)',
            style: AppTextStyles.bodyMedium.copyWith(color: const Color.fromARGB(255, 39, 40, 41), fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: _selectDateOfBirth,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
          border: Border.all(color: const Color(0xFF666666), width: 1.5), // Dark gray border
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _dateOfBirth != null ? DateFormat('MMMM dd, yyyy').format(_dateOfBirth!) : 'December 22, 2025',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _dateOfBirth != null ? AppColors.onBackground : const Color.fromARGB(255, 117, 116, 116),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.calendar_today_rounded, color: AppColors.accent, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color backgroundColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: backgroundColor == Colors.white ? AppColors.onBackground : Colors.white, size: 24),
      ),
    );
  }

  Widget _buildDropdownField({required String? label, required String? value, required List<String> items, required IconData? icon, required ValueChanged<String?> onChanged}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF666666), width: 1.5), // Dark gray border
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(icon, color: AppColors.primaryGray, size: 22),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
        style: AppTextStyles.bodyMedium.copyWith(
          color: value != null ? AppColors.onBackground : const Color.fromARGB(255, 117, 116, 116),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        dropdownColor: AppColors.surface,
        icon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent, size: 20),
        ),
        hint: Text(
          'Select gender',
          style: AppTextStyles.bodyMedium.copyWith(color: const Color.fromARGB(255, 117, 116, 116), fontSize: 15, fontWeight: FontWeight.w400),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
