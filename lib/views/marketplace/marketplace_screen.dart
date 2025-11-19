import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Marketplace screen - browse trainer programs
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  String _selectedGoal = 'All';
  bool _showCertifiedOnly = false;

  // Mock bundle data
  final List<Map<String, dynamic>> _bundles = [
    {
      'id': 'bundle_1',
      'title': 'Complete Fitness Bundle',
      'description': 'Full body transformation program',
      'discount': 25,
      'totalValue': 159.97,
      'bundlePrice': 119.99,
      'programs': [
        {
          'id': 'program_1',
          'title': 'Complete Strength Program',
          'trainer': 'Sarah Johnson',
          'trainerImage': 'SJ',
          'price': 49.99,
          'duration': '12 weeks',
          'category': 'Strength',
          'goal': 'Muscle Building',
          'certified': true,
          'rating': 4.8,
          'students': 1250,
        },
        {
          'id': 'program_2',
          'title': 'Cardio Blast Challenge',
          'trainer': 'Mike Chen',
          'trainerImage': 'MC',
          'price': 29.99,
          'duration': '8 weeks',
          'category': 'Cardio',
          'goal': 'Weight Loss',
          'certified': true,
          'rating': 4.9,
          'students': 2100,
        },
        {
          'id': 'program_3',
          'title': 'Yoga for Athletes',
          'trainer': 'Emma Davis',
          'trainerImage': 'ED',
          'price': 39.99,
          'duration': '6 weeks',
          'category': 'Flexibility',
          'goal': 'Flexibility',
          'certified': true,
          'rating': 4.7,
          'students': 850,
        },
      ],
    },
    {
      'id': 'bundle_2',
      'title': 'Elite Performance Bundle',
      'description': 'Advanced training for serious athletes',
      'discount': 30,
      'totalValue': 189.97,
      'bundlePrice': 132.99,
      'programs': [
        {
          'id': 'program_5',
          'title': 'Marathon Prep',
          'trainer': 'Lisa Thompson',
          'trainerImage': 'LT',
          'price': 59.99,
          'duration': '16 weeks',
          'category': 'Running',
          'goal': 'Endurance',
          'certified': true,
          'rating': 4.9,
          'students': 1520,
        },
        {
          'id': 'program_4',
          'title': 'Bodyweight Mastery',
          'trainer': 'Alex Rodriguez',
          'trainerImage': 'AR',
          'price': 34.99,
          'duration': '10 weeks',
          'category': 'Bodyweight',
          'goal': 'General Fitness',
          'certified': false,
          'rating': 4.5,
          'students': 640,
        },
        {
          'id': 'program_6',
          'title': 'Core Strength Elite',
          'trainer': 'David Kim',
          'trainerImage': 'DK',
          'price': 24.99,
          'duration': '4 weeks',
          'category': 'Core',
          'goal': 'Strength',
          'certified': false,
          'rating': 4.6,
          'students': 980,
        },
        {
          'id': 'program_1',
          'title': 'Complete Strength Program',
          'trainer': 'Sarah Johnson',
          'trainerImage': 'SJ',
          'price': 49.99,
          'duration': '12 weeks',
          'category': 'Strength',
          'goal': 'Muscle Building',
          'certified': true,
          'rating': 4.8,
          'students': 1250,
        },
      ],
    },
  ];

  // Mock program data
  final List<Map<String, dynamic>> _programs = [
    {
      'id': 'program_1',
      'title': 'Complete Strength Program',
      'trainer': 'Sarah Johnson',
      'trainerImage': 'SJ',
      'price': 49.99,
      'duration': '12 weeks',
      'category': 'Strength',
      'goal': 'Muscle Building',
      'certified': true,
      'rating': 4.8,
      'students': 1250,
      'description': 'Build muscle and strength with this comprehensive program',
    },
    {
      'id': 'program_2',
      'title': 'Cardio Blast Challenge',
      'trainer': 'Mike Chen',
      'trainerImage': 'MC',
      'price': 29.99,
      'duration': '8 weeks',
      'category': 'Cardio',
      'goal': 'Weight Loss',
      'certified': true,
      'rating': 4.9,
      'students': 2100,
      'description': 'High-intensity cardio program for maximum fat loss',
    },
    {
      'id': 'program_3',
      'title': 'Yoga for Athletes',
      'trainer': 'Emma Davis',
      'trainerImage': 'ED',
      'price': 39.99,
      'duration': '6 weeks',
      'category': 'Flexibility',
      'goal': 'Flexibility',
      'certified': true,
      'rating': 4.7,
      'students': 850,
      'description': 'Improve flexibility and recovery through targeted yoga',
    },
    {
      'id': 'program_4',
      'title': 'Bodyweight Mastery',
      'trainer': 'Alex Rodriguez',
      'trainerImage': 'AR',
      'price': 34.99,
      'duration': '10 weeks',
      'category': 'Bodyweight',
      'goal': 'General Fitness',
      'certified': false,
      'rating': 4.5,
      'students': 640,
      'description': 'Master bodyweight exercises anywhere, no equipment needed',
    },
    {
      'id': 'program_5',
      'title': 'Marathon Prep',
      'trainer': 'Lisa Thompson',
      'trainerImage': 'LT',
      'price': 59.99,
      'duration': '16 weeks',
      'category': 'Running',
      'goal': 'Endurance',
      'certified': true,
      'rating': 4.9,
      'students': 1520,
      'description': 'Complete training plan to conquer your first marathon',
    },
    {
      'id': 'program_6',
      'title': 'Core Strength Elite',
      'trainer': 'David Kim',
      'trainerImage': 'DK',
      'price': 24.99,
      'duration': '4 weeks',
      'category': 'Core',
      'goal': 'Strength',
      'certified': false,
      'rating': 4.6,
      'students': 980,
      'description': 'Intensive core training for a solid foundation',
    },
  ];

  List<Map<String, dynamic>> get _filteredPrograms {
    return _programs.where((program) {
      if (_selectedCategory != 'All' && program['category'] != _selectedCategory) return false;
      if (_selectedGoal != 'All' && program['goal'] != _selectedGoal) return false;
      if (_showCertifiedOnly && !program['certified']) return false;
      return true;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.filter_list, color: AppColors.accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text('Filter Programs', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.primaryGray),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                _buildFilterSectionHeader('Category', Icons.category_outlined),
                SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Strength', 'Cardio', 'Flexibility', 'Bodyweight', 'Running', 'Core'].map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? AppColors.accent : AppColors.primaryGray, width: isSelected ? 2 : 1),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected ? AppColors.onAccent : AppColors.onBackground,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Goal Section
                _buildFilterSectionHeader('Fitness Goal', Icons.flag_outlined),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Muscle Building', 'Weight Loss', 'Flexibility', 'General Fitness', 'Endurance', 'Strength'].map((goal) {
                      final isSelected = _selectedGoal == goal;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedGoal = goal;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? AppColors.accent : AppColors.primaryGray, width: isSelected ? 2 : 1),
                          ),
                          child: Text(
                            goal,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected ? AppColors.onAccent : AppColors.onBackground,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Certified Only Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _showCertifiedOnly ? AppColors.completed.withOpacity(0.2) : AppColors.primaryGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.verified, color: _showCertifiedOnly ? AppColors.completed : AppColors.primaryGray, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Certified Trainers Only', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                            Text('Show only verified professionals', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showCertifiedOnly,
                        onChanged: (value) {
                          setModalState(() {
                            _showCertifiedOnly = value;
                          });
                        },
                        activeColor: AppColors.completed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setModalState(() {
                              _selectedCategory = 'All';
                              _selectedGoal = 'All';
                              _showCertifiedOnly = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryGray, width: 2),
                            foregroundColor: AppColors.onBackground,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.clear_all, size: 20),
                          label: Text('Clear All', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.onBackground)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.onAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.check, size: 20),
                          label: Text('Apply Filters', style: AppTextStyles.buttonMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
      ],
    );
  }

  void _showProgramDetail(Map<String, dynamic> program) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _navigateToTrainerProfile(program);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.accent,
                      child: Text(program['trainerImage'], style: AppTextStyles.titleMedium.copyWith(color: AppColors.onAccent)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(program['trainer'], style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
                          Row(
                            children: [
                              Icon(Icons.star, color: AppColors.upcoming, size: 16),
                              const SizedBox(width: 4),
                              Text('${program['rating']}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface)),
                              const SizedBox(width: 8),
                              Text('${program['students']} students', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                            ],
                          ),
                          if (program['certified'])
                            Row(
                              children: [
                                Icon(Icons.verified, color: AppColors.completed, size: 16),
                                const SizedBox(width: 4),
                                Text('Certified Trainer', style: AppTextStyles.labelSmall.copyWith(color: AppColors.completed)),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.accent),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(program['title'], style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onSurface)),
              const SizedBox(height: 12),
              Text(program['description'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildInfoChip(Icons.schedule, program['duration']),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.category, program['category']),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.flag, program['goal']),
                ],
              ),
              const SizedBox(height: 32),
              Text('Program Details', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
              const SizedBox(height: 12),
              _buildDetailItem(Icons.fitness_center, 'Full workout plans and schedules'),
              _buildDetailItem(Icons.video_library, 'Video demonstrations for all exercises'),
              _buildDetailItem(Icons.track_changes, 'Progress tracking and analytics'),
              _buildDetailItem(Icons.chat, 'Direct messaging with trainer'),
              _buildDetailItem(Icons.library_books, 'Nutrition guide included'),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray)),
                        Text('\$${program['price']}', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accent)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.toNamed(AppRoutes.programDetail, arguments: program);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPrograms = _filteredPrograms;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text('Market Place', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.onPrimary),
                onPressed: _showFilterModal,
              ),
              if (_selectedCategory != 'All' || _selectedGoal != 'All' || _showCertifiedOnly)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bundle Programs Section
            Text('Bundle Programs', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: _bundles.length,
                itemBuilder: (context, index) {
                  return _buildBundleCard(_bundles[index]);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Active filters indicator
            if (_selectedCategory != 'All' || _selectedGoal != 'All' || _showCertifiedOnly) ...[
              Row(
                children: [
                  Text('Active Filters: ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
                  if (_selectedCategory != 'All')
                    Chip(label: Text(_selectedCategory), deleteIcon: const Icon(Icons.close, size: 16), onDeleted: () => setState(() => _selectedCategory = 'All')),
                  if (_selectedGoal != 'All')
                    Chip(label: Text(_selectedGoal), deleteIcon: const Icon(Icons.close, size: 16), onDeleted: () => setState(() => _selectedGoal = 'All')),
                  if (_showCertifiedOnly)
                    Chip(label: const Text('Certified'), deleteIcon: const Icon(Icons.close, size: 16), onDeleted: () => setState(() => _showCertifiedOnly = false)),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Programs header
            Text('${filteredPrograms.length} Programs Available', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 16),

            // Programs grid
            filteredPrograms.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 80, color: AppColors.primaryGray.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text('No programs found', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGray)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => setState(() {
                              _selectedCategory = 'All';
                              _selectedGoal = 'All';
                              _showCertifiedOnly = false;
                            }),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredPrograms.length,
                    itemBuilder: (context, index) {
                      final program = filteredPrograms[index];
                      return _buildProgramCard(program);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle) {
    final programs = bundle['programs'] as List<Map<String, dynamic>>;
    final totalValue = bundle['totalValue'] as double;
    final bundlePrice = bundle['bundlePrice'] as double;
    final discount = bundle['discount'] as int;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.bundleDetail, arguments: bundle);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bundle Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentVariant], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bundle['title'], style: AppTextStyles.titleLarge.copyWith(color: AppColors.onAccent)),

                          const SizedBox(height: 4),
                          Text(bundle['description'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.onAccent.withOpacity(0.9))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.onAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '$discount% OFF',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Programs Horizontal Scroll
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${programs.length} Programs', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: programs.length,
                      itemBuilder: (context, index) {
                        return SizedBox(child: _buildCompactProgramCard(programs[index]));
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bundle Price and Enroll Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryVariant,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Value', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                          Text(
                            '\$${totalValue.toStringAsFixed(2)}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray, decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Bundle Price', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onAccent)),
                          Text(
                            '\$${bundlePrice.toStringAsFixed(2)}',
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _enrollInBundle(bundle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.shopping_cart, size: 20),
                      label: Text('Enroll Bundle', style: AppTextStyles.buttonMedium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactProgramCard(Map<String, dynamic> program) {
    return Container(
      width: 220,
      height: 350,
      margin: const EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGray.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),

          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent,
                child: Text(program['trainerImage'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.onAccent)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['trainer'],
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.upcoming, size: 12),
                        const SizedBox(width: 2),
                        Text('${program['rating']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            program['title'],
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${program['price']}',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.schedule, size: 12, color: AppColors.primaryGray),
                  const SizedBox(width: 4),
                  Text(program['duration'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _enrollInBundle(Map<String, dynamic> bundle) {
    Get.toNamed(AppRoutes.bundleDetail, arguments: bundle);
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return GestureDetector(
      onTap: () => _showProgramDetail(program),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGray, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToTrainerProfile(program),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.accent,
                    child: Text(program['trainerImage'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.onAccent)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToTrainerProfile(program),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(program['trainer'], style: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurface)),
                            ),
                            if (program['certified']) Icon(Icons.verified, color: AppColors.completed, size: 16),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.upcoming, size: 14),
                            const SizedBox(width: 4),
                            Text('${program['rating']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface)),
                            const SizedBox(width: 8),
                            Text('${program['students']} students', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(program['title'], style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(
              program['description'],
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(program['category']), padding: const EdgeInsets.symmetric(horizontal: 8), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                const SizedBox(width: 8),
                Icon(Icons.schedule, size: 14, color: AppColors.primaryGray),
                const SizedBox(width: 4),
                Text(program['duration'], style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray)),
                const Spacer(),
                Text(
                  '\$${program['price']}',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: AppColors.primaryGray.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.accent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
          ),
        ],
      ),
    );
  }

  void _navigateToTrainerProfile(Map<String, dynamic> program) {
    // Create trainer data from program info
    final trainerData = {
      'id': program['trainer'].toString().toLowerCase().replaceAll(' ', '_'),
      'name': program['trainer'],
      'initials': program['trainerImage'],
      'bio': 'Certified personal trainer with years of experience helping clients achieve their fitness goals. Specializing in ${program['category']} and ${program['goal']}.',
      'specialties': [program['category'], program['goal'], 'Nutrition Coaching'],
      'yearsOfExperience': 8,
      'certified': program['certified'],
      'certifications': program['certified'] ? ['NASM Certified Personal Trainer', 'Precision Nutrition Level 1'] : null,
      'hourlyRate': 75.0,
      'rating': program['rating'],
      'totalReviews': 127,
      'students': program['students'],
      'activePrograms': 5,
      'completedPrograms': 12,
      'totalPrograms': 17,
    };

    Get.toNamed(AppRoutes.trainerProfile, arguments: trainerData);
  }
}
