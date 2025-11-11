import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

/// Modern onboarding screen with immersive design and smooth transitions
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.fitness_center_rounded,
      title: 'Track Your\nWorkouts',
      description: 'Log every rep, set, and weight. Watch your progress grow with detailed analytics and insights.',
      accentColor: AppColors.accent,
    ),
    OnboardingPage(
      icon: Icons.calendar_today_rounded,
      title: 'Plan Your\nJourney',
      description: 'Follow expert programs or create custom plans that fit your goals and schedule perfectly.',
      accentColor: AppColors.accent,
    ),
    OnboardingPage(
      icon: Icons.directions_run_rounded,
      title: 'Run & Track\nEverywhere',
      description: 'GPS tracking for outdoor runs with real-time pace, distance, and elevation data.',
      accentColor: AppColors.accent,
    ),
    OnboardingPage(
      icon: Icons.school_rounded,
      title: 'Learn from\nExperts',
      description: 'Access premium programs and courses from certified trainers and fitness professionals.',
      accentColor: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageTransitionController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeOutCubic));
    _pageTransitionController.forward();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _pageTransitionController.reset();
    _pageTransitionController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final storage = await StorageService.getInstance();
    final authController = Get.put(AuthController(storage), permanent: true);
    await authController.completeOnboarding();
    Get.offAllNamed(AppRoutes.welcome);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
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
              Column(
                children: [
                  // Skip button
                  _buildSkipButton(),

                  // Page view
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildPage(_pages[index]);
                      },
                    ),
                  ),

                  // Bottom section with indicators and button
                  _buildBottomSection(),
                ],
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
        animation: _pageTransitionController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: size.height * 0.1 * (1 - _fadeAnimation.value),
                right: -size.width * 0.2,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.1,
                  child: Container(
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [_pages[_currentPage].accentColor.withOpacity(0.2), Colors.transparent]),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.2 * (1 - _fadeAnimation.value),
                left: -size.width * 0.3,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.08,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [_pages[_currentPage].accentColor.withOpacity(0.15), Colors.transparent]),
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

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: _skip,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: AppColors.surface.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            'Skip',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with modern card design
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.surface, AppColors.surface.withOpacity(0.8)]),
                  border: Border.all(color: AppColors.primaryGray.withOpacity(0.2), width: 1.5),
                  boxShadow: [BoxShadow(color: page.accentColor.withOpacity(0.2), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10))],
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [page.accentColor, page.accentColor.withOpacity(0.8)]),
                    ),
                    child: Icon(page.icon, size: 40, color: AppColors.onAccent),
                  ),
                ),
              ),
              const SizedBox(height: 64),

              // Title with premium typography
              Text(
                page.title,
                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground, fontSize: 38, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  page.description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onBackground.withOpacity(0.7),
                    fontSize: 17,
                    height: 1.6,
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
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length, (index) => _buildPageIndicator(index))),
          const SizedBox(height: 32),

          // Next/Get Started button
          CustomButton(
            text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
            onPressed: _nextPage,
            icon: _currentPage == _pages.length - 1 ? const Icon(Icons.arrow_forward_rounded) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 40 : 12,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isActive ? AppColors.accent : AppColors.primaryGray.withOpacity(0.3),
        boxShadow: isActive ? [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)] : null,
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  OnboardingPage({required this.icon, required this.title, required this.description, required this.accentColor});
}
