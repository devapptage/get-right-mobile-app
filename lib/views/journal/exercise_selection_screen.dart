import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/models/exercise_library_model.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  const ExerciseSelectionScreen({super.key});
  @override
  State<ExerciseSelectionScreen> createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isWarmup = false;
  List<ExerciseLibraryModel> _filtered = ExerciseLibraryData.exercises;
  final Set<ExerciseLibraryModel> _selected = {};
  bool _isSuperset = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) _isWarmup = args['isWarmup'] ?? false;
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() => _filtered = ExerciseLibraryData.exercises.where((e) => e.name.toLowerCase().contains(q) || e.primaryMuscle.toLowerCase().contains(q)).toList());
  }

  void _toggleSelect(ExerciseLibraryModel ex) {
    setState(() {
      if (_selected.contains(ex))
        _selected.remove(ex);
      else if (_isSuperset && _selected.length < 2)
        _selected.add(ex);
      else if (!_isSuperset) {
        _selected.clear();
        _selected.add(ex);
      }
    });
  }

  void _onContinue() {
    if (_selected.isEmpty) {
      Get.snackbar('Select Exercise', 'Please select at least one exercise', backgroundColor: AppColors.error, colorText: AppColors.onError);
      return;
    }
    if (_isSuperset && _selected.length != 2) {
      Get.snackbar('Superset', 'Select exactly 2 exercises for superset', backgroundColor: AppColors.error, colorText: AppColors.onError);
      return;
    }
    Get.toNamed(
      AppRoutes.exerciseConfiguration,
      arguments: {
        'isWarmup': _isWarmup,
        'isSuperset': _isSuperset,
        'exercise': _selected.length == 1 ? _selected.first : null,
        'exercises': _isSuperset ? _selected.toList() : null,
      },
    )?.then((r) {
      if (r != null) Get.back(result: r);
    });
  }

  void _onManual() => Get.toNamed(AppRoutes.exerciseConfiguration, arguments: {'isWarmup': _isWarmup, 'isManual': true})?.then((r) {
    if (r != null) Get.back(result: r);
  });

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
        title: Text('Select Exercise', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGrayDark),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface),
            ),
          ),
          if (!_isWarmup)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Checkbox(
                    value: _isSuperset,
                    onChanged: (v) => setState(() {
                      _isSuperset = v ?? false;
                      if (!_isSuperset && _selected.length > 1) {
                        final first = _selected.first;
                        _selected.clear();
                        _selected.add(first);
                      }
                    }),
                    activeColor: AppColors.accent,
                  ),
                  Text('Create Superset (select 2)', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onBackground)),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final ex = _filtered[i];
                final sel = _selected.contains(ex);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: sel ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: sel ? AppColors.accent : Colors.transparent, width: 2),
                  ),
                  child: InkWell(
                    onTap: () => _toggleSelect(ex),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          if (sel)
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: AppColors.onAccent, size: 16),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.name,
                                  style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(ex.primaryMuscle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGrayDark)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: AppColors.primaryGrayDark),
                            onPressed: () => Get.toNamed(AppRoutes.exerciseLibraryDetail, arguments: {'exercise': ex}),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryGray),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _selected.isNotEmpty ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        disabledBackgroundColor: AppColors.primaryGrayLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _isSuperset && _selected.length == 2
                            ? 'Configure Superset'
                            : _selected.isNotEmpty
                            ? 'Configure ${_selected.first.name}'
                            : 'Select an Exercise',
                        style: AppTextStyles.buttonMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _onManual,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onBackground,
                        side: const BorderSide(color: AppColors.primaryGray, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Couldn't find Exercise?", style: AppTextStyles.buttonMedium.copyWith(color: AppColors.onBackground)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
