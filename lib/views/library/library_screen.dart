import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Library screen - exercise library organized by muscle groups
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock muscle groups data
  final List<Map<String, dynamic>> _muscleGroups = [
    {
      'id': 'chest',
      'name': 'Chest',
      'exerciseCount': 25,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'back',
      'name': 'Back',
      'exerciseCount': 25,
      'icon': Icons.accessibility_new,
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'shoulders',
      'name': 'Shoulders',
      'exerciseCount': 25,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'quads',
      'name': 'Quads',
      'exerciseCount': 24,
      'icon': Icons.directions_walk,
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'hamstrings',
      'name': 'Hamstrings',
      'exerciseCount': 20,
      'icon': Icons.directions_run,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'triceps',
      'name': 'Triceps',
      'exerciseCount': 25,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'biceps',
      'name': 'Biceps',
      'exerciseCount': 24,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'core',
      'name': 'Core',
      'exerciseCount': 30,
      'icon': Icons.self_improvement,
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'glutes',
      'name': 'Glutes',
      'exerciseCount': 18,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'calves',
      'name': 'Calves',
      'exerciseCount': 12,
      'icon': Icons.directions_walk,
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'forearms',
      'name': 'Forearms',
      'exerciseCount': 15,
      'icon': Icons.fitness_center,
      'color': const Color(0xFFE53935),
    },
  ];

  List<Map<String, dynamic>> get _filteredMuscleGroups {
    if (_searchQuery.isEmpty) {
      return _muscleGroups;
    }
    return _muscleGroups.where((group) {
      return group['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _filteredMuscleGroups;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text('Library', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Show favorite exercises
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search exercises',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGray),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.primaryGray),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.primaryVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Muscle Groups List
          Expanded(
            child: filteredGroups.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: AppColors.primaryGray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No muscle groups found',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      return _buildMuscleGroupCard(filteredGroups[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupCard(Map<String, dynamic> muscleGroup) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: muscleGroup['color'].withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: muscleGroup['color'],
              width: 2,
            ),
          ),
          child: Icon(
            muscleGroup['icon'],
            color: muscleGroup['color'],
            size: 28,
          ),
        ),
        title: Text(
          muscleGroup['name'],
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${muscleGroup['exerciseCount']} exercises',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGray),
        onTap: () {
          Get.toNamed(
            AppRoutes.exerciseList,
            arguments: muscleGroup,
          );
        },
      ),
    );
  }
}

