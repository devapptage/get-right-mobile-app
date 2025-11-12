import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_right/constants/app_constants.dart';
import 'package:get_right/models/run_model.dart';

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

  // Run tracking methods

  /// Save runs list
  Future<bool> saveRuns(List<RunModel> runs) async {
    final jsonList = runs.map((run) => json.encode(run.toJson())).toList();
    return await saveStringList('user_runs', jsonList);
  }

  /// Get runs list
  Future<List<RunModel>> getRuns() async {
    final jsonList = getStringList('user_runs') ?? [];
    return jsonList.map((jsonStr) => RunModel.fromJson(json.decode(jsonStr))).toList();
  }

  /// Get runs for specific date
  Future<List<RunModel>> getRunsForDate(DateTime date) async {
    final allRuns = await getRuns();
    return allRuns.where((run) {
      return run.startTime.year == date.year && run.startTime.month == date.month && run.startTime.day == date.day;
    }).toList();
  }

  /// Get total runs count
  Future<int> getTotalRunsCount() async {
    final runs = await getRuns();
    return runs.length;
  }

  /// Get total distance in meters
  Future<double> getTotalDistance() async {
    final runs = await getRuns();
    double total = 0.0;
    for (final run in runs) {
      total += run.distanceMeters;
    }
    return total;
  }

  // Journal sync methods

  /// Sync run to journal as a workout activity
  Future<bool> syncRunToJournal(RunModel run) async {
    try {
      // Store run ID in synced runs list
      final syncedRuns = getStringList('synced_runs_to_journal') ?? [];
      if (!syncedRuns.contains(run.id)) {
        syncedRuns.add(run.id);
        await saveStringList('synced_runs_to_journal', syncedRuns);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if run is synced to journal
  bool isRunSyncedToJournal(String runId) {
    final syncedRuns = getStringList('synced_runs_to_journal') ?? [];
    return syncedRuns.contains(runId);
  }

  // Calendar sync methods

  /// Sync run to calendar
  Future<bool> syncRunToCalendar(RunModel run) async {
    try {
      // Store run ID in synced runs list for calendar
      final syncedRuns = getStringList('synced_runs_to_calendar') ?? [];
      if (!syncedRuns.contains(run.id)) {
        syncedRuns.add(run.id);
        await saveStringList('synced_runs_to_calendar', syncedRuns);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if run is synced to calendar
  bool isRunSyncedToCalendar(String runId) {
    final syncedRuns = getStringList('synced_runs_to_calendar') ?? [];
    return syncedRuns.contains(runId);
  }

  /// Auto-sync run to both journal and calendar
  Future<bool> autoSyncRun(RunModel run) async {
    final journalSync = await syncRunToJournal(run);
    final calendarSync = await syncRunToCalendar(run);
    return journalSync && calendarSync;
  }
}
