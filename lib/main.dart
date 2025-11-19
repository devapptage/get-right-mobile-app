import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_right/theme/app_theme.dart';
import 'package:get_right/routes/app_pages.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/controllers/auth_controller.dart';

// 1. DEFINE THE STYLE FOR DARK SCREENS (WHITE ICONS)
// This constant ensures the status bar icons (time, battery, wifi) are white.
const SystemUiOverlayStyle darkSystemOverlay = SystemUiOverlayStyle(
  // Make status bar background transparent (or a dark color)
  statusBarColor: Colors.transparent,

  // *** THIS IS THE CRUCIAL LINE for Android/General ***
  // Brightness.light makes the icons/text white for visibility against a dark background.
  statusBarIconBrightness: Brightness.light,

  // *** THIS IS THE CRUCIAL LINE for iOS ***
  // Brightness.dark tells iOS the background is dark, so it should use light foreground elements.
  statusBarBrightness: Brightness.dark,

  // Optional: Ensure navigation bar (Android bottom bar) icons are also light if visible
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.black,
);

// Stub for Firebase Messaging background handler (to prevent errors if Firebase tries to initialize)
@pragma('vm:entry-point')
void _firebaseMessagingBackgroundHandler(dynamic message) async {
  // This is a stub to prevent Firebase initialization errors
  // Firebase is not currently used in this app
}

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Remove SystemChrome.setSystemUIOverlayStyle from here,
  // as it's less reliable than using AnnotatedRegion in the widget tree.

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize services
  await initServices();

  runApp(const GetRightApp());
}

/// Initialize all required services
Future<void> initServices() async {
  // Initialize StorageService
  final storageService = await StorageService.getInstance();
  Get.put(storageService);

  // Initialize AuthController
  Get.put(AuthController(storageService));
}

class GetRightApp extends StatelessWidget {
  const GetRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. WRAP the entire app in AnnotatedRegion
    // This ensures the style is applied consistently across all screens
    // unless explicitly overridden by a deeper AnnotatedRegion or AppBar.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: darkSystemOverlay,
      child: GetMaterialApp(
        title: 'Get Right',
        debugShowCheckedModeBanner: false,

        // Apply App Theme with Google Fonts fallback for Inter
        theme: AppTheme.lightTheme.copyWith(textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme)),

        // GetX Routing
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,

        // Default transition
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
