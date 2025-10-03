import 'package:flutter/foundation.dart';
import '../models/artwork.dart';
import '../services/artwork_service.dart';

class ArtworkProvider with ChangeNotifier {
  final ArtworkService _artworkService = ArtworkService();

  List<Artwork> _artworks = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _selectedCategory;
  String? _searchQuery;

  List<Artwork> get artworks => _artworks;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _currentPage < _totalPages;
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;

  Future<void> loadArtworks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _artworks.clear();
    }

    if (_isLoading || _isLoadingMore) return;

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final result = await _artworkService.getArtworks(
        page: _currentPage,
        limit: 20,
        category: _selectedCategory,
        search: _searchQuery,
      );

      if (result['success']) {
        final newArtworks = result['artworks'] as List<Artwork>;
        final pagination = result['pagination'];

        if (_currentPage == 1) {
          _artworks = newArtworks;
        } else {
          _artworks.addAll(newArtworks);
        }

        _totalPages = pagination['totalPages'] ?? 1;
        _currentPage++;
      } else {
        _error = result['message'];
      }
    } catch (e) {
      _error = 'Erreur: ${e.toString()}';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> searchArtworks(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    await loadArtworks(refresh: true);
  }

  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    await loadArtworks(refresh: true);
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = null;
    loadArtworks(refresh: true);
  }
}
