import 'package:flutter/material.dart';
import 'package:get_right/widgets/common/empty_state.dart';

/// Planner screen - workout plans and schedules
class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books_outlined),
            onPressed: () {
              // TODO: Show templates
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.calendar_today,
        title: 'No Plans Yet',
        subtitle: 'Create your first workout plan or choose from our templates!',
        buttonText: 'Create Plan',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create plan
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
