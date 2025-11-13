/// Filter model for workouts and programs
class FilterModel {
  // Workout Types
  final List<String> workoutTypes;

  // Difficulty Levels
  final List<String> difficultyLevels;

  // Duration ranges (in minutes)
  final List<String> durations;

  // Equipment needed
  final List<String> equipmentTypes;

  // Trainer rating (minimum)
  final double? minTrainerRating;

  // Certification status
  final bool? certifiedOnly;

  // Price range
  final double? minPrice;
  final double? maxPrice;

  // Program duration (in weeks)
  final List<String> programDurations;

  // Search query
  final String? searchQuery;

  FilterModel({
    this.workoutTypes = const [],
    this.difficultyLevels = const [],
    this.durations = const [],
    this.equipmentTypes = const [],
    this.minTrainerRating,
    this.certifiedOnly,
    this.minPrice,
    this.maxPrice,
    this.programDurations = const [],
    this.searchQuery,
  });

  FilterModel copyWith({
    List<String>? workoutTypes,
    List<String>? difficultyLevels,
    List<String>? durations,
    List<String>? equipmentTypes,
    double? minTrainerRating,
    bool? certifiedOnly,
    double? minPrice,
    double? maxPrice,
    List<String>? programDurations,
    String? searchQuery,
  }) {
    return FilterModel(
      workoutTypes: workoutTypes ?? this.workoutTypes,
      difficultyLevels: difficultyLevels ?? this.difficultyLevels,
      durations: durations ?? this.durations,
      equipmentTypes: equipmentTypes ?? this.equipmentTypes,
      minTrainerRating: minTrainerRating ?? this.minTrainerRating,
      certifiedOnly: certifiedOnly ?? this.certifiedOnly,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      programDurations: programDurations ?? this.programDurations,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters {
    return workoutTypes.isNotEmpty ||
        difficultyLevels.isNotEmpty ||
        durations.isNotEmpty ||
        equipmentTypes.isNotEmpty ||
        minTrainerRating != null ||
        certifiedOnly != null ||
        minPrice != null ||
        maxPrice != null ||
        programDurations.isNotEmpty;
  }

  int get activeFilterCount {
    int count = 0;
    if (workoutTypes.isNotEmpty) count++;
    if (difficultyLevels.isNotEmpty) count++;
    if (durations.isNotEmpty) count++;
    if (equipmentTypes.isNotEmpty) count++;
    if (minTrainerRating != null) count++;
    if (certifiedOnly == true) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (programDurations.isNotEmpty) count++;
    return count;
  }

  FilterModel clear() {
    return FilterModel();
  }
}

/// Available workout types
class WorkoutTypes {
  static const String cardio = 'Cardio';
  static const String strength = 'Strength';
  static const String yoga = 'Yoga';
  static const String pilates = 'Pilates';
  static const String hiit = 'HIIT';
  static const String crossfit = 'CrossFit';
  static const String sports = 'Sports';
  static const String stretching = 'Stretching';
  static const String mobility = 'Mobility';
  static const String dance = 'Dance';

  static const List<String> all = [cardio, strength, yoga, pilates, hiit, crossfit, sports, stretching, mobility, dance];
}

/// Available difficulty levels
class DifficultyLevels {
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';

  static const List<String> all = [beginner, intermediate, advanced];
}

/// Available duration options
class WorkoutDurations {
  static const String min15 = '15 mins';
  static const String min30 = '30 mins';
  static const String min45 = '45 mins';
  static const String min60Plus = '60+ mins';

  static const List<String> all = [min15, min30, min45, min60Plus];
}

/// Available equipment types
class EquipmentTypes {
  static const String none = 'No Equipment';
  static const String basic = 'Basic Equipment';
  static const String gym = 'Gym Equipment';

  static const List<String> all = [none, basic, gym];
}

/// Available program durations
class ProgramDurations {
  static const String week4 = '4 Weeks';
  static const String week8 = '8 Weeks';
  static const String week12 = '12 Weeks';
  static const String week16Plus = '16+ Weeks';

  static const List<String> all = [week4, week8, week12, week16Plus];
}
