import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/views/home/dashboard_screen.dart';
import 'package:get_right/views/journal/combined_journal_screen.dart';
import 'package:get_right/views/planner/planner_screen.dart';
import 'package:get_right/views/marketplace/marketplace_screen.dart';
import 'package:get_right/views/library/library_screen.dart';
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
    DashboardScreen(), // Home
    PlannerScreen(), // Planner
    CombinedJournalScreen(), // Journal (Center - Workout Journal + Runner Log)
    MarketplaceScreen(), // Marketplace
    LibraryScreen(), // Library
  ];

  @override
  void initState() {
    super.initState();
    // Initialize navigation controller
    _navController = Get.put(HomeNavigationController());
    // Store scaffold key in controller for global access
    _navController.scaffoldKey = _scaffoldKey;
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

  /// Professional custom bottom navigation bar
  Widget _buildProfessionalBottomNav() {
    final navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.calendar_today_outlined, 'activeIcon': Icons.calendar_today_rounded, 'label': 'Planner'},
      {'icon': Icons.fitness_center_outlined, 'activeIcon': Icons.fitness_center_rounded, 'label': 'Journal'},
      {'icon': Icons.store_outlined, 'activeIcon': Icons.store_rounded, 'label': 'Market'},
      {'icon': Icons.library_books_outlined, 'activeIcon': Icons.library_books_rounded, 'label': 'Library'},
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryVariant, AppColors.primary]),
        border: Border(top: BorderSide(color: AppColors.accent.withOpacity(0.1), width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 16, spreadRadius: 0, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) => _buildNavItem(
                icon: navItems[index]['icon'] as IconData,
                activeIcon: navItems[index]['activeIcon'] as IconData,
                label: navItems[index]['label'] as String,
                index: index,
                isSelected: _navController.currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Individual navigation item with animation
  Widget _buildNavItem({required IconData icon, required IconData activeIcon, required String label, required int index, required bool isSelected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _navController.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                // Icon with animated container and glow effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect for selected item
                    if (isSelected)
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, spreadRadius: 0)],
                        ),
                      ),
                    // Icon container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: isSelected ? Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 1) : null,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Icon(
                            isSelected ? activeIcon : icon,
                            key: ValueKey(isSelected),
                            color: isSelected ? AppColors.white : AppColors.primaryGray,
                            size: isSelected ? 23 : 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // Label with enhanced animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: isSelected ? 11 : 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.primaryGray,
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
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
