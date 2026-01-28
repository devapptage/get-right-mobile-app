// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_right/routes/app_routes.dart';
// import 'package:get_right/theme/color_constants.dart';
// import 'package:get_right/theme/text_styles.dart';
// import 'package:table_calendar/table_calendar.dart';

// /// Bundle Enrollment Date Selection Screen
// class BundleEnrollmentScreen extends StatefulWidget {
//   const BundleEnrollmentScreen({super.key});

//   @override
//   State<BundleEnrollmentScreen> createState() => _BundleEnrollmentScreenState();
// }

// class _BundleEnrollmentScreenState extends State<BundleEnrollmentScreen> {
//   final Map<String, dynamic> bundle = Get.arguments ?? {};
//   final List<Map<String, dynamic>> programs = [];

//   DateTime _focusedDay = DateTime.now();
//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _isSelectingStartDate = true;

//   @override
//   void initState() {
//     super.initState();
//     // Extract programs from bundle
//     if (bundle['programs'] != null && bundle['programs'] is List) {
//       programs.addAll((bundle['programs'] as List).cast<Map<String, dynamic>>());
//     }

//     // Set default start date to tomorrow
//     _startDate = DateTime.now().add(const Duration(days: 1));

//     // Calculate end date based on longest program duration
//     if (programs.isNotEmpty && _startDate != null) {
//       int maxDurationWeeks = 0;
//       for (var program in programs) {
//         final duration = _parseDuration(program['duration'] ?? '12 weeks');
//         if (duration > maxDurationWeeks) {
//           maxDurationWeeks = duration;
//         }
//       }
//       if (maxDurationWeeks > 0) {
//         _endDate = _startDate!.add(Duration(days: maxDurationWeeks * 7));
//       }
//     }
//   }

//   int _parseDuration(String duration) {
//     final match = RegExp(r'(\d+)').firstMatch(duration);
//     if (match != null && match.group(1) != null) {
//       return int.parse(match.group(1)!);
//     }
//     return 12;
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
//       Get.snackbar('Invalid Date', 'Please select a date from today onwards', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.missed, colorText: Colors.white);
//       return;
//     }

//     setState(() {
//       _focusedDay = focusedDay;

//       if (_isSelectingStartDate) {
//         _startDate = selectedDay;
//         if (_endDate != null && _endDate!.isBefore(selectedDay)) {
//           _endDate = null;
//         }
//         // Auto-calculate end date based on longest program
//         if (_endDate == null && programs.isNotEmpty) {
//           int maxDurationWeeks = 0;
//           for (var program in programs) {
//             final duration = _parseDuration(program['duration'] ?? '12 weeks');
//             if (duration > maxDurationWeeks) {
//               maxDurationWeeks = duration;
//             }
//           }
//           if (maxDurationWeeks > 0) {
//             _endDate = _startDate!.add(Duration(days: maxDurationWeeks * 7));
//           }
//         }
//       } else {
//         if (_startDate == null) {
//           Get.snackbar(
//             'Select Start Date First',
//             'Please select a start date before selecting an end date',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.upcoming,
//             colorText: Colors.white,
//           );
//           return;
//         }
//         if (selectedDay.isBefore(_startDate!)) {
//           Get.snackbar('Invalid Date', 'End date must be after start date', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.missed, colorText: Colors.white);
//           return;
//         }
//         _endDate = selectedDay;
//       }
//     });
//   }

//   void _proceedToCheckout() {
//     if (_startDate == null || _endDate == null) {
//       Get.snackbar('Incomplete', 'Please select both start and end dates', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.missed, colorText: Colors.white);
//       return;
//     }

//     if (_endDate!.isBefore(_startDate!)) {
//       Get.snackbar('Invalid Dates', 'End date must be after start date', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.missed, colorText: Colors.white);
//       return;
//     }

//     // Pass bundle data with selected dates to purchase details screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bundlePrice = bundle['bundlePrice'] as double? ?? 0.0;
//     final totalValue = bundle['totalValue'] as double? ?? 0.0;
//     final discount = bundle['discount'] as int? ?? 0;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Bundle Dates', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Bundle Info Card
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.1), AppColors.accentVariant.withOpacity(0.05)]),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.accent, width: 2),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               bundle['title'] ?? 'Bundle',
//                               style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Text('${programs.length} Programs Included', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray)),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(color: AppColors.completed.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
//                         child: Text(
//                           '$discount% OFF',
//                           style: AppTextStyles.labelSmall.copyWith(color: AppColors.completed, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Total Value', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
//                           Text(
//                             '\$${totalValue.toStringAsFixed(2)}',
//                             style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, decoration: TextDecoration.lineThrough),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text('Bundle Price', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
//                           Text(
//                             '\$${bundlePrice.toStringAsFixed(2)}',
//                             style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Instructions
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.accent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.accent.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: AppColors.accent, size: 20),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Select your bundle start and end dates. All programs in the bundle will start on the same date.',
//                       style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Date Selection Toggle
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => setState(() {
//                         _isSelectingStartDate = true;
//                         if (_startDate != null) {
//                           _focusedDay = _startDate!;
//                         }
//                       }),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(color: _isSelectingStartDate ? AppColors.accent : Colors.transparent, borderRadius: BorderRadius.circular(8)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.play_circle_outline, size: 18, color: _isSelectingStartDate ? AppColors.onAccent : AppColors.primaryGray),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Start Date',
//                               style: AppTextStyles.bodyMedium.copyWith(
//                                 color: _isSelectingStartDate ? AppColors.onAccent : AppColors.onBackground,
//                                 fontWeight: _isSelectingStartDate ? FontWeight.w600 : FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (_startDate == null) {
//                           Get.snackbar(
//                             'Select Start Date First',
//                             'Please select a start date before selecting an end date',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: AppColors.upcoming,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//                         setState(() {
//                           _isSelectingStartDate = false;
//                           if (_endDate != null) {
//                             _focusedDay = _endDate!;
//                           }
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(color: !_isSelectingStartDate ? AppColors.accent : Colors.transparent, borderRadius: BorderRadius.circular(8)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.flag_outlined, size: 18, color: !_isSelectingStartDate ? AppColors.onAccent : AppColors.primaryGray),
//                             const SizedBox(width: 8),
//                             Text(
//                               'End Date',
//                               style: AppTextStyles.bodyMedium.copyWith(
//                                 color: !_isSelectingStartDate ? AppColors.onAccent : AppColors.onBackground,
//                                 fontWeight: !_isSelectingStartDate ? FontWeight.w600 : FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Calendar
//             Text(
//               _isSelectingStartDate ? 'Select Start Date' : 'Select End Date',
//               style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
//               ),
//               padding: const EdgeInsets.all(12),
//               child: TableCalendar(
//                 firstDay: DateTime.now(),
//                 lastDay: DateTime.now().add(const Duration(days: 365)),
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_startDate, day) || isSameDay(_endDate, day),
//                 onDaySelected: _onDaySelected,
//                 calendarFormat: CalendarFormat.month,
//                 startingDayOfWeek: StartingDayOfWeek.monday,
//                 headerStyle: HeaderStyle(
//                   titleCentered: true,
//                   formatButtonVisible: false,
//                   titleTextStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface),
//                   leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.accent),
//                   rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.accent),
//                 ),
//                 calendarStyle: CalendarStyle(
//                   todayDecoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.3), shape: BoxShape.circle),
//                   selectedDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
//                   selectedTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
//                   todayTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
//                   defaultTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
//                   weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
//                   outsideTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray.withOpacity(0.5)),
//                 ),
//                 daysOfWeekStyle: DaysOfWeekStyle(
//                   weekdayStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
//                   weekendStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Programs List
//             if (programs.isNotEmpty) ...[
//               Text(
//                 'Bundle Programs',
//                 style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               ...programs.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final program = entry.value;
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.surface,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: AppColors.primaryGray.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 32,
//                         height: 32,
//                         decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
//                         child: Center(
//                           child: Text(
//                             '${index + 1}',
//                             style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               program['title'] ?? 'Program',
//                               style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
//                             ),
//                             Text(program['duration'] ?? '', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//               const SizedBox(height: 24),
//             ],

//             // Selected Dates Summary
//             if (_startDate != null && _endDate != null) ...[
//               Text(
//                 'Bundle Duration',
//                 style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.accent.withOpacity(0.3)),
//                 ),
//                 child: Column(
//                   children: [
//                     _buildDateRow('Start Date', _formatDate(_startDate!), Icons.play_circle_outline, isSelected: _isSelectingStartDate),
//                     const Divider(height: 24),
//                     _buildDateRow('End Date', _formatDate(_endDate!), Icons.flag_outlined, isSelected: !_isSelectingStartDate),
//                     const Divider(height: 24),
//                     _buildDateRow('Duration', _calculateDuration(), Icons.schedule),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
//         ),
//         child: SafeArea(
//           child: ElevatedButton.icon(
//             onPressed: _proceedToCheckout,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.accent,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             icon: const Icon(Icons.shopping_cart, size: 20),
//             label: Text('Next', style: AppTextStyles.buttonLarge.copyWith(color: AppColors.onAccent)),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateRow(String label, String value, IconData icon, {bool isSelected = false}) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isSelected ? AppColors.accent.withOpacity(0.2) : AppColors.accent.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//             border: isSelected ? Border.all(color: AppColors.accent, width: 1.5) : null,
//           ),
//           child: Icon(icon, color: AppColors.accent, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? AppColors.accent : AppColors.onSurface, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         if (isSelected)
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
//             child: const Icon(Icons.check, size: 14, color: AppColors.onAccent),
//           ),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }

//   String _calculateDuration() {
//     if (_startDate == null || _endDate == null) {
//       return 'N/A';
//     }
//     final difference = _endDate!.difference(_startDate!);
//     final totalDays = difference.inDays;
//     final weeks = totalDays ~/ 7;
//     final days = totalDays % 7;

//     if (weeks > 0 && days > 0) {
//       return '$weeks week${weeks > 1 ? 's' : ''} ${days} day${days > 1 ? 's' : ''}';
//     } else if (weeks > 0) {
//       return '$weeks week${weeks > 1 ? 's' : ''}';
//     } else {
//       return '$days day${days > 1 ? 's' : ''}';
//     }
//   }
// }
