import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/widgets/common/empty_state.dart';

/// Journal screen - workout logs
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.fitness_center,
        title: 'No Workouts Yet',
        subtitle: 'Start tracking your fitness journey by adding your first workout!',
        buttonText: 'Add Workout',
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Get.toNamed(AppRoutes.addWorkout), child: const Icon(Icons.add)),
    );
  }
}
