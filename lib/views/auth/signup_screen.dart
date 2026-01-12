import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';
import 'package:get_right/widgets/common/custom_text_field.dart';

/// Modern signup screen with streamlined UX and premium design
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _signup() {
    final authController = Get.find<AuthController>();
    authController.signup(email: _emailController.text.trim(), password: _passwordController.text, firstName: '', lastName: '');

    // Navigate to OTP verification after signup
    Get.toNamed(
      AppRoutes.otp,
      arguments: {
        'email': _emailController.text.trim(),
        'fromSignup': true, // Flag to indicate this is from signup
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.accent, size: 35),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Create Account',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accent, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Email
                  _buildLabelWithAsterisk('Email'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _emailController,
                    labelText: null,
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  // Password
                  _buildLabelWithAsterisk('Password'),
                  const SizedBox(height: 8),
                  PasswordTextField(controller: _passwordController, labelText: null, hintText: 'Enter your password', onChanged: (value) => setState(() {})),
                  const SizedBox(height: 24),

                  // Confirm Password
                  _buildLabelWithAsterisk('Confirm Password'),
                  const SizedBox(height: 8),
                  PasswordTextField(controller: _confirmPasswordController, labelText: null, hintText: 'Confirm your password', onChanged: (value) => setState(() {})),
                  const SizedBox(height: 16),

                  // Instructions
                  Text(
                    'Password must be at least 8 characters long and include uppercase and lowercase letters.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w400, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'After creating your account, check your email (including spam folder) for verification.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w400, height: 1.4),
                  ),
                  const SizedBox(height: 32),

                  // Create Account button
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      final isValid = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;
                      return CustomButton(text: 'Create Account', onPressed: _signup, isLoading: controller.isLoading, backgroundColor: AppColors.accent, textColor: Colors.white);
                    },
                  ),
                  const SizedBox(height: 32),

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

                  // Social signup buttons
                  _buildSocialButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Continue with Google',
                    onPressed: () {
                      // TODO: Implement Google sign up
                    },
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    icon: Icons.apple_rounded,
                    label: 'Continue with Apple',
                    onPressed: () {
                      // TODO: Implement Apple sign up
                    },
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 32),
                ],
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

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onPressed, bool isFullWidth = false}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.onBackground),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
