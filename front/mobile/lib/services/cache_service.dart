import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Service de gestion du cache pour optimiser les performances
class CacheService {
  static const String _artworkBoxName = 'artworks';
  static const String _settingsBoxName = 'settings';
  static const Duration _cacheExpiration = Duration(minutes: 5); // Cache court pour avoir les données fraîches

  static Box? _artworkBox;
  static Box? _settingsBox;

  /// Initialiser Hive et les boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _artworkBox = await Hive.openBox(_artworkBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  /// Cache Manager personnalisé pour les images
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: 'customCacheKey'),
      fileService: HttpFileService(),
    ),
  );

  // ==================== ARTWORKS ====================

  /// Sauvegarder une liste d'œuvres
  static Future<void> cacheArtworks(List<Map<String, dynamic>> artworks) async {
    await _artworkBox?.put('artworks_list', {
      'data': artworks,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Récupérer les œuvres en cache
  static List<Map<String, dynamic>>? getCachedArtworks() {
    final cached = _artworkBox?.get('artworks_list');
    if (cached == null) return null;

    final timestamp = cached['timestamp'] as int;
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

    // Vérifier si le cache est expiré
    if (cacheAge > _cacheExpiration.inMilliseconds) {
      _artworkBox?.delete('artworks_list');
      return null;
    }

    return List<Map<String, dynamic>>.from(cached['data']);
  }

  /// Sauvegarder une œuvre individuelle
  static Future<void> cacheArtwork(String id, Map<String, dynamic> artwork) async {
    await _artworkBox?.put('artwork_$id', {
      'data': artwork,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Récupérer une œuvre en cache
  static Map<String, dynamic>? getCachedArtwork(String id) {
    final cached = _artworkBox?.get('artwork_$id');
    if (cached == null) return null;

    final timestamp = cached['timestamp'] as int;
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

    if (cacheAge > _cacheExpiration.inMilliseconds) {
      _artworkBox?.delete('artwork_$id');
      return null;
    }

    return cached['data'] as Map<String, dynamic>;
  }

  // ==================== SETTINGS ====================

  /// Sauvegarder une valeur
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }

  /// Récupérer une valeur
  static T? getSetting<T>(String key) {
    return _settingsBox?.get(key) as T?;
  }

  // ==================== CLEAR CACHE ====================

  /// Vider tout le cache
  static Future<void> clearAll() async {
    await _artworkBox?.clear();
    await customCacheManager.emptyCache();
  }

  /// Vider uniquement le cache des œuvres
  static Future<void> clearArtworks() async {
    await _artworkBox?.clear();
  }

  /// Invalider le cache d'une œuvre spécifique
  static Future<void> invalidateArtwork(String id) async {
    await _artworkBox?.delete('artwork_$id');
  }

  /// Invalider le cache de la liste des œuvres
  static Future<void> invalidateArtworksList() async {
    await _artworkBox?.delete('artworks_list');
  }

  /// Vider uniquement le cache des images
  static Future<void> clearImages() async {
    await customCacheManager.emptyCache();
  }

  /// Fermer les boxes (à appeler lors de la fermeture de l'app)
  static Future<void> close() async {
    await _artworkBox?.close();
    await _settingsBox?.close();
  }
}
