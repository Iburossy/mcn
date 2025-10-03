import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(StorageKeys.favoriteArtworks) ?? [];
    _favoriteIds = favorites.toSet();
    notifyListeners();
  }

  bool isFavorite(String artworkId) {
    return _favoriteIds.contains(artworkId);
  }

  Future<void> toggleFavorite(String artworkId) async {
    if (_favoriteIds.contains(artworkId)) {
      _favoriteIds.remove(artworkId);
    } else {
      _favoriteIds.add(artworkId);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(StorageKeys.favoriteArtworks, _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favoriteIds.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.favoriteArtworks);
    notifyListeners();
  }
}
