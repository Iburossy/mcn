import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/artwork.dart';
import '../../services/artwork_service.dart';
import '../../services/cache_service.dart';
import '../../providers/language_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../video/video_player_screen.dart';
import '../../widgets/compact_audio_player.dart';

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
  bool _isDescriptionExpanded = false;

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

    final l10n = AppLocalizations.of(context)!;
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
                  isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
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
                _buildInfoChip(Icons.person_outline, _artwork!.artist, AppColors.primary),

                const SizedBox(height: 24),

                // Boutons Audio, Vidéo, Traduction et Modèle 3D
                _buildActionBar(l10n, language),

                const SizedBox(height: 16),

                // Description
                _buildDescriptionSection(l10n, language),

                const SizedBox(height: 24),

                // Informations principales (avec matériaux)
                _buildInfoCard(l10n, language),

                // Contexte culturel
                if (_artwork!.getCulturalContext(language) != null) ...[
                  const SizedBox(height: 24),
                  _buildSection(
                    l10n.culturalContext,
                    Text(
                      _artwork!.getCulturalContext(language)!,
                      style: AppTextStyles.body1.copyWith(height: 1.6),
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
              cacheManager: CacheService.customCacheManager,
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

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(AppLocalizations l10n, String language) {
    final audioUrl = _artwork!.getAudioGuide(language) ?? _artwork!.getAudio(language);
    final hasVideo = _artwork!.getVideoGuide(language) != null || _artwork!.video != null;
    final has3DModel = _artwork!.model3D != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lecteur audio compact (sur sa propre ligne)
        if (audioUrl != null) ...[
          CompactAudioPlayer(audioUrl: audioUrl),
          const SizedBox(height: 12),
        ],

        // Ligne avec Vidéo, Traduction et Modèle 3D
        Row(
          children: [
            // Bouton Vidéo (icône seule)
            if (hasVideo) ...[
              _buildIconButton(
                icon: Icons.videocam,
                color: AppColors.secondary,
                onTap: () => _playVideo(context, language),
              ),
              const SizedBox(width: 12),
            ],

            // Bouton Traduction/Langue
            _buildIconButton(
              icon: Icons.translate,
              color: AppColors.accent,
              onTap: () => _showLanguageSelector(context),
            ),

            if (has3DModel) const SizedBox(width: 12),

            // Bouton Modèle 3D avec texte
            if (has3DModel)
              Expanded(
                child: _buildTextIconButton(
                  icon: Icons.view_in_ar,
                  label: l10n.virtualTour,
                  color: Colors.green,
                  onTap: () {
                    // TODO: Afficher le modèle 3D
                    Helpers.showInfo(context, 'Visualisation 3D à venir');
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildTextIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playVideo(BuildContext context, String language) {
    final videoUrl = _artwork!.getVideoGuide(language) ?? _artwork!.video;
    
    if (videoUrl == null) {
      Helpers.showError(context, 'Aucune vidéo disponible');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: videoUrl,
          title: _artwork!.getTitle(language),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 24),
              ...LanguageProvider.supportedLocales.map((locale) {
                final isSelected = languageProvider.currentLanguage == locale.languageCode;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                  title: Text(
                    languageProvider.getLanguageName(locale.languageCode),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    languageProvider.setLanguage(locale.languageCode);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n, String language) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.category_outlined, l10n.category, _artwork!.category),
            const Divider(height: 24),
            _buildInfoRow(Icons.calendar_today_outlined, l10n.year, _artwork!.period),
            const Divider(height: 24),
            _buildInfoRow(Icons.public_outlined, l10n.origin, _artwork!.origin),
            if (_artwork!.getFormattedDimensions() != null) ...[
              const Divider(height: 24),
              _buildInfoRow(Icons.straighten_outlined, l10n.dimensions, _artwork!.getFormattedDimensions()!),
            ],
            if (_artwork!.materials != null && _artwork!.materials!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRowWithChips(
                Icons.construction_outlined,
                l10n.materials,
                _artwork!.materials!,
              ),
            ],
            if (_artwork!.viewCount > 0) ...[
              const Divider(height: 24),
              _buildInfoRow(Icons.visibility_outlined, l10n.viewCount, '${_artwork!.viewCount}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowWithChips(IconData icon, String label, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.body2),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: items.map((item) => Chip(
                  label: Text(
                    item,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(AppLocalizations l10n, String language) {
    final description = _artwork!.getDescription(language);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.description, style: AppTextStyles.h2),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppTextStyles.body1.copyWith(height: 1.6),
          maxLines: _isDescriptionExpanded ? null : 2,
          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (description.length > 100) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Text(
              _isDescriptionExpanded ? 'Voir moins' : 'Voir plus',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h2),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.body2),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
