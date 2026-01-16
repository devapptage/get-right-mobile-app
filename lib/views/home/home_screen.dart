import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/views/home/dashboard_screen.dart';
import 'package:get_right/views/journal/combined_journal_screen.dart';
import 'package:get_right/views/feed/feed_screen.dart';
import 'package:get_right/views/marketplace/marketplace_screen.dart';
import 'package:get_right/views/library/library_screen.dart';
import 'package:get_right/views/nutrition/nutrition_screen.dart';
import 'package:get_right/widgets/common/app_drawer.dart';

/// Home screen with bottom navigation - 5 tabs
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeNavigationController _navController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = const [
    MarketplaceScreen(), // Marketplace
    FeedScreen(), // Community Feed
    CombinedJournalScreen(), // Journal (Center - Workout Journal + Runner Log)
    LibraryScreen(), // Library
    NutritionScreen(), // Home
  ];

  @override
  void initState() {
    super.initState();
    // Initialize navigation controller
    _navController = Get.put(HomeNavigationController());
    // Store scaffold key in controller for global access
    _navController.scaffoldKey = _scaffoldKey;
    // Initialize notification controller
    Get.put(NotificationController());

    // Check if we should redirect based on preference from auth questionnaire or navigateToTab argument
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      
      // Check for navigateToTab argument (used from favorites screen)
      final navigateToTab = args?['navigateToTab'] as int?;
      if (navigateToTab != null) {
        _navController.changeTab(navigateToTab);
        return;
      }
      
      // Check for preference argument
      final preference = args?['preference'] as String?;
      if (preference != null) {
        // Navigate to journal tab (index 2)
        // Set journal tab index: 0 for Strength Training (Workout Journal), 1 for Running & Cardio (Runner Log)
        final journalTabIndex = preference == 'Strength Training' ? 0 : 1;
        _navController.changeTab(2, journalTab: journalTabIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(), // Professional app drawer
          body: IndexedStack(index: _navController.currentIndex, children: _screens),
          bottomNavigationBar: _buildProfessionalBottomNav(),
        ),
      ),
    );
  }

  /// Modern 2024/2025 bottom navigation bar with liquid glass effect
  Widget _buildProfessionalBottomNav() {
    final navItems = [
      // {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.storefront_outlined, 'activeIcon': Icons.storefront_rounded, 'label': 'Market'},
      {'icon': Icons.explore_outlined, 'activeIcon': Icons.explore_rounded, 'label': 'Feed'},
      {'icon': Icons.add_circle_outline, 'activeIcon': Icons.add_circle, 'label': 'Journal'},
      {'icon': Icons.menu_book_outlined, 'activeIcon': Icons.menu_book_rounded, 'label': 'Library'},
      {'icon': Icons.restaurant_menu_outlined, 'activeIcon': Icons.restaurant_menu_rounded, 'label': 'Nutrition'},
    ];

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5).withOpacity(0.8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, -8))],
          ),
          child: SafeArea(
            top: false,
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) {
                  final isCenter = index == 2;
                  return _buildNavItem(
                    icon: navItems[index]['icon'] as IconData,
                    activeIcon: navItems[index]['activeIcon'] as IconData,
                    label: navItems[index]['label'] as String,
                    index: index,
                    isSelected: _navController.currentIndex == index,
                    isCenter: isCenter,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Modern navigation item
  Widget _buildNavItem({required IconData icon, required IconData activeIcon, required String label, required int index, required bool isSelected, bool isCenter = false}) {
    const greenAccent = Color(0xFF29603C);
    const blackPrimary = Color(0xFF000000);
    const textSecondary = Color(0xFF404040);

    return Expanded(
      child: GestureDetector(
        onTap: () => _navController.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: isCenter ? 48 : (isSelected ? 40 : 34),
                height: isCenter ? 48 : (isSelected ? 40 : 34),
                decoration: BoxDecoration(
                  color: isCenter
                      ? greenAccent
                      : isSelected
                      ? greenAccent.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(isCenter ? 26 : 22),
                  boxShadow: isCenter ? [BoxShadow(color: greenAccent.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))] : null,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      key: ValueKey('$index-$isSelected'),
                      color: isCenter
                          ? Colors.white
                          : isSelected
                          ? greenAccent
                          : textSecondary,
                      size: isCenter ? 24 : 20,
                    ),
                  ),
                ),
              ),
              // Label (hidden for center item)
              if (!isCenter) ...[
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? blackPrimary : textSecondary,
                    letterSpacing: 0.2,
                    height: 1.0,
                  ),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<HomeNavigationController>();
    super.dispose();
  }
}
