import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/artwork.dart';
import '../../services/artwork_service.dart';
import '../../providers/language_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final String artworkId;

  const ArtworkDetailScreen({
    super.key,
    required this.artworkId,
  });

  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  final ArtworkService _artworkService = ArtworkService();
  Artwork? _artwork;
  bool _isLoading = true;
  String? _error;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadArtwork();
  }

  Future<void> _loadArtwork() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _artworkService.getArtworkById(widget.artworkId);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _artwork = result['artwork'];
        } else {
          _error = result['message'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>().currentLanguage;
    final favoritesProvider = context.watch<FavoritesProvider>();
    
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildContent(language, favoritesProvider),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_error!, style: AppTextStyles.body1),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadArtwork,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String language, FavoritesProvider favoritesProvider) {
    if (_artwork == null) return const SizedBox();

    final isFavorite = favoritesProvider.isFavorite(_artwork!.id);

    return CustomScrollView(
      slivers: [
        // AppBar avec image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageCarousel(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                favoritesProvider.toggleFavorite(_artwork!.id);
                Helpers.showSuccess(
                  context,
                  isFavorite ? 'Retiré des favoris' : 'Ajouté aux favoris',
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Partager
              },
            ),
          ],
        ),

        // Contenu
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  _artwork!.getTitle(language),
                  style: AppTextStyles.h1,
                ),

                const SizedBox(height: 8),

                // Artiste
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      _artwork!.artist,
                      style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Informations
                _buildInfoRow(Icons.category_outlined, 'Catégorie', _artwork!.category),
                _buildInfoRow(Icons.calendar_today_outlined, 'Période', _artwork!.period),

                const SizedBox(height: 24),

                // Description
                const Text('Description', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(
                  _artwork!.getDescription(language),
                  style: AppTextStyles.body1.copyWith(height: 1.6),
                ),

                const SizedBox(height: 24),

                // Audio-guide
                if (_artwork!.audioGuide != null) ...[
                  const Text('Audio-guide', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.headphones, color: AppColors.primary),
                      title: const Text('Écouter l\'audio-guide'),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: () {
                        // TODO: Lire l'audio-guide
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // QR Code
                if (_artwork!.qrCode != null) ...[
                  const Text('QR Code', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code, size: 100, color: AppColors.primary),
                          const SizedBox(height: 8),
                          Text(
                            'Scannez ce code dans le musée',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    if (_artwork!.images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: _artwork!.images.length,
          onPageChanged: (index) {
            setState(() => _currentImageIndex = index);
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: _artwork!.images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.error_outline, size: 64, color: Colors.grey),
                ),
              ),
            );
          },
        ),

        // Indicateur de page
        if (_artwork!.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _artwork!.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTextStyles.body2),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
