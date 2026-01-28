import 'package:get/get.dart';
import 'package:get_right/models/filter_model.dart';

/// Controller for managing search and filter functionality
class WorkoutSearchController extends GetxController {
  final Rx<FilterModel> _filters = FilterModel().obs;
  final RxList<dynamic> _searchResults = <dynamic>[].obs;
  final RxBool _isSearching = false.obs;
  final RxString _searchQuery = ''.obs;

  FilterModel get filters => _filters.value;
  List<dynamic> get searchResults => _searchResults;
  bool get isSearching => _isSearching.value;
  String get searchQuery => _searchQuery.value;

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    performSearch();
  }

  // Update filter
  void updateFilter(FilterModel newFilter) {
    _filters.value = newFilter;
    performSearch();
  }

  // Toggle workout type
  void toggleWorkoutType(String type) {
    final types = List<String>.from(_filters.value.workoutTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    _filters.value = _filters.value.copyWith(workoutTypes: types);
  }

  // Toggle difficulty level
  void toggleDifficultyLevel(String level) {
    final levels = List<String>.from(_filters.value.difficultyLevels);
    if (levels.contains(level)) {
      levels.remove(level);
    } else {
      levels.add(level);
    }
    _filters.value = _filters.value.copyWith(difficultyLevels: levels);
  }

  // Toggle workout duration
  void toggleWorkoutDuration(String duration) {
    final durations = List<String>.from(_filters.value.durations);
    if (durations.contains(duration)) {
      durations.remove(duration);
    } else {
      durations.add(duration);
    }
    _filters.value = _filters.value.copyWith(durations: durations);
  }

  // Toggle equipment type
  void toggleEquipmentType(String equipment) {
    final equipments = List<String>.from(_filters.value.equipmentTypes);
    if (equipments.contains(equipment)) {
      equipments.remove(equipment);
    } else {
      equipments.add(equipment);
    }
    _filters.value = _filters.value.copyWith(equipmentTypes: equipments);
  }

  // Toggle program duration
  void toggleProgramDuration(String duration) {
    final durations = List<String>.from(_filters.value.programDurations);
    if (durations.contains(duration)) {
      durations.remove(duration);
    } else {
      durations.add(duration);
    }
    _filters.value = _filters.value.copyWith(programDurations: durations);
  }

  // Set trainer rating
  void setTrainerRating(double? rating) {
    _filters.value = _filters.value.copyWith(minTrainerRating: rating);
  }

  // Toggle certification
  void toggleCertification(bool? certified) {
    _filters.value = _filters.value.copyWith(certifiedOnly: certified);
  }

  // Set price range
  void setPriceRange(double? minPrice, double? maxPrice) {
    _filters.value = _filters.value.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  // Clear all filters
  void clearFilters() {
    _filters.value = FilterModel();
    performSearch();
  }

  // Perform search with current filters
  void performSearch() {
    _isSearching.value = true;

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock data - In a real app, this would call an API
      _searchResults.value = _getMockSearchResults();
      _isSearching.value = false;
    });
  }

  // Mock search results (In production, this would be an API call)
  List<dynamic> _getMockSearchResults() {
    // Mock programs and workouts
    final allResults = [
      {
        'type': 'program',
        'name': 'Complete Body Transformation',
        'trainer': 'Sarah Johnson',
        'rating': 4.8,
        'certified': true,
        'price': 79.99,
        'duration': '12 Weeks',
        'workoutType': WorkoutTypes.strength,
        'difficulty': DifficultyLevels.intermediate,
        'equipment': EquipmentTypes.gym,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'program',
        'name': 'Yoga for Beginners',
        'trainer': 'Emma Williams',
        'rating': 4.9,
        'certified': true,
        'price': 49.99,
        'duration': '8 Weeks',
        'workoutType': WorkoutTypes.yoga,
        'difficulty': DifficultyLevels.beginner,
        'equipment': EquipmentTypes.none,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'workout',
        'name': 'HIIT Cardio Blast',
        'trainer': 'Mike Chen',
        'rating': 4.7,
        'certified': true,
        'price': 0.0,
        'duration': '30 mins',
        'workoutType': WorkoutTypes.hiit,
        'difficulty': DifficultyLevels.advanced,
        'equipment': EquipmentTypes.none,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'program',
        'name': 'Strength Builder Pro',
        'trainer': 'David Smith',
        'rating': 4.6,
        'certified': true,
        'price': 99.99,
        'duration': '16+ Weeks',
        'workoutType': WorkoutTypes.strength,
        'difficulty': DifficultyLevels.advanced,
        'equipment': EquipmentTypes.gym,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'workout',
        'name': 'Morning Stretching Routine',
        'trainer': 'Lisa Anderson',
        'rating': 4.5,
        'certified': false,
        'price': 0.0,
        'duration': '15 mins',
        'workoutType': WorkoutTypes.stretching,
        'difficulty': DifficultyLevels.beginner,
        'equipment': EquipmentTypes.none,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'program',
        'name': 'CrossFit Fundamentals',
        'trainer': 'Tom Rodriguez',
        'rating': 4.8,
        'certified': true,
        'price': 89.99,
        'duration': '12 Weeks',
        'workoutType': WorkoutTypes.crossfit,
        'difficulty': DifficultyLevels.intermediate,
        'equipment': EquipmentTypes.gym,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'workout',
        'name': 'Dance Fitness Party',
        'trainer': 'Maria Garcia',
        'rating': 4.9,
        'certified': true,
        'price': 0.0,
        'duration': '45 mins',
        'workoutType': WorkoutTypes.dance,
        'difficulty': DifficultyLevels.beginner,
        'equipment': EquipmentTypes.none,
        'image': 'assets/images/logo.png',
      },
      {
        'type': 'program',
        'name': 'Pilates Core Power',
        'trainer': 'Rachel Kim',
        'rating': 4.7,
        'certified': true,
        'price': 59.99,
        'duration': '8 Weeks',
        'workoutType': WorkoutTypes.pilates,
        'difficulty': DifficultyLevels.intermediate,
        'equipment': EquipmentTypes.basic,
        'image': 'assets/images/logo.png',
      },
    ];

    // Apply filters
    var filtered = allResults.where((item) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        final name = (item['name'] as String).toLowerCase();
        final trainer = (item['trainer'] as String).toLowerCase();
        if (!name.contains(query) && !trainer.contains(query)) {
          return false;
        }
      }

      // Workout type filter
      if (_filters.value.workoutTypes.isNotEmpty) {
        if (!_filters.value.workoutTypes.contains(item['workoutType'])) {
          return false;
        }
      }

      // Difficulty filter
      if (_filters.value.difficultyLevels.isNotEmpty) {
        if (!_filters.value.difficultyLevels.contains(item['difficulty'])) {
          return false;
        }
      }

      // Duration filter
      if (_filters.value.durations.isNotEmpty) {
        if (item['type'] == 'workout') {
          if (!_filters.value.durations.contains(item['duration'])) {
            return false;
          }
        }
      }

      // Program duration filter
      if (_filters.value.programDurations.isNotEmpty) {
        if (item['type'] == 'program') {
          if (!_filters.value.programDurations.contains(item['duration'])) {
            return false;
          }
        }
      }

      // Equipment filter
      if (_filters.value.equipmentTypes.isNotEmpty) {
        if (!_filters.value.equipmentTypes.contains(item['equipment'])) {
          return false;
        }
      }

      // Trainer rating filter
      if (_filters.value.minTrainerRating != null) {
        if ((item['rating'] as double) < _filters.value.minTrainerRating!) {
          return false;
        }
      }

      // Certification filter
      if (_filters.value.certifiedOnly == true) {
        if (item['certified'] != true) {
          return false;
        }
      }

      // Price range filter
      final price = item['price'] as double;
      if (_filters.value.minPrice != null && price < _filters.value.minPrice!) {
        return false;
      }
      if (_filters.value.maxPrice != null && price > _filters.value.maxPrice!) {
        return false;
      }

      return true;
    }).toList();

    return filtered;
  }
}
