import 'package:logger/logger.dart';
import '../models/artwork.dart';
import 'api_service.dart';

class ArtworkService {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> getArtworks({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiService.get('/artworks', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Le backend retourne: { success: true, data: [...] }
        final data = response.data['data'];
        
        // data est directement un tableau d'œuvres
        final artworks = (data as List)
            .map((json) => Artwork.fromJson(json))
            .toList();

        // Pagination basique (pas de pagination dans la réponse backend)
        return {
          'success': true,
          'artworks': artworks,
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

  Future<Map<String, dynamic>> getArtworkById(String id) async {
    try {
      final response = await _apiService.get('/artworks/$id');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final artwork = Artwork.fromJson(response.data['data']);
        return {
          'success': true,
          'artwork': artwork,
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
