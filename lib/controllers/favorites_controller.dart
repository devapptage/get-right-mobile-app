import 'package:get/get.dart';
import 'package:get_right/services/storage_service.dart';

/// Controller for managing favorite programs and workouts
class FavoritesController extends GetxController {
  late final StorageService _storage;

  // Observable list of favorite program/workout IDs
  final RxList<String> _favoriteIds = <String>[].obs;

  // Observable list of full favorite items
  final RxList<Map<String, dynamic>> _favorites = <Map<String, dynamic>>[].obs;

  List<String> get favoriteIds => _favoriteIds;
  List<Map<String, dynamic>> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    try {
      _storage = Get.find<StorageService>();
      _loadFavorites();
    } catch (e) {
      print('Error initializing FavoritesController: $e');
      // Initialize with empty storage if not available
    }
  }

  /// Load favorites from storage
  Future<void> _loadFavorites() async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        print('StorageService not registered, skipping load');
        return;
      }

      final savedIds = _storage.getString('favorite_ids');
      if (savedIds != null && savedIds.isNotEmpty) {
        _favoriteIds.value = savedIds.split(',').where((id) => id.isNotEmpty).toList();
      }

      final savedFavorites = _storage.getString('favorites_data');
      if (savedFavorites != null) {
        // In a real app, you'd deserialize from JSON
        // For now, we'll load empty and populate as items are favorited
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  /// Check if an item is favorited
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id, Map<String, dynamic> item) async {
    if (isFavorite(id)) {
      // Remove from favorites
      _favoriteIds.remove(id);
      _favorites.removeWhere((fav) => fav['id'] == id);
    } else {
      // Add to favorites
      _favoriteIds.add(id);
      _favorites.add(item);
    }

    // Save to storage
    await _saveFavorites();
  }

  /// Save favorites to storage
  Future<void> _saveFavorites() async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        print('StorageService not registered, skipping save');
        return;
      }

      // Save IDs as comma-separated string
      await _storage.saveString('favorite_ids', _favoriteIds.join(','));

      // In a real app, you'd serialize _favorites to JSON and save
      // For now, we'll just save the IDs
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  /// Add a favorite programmatically
  Future<void> addFavorite(String id, Map<String, dynamic> item) async {
    if (!isFavorite(id)) {
      _favoriteIds.add(id);
      _favorites.add(item);
      await _saveFavorites();
    }
  }

  /// Remove a favorite programmatically
  Future<void> removeFavorite(String id) async {
    if (isFavorite(id)) {
      _favoriteIds.remove(id);
      _favorites.removeWhere((fav) => fav['id'] == id);
      await _saveFavorites();
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    _favoriteIds.clear();
    _favorites.clear();

    try {
      if (Get.isRegistered<StorageService>()) {
        await _storage.saveString('favorite_ids', '');
      }
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }

  /// Get favorites by type
  List<Map<String, dynamic>> getFavoritesByType(String type) {
    return _favorites.where((item) => item['type'] == type).toList();
  }
}
