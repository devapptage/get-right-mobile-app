import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/models/workout_exercise_model.dart';
import 'package:get_right/models/exercise_set_model.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class WorkoutTimerScreen extends StatefulWidget {
  const WorkoutTimerScreen({super.key});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  Timer? _timer;
  int _currentSeconds = 0;
  int _initialSeconds = 0;
  bool _isRunning = false;
  WorkoutExerciseModel? _exercise;
  List<ExerciseSetModel> _timedSets = [];
  int _currentSetIndex = 0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['exercise'] != null) {
      _exercise = args['exercise'] as WorkoutExerciseModel;
      _timedSets = _exercise!.timedSets;
      if (_timedSets.isNotEmpty) {
        _currentSeconds = _timedSets[0].timeSeconds!;
        _initialSeconds = _currentSeconds;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_currentSeconds <= 0) _currentSeconds = _initialSeconds;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() => _currentSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _showCompletionDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentSeconds = _initialSeconds;
      _isRunning = false;
    });
  }

  void _showCompletionDialog() {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: AppColors.accent, size: 48)),
            const SizedBox(height: 20),
            Text('Time\'s Up!', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Set ${_currentSetIndex + 1} completed', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () { Get.back(); _nextSet(); }, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: AppColors.primaryGray, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Next Set', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.onBackground)))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () { Get.back(); Get.back(); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Done', style: AppTextStyles.buttonMedium))),
            ]),
          ],
        ),
      ),
    ));
  }

  void _nextSet() {
    if (_currentSetIndex < _timedSets.length - 1) {
      setState(() {
        _currentSetIndex++;
        _currentSeconds = _timedSets[_currentSetIndex].timeSeconds!;
        _initialSeconds = _currentSeconds;
      });
    } else {
      Get.back();
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_exercise == null || _timedSets.isEmpty) {
      return Scaffold(appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: AppColors.onBackground, title: Text('Timer', style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent))), body: Center(child: Text('No timed sets available', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground))));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.onBackground), onPressed: () => Get.back()), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Timer', style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent)), Text(_exercise!.exerciseName, style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold))])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accent, width: 3)), child: Center(child: Text(_formatTime(_currentSeconds), style: const TextStyle(fontFamily: 'Inter', fontSize: 56, fontWeight: FontWeight.bold, color: AppColors.accent)))),
            const SizedBox(height: 24),
            Text('Starting from: ${_formatTime(_initialSeconds)}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark)),
            if (_timedSets.length > 1) ...[const SizedBox(height: 16), Text('Set ${_currentSetIndex + 1} of ${_timedSets.length}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGrayDark))],
            const SizedBox(height: 40),
            if (!_isRunning) SizedBox(width: 200, height: 56, child: ElevatedButton.icon(onPressed: _startTimer, icon: const Icon(Icons.play_arrow, size: 24), label: Text('Start', style: AppTextStyles.buttonLarge), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))))
            else Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(width: 100, height: 56, child: OutlinedButton.icon(onPressed: _pauseTimer, icon: const Icon(Icons.pause, size: 24), label: const Text('Pause'), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accent, width: 2), foregroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
              const SizedBox(width: 12),
              SizedBox(width: 100, height: 56, child: OutlinedButton.icon(onPressed: _resetTimer, icon: const Icon(Icons.refresh, size: 24), label: const Text('Reset'), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryGray, width: 2), foregroundColor: AppColors.onBackground, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
            ]),
          ],
        ),
      ),
    );
  }
}

