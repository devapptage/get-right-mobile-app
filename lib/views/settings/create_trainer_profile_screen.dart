// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_right/theme/color_constants.dart';
// import 'package:get_right/theme/text_styles.dart';

// /// Create Trainer Profile Screen
// class CreateTrainerProfileScreen extends StatefulWidget {
//   const CreateTrainerProfileScreen({super.key});

//   @override
//   State<CreateTrainerProfileScreen> createState() => _CreateTrainerProfileScreenState();
// }

// class _CreateTrainerProfileScreenState extends State<CreateTrainerProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _bioController = TextEditingController();
//   final _specialtiesController = TextEditingController();
//   final _experienceController = TextEditingController();
//   final _certificationController = TextEditingController();
//   final _hourlyRateController = TextEditingController();

//   bool _isCertified = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _bioController.dispose();
//     _specialtiesController.dispose();
//     _experienceController.dispose();
//     _certificationController.dispose();
//     _hourlyRateController.dispose();
//     super.dispose();
//   }

//   Future<void> _createTrainerProfile() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       setState(() => _isLoading = false);

//       // Return success
//       Get.back(result: true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Become a Trainer', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant]),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(Icons.fitness_center, size: 60, color: AppColors.onAccent),
//                     const SizedBox(height: 12),
//                     Text('Share Your Expertise', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onAccent)),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Create your trainer profile and start helping others achieve their fitness goals',
//                       style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent.withOpacity(0.9)),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Bio
//               Text(
//                 'Professional Bio',
//                 style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _bioController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: 'Tell us about yourself and your fitness journey...',
//                   filled: true,
//                   fillColor: AppColors.surface,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your bio';
//                   }
//                   if (value.length < 50) {
//                     return 'Bio must be at least 50 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Specialties
//               Text(
//                 'Specialties',
//                 style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _specialtiesController,
//                 decoration: InputDecoration(
//                   hintText: 'e.g., Weight Loss, Strength Training, Yoga',
//                   filled: true,
//                   fillColor: AppColors.surface,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your specialties';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Years of Experience
//               Text(
//                 'Years of Experience',
//                 style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _experienceController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'e.g., 5',
//                   filled: true,
//                   fillColor: AppColors.surface,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your years of experience';
//                   }
//                   final years = int.tryParse(value);
//                   if (years == null || years < 0) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Certification
//               Row(
//                 children: [
//                   Checkbox(value: _isCertified, onChanged: (value) => setState(() => _isCertified = value ?? false), activeColor: AppColors.accent),
//                   Expanded(
//                     child: Text('I have professional certification(s)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
//                   ),
//                 ],
//               ),

//               if (_isCertified) ...[
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _certificationController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter your certification names',
//                     filled: true,
//                     fillColor: AppColors.surface,
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   validator: (value) {
//                     if (_isCertified && (value == null || value.isEmpty)) {
//                       return 'Please enter your certifications';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//               const SizedBox(height: 20),

//               // Hourly Rate
//               Text(
//                 'Hourly Rate (USD)',
//                 style: AppTextStyles.titleSmall.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _hourlyRateController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'e.g., 50',
//                   prefixText: '\$ ',
//                   filled: true,
//                   fillColor: AppColors.surface,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your hourly rate';
//                   }
//                   final rate = double.tryParse(value);
//                   if (rate == null || rate < 0) {
//                     return 'Please enter a valid rate';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32),

//               // Info Card
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.accent.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.accent.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline, color: AppColors.accent),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Your profile will be reviewed before going live. This usually takes 24-48 hours.',
//                         style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _createTrainerProfile,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: AppColors.accent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: _isLoading
//                       ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.onAccent, strokeWidth: 2))
//                       : Text('Create Trainer Profile', style: AppTextStyles.labelLarge.copyWith(color: AppColors.onAccent)),
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
