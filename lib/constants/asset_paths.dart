/// Asset paths for images, icons, and other resources
class AssetPaths {
  AssetPaths._(); // Private constructor

  // Base paths
  static const String _imagesBase = 'assets/images';
  static const String _iconsBase = 'assets/icons';

  // Images
  static const String logo = '$_imagesBase/logo.png'; // Main app logo
  static const String logoWhite = '$_imagesBase/logo_white.png';
  static const String onboarding1 = '$_imagesBase/onboarding_1.png';
  static const String onboarding2 = '$_imagesBase/onboarding_2.png';
  static const String onboarding3 = '$_imagesBase/onboarding_3.png';
  static const String placeholder = '$_imagesBase/placeholder.png';
  static const String emptyState = '$_imagesBase/empty_state.png';
  static const String noWorkouts = '$_imagesBase/no_workouts.png';
  static const String noPrograms = '$_imagesBase/no_programs.png';

  // Icons
  static const String iconHome = '$_iconsBase/home.png';
  static const String iconJournal = '$_iconsBase/journal.png';
  static const String iconPlanner = '$_iconsBase/planner.png';
  static const String iconTracker = '$_iconsBase/tracker.png';
  static const String iconMarketplace = '$_iconsBase/marketplace.png';
  static const String iconProfile = '$_iconsBase/profile.png';

  // Note: Add actual image files to assets/ folder or use Material Icons
}
