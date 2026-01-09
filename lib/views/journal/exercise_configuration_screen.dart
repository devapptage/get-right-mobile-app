import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/models/exercise_library_model.dart';
import 'package:get_right/models/exercise_set_model.dart';
import 'package:get_right/models/workout_exercise_model.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class ExerciseConfigurationScreen extends StatefulWidget {
  const ExerciseConfigurationScreen({super.key});
  @override
  State<ExerciseConfigurationScreen> createState() => _ExerciseConfigurationScreenState();
}

class _ExerciseConfigurationScreenState extends State<ExerciseConfigurationScreen> {
  bool _isWarmup = false;
  bool _isManual = false;
  bool _isSuperset = false;
  final TextEditingController _nameController = TextEditingController();
  List<_Config> _configs = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isWarmup = args['isWarmup'] ?? false;
      _isManual = args['isManual'] ?? false;
      _isSuperset = args['isSuperset'] ?? false;
      if (_isSuperset && args['exercises'] != null) {
        for (var ex in args['exercises'] as List<ExerciseLibraryModel>) _configs.add(_Config(name: ex.name, id: ex.id));
      } else if (args['exercise'] != null) {
        final ex = args['exercise'] as ExerciseLibraryModel;
        _configs.add(_Config(name: ex.name, id: ex.id));
      } else if (_isManual) {
        _configs.add(_Config(name: '', id: 'manual_${DateTime.now().millisecondsSinceEpoch}'));
      }
    }
    if (_configs.isEmpty) _configs.add(_Config(name: '', id: 'manual_${DateTime.now().millisecondsSinceEpoch}'));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    final List<WorkoutExerciseModel> exercises = [];
    final now = DateTime.now();
    for (var cfg in _configs) {
      final name = cfg.name.isNotEmpty ? cfg.name : _nameController.text;
      if (name.isEmpty) {
        Get.snackbar('Error', 'Please enter exercise name', backgroundColor: AppColors.error, colorText: AppColors.onError);
        return;
      }
      final sets = cfg.sets.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return ExerciseSetModel(
          id: 'set_${i + 1}_${now.millisecondsSinceEpoch}',
          setNumber: i + 1,
          reps: cfg.type != 'Time' ? s.reps : null,
          repsType: 'standard',
          timeSeconds: cfg.type == 'Time' ? s.time : null,
          weight: cfg.type != 'Time' ? s.weight : null,
          weightType: s.weight == 0 ? 'BW' : 'standard',
        );
      }).toList();
      exercises.add(
        WorkoutExerciseModel(
          id: 'ex_${now.millisecondsSinceEpoch}_${exercises.length}',
          exerciseName: name,
          exerciseId: cfg.id,
          sets: sets,
          isSuperset: _isSuperset,
          supersetId: _isSuperset ? 'ss_${now.millisecondsSinceEpoch}' : null,
          supersetOrder: _isSuperset ? exercises.length : null,
          date: now,
          createdAt: now,
        ),
      );
    }
    Get.back(result: {'exercises': exercises, 'isWarmup': _isWarmup});
  }

  void _showPercentageCalc(int cfgIdx, int setIdx) {
    const double pr = 315.0;
    double pct = 75.0;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 8,
        child: StatefulBuilder(
          builder: (ctx, setDlg) {
            final calc = (pr * pct / 100).round();
            return Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.1)]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.calculate_rounded, color: AppColors.accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Percentage Calculator',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close_rounded, color: AppColors.primaryGrayDark),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent.withOpacity(0.1), AppColors.accent.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PERSONAL RECORD',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark, fontWeight: FontWeight.w700, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bench Press',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pr.toInt()} lbs',
                          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'SELECT PERCENTAGE',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [50, 60, 70, 75, 80, 85, 90, 95]
                        .map(
                          (p) => GestureDetector(
                            onTap: () => setDlg(() => pct = p.toDouble()),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: pct == p ? LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.85)]) : null,
                                color: pct == p ? null : AppColors.primaryGrayLight.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: pct == p ? AppColors.accent : AppColors.primaryGrayLight.withOpacity(0.5), width: 1.5),
                                boxShadow: pct == p ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
                              ),
                              child: Text(
                                '$p%',
                                style: AppTextStyles.labelLarge.copyWith(color: pct == p ? AppColors.onAccent : AppColors.onSurface, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.trending_up_rounded, color: AppColors.accent, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '≈ $calc lbs',
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _configs[cfgIdx].sets[setIdx].weight = calc.toDouble());
                        Get.back();
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 22),
                      label: Text('Apply to Set ${setIdx + 1}', style: AppTextStyles.buttonMedium),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        elevation: 2,
                        shadowColor: AppColors.accent.withOpacity(0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent, size: 18),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Configure Exercise',
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                children: _configs
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: e.key < _configs.length - 1 ? 20 : 0),
                        child: _buildCard(e.value, e.key),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -4), spreadRadius: 0)],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.check_circle_rounded, size: 24),
                  label: Text('Save Exercise', style: AppTextStyles.buttonLarge.copyWith(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    elevation: 4,
                    shadowColor: AppColors.accent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(_Config cfg, int idx) {
    final isMan = cfg.name.isEmpty;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: 0),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2), spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fitness_center_rounded, color: AppColors.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isMan
                    ? TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter exercise name',
                          hintStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGrayDark.withOpacity(0.6)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                      )
                    : Text(
                        cfg.name,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.primaryGrayLight.withOpacity(0.3), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: ['Reps', 'Time', 'Weight', 'Distance'].map((t) {
                final sel = cfg.type == t;
                final icons = {'Reps': Icons.repeat_rounded, 'Time': Icons.timer_outlined, 'Weight': Icons.fitness_center, 'Distance': Icons.straighten_rounded};
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => cfg.type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        gradient: sel ? LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.85)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                        color: sel ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: sel ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icons[t], size: 18, color: sel ? AppColors.onAccent : AppColors.onSurface.withOpacity(0.6)),
                          const SizedBox(height: 4),
                          Text(
                            t,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: sel ? AppColors.onAccent : AppColors.onSurface.withOpacity(0.8),
                              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'SET',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    (cfg.type == 'Time' ? 'TIME (s)' : 'REPS').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                ),
                if (cfg.type == 'Weight' || cfg.type == 'Reps')
                  Expanded(
                    flex: 2,
                    child: Text(
                      'WEIGHT (lbs)'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...cfg.sets.asMap().entries.map((e) => _buildSetRow(cfg, idx, e.key, e.value)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: cfg.sets.length > 1 ? () => setState(() => cfg.sets.removeLast()) : null,
                  icon: const Icon(Icons.remove_rounded, size: 20),
                  label: Text('Remove Set', style: AppTextStyles.buttonMedium),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cfg.sets.length > 1 ? Colors.red.shade400 : Colors.grey.shade300,
                    foregroundColor: cfg.sets.length > 1 ? Colors.white : Colors.grey.shade500,
                    elevation: cfg.sets.length > 1 ? 2 : 0,
                    shadowColor: Colors.red.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => cfg.sets.add(_SetData())),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text('Add Set', style: AppTextStyles.buttonMedium),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    elevation: 2,
                    shadowColor: AppColors.accent.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(_Config cfg, int cfgIdx, int setIdx, _SetData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.15)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${setIdx + 1}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGrayLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGrayLight.withOpacity(0.4), width: 1),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: cfg.type == 'Time' ? '30' : '10',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark.withOpacity(0.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                onChanged: (v) {
                  final n = int.tryParse(v) ?? 0;
                  setState(() {
                    if (cfg.type == 'Time')
                      data.time = n;
                    else
                      data.reps = n;
                  });
                },
              ),
            ),
          ),
          if (cfg.type == 'Weight' || cfg.type == 'Reps') ...[
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGrayLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGrayLight.withOpacity(0.4), width: 1),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                        onChanged: (v) => setState(() => data.weight = double.tryParse(v) ?? 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showPercentageCalc(cfgIdx, setIdx),
                    child: Container(
                      width: 44,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.accent.withOpacity(0.15), AppColors.accent.withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '%',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Config {
  String name, id, type;
  List<_SetData> sets;
  _Config({required this.name, required this.id, this.type = 'Reps'}) : sets = [_SetData(), _SetData(), _SetData()];
}

class _SetData {
  int reps, time;
  double weight;
  _SetData({this.reps = 10, this.time = 0, this.weight = 0});
}
