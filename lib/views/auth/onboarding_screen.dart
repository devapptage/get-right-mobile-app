import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/storage_service.dart';
import 'dart:math' as math;

/// Next-Level Modern Onboarding Screen 2024/2025
/// Features: Bold visuals, smooth animations, immersive design
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Modern color palette
  static const Color _greenAccent = Color(0xFF29603C);
  static const Color _blackPrimary = Color(0xFF000000);
  static const Color _bgGrey = Color(0xFFD6D6D6);
  static const Color _cardWhite = Color(0xFFF5F5F5);

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      emoji: '💪',
      title: 'Track Every Rep',
      subtitle: 'Your Fitness Journey',
      description: 'Log workouts, track progress, and watch yourself grow stronger every single day.',
      gradient: [Color(0xFF29603C), Color(0xFF1a3d26)],
    ),
    OnboardingPage(
      emoji: '📅',
      title: 'Plan Your Goals',
      subtitle: 'Smart Planning',
      description: 'Custom programs designed for your goals. Follow expert plans or create your own.',
      gradient: [Color(0xFF29603C), Color(0xFF1a3d26)],
    ),
    OnboardingPage(
      emoji: '🏃',
      title: 'Run & Conquer',
      subtitle: 'GPS Tracking',
      description: 'Track outdoor runs with real-time pace, distance, and elevation data.',
      gradient: [Color(0xFF29603C), Color(0xFF1a3d26)],
    ),
    OnboardingPage(
      emoji: '🎯',
      title: 'Get Right',
      subtitle: 'Start Today',
      description: 'Join thousands achieving their fitness goals. Your transformation starts now.',
      gradient: [Color(0xFF29603C), Color(0xFF1a3d26)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _scaleController.forward();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _fadeController.reset();
    _scaleController.reset();
    _fadeController.forward();
    _scaleController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
    } else {
      _completeOnboarding();
    }
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
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_bgGrey, Color.lerp(_bgGrey, _pages[_currentPage].gradient[0], 0.1)!]),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar with skip
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            'Skip',
                            style: TextStyle(color: _blackPrimary.withOpacity(0.6), fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Bottom section
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji with modern container
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: page.gradient),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [BoxShadow(color: page.gradient[0].withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 20))],
                    ),
                    child: Center(child: Text(page.emoji, style: TextStyle(fontSize: 80))),
                  ),
                  const SizedBox(height: 64),

                  // Subtitle
                  Text(
                    page.subtitle,
                    style: TextStyle(color: _greenAccent, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    page.title,
                    style: TextStyle(color: _blackPrimary, fontSize: 40, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      page.description,
                      style: TextStyle(color: _blackPrimary.withOpacity(0.6), fontSize: 16, height: 1.6, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length, (index) => _buildPageIndicator(index))),
          const SizedBox(height: 40),

          // CTA Button
          GestureDetector(
            onTap: _nextPage,
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _pages[_currentPage].gradient),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: _pages[_currentPage].gradient[0].withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 12))],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
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
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: isActive ? _greenAccent : _blackPrimary.withOpacity(0.2)),
    );
  }
}

class OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradient;

  OnboardingPage({required this.emoji, required this.title, required this.subtitle, required this.description, required this.gradient});
}
