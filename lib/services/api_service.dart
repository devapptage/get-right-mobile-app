import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/services/storage_service.dart';

/// API Service for backend communication
///
/// Note: This is a template. Update with actual HTTP client (dio/http package)
/// and implement real API endpoints when backend is ready.
class ApiService {
  static ApiService? _instance;
  final StorageService _storage; // Used for auth token in real API calls

  ApiService._(this._storage);

  /// Get singleton instance
  static Future<ApiService> getInstance() async {
    if (_instance == null) {
      final storage = await StorageService.getInstance();
      _instance = ApiService._(storage);
    }
    return _instance!;
  }

  /// Get base URL
  String get baseUrl => '${AppConstants.baseUrl}/${AppConstants.apiVersion}';

  // ========== AUTH ENDPOINTS ==========

  /// Login
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    // TODO: Implement actual API call
    // Example:
    // final response = await http.post(
    //   Uri.parse('$baseUrl/auth/login'),
    //   headers: _headers,
    //   body: jsonEncode({'email': email, 'password': password}),
    // );

    // Mock response for development
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {'id': 'user_1', 'email': email, 'firstName': 'John', 'lastName': 'Doe'},
    };
  }

  /// Signup
  Future<Map<String, dynamic>> signup({required String email, required String password, required String firstName, required String lastName}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'OTP sent to email'};
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOTP({required String email, required String otp}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {'id': 'user_1', 'email': email, 'firstName': 'John', 'lastName': 'Doe'},
    };
  }

  /// Resend OTP
  Future<Map<String, dynamic>> resendOTP(String email) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'OTP resent'};
  }

  /// Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'Reset link sent to email'};
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword({required String email, required String otp, required String newPassword}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'Password reset successful'};
  }

  // ========== USER ENDPOINTS ==========

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'user': {'id': userId, 'email': 'user@example.com', 'firstName': 'John', 'lastName': 'Doe'},
    };
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile({required String userId, required Map<String, dynamic> data}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'Profile updated'};
  }

  // ========== WORKOUT ENDPOINTS ==========

  /// Get workouts
  Future<List<Map<String, dynamic>>> getWorkouts({required String userId, int page = 1, int limit = 20}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /// Add workout
  Future<Map<String, dynamic>> addWorkout(Map<String, dynamic> workout) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'id': 'workout_${DateTime.now().millisecondsSinceEpoch}'};
  }

  /// Update workout
  Future<Map<String, dynamic>> updateWorkout(String workoutId, Map<String, dynamic> workout) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true};
  }

  /// Delete workout
  Future<Map<String, dynamic>> deleteWorkout(String workoutId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true};
  }

  // ========== RUN ENDPOINTS ==========

  /// Save run
  Future<Map<String, dynamic>> saveRun(Map<String, dynamic> run) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'id': 'run_${DateTime.now().millisecondsSinceEpoch}'};
  }

  /// Get runs
  Future<List<Map<String, dynamic>>> getRuns({required String userId, int page = 1, int limit = 20}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  // ========== PROGRAM ENDPOINTS ==========

  /// Get programs (marketplace)
  Future<List<Map<String, dynamic>>> getPrograms({String? category, String? searchQuery, int page = 1, int limit = 20}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /// Get program details
  Future<Map<String, dynamic>> getProgramDetails(String programId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true};
  }

  /// Purchase program
  Future<Map<String, dynamic>> purchaseProgram({required String userId, required String programId, required double amount}) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'message': 'Program purchased'};
  }

  // ========== CHAT ENDPOINTS ==========

  /// Get conversations
  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /// Get messages
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /// Send message
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
    String type = 'text',
  }) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'id': 'msg_${DateTime.now().millisecondsSinceEpoch}'};
  }
}
