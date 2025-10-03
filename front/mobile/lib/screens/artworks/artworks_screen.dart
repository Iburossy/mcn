import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/artwork_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/artwork_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/empty_state.dart';
import 'artwork_detail_screen.dart';

class ArtworksScreen extends StatefulWidget {
  const ArtworksScreen({super.key});

  @override
  State<ArtworksScreen> createState() => _ArtworksScreenState();
}

class _ArtworksScreenState extends State<ArtworksScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArtworkProvider>().loadArtworks(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<ArtworkProvider>();
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadArtworks();
      }
    }
  }

  void _onSearch(String query) {
    context.read<ArtworkProvider>().searchArtworks(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Œuvres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: SearchBarWidget(
              controller: _searchController,
              hint: 'Rechercher une œuvre...',
              onSubmitted: _onSearch,
              onClear: () {
                _searchController.clear();
                _onSearch('');
              },
            ),
          ),

          // Liste des œuvres
          Expanded(
            child: Consumer<ArtworkProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.artworks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.artworks.isEmpty) {
                  return EmptyState(
                    icon: Icons.error_outline,
                    title: 'Erreur',
                    subtitle: provider.error,
                    action: ElevatedButton(
                      onPressed: () => provider.loadArtworks(refresh: true),
                      child: const Text('Réessayer'),
                    ),
                  );
                }

                if (provider.artworks.isEmpty) {
                  return const EmptyState(
                    icon: Icons.palette_outlined,
                    title: 'Aucune œuvre trouvée',
                    subtitle: 'Essayez de modifier vos filtres',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadArtworks(refresh: true),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: AppDimensions.paddingMedium,
                      mainAxisSpacing: AppDimensions.paddingMedium,
                    ),
                    itemCount: provider.artworks.length + (provider.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.artworks.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final artwork = provider.artworks[index];
                      final language = context.watch<LanguageProvider>().currentLanguage;
                      
                      return ArtworkCard(
                        artwork: artwork,
                        language: language,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<ArtworkProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtres', style: AppTextStyles.h2),
                      TextButton(
                        onPressed: () {
                          provider.clearFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Catégorie', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Toutes'),
                        selected: provider.selectedCategory == null,
                        onSelected: (selected) {
                          provider.filterByCategory(null);
                          Navigator.pop(context);
                        },
                      ),
                      FilterChip(
                        label: const Text('Sculpture'),
                        selected: provider.selectedCategory == 'Sculpture',
                        onSelected: (selected) {
                          provider.filterByCategory('Sculpture');
                          Navigator.pop(context);
                        },
                      ),
                      FilterChip(
                        label: const Text('Peinture'),
                        selected: provider.selectedCategory == 'Peinture',
                        onSelected: (selected) {
                          provider.filterByCategory('Peinture');
                          Navigator.pop(context);
                        },
                      ),
                      FilterChip(
                        label: const Text('Textile'),
                        selected: provider.selectedCategory == 'Textile',
                        onSelected: (selected) {
                          provider.filterByCategory('Textile');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
