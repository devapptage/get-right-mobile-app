/// Route names for navigation
class AppRoutes {
  AppRoutes._(); // Private constructor

  // Auth Routes
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String profileSetup = '/profile-setup';

  // Main App Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String createProfile = '/create-profile';

  // Journal Routes
  static const String journal = '/journal';
  static const String addWorkout = '/add-workout';
  static const String editWorkout = '/edit-workout';
  static const String workoutDetail = '/workout-detail';
  static const String logRun = '/log-run';
  static const String logMeal = '/log-meal';
  static const String writeNote = '/write-note';

  // Tracker Routes
  static const String tracker = '/tracker';
  static const String calendar = '/calendar';
  static const String progress = '/progress';
  static const String runTracker = '/run-tracker';
  static const String runTracking = '/run-tracking'; // Live GPS tracking
  static const String runHistory = '/run-history';
  static const String runDetail = '/run-detail';

  // Planner Routes
  static const String planner = '/planner';
  static const String createPlan = '/create-plan';
  static const String editPlan = '/edit-plan';
  static const String planDetail = '/plan-detail';
  static const String templates = '/templates';

  // Marketplace Routes
  static const String marketplace = '/marketplace';
  static const String programDetail = '/program-detail';
  static const String programEnrollment = '/program-enrollment';
  static const String purchaseDetails = '/purchase-details';
  static const String paymentForm = '/payment-form';
  static const String programTerms = '/program-terms';
  static const String trainerProfile = '/trainer-profile';
  static const String trainerReviews = '/trainer-reviews';
  static const String myPrograms = '/my-programs';
  static const String favorites = '/favorites';
  static const String checkout = '/checkout';

  // Search Routes
  static const String search = '/search';
  static const String searchResults = '/search-results';

  // Chat Routes
  static const String chatList = '/chat-list';
  static const String chatRoom = '/chat-room';

  // Settings Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String helpFeedback = '/help-feedback';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String about = '/about';
  static const String createTrainerProfile = '/create-trainer-profile';
}
