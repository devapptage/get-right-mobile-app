import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_right/theme/app_theme.dart';
import 'package:get_right/routes/app_pages.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system overlay style
  SystemChrome.setSystemUIOverlayStyle(AppTheme.lightSystemOverlay);

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const GetRightApp());
}

class GetRightApp extends StatelessWidget {
  const GetRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
    );
  }
}
