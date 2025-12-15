class ExerciseLibraryModel {
  final String id;
  final String name;
  final String primaryMuscle;
  final String? secondaryMuscle;
  final String difficulty;
  final String? equipmentRequired;
  final List<String> instructions;
  final List<String> tips;
  final String? videoUrl;

  ExerciseLibraryModel({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    this.secondaryMuscle,
    required this.difficulty,
    this.equipmentRequired,
    required this.instructions,
    this.tips = const [],
    this.videoUrl,
  });

  factory ExerciseLibraryModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLibraryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      primaryMuscle: json['primaryMuscle'] ?? '',
      secondaryMuscle: json['secondaryMuscle'],
      difficulty: json['difficulty'] ?? 'Intermediate',
      equipmentRequired: json['equipmentRequired'],
      instructions: (json['instructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      tips: (json['tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'primaryMuscle': primaryMuscle,
    'secondaryMuscle': secondaryMuscle,
    'difficulty': difficulty,
    'equipmentRequired': equipmentRequired,
    'instructions': instructions,
    'tips': tips,
    'videoUrl': videoUrl,
  };
}

class ExerciseLibraryData {
  static final List<ExerciseLibraryModel> exercises = [
    ExerciseLibraryModel(
      id: 'bench_press',
      name: 'Bench Press',
      primaryMuscle: 'Chest',
      secondaryMuscle: 'Triceps, Shoulders',
      difficulty: 'Intermediate',
      equipmentRequired: 'Barbell, Bench',
      instructions: [
        'Lie flat on the bench with your eyes under the bar',
        'Grip the bar slightly wider than shoulder width',
        'Unrack the bar and lower it to mid-chest',
        'Press the bar back up to the starting position',
      ],
      tips: ['Keep your feet flat on the floor', 'Maintain a slight arch in your lower back', 'Keep your elbows at a 45-degree angle'],
    ),
    ExerciseLibraryModel(
      id: 'squat',
      name: 'Squat',
      primaryMuscle: 'Quadriceps',
      secondaryMuscle: 'Glutes, Hamstrings',
      difficulty: 'Intermediate',
      equipmentRequired: 'Barbell, Squat Rack',
      instructions: [
        'Position the bar on your upper back',
        'Stand with feet shoulder-width apart',
        'Lower your body by bending your knees and hips',
        'Descend until thighs are parallel to the floor',
        'Push through your heels to return to standing',
      ],
      tips: ['Keep your chest up throughout the movement', 'Push your knees out over your toes', 'Maintain a neutral spine'],
    ),
    ExerciseLibraryModel(
      id: 'deadlift',
      name: 'Deadlift',
      primaryMuscle: 'Back',
      secondaryMuscle: 'Glutes, Hamstrings',
      difficulty: 'Advanced',
      equipmentRequired: 'Barbell',
      instructions: [
        'Stand with feet hip-width apart, bar over mid-foot',
        'Bend at hips and knees to grip the bar',
        'Keep your back flat and chest up',
        'Drive through your heels and extend hips and knees',
        'Stand tall, then reverse the movement',
      ],
      tips: ['Keep the bar close to your body', 'Engage your lats before lifting', 'Don\'t round your lower back'],
    ),
    ExerciseLibraryModel(
      id: 'overhead_press',
      name: 'Overhead Press',
      primaryMuscle: 'Shoulders',
      secondaryMuscle: 'Triceps',
      difficulty: 'Intermediate',
      equipmentRequired: 'Barbell',
      instructions: [
        'Hold the bar at shoulder height with hands slightly wider than shoulders',
        'Press the bar overhead until arms are fully extended',
        'Lower the bar back to shoulder height with control',
      ],
      tips: ['Brace your core throughout', 'Tuck your chin as the bar passes', 'Lock out at the top'],
    ),
    ExerciseLibraryModel(
      id: 'pull_up',
      name: 'Pull-up',
      primaryMuscle: 'Back',
      secondaryMuscle: 'Biceps',
      difficulty: 'Advanced',
      equipmentRequired: 'Pull-up Bar',
      instructions: [
        'Hang from the bar with hands slightly wider than shoulders',
        'Pull yourself up until your chin is over the bar',
        'Lower yourself with control to the starting position',
      ],
      tips: ['Initiate the pull with your back muscles', 'Keep your core engaged', 'Avoid swinging or kipping'],
    ),
    ExerciseLibraryModel(
      id: 'plank',
      name: 'Plank',
      primaryMuscle: 'Core',
      secondaryMuscle: null,
      difficulty: 'Beginner',
      equipmentRequired: null,
      instructions: ['Start in a forearm plank position', 'Keep your body in a straight line from head to heels', 'Hold this position for the desired time'],
      tips: ['Don\'t let your hips sag', 'Engage your glutes', 'Breathe steadily'],
    ),
    ExerciseLibraryModel(
      id: 'front_squat',
      name: 'Front Squat',
      primaryMuscle: 'Quadriceps',
      secondaryMuscle: 'Core, Glutes',
      difficulty: 'Advanced',
      equipmentRequired: 'Barbell, Squat Rack',
      instructions: [
        'Position the bar on front deltoids, elbows high',
        'Stand with feet shoulder-width apart',
        'Squat down keeping torso upright',
        'Drive through heels to return',
      ],
      tips: ['Keep elbows high throughout', 'Maintain an upright torso', 'Go as deep as mobility allows'],
    ),
    ExerciseLibraryModel(
      id: 'lat_pulldown',
      name: 'Lat Pulldown',
      primaryMuscle: 'Back',
      secondaryMuscle: 'Biceps',
      difficulty: 'Beginner',
      equipmentRequired: 'Cable Machine',
      instructions: ['Sit and grip the bar wider than shoulder-width', 'Pull the bar down to your upper chest', 'Control the bar back up'],
      tips: ['Lead with your elbows', 'Squeeze your lats at the bottom', 'Don\'t lean back excessively'],
    ),
    ExerciseLibraryModel(
      id: 'dumbbell_curl',
      name: 'Dumbbell Curl',
      primaryMuscle: 'Biceps',
      secondaryMuscle: null,
      difficulty: 'Beginner',
      equipmentRequired: 'Dumbbells',
      instructions: ['Stand with dumbbells at your sides', 'Curl the weights up while keeping upper arms stationary', 'Lower with control'],
      tips: ['Avoid swinging', 'Fully extend at the bottom', 'Squeeze at the top'],
    ),
    ExerciseLibraryModel(
      id: 'tricep_pushdown',
      name: 'Tricep Pushdown',
      primaryMuscle: 'Triceps',
      secondaryMuscle: null,
      difficulty: 'Beginner',
      equipmentRequired: 'Cable Machine',
      instructions: ['Stand facing the cable machine', 'Grip the bar with arms bent at 90 degrees', 'Push down until arms are fully extended', 'Return to starting position'],
      tips: ['Keep elbows pinned to your sides', 'Control the weight on the way up', 'Don\'t use momentum'],
    ),
    ExerciseLibraryModel(
      id: 'lunges',
      name: 'Lunges',
      primaryMuscle: 'Quadriceps',
      secondaryMuscle: 'Glutes, Hamstrings',
      difficulty: 'Beginner',
      equipmentRequired: null,
      instructions: ['Stand tall with feet hip-width apart', 'Step forward with one leg', 'Lower until both knees are at 90 degrees', 'Push back to starting position'],
      tips: ['Keep your torso upright', 'Don\'t let your front knee go past your toes', 'Alternate legs'],
    ),
    ExerciseLibraryModel(
      id: 'leg_press',
      name: 'Leg Press',
      primaryMuscle: 'Quadriceps',
      secondaryMuscle: 'Glutes, Hamstrings',
      difficulty: 'Beginner',
      equipmentRequired: 'Leg Press Machine',
      instructions: [
        'Sit on the machine with back against pad',
        'Place feet shoulder-width on the platform',
        'Lower the weight by bending your knees',
        'Push back up without locking knees',
      ],
      tips: ['Keep your lower back pressed against the pad', 'Don\'t lock out at the top', 'Control the descent'],
    ),
  ];
}
