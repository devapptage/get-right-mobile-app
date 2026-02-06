import 'package:flutter/material.dart';
import 'package:get_right/models/workout_exercise_model.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/journal/exercise_card.dart';

/// Superset Card Widget
/// Displays two exercises grouped together as a superset
class SupersetCard extends StatelessWidget {
  final WorkoutExerciseModel exercise1;
  final WorkoutExerciseModel exercise2;
  final VoidCallback? onMenuTap1;
  final VoidCallback? onMenuTap2;
  final VoidCallback? onTimerTap1;
  final VoidCallback? onTimerTap2;

  const SupersetCard({super.key, required this.exercise1, required this.exercise2, this.onMenuTap1, this.onMenuTap2, this.onTimerTap1, this.onTimerTap2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise 1
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: ExerciseCard(exercise: exercise1, onMenuTap: onMenuTap1, onTimerTap: onTimerTap1),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppColors.accent.withOpacity(0.3), Colors.transparent])),
                  ),
                ),
              ],
            ),
          ),

          // Exercise 2
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: ExerciseCard(exercise: exercise2, onMenuTap: onMenuTap2, onTimerTap: onTimerTap2),
          ),
        ],
      ),
    );
  }
}
