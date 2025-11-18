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
import 'package:get_right/views/home/dashboard_screen.dart';
import 'package:get_right/views/profile/profile_screen.dart';
import 'package:get_right/views/profile/edit_profile_screen.dart';
import 'package:get_right/views/journal/journal_screen.dart';
import 'package:get_right/views/journal/add_workout_screen.dart';
import 'package:get_right/views/journal/log_run_screen.dart';
import 'package:get_right/views/journal/log_meal_screen.dart';
import 'package:get_right/views/journal/write_note_screen.dart';
import 'package:get_right/views/tracker/tracker_screen.dart';
import 'package:get_right/views/tracker/run_tracker_screen.dart';
import 'package:get_right/views/tracker/active_run_screen.dart';
import 'package:get_right/views/tracker/run_summary_screen.dart';
import 'package:get_right/views/tracker/run_history_screen.dart';
import 'package:get_right/views/planner/planner_screen.dart';
import 'package:get_right/views/marketplace/marketplace_screen.dart';
import 'package:get_right/views/settings/settings_screen.dart';
import 'package:get_right/views/settings/change_password_screen.dart';
import 'package:get_right/views/settings/notifications_screen.dart';
import 'package:get_right/views/settings/help_feedback_screen.dart';
import 'package:get_right/views/settings/about_screen.dart';
import 'package:get_right/views/chat/chat_list_screen.dart';
import 'package:get_right/views/chat/chat_room_screen.dart';
import 'package:get_right/views/tracker/progress_screen.dart';
import 'package:get_right/views/search/search_screen.dart';
import 'package:get_right/views/search/search_results_screen.dart';
import 'package:get_right/views/trainer/trainer_profile_screen.dart';
import 'package:get_right/views/trainer/trainer_reviews_screen.dart';
import 'package:get_right/views/marketplace/program_detail_screen.dart';
import 'package:get_right/views/marketplace/program_enrollment_screen.dart';
import 'package:get_right/views/marketplace/purchase_details_screen.dart';
import 'package:get_right/views/marketplace/payment_form_screen.dart';
import 'package:get_right/views/marketplace/program_terms_screen.dart';
import 'package:get_right/views/marketplace/my_programs_screen.dart';
import 'package:get_right/views/favorites/favorites_screen.dart';
import 'package:get_right/views/program_history/program_history_screen.dart';
import 'package:get_right/views/program_history/active_program_detail_screen.dart';
import 'package:get_right/views/program_history/completed_program_detail_screen.dart';
import 'package:get_right/views/program_history/program_modification_request_screen.dart';
import 'package:get_right/views/transaction_history/transaction_history_screen.dart';
import 'package:get_right/views/transaction_history/transaction_detail_screen.dart';

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
    GetPage(name: AppRoutes.changePassword, page: () => const ChangePasswordScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.profileSetup, page: () => const ProfileSetupScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.termsConditions, page: () => const TermsConditionsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.privacyPolicy, page: () => const PrivacyPolicyScreen(), transition: Transition.rightToLeft),

    // Main App Pages
    GetPage(name: AppRoutes.home, page: () => const HomeScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen(), transition: Transition.fade),

    // Profile Pages
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen(), transition: Transition.rightToLeft),

    // Journal Pages
    GetPage(name: AppRoutes.journal, page: () => const JournalScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.addWorkout, page: () => const AddWorkoutScreen(), transition: Transition.downToUp),
    GetPage(name: AppRoutes.logRun, page: () => const LogRunScreen(), transition: Transition.downToUp),
    GetPage(name: AppRoutes.logMeal, page: () => const LogMealScreen(), transition: Transition.downToUp),
    GetPage(name: AppRoutes.writeNote, page: () => const WriteNoteScreen(), transition: Transition.downToUp),

    // Tracker Pages
    GetPage(name: AppRoutes.tracker, page: () => const TrackerScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.runTracker, page: () => const RunTrackerScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.runTracking, page: () => const ActiveRunScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.runHistory, page: () => const RunHistoryScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.runDetail, page: () => const RunSummaryScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.progress, page: () => const ProgressScreen(), transition: Transition.rightToLeft),

    // Planner Pages
    GetPage(name: AppRoutes.planner, page: () => const PlannerScreen(), transition: Transition.fade),

    // Marketplace Pages
    GetPage(name: AppRoutes.marketplace, page: () => const MarketplaceScreen(), transition: Transition.fade),
    GetPage(name: AppRoutes.programDetail, page: () => const ProgramDetailScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.programEnrollment, page: () => const ProgramEnrollmentScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.purchaseDetails, page: () => const PurchaseDetailsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.paymentForm, page: () => const PaymentFormScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.programTerms, page: () => const ProgramTermsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.myPrograms, page: () => const MyProgramsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.favorites, page: () => const FavoritesScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.trainerProfile, page: () => const TrainerProfileScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.trainerReviews, page: () => const TrainerReviewsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.programHistory, page: () => const ProgramHistoryScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.activeProgramDetail, page: () => const ActiveProgramDetailScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.completedProgramDetail, page: () => const CompletedProgramDetailScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.programModificationRequest, page: () => const ProgramModificationRequestScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.transactionHistory, page: () => TransactionHistoryScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.transactionDetail, page: () => const TransactionDetailScreen(), transition: Transition.rightToLeft),

    // Search Pages
    GetPage(name: AppRoutes.search, page: () => SearchScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.searchResults, page: () => const SearchResultsScreen(), transition: Transition.rightToLeft),

    // Chat Pages
    GetPage(name: AppRoutes.chatList, page: () => const ChatListScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.chatRoom, page: () => const ChatRoomScreen(), transition: Transition.rightToLeft),

    // Settings Pages
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.helpFeedback, page: () => const HelpFeedbackScreen(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.about, page: () => const AboutScreen(), transition: Transition.rightToLeft),
    // GetPage(name: AppRoutes.createTrainerProfile, page: () => const CreateTrainerProfileScreen(), transition: Transition.rightToLeft),
  ];
}
