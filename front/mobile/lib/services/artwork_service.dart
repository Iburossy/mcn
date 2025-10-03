import 'package:logger/logger.dart';
import '../models/artwork.dart';
import 'cache_service.dart';
import 'api_service.dart';

class ArtworkService {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();
  Future<Map<String, dynamic>> getArtworks({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool forceRefresh = false,
  }) async {
    try {
      // Vérifier le cache si pas de recherche/filtre et pas de refresh forcé
      if (!forceRefresh && page == 1 && category == null && search == null) {
        final cachedArtworks = CacheService.getCachedArtworks();
        if (cachedArtworks != null) {
          try {
            final artworks = cachedArtworks
                .map((json) => Artwork.fromJson(Map<String, dynamic>.from(json as Map)))
                .toList();
            
            return {
              'success': true,
              'artworks': artworks,
              'fromCache': true,
              'pagination': {
                'currentPage': page,
                'totalPages': artworks.length < limit ? page : page + 1,
                'totalItems': artworks.length,
              },
            };
          } catch (e) {
            _logger.w('Erreur cache, rechargement depuis API', error: e);
            // Vider le cache corrompu
            await CacheService.clearArtworks();
          }
        }
      }

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiService.get('/artworks', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        
        final artworks = (data as List)
            .map((json) => Artwork.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();

        // Mettre en cache si c'est la première page sans filtre
        if (page == 1 && category == null && search == null) {
          final artworksJson = artworks.map((a) => a.toJson()).toList();
          await CacheService.cacheArtworks(artworksJson);
        }

        return {
          'success': true,
          'artworks': artworks,
          'fromCache': false,
          'pagination': {
            'currentPage': page,
            'totalPages': artworks.length < limit ? page : page + 1,
            'totalItems': artworks.length,
          },
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Erreur lors du chargement des œuvres',
      };
    } catch (e) {
      _logger.e('Erreur getArtworks', error: e);
      return {
        'success': false,
        'message': 'Erreur réseau: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getArtworkById(String id, {bool forceRefresh = false}) async {
    try {
      // Vérifier le cache
      if (!forceRefresh) {
        final cachedArtwork = CacheService.getCachedArtwork(id);
        if (cachedArtwork != null) {
          try {
            return {
              'success': true,
              'artwork': Artwork.fromJson(Map<String, dynamic>.from(cachedArtwork as Map)),
              'fromCache': true,
            };
          } catch (e) {
            _logger.w('Erreur cache artwork, rechargement depuis API', error: e);
            // Continuer pour charger depuis l'API
          }
        }
      }

      final response = await _apiService.get('/artworks/$id');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final artwork = Artwork.fromJson(Map<String, dynamic>.from(response.data['data'] as Map));
        
        // Mettre en cache
        await CacheService.cacheArtwork(id, artwork.toJson());
        
        return {
          'success': true,
          'artwork': artwork,
          'fromCache': false,
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Œuvre non trouvée',
      };
    } catch (e) {
      _logger.e('Erreur getArtworkById', error: e);
      return {
        'success': false,
        'message': 'Erreur réseau: ${e.toString()}',
      };
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get('/artworks/categories');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<String>.from(response.data['data'] ?? []);
      }

      return [];
    } catch (e) {
      _logger.e('Erreur getCategories', error: e);
      return [];
    }
  }
}
