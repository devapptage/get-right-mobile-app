import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/views/auth/splash_screen.dart';
import 'package:get_right/views/auth/welcome_screen.dart';
import 'package:get_right/views/auth/onboarding_screen.dart';
import 'package:get_right/views/auth/login_screen.dart';
import 'package:get_right/views/auth/signup_screen.dart';
import 'package:get_right/views/auth/otp_screen.dart';
import 'package:get_right/views/auth/forgot_password_screen.dart';
import 'package:get_right/views/auth/reset_password_screen.dart';
import 'package:get_right/views/auth/profile_setup_screen.dart';
import 'package:get_right/views/auth/terms_conditions_screen.dart';
import 'package:get_right/views/auth/privacy_policy_screen.dart';
import 'package:get_right/views/home/home_screen.dart';
import 'package:get_right/views/profile/profile_screen.dart';
import 'package:get_right/views/profile/edit_profile_screen.dart';
import 'package:get_right/views/journal/journal_screen.dart';
import 'package:get_right/views/journal/add_workout_screen.dart';
import 'package:get_right/views/tracker/tracker_screen.dart';
import 'package:get_right/views/planner/planner_screen.dart';
import 'package:get_right/views/marketplace/marketplace_screen.dart';
import 'package:get_right/views/settings/settings_screen.dart';

/// App Pages - GetX route configuration
class AppPages {
  AppPages._(); // Private constructor

  static const initial = AppRoutes.splash;

  static final routes = [
    // Auth Pages
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.otp, page: () => const OtpScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.resetPassword, page: () => const ResetPasswordScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.profileSetup, page: () => const ProfileSetupScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.termsConditions, page: () => const TermsConditionsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.privacyPolicy, page: () => const PrivacyPolicyScreen(), transition: Transition.rightToLeft),

    // Main App Pages
    GetPage(name: AppRoutes.home, page: () => const HomeScreen(), transition: Transition.fade),

    // Profile Pages
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen(), transition: Transition.rightToLeft),

    // Journal Pages
    GetPage(name: AppRoutes.journal, page: () => const JournalScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.addWorkout, page: () => const AddWorkoutScreen(), transition: Transition.downToUp),

    // Tracker Pages
    GetPage(name: AppRoutes.tracker, page: () => const TrackerScreen(), transition: Transition.fade),

    // Planner Pages
    GetPage(name: AppRoutes.planner, page: () => const PlannerScreen(), transition: Transition.fade),

    // Marketplace Pages
    GetPage(name: AppRoutes.marketplace, page: () => const MarketplaceScreen(), transition: Transition.fade),

    // Settings Pages
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen(), transition: Transition.rightToLeft),
  ];
}
