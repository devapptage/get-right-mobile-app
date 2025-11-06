import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Tracker screen - progress tracking and run history
class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Calendar', icon: Icon(Icons.calendar_month)),
              Tab(text: 'Runs', icon: Icon(Icons.directions_run)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Calendar view
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, size: 100, color: AppColors.primaryGray),
                  const SizedBox(height: 16),
                  Text('Calendar View Coming Soon', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground)),
                ],
              ),
            ),

            // Run tracking
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_run, size: 100, color: AppColors.primaryGray),
                  const SizedBox(height: 16),
                  Text('No Runs Yet', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onBackground)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Start run tracking
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Run'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
