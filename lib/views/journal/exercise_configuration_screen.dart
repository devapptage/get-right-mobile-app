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
  void dispose() { _nameController.dispose(); super.dispose(); }

  void _onSave() {
    final List<WorkoutExerciseModel> exercises = [];
    final now = DateTime.now();
    for (var cfg in _configs) {
      final name = cfg.name.isNotEmpty ? cfg.name : _nameController.text;
      if (name.isEmpty) { Get.snackbar('Error', 'Please enter exercise name', backgroundColor: AppColors.error, colorText: AppColors.onError); return; }
      final sets = cfg.sets.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return ExerciseSetModel(id: 'set_${i + 1}_${now.millisecondsSinceEpoch}', setNumber: i + 1, reps: cfg.type != 'Time' ? s.reps : null, repsType: 'standard', timeSeconds: cfg.type == 'Time' ? s.time : null, weight: cfg.type != 'Time' ? s.weight : null, weightType: s.weight == 0 ? 'BW' : 'standard');
      }).toList();
      exercises.add(WorkoutExerciseModel(id: 'ex_${now.millisecondsSinceEpoch}_${exercises.length}', exerciseName: name, exerciseId: cfg.id, sets: sets, isSuperset: _isSuperset, supersetId: _isSuperset ? 'ss_${now.millisecondsSinceEpoch}' : null, supersetOrder: _isSuperset ? exercises.length : null, date: now, createdAt: now));
    }
    Get.back(result: {'exercises': exercises, 'isWarmup': _isWarmup});
  }

  void _showPercentageCalc(int cfgIdx, int setIdx) {
    const double pr = 315.0;
    double pct = 75.0;
    Get.dialog(Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: StatefulBuilder(builder: (ctx, setDlg) {
      final calc = (pr * pct / 100).round();
      return Container(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Percentage Calculator', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)), TextButton(onPressed: () => Get.back(), child: Text('Done', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent)))]),
        const SizedBox(height: 24),
        Text('Personal Record', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Bench Press', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark)), const SizedBox(width: 8), Text('${pr.toInt()} lbs', style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent))]),
        const SizedBox(height: 24),
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [50, 60, 70, 75, 80, 85, 90, 95].map((p) => GestureDetector(onTap: () => setDlg(() => pct = p.toDouble()), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: pct == p ? AppColors.accent : AppColors.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: pct == p ? AppColors.accent : AppColors.primaryGrayLight)), child: Text('$p%', style: AppTextStyles.labelMedium.copyWith(color: pct == p ? AppColors.onAccent : AppColors.onSurface))))).toList()),
        const SizedBox(height: 16),
        Text('≈ $calc lbs', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() => _configs[cfgIdx].sets[setIdx].weight = calc.toDouble()); Get.back(); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)), child: Text('Apply to Set ${setIdx + 1}', style: AppTextStyles.buttonMedium))),
      ]));
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.accent, size: 20), onPressed: () => Get.back()), actions: [IconButton(icon: const Icon(Icons.check, color: AppColors.accent, size: 24), onPressed: _onSave)]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: _configs.asMap().entries.map((e) => Padding(padding: EdgeInsets.only(bottom: e.key < _configs.length - 1 ? 24 : 0), child: _buildCard(e.value, e.key))).toList())),
    );
  }

  Widget _buildCard(_Config cfg, int idx) {
    final isMan = cfg.name.isEmpty;
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: isMan ? TextField(controller: _nameController, decoration: InputDecoration(hintText: 'Exercise name', hintStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGrayDark), border: InputBorder.none), style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)) : Text(cfg.name, style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface))), const Icon(Icons.check, color: AppColors.accent, size: 20)]),
      const SizedBox(height: 16),
      Row(children: ['Reps', 'Time', 'Weight', 'Distance'].map((t) { final sel = cfg.type == t; return Expanded(child: GestureDetector(onTap: () => setState(() => cfg.type = t), child: Container(padding: const EdgeInsets.symmetric(vertical: 10), margin: const EdgeInsets.only(right: 4), decoration: BoxDecoration(color: sel ? AppColors.accent : AppColors.primaryGrayLight.withOpacity(0.5), borderRadius: BorderRadius.circular(8)), child: Center(child: Text(t, style: AppTextStyles.labelSmall.copyWith(color: sel ? AppColors.onAccent : AppColors.onSurface, fontWeight: FontWeight.w600)))))); }).toList()),
      const SizedBox(height: 20),
      Row(children: [Expanded(flex: 1, child: Text('Set', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark))), Expanded(flex: 2, child: Text(cfg.type == 'Time' ? 'Time' : 'Reps', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark))), if (cfg.type == 'Weight' || cfg.type == 'Reps') Expanded(flex: 2, child: Text('Weight', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGrayDark)))]),
      const SizedBox(height: 8),
      ...cfg.sets.asMap().entries.map((e) => _buildSetRow(cfg, idx, e.key, e.value)),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: ElevatedButton(onPressed: cfg.sets.length > 1 ? () => setState(() => cfg.sets.removeLast()) : null, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12)), child: Text('- Set', style: AppTextStyles.buttonMedium))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: () => setState(() => cfg.sets.add(_SetData())), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12)), child: Text('+ Set', style: AppTextStyles.buttonMedium)))]),
    ]));
  }

  Widget _buildSetRow(_Config cfg, int cfgIdx, int setIdx, _SetData data) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [
      Expanded(flex: 1, child: Text('${setIdx + 1}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface))),
      Expanded(flex: 2, child: Container(height: 40, decoration: BoxDecoration(color: AppColors.primaryGrayLight.withOpacity(0.3), borderRadius: BorderRadius.circular(8)), child: TextField(textAlign: TextAlign.center, keyboardType: TextInputType.number, decoration: InputDecoration(border: InputBorder.none, hintText: cfg.type == 'Time' ? '30' : '10', hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark)), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface), onChanged: (v) { final n = int.tryParse(v) ?? 0; setState(() { if (cfg.type == 'Time') data.time = n; else data.reps = n; }); }))),
      if (cfg.type == 'Weight' || cfg.type == 'Reps') ...[const SizedBox(width: 8), Expanded(flex: 2, child: Row(children: [Expanded(child: Container(height: 40, decoration: BoxDecoration(color: AppColors.primaryGrayLight.withOpacity(0.3), borderRadius: BorderRadius.circular(8)), child: TextField(textAlign: TextAlign.center, keyboardType: TextInputType.number, decoration: InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark)), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface), onChanged: (v) => setState(() => data.weight = double.tryParse(v) ?? 0)))), const SizedBox(width: 4), GestureDetector(onTap: () => _showPercentageCalc(cfgIdx, setIdx), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.accent.withOpacity(0.3))), child: Text('%', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold))))]))],
    ]));
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

