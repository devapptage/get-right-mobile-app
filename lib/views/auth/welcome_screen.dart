import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/app_logo.dart';
import 'package:get_right/widgets/common/custom_button.dart';

/// Welcome/Onboarding screen - single screen entry point
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _navigateToSignUp() {
    Get.toNamed(AppRoutes.signup);
  }

  void _navigateToSignIn() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.background, AppColors.primaryVariant.withOpacity(0.3)]),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background shapes
              _buildBackgroundShapes(size),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Logo with animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: LinearGradient(colors: [AppColors.surface, AppColors.surface.withOpacity(0.8)]),
                                border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1.5),
                                boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10))],
                              ),
                              child: const AppLogo(size: 120, borderRadius: 20),
                            ),
                            const SizedBox(height: 48),

                            // App Name
                            Text(
                              'Get Right',
                              style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -2, height: 1.1),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Tagline
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Plan workouts, track runs, connect with trainers',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.onBackground.withOpacity(0.7),
                                  fontSize: 18,
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Action buttons
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Sign Up Button (Primary)
                          CustomButton(text: 'Sign IN', onPressed: _navigateToSignIn, icon: const Icon(Icons.arrow_forward_rounded)),
                          const SizedBox(height: 16),

                          // Sign In Button (Outline)
                          CustomOutlineButton(text: 'Sign Up', onPressed: _navigateToSignUp, icon: const Icon(Icons.arrow_forward_rounded)),
                          const SizedBox(height: 24),

                          // Join as Trainer link
                          // TextButton(
                          //   onPressed: () {
                          //     // TODO: Navigate to trainer signup
                          //     Get.snackbar(
                          //       'Coming Soon',
                          //       'Trainer registration will be available soon!',
                          //       snackPosition: SnackPosition.BOTTOM,
                          //       backgroundColor: AppColors.surface,
                          //       colorText: AppColors.onBackground,
                          //       margin: const EdgeInsets.all(16),
                          //       borderRadius: 12,
                          //       duration: const Duration(seconds: 3),
                          //     );
                          //   },
                          //   style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Icon(Icons.school_rounded, size: 20, color: AppColors.accent),
                          //       const SizedBox(width: 8),
                          //       Text(
                          //         'Join as a Trainer',
                          //         style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w600),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundShapes(Size size) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: size.height * 0.1 * (1 - _fadeAnimation.value),
                right: -size.width * 0.3,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.08,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.15), Colors.transparent]),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.15 * (1 - _fadeAnimation.value),
                left: -size.width * 0.4,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.06,
                  child: Container(
                    width: size.width * 1.0,
                    height: size.width * 1.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.12), Colors.transparent]),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
