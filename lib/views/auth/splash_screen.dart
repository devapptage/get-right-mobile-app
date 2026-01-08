import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/widgets/common/app_logo.dart';

/// Modern splash screen with elegant animations and premium feel
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Fade animation
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Scale animation
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    // Shimmer animation for premium effect
    _shimmerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _shimmerController.repeat();
  }

  Future<void> _initializeApp() async {
    // Initialize local storage service only
    final storage = await StorageService.getInstance();

    // Initialize auth controller as permanent (survives route changes)
    Get.put(AuthController(storage), permanent: true);

    // Wait for minimum splash screen display time (2.8 seconds for animations)
    await Future.delayed(const Duration(milliseconds: 2800));

    // Always navigate to onboarding screen
    Get.offAllNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.background, AppColors.primaryVariant.withOpacity(0.3)]),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated gradient circles for depth
              _buildAnimatedCircle(alignment: Alignment.topLeft, size: 200, offset: const Offset(-50, -50)),
              _buildAnimatedCircle(alignment: Alignment.bottomRight, size: 250, offset: const Offset(50, 100)),

              // Main content
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with scale animation and shimmer
                      const AppLogo(borderRadius: 20),
                      const SizedBox(height: 48),

                      // App name with premium typography

                      // Tagline with fade
                      Text(
                        'Transform Your Fitness Journey',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 16, letterSpacing: 0.8, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),

                      // Modern loading indicator
                      _buildModernLoadingIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle({required Alignment alignment, required double size, required Offset offset}) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform.translate(
          offset: offset,
          child: AnimatedBuilder(
            animation: _scaleController,
            builder: (context, child) {
              return Container(
                width: size * _scaleAnimation.value,
                height: size * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.08), AppColors.accent.withOpacity(0.02), Colors.transparent]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModernLoadingIndicator() {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          SizedBox(width: 50, height: 50, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent.withOpacity(0.3)))),
          // Inner ring
          SizedBox(width: 35, height: 35, child: CircularProgressIndicator(strokeWidth: 3, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent))),
        ],
      ),
    );
  }
}
