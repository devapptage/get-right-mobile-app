import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/app_logo.dart';
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
  bool _acceptedTerms = false;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 20),
                      ),
                      onPressed: () => Get.back(),
                    ),

                    // Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)]),
                          border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1.5),
                          boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 8))],
                        ),
                        child: const AppLogo(size: 80, borderRadius: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Sign Up',
                      style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign up to start your fitness journey',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.2),
                    ),
                    const SizedBox(height: 25),

                    // Email
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    PasswordTextField(controller: _passwordController),
                    const SizedBox(height: 20),

                    // Confirm Password
                    PasswordTextField(controller: _confirmPasswordController, labelText: 'Confirm Password', hintText: 'Re-enter your password'),
                    const SizedBox(height: 24),

                    // Terms and conditions
                    InkWell(
                      onTap: () {
                        setState(() {
                          _acceptedTerms = !_acceptedTerms;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _acceptedTerms ? AppColors.accent.withOpacity(0.5) : AppColors.primaryGray.withOpacity(0.2), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _acceptedTerms ? AppColors.accent : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _acceptedTerms ? AppColors.accent : AppColors.primaryGray.withOpacity(0.4), width: 2),
                              ),
                              child: _acceptedTerms ? const Icon(Icons.check_rounded, size: 16, color: AppColors.onAccent) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.termsConditions),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.onBackground.withOpacity(0.7)),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Signup button (disabled if terms not accepted)
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return CustomButton(text: 'Sign Up', onPressed: _acceptedTerms ? _signup : null, isLoading: controller.isLoading);
                      },
                    ),
                    const SizedBox(height: 32),

                    // Divider with "OR"
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppColors.primaryGray.withOpacity(0.3)])),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR SIGN UP WITH',
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryGray.withOpacity(0.3), Colors.transparent])),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social signup buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Google',
                            onPressed: () {
                              // TODO: Implement Google sign up
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Expanded(
                        //   child: _buildSocialButton(
                        //     icon: Icons.apple_rounded,
                        //     label: 'Apple',
                        //     onPressed: () {
                        //       // TODO: Implement Apple sign up
                        //     },
                        //   ),
                        // ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSocialButton(
                            icon: Icons.facebook_rounded,
                            label: 'Facebook',
                            onPressed: () {
                              // TODO: Implement Facebook sign up
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 15),
                          ).paddingOnly(top: 4),
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign In',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ),
                        ],
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

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.onBackground),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
