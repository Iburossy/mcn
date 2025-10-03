import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/artwork_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/artwork_card.dart';
import '../artworks/artwork_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              if (favProvider.favoriteIds.isEmpty) return const SizedBox();
              
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  _showClearDialog(context, favProvider);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer3<FavoritesProvider, ArtworkProvider, LanguageProvider>(
        builder: (context, favProvider, artworkProvider, langProvider, child) {
          if (favProvider.favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun favori',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des œuvres à vos favoris',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            );
          }

          // Filtrer les œuvres favorites
          final favoriteArtworks = artworkProvider.artworks
              .where((artwork) => favProvider.isFavorite(artwork.id))
              .toList();

          if (favoriteArtworks.isEmpty && artworkProvider.artworks.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement des favoris...',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppDimensions.paddingMedium,
              mainAxisSpacing: AppDimensions.paddingMedium,
            ),
            itemCount: favoriteArtworks.length,
            itemBuilder: (context, index) {
              final artwork = favoriteArtworks[index];
              
              return ArtworkCard(
                artwork: artwork,
                language: langProvider.currentLanguage,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtworkDetailScreen(
                        artworkId: artwork.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer tous les favoris'),
        content: const Text('Êtes-vous sûr de vouloir supprimer tous vos favoris ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              provider.clearFavorites();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
