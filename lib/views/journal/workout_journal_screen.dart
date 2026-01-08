import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_right/models/workout_journal_model.dart';
import 'package:get_right/models/workout_exercise_model.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/widgets/journal/exercise_card.dart';
import 'package:get_right/widgets/journal/superset_card.dart';
import 'package:get_right/views/journal/workout_celebration_screen.dart';

class WorkoutJournalScreen extends StatefulWidget {
  final bool isEmbedded;
  const WorkoutJournalScreen({super.key, this.isEmbedded = false});

  @override
  State<WorkoutJournalScreen> createState() => _WorkoutJournalScreenState();
}

class _WorkoutJournalScreenState extends State<WorkoutJournalScreen> {
  WorkoutJournalModel? _workout;
  bool _isLoading = true;
  bool _isStarted = false;
  bool _isPaused = false;
  Timer? _timer;
  int _seconds = 0;
  int _calories = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _load() {
    setState(() {
      _isLoading = false;
      _workout = WorkoutJournalModel(
        id: 'w_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_1',
        date: DateTime.now(),
        warmupExercises: [],
        workoutExercises: [],
        createdAt: DateTime.now(),
      );
    });
  }

  void _startWorkout() {
    setState(() {
      _isStarted = true;
      _isPaused = false;
      _startTime = DateTime.now();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isPaused) {
        setState(() {
          _seconds++;
          _calories = (_seconds / 60 * 5).round();
        });
      }
    });
  }

  void _pauseWorkout() {
    setState(() => _isPaused = true);
  }

  void _resumeWorkout() {
    setState(() => _isPaused = false);
  }

  void _stopWorkout() {
    _timer?.cancel();

    // Calculate average heart rate

    // Update workout model with completion data
    if (_workout != null && _startTime != null) {
      _workout = _workout!.copyWith(startedAt: _startTime, completedAt: DateTime.now(), durationSeconds: _seconds, caloriesBurned: _calories);
    }

    setState(() {
      _isStarted = false;
      _isPaused = false;
    });

    // Show full-screen celebration view
    Get.to(
      () => WorkoutCelebrationScreen(duration: _formatTime(_seconds), calories: _calories, workoutName: _getWorkoutName()),
      transition: Transition.zoom,
      duration: const Duration(milliseconds: 500),
    )?.then((_) {
      // Reset workout stats after closing celebration
      setState(() {
        _seconds = 0;
        _calories = 0;
        _startTime = null;
      });
    });
  }

  String _getWorkoutName() {
    if (_workout == null) return 'Workout';
    final exerciseCount = _workout!.warmupExercises.length + _workout!.workoutExercises.length;
    return '$exerciseCount Exercise${exerciseCount != 1 ? 's' : ''}';
  }

  Widget _buildStatBadge({required IconData icon, required String value, required String label}) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, color: AppColors.accent, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark)),
      ],
    );
  }

  String _formatTime(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  void _onAddWarmup() => Get.toNamed(AppRoutes.exerciseSelection, arguments: {'isWarmup': true})?.then((r) {
    if (r != null && r['exercises'] != null)
      setState(() => _workout = _workout!.copyWith(warmupExercises: [..._workout!.warmupExercises, ...r['exercises'] as List<WorkoutExerciseModel>]));
  });
  void _onAddWorkout() => Get.toNamed(AppRoutes.exerciseSelection, arguments: {'isWarmup': false})?.then((r) {
    if (r != null && r['exercises'] != null)
      setState(() => _workout = _workout!.copyWith(workoutExercises: [..._workout!.workoutExercises, ...r['exercises'] as List<WorkoutExerciseModel>]));
  });
  void _onAddExercise() => Get.toNamed(AppRoutes.addExercise);

  @override
  Widget build(BuildContext context) {
    if (widget.isEmbedded) {
      // When embedded in combined screen, no AppBar or Scaffold needed
      return Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Actions bar
            _workout == null || _workout!.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                            child: const Icon(Icons.add, color: AppColors.onAccent, size: 20),
                          ),
                          onPressed: _onAddExercise,
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: AppColors.accent))
                  : _workout == null || _workout!.isEmpty
                  ? _buildEmpty()
                  : _buildContent(),
            ),
          ],
        ),
      );
    }

    // Standalone screen with full scaffold
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.accent),
          onPressed: () {},
        ),
        title: Text(
          'Workout Journal',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.accent),
            onPressed: () => Get.toNamed(AppRoutes.calendar),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: AppColors.onAccent, size: 20),
            ),
            onPressed: _onAddExercise,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _workout == null || _workout!.isEmpty
          ? _buildEmpty()
          : _buildContent(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _onAddWarmup,
                icon: const Icon(Icons.whatshot_outlined, size: 22),
                label: Text('Add Warmup Exercise', style: AppTextStyles.buttonMedium),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _onAddWorkout,
                icon: const Icon(Icons.fitness_center, size: 22),
                label: Text('Add Workout Exercise', style: AppTextStyles.buttonMedium),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isStarted) _buildMetrics(),
          if (!_isStarted && !_workout!.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _startWorkout,
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: AppColors.onAccent, shape: BoxShape.circle),
                    child: Icon(Icons.play_arrow, color: AppColors.accent, size: 18),
                  ),
                  label: Text('Start Workout', style: AppTextStyles.buttonLarge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          if (_workout!.warmupExercises.isNotEmpty) ...[_buildHeader('Warmup', Icons.local_fire_department), ..._buildExercisesList(_workout!.warmupExercises, true)],
          if (_workout!.workoutExercises.isNotEmpty) ...[_buildHeader('Workout', Icons.fitness_center), ..._buildExercisesList(_workout!.workoutExercises, false)],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          GestureDetector(
            onTap: _stopWorkout,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Icon(Icons.stop, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isPaused ? _resumeWorkout : _pauseWorkout,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: _isPaused ? AppColors.accent : Colors.orange, shape: BoxShape.circle),
              child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primaryGrayLight.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, color: AppColors.accent, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(_seconds),
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 20, color: AppColors.primaryGrayLight),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_calories',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  /// Build exercises list with superset grouping support
  List<Widget> _buildExercisesList(List<WorkoutExerciseModel> exercises, bool isWarmup) {
    final List<Widget> widgets = [];
    final Set<String> processedSupersets = {};

    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];

      // Check if this exercise is part of a superset
      if (exercise.isSuperset && exercise.supersetId != null) {
        // Skip if we've already processed this superset
        if (processedSupersets.contains(exercise.supersetId)) {
          continue;
        }

        // Find the other exercise in the superset
        final otherExercise = exercises.firstWhereOrNull((e) => e.isSuperset && e.supersetId == exercise.supersetId && e.id != exercise.id);

        if (otherExercise != null) {
          // Add superset card
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SupersetCard(
                exercise1: exercise.supersetOrder == 0 ? exercise : otherExercise,
                exercise2: exercise.supersetOrder == 0 ? otherExercise : exercise,
                onInfoTap1: () {},
                onInfoTap2: () {},
                onMenuTap1: () => _showMenu(exercise.supersetOrder == 0 ? exercise : otherExercise, isWarmup),
                onMenuTap2: () => _showMenu(exercise.supersetOrder == 0 ? otherExercise : exercise, isWarmup),
                onTimerTap1: () {
                  final ex1 = exercise.supersetOrder == 0 ? exercise : otherExercise;
                  if (ex1.hasTimedSets) {
                    Get.toNamed(AppRoutes.workoutTimer, arguments: {'exercise': ex1});
                  }
                },
                onTimerTap2: () {
                  final ex2 = exercise.supersetOrder == 0 ? otherExercise : exercise;
                  if (ex2.hasTimedSets) {
                    Get.toNamed(AppRoutes.workoutTimer, arguments: {'exercise': ex2});
                  }
                },
              ),
            ),
          );
          processedSupersets.add(exercise.supersetId!);
        } else {
          // Superset partner not found, display as regular exercise
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExerciseCard(
                exercise: exercise,
                onInfoTap: () {},
                onMenuTap: () => _showMenu(exercise, isWarmup),
                onTimerTap: () {
                  if (exercise.hasTimedSets) {
                    Get.toNamed(AppRoutes.workoutTimer, arguments: {'exercise': exercise});
                  }
                },
              ),
            ),
          );
        }
      } else {
        // Regular exercise (not a superset)
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExerciseCard(
              exercise: exercise,
              onInfoTap: () {},
              onMenuTap: () => _showMenu(exercise, isWarmup),
              onTimerTap: () {
                if (exercise.hasTimedSets) {
                  Get.toNamed(AppRoutes.workoutTimer, arguments: {'exercise': exercise});
                }
              },
            ),
          ),
        );
      }
    }

    return widgets;
  }

  void _showMenu(WorkoutExerciseModel ex, bool isWarmup) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.primaryGray, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.exerciseConfiguration, arguments: {'isEditing': true, 'existingExercise': ex, 'isWarmup': isWarmup});
                },
                title: Center(
                  child: Text(
                    'Edit',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.videoWalkthrough, arguments: {'exerciseName': ex.exerciseName});
                },
                title: Center(
                  child: Text(
                    'Video Walkthrough',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  setState(() {
                    if (isWarmup)
                      _workout = _workout!.copyWith(warmupExercises: _workout!.warmupExercises.where((e) => e.id != ex.id).toList());
                    else
                      _workout = _workout!.copyWith(workoutExercises: _workout!.workoutExercises.where((e) => e.id != ex.id).toList());
                  });
                },
                title: Center(
                  child: Text(
                    'Delete',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.reorderExercises, arguments: {'exercises': isWarmup ? _workout!.warmupExercises : _workout!.workoutExercises})?.then((r) {
                    if (r != null && r['exercises'] != null)
                      setState(() {
                        if (isWarmup)
                          _workout = _workout!.copyWith(warmupExercises: r['exercises'] as List<WorkoutExerciseModel>);
                        else
                          _workout = _workout!.copyWith(workoutExercises: r['exercises'] as List<WorkoutExerciseModel>);
                      });
                  });
                },
                title: Center(
                  child: Text(
                    'Move/Reorder',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.addNotes, arguments: {'exerciseName': ex.exerciseName, 'existingNotes': ex.notes})?.then((r) {
                    if (r != null && r['notes'] != null)
                      setState(() {
                        if (isWarmup) {
                          final idx = _workout!.warmupExercises.indexWhere((e) => e.id == ex.id);
                          if (idx != -1) {
                            final l = List<WorkoutExerciseModel>.from(_workout!.warmupExercises);
                            l[idx] = ex.copyWith(notes: r['notes'] as String);
                            _workout = _workout!.copyWith(warmupExercises: l);
                          }
                        } else {
                          final idx = _workout!.workoutExercises.indexWhere((e) => e.id == ex.id);
                          if (idx != -1) {
                            final l = List<WorkoutExerciseModel>.from(_workout!.workoutExercises);
                            l[idx] = ex.copyWith(notes: r['notes'] as String);
                            _workout = _workout!.copyWith(workoutExercises: l);
                          }
                        }
                      });
                  });
                },
                title: Center(
                  child: Text(
                    'Add Notes',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Cancel', style: AppTextStyles.buttonMedium),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
