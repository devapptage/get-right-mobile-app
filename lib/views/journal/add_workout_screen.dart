import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/utils/validators.dart';
import 'package:get_right/widgets/common/custom_button.dart';
import 'package:get_right/widgets/common/custom_text_field.dart';

/// Add workout screen
class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final List<String> _selectedTags = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save workout
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Workout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise name
              CustomTextField(
                controller: _exerciseController,
                labelText: 'Exercise Name',
                hintText: 'e.g., Bench Press',
                validator: (value) => Validators.validateRequired(value, 'Exercise name'),
              ),
              const SizedBox(height: 16),

              // Sets, Reps, Weight
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _setsController,
                      labelText: 'Sets',
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validatePositiveNumber(value, fieldName: 'Sets'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _repsController,
                      labelText: 'Reps',
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validatePositiveNumber(value, fieldName: 'Reps'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(controller: _weightController, labelText: 'Weight (kg)', keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date
              CustomTextField(
                labelText: 'Date',
                hintText: 'Select date',
                readOnly: true,
                onTap: _selectDate,
                controller: TextEditingController(text: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              const SizedBox(height: 16),

              // Tags - White on black
              Text('Tags', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.workoutTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    selectedColor: AppColors.secondary, // Green (secondary) when selected
                    labelStyle: TextStyle(color: isSelected ? AppColors.onSecondary : AppColors.onBackground), // White on green, white otherwise
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Notes
              CustomTextField(controller: _notesController, labelText: 'Notes (Optional)', hintText: 'Add any additional notes', maxLines: 3),
              const SizedBox(height: 16),

              // Add photo button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Add photo
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Add Progress Photo'),
              ),
              const SizedBox(height: 32),

              // Save button
              CustomButton(text: 'Save Workout', onPressed: _saveWorkout),
            ],
          ),
        ),
      ),
    );
  }
}
