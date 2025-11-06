import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_right/constants/app_constants.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  /// Get singleton instance
  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _preferences!.getString(key);
  }

  /// Save int value
  Future<bool> saveInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return _preferences!.getInt(key);
  }

  /// Save bool value
  Future<bool> saveBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _preferences!.getDouble(key);
  }

  /// Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  /// Get list of strings
  List<String>? getStringList(String key) {
    return _preferences!.getStringList(key);
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    return await _preferences!.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  // Auth-specific methods

  /// Save user token
  Future<bool> saveToken(String token) async {
    return await saveString(AppConstants.keyUserToken, token);
  }

  /// Get user token
  String? getToken() {
    return getString(AppConstants.keyUserToken);
  }

  /// Save user ID
  Future<bool> saveUserId(String userId) async {
    return await saveString(AppConstants.keyUserId, userId);
  }

  /// Get user ID
  String? getUserId() {
    return getString(AppConstants.keyUserId);
  }

  /// Save login status
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    return await saveBool(AppConstants.keyIsLoggedIn, isLoggedIn);
  }

  /// Get login status
  bool isLoggedIn() {
    return getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  /// Save user email
  Future<bool> saveEmail(String email) async {
    return await saveString(AppConstants.keyUserEmail, email);
  }

  /// Get user email
  String? getEmail() {
    return getString(AppConstants.keyUserEmail);
  }

  /// Save user name
  Future<bool> saveName(String name) async {
    return await saveString(AppConstants.keyUserName, name);
  }

  /// Get user name
  String? getName() {
    return getString(AppConstants.keyUserName);
  }

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return getBool(AppConstants.keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as complete
  Future<bool> completeOnboarding() async {
    return await saveBool(AppConstants.keyOnboardingComplete, true);
  }

  /// Logout - clear all auth data
  Future<bool> logout() async {
    await remove(AppConstants.keyUserToken);
    await remove(AppConstants.keyUserId);
    await remove(AppConstants.keyUserEmail);
    await remove(AppConstants.keyUserName);
    return await saveBool(AppConstants.keyIsLoggedIn, false);
  }
}
