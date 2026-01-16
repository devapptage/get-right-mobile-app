import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/auth_controller.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/common/custom_button.dart';

/// Modern OTP verification screen with enhanced UX and timer
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(AppConstants.otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(AppConstants.otpLength, (_) => FocusNode());

  int _remainingSeconds = AppConstants.otpResendTimeSeconds;
  Timer? _timer;

  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startTimer();
  }

  void _setupAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  // void _verifyOTP() {
  //   final otp = _otpControllers.map((c) => c.text).join();
  //   final authController = Get.find<AuthController>();
  //   authController.verifyOTP(otp);

  //   // Check if this is from signup flow
  //   final args = Get.arguments as Map<String, dynamic>?;
  //   final fromSignup = args?['fromSignup'] ?? false;

  //   if (fromSignup) {
  //     // Navigate to Profile Setup after OTP verification from signup
  //     Get.offAllNamed(AppRoutes.profileSetup);
  //   } else {
  //     // Navigate to reset password or login for other flows
  //   }
  // }

  void _resendOTP() {
    if (_remainingSeconds > 0) return;

    final authController = Get.find<AuthController>();
    authController.resendOTP();

    setState(() {
      _remainingSeconds = AppConstants.otpResendTimeSeconds;
    });
    _startTimer();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all fields are filled
    // if (_otpControllers.every((c) => c.text.isNotEmpty)) {
    //   _verifyOTP();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Get email from arguments if passed
    final args = Get.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String?;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(center: Alignment.topCenter, radius: 1.0, colors: [AppColors.accent.withOpacity(0.05), AppColors.background]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: AppColors.accent, size: 35),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Icon with animation
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)]),
                        ),
                        child: const Icon(Icons.verified_outlined, size: 60, color: AppColors.onAccent),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Verify Your Email',
                            style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackground, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              email != null
                                  ? 'We\'ve sent a ${AppConstants.otpLength}-digit verification code to\n$email'
                                  : 'We\'ve sent a ${AppConstants.otpLength}-digit verification code to your email.\nPlease enter it below.',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground.withOpacity(0.6), fontSize: 15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // OTP input fields
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value * (_shakeController.isAnimating ? ((_shakeController.value * 4).floor() % 2 == 0 ? 1 : -1) : 0), 0),
                                child: child,
                              );
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(AppConstants.otpLength, (index) => _buildOtpField(index))),
                          ),
                          const SizedBox(height: 48),

                          // Verify button
                          GetBuilder<AuthController>(
                            builder: (controller) {
                              return CustomButton(text: 'Verify Code', onPressed: () => Get.toNamed(AppRoutes.profileSetup));
                            },
                          ),
                          const SizedBox(height: 32),

                          // Timer and resend
                          _buildResendSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 55,
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surface,
        border: Border.all(color: _focusNodes[index].hasFocus ? AppColors.accent : AppColors.primaryGray.withOpacity(0.3), width: _focusNodes[index].hasFocus ? 2.0 : 1.5),
        boxShadow: _focusNodes[index].hasFocus ? [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4))] : [],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
        // Remove background by not specifying fillColor and by keeping border: InputBorder.none
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
          // fillColor and filled are omitted to prevent white background
        ),
        onChanged: (value) => _onOtpChanged(value, index),
      ),
    );
  }

  Widget _buildResendSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: 20, color: AppColors.onBackground.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text('Didn\'t receive the code? ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground.withOpacity(0.7), fontSize: 14)),
          if (_remainingSeconds > 0)
            Text(
              'Resend in ${_remainingSeconds}s',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, fontSize: 14, fontWeight: FontWeight.w600),
            )
          else
            TextButton(
              onPressed: _resendOTP,
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(
                'Resend Code',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
