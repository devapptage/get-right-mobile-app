import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});
  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final TextEditingController _notesController = TextEditingController();
  String _exerciseName = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _exerciseName = args['exerciseName'] ?? '';
      _notesController.text = args['existingNotes'] ?? '';
    }
  }

  @override
  void dispose() { _notesController.dispose(); super.dispose(); }

  void _onSave() => Get.back(result: {'notes': _notesController.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.accent, size: 20), onPressed: () => Get.back()), title: Text('Notes', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)), centerTitle: true, actions: [TextButton(onPressed: _onSave, child: Text('Save', style: AppTextStyles.labelMedium.copyWith(color: Colors.blue)))]),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Exercise: $_exerciseName', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground)),
        const SizedBox(height: 16),
        Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: TextField(controller: _notesController, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, decoration: InputDecoration(hintText: 'Add your notes here...', hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGrayDark), border: InputBorder.none), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)))),
      ])),
    );
  }
}

