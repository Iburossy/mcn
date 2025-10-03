import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Card de prévisualisation vidéo avec bouton play
class VideoThumbnailCard extends StatelessWidget {
  final String? thumbnailUrl;
  final String title;
  final VoidCallback onTap;

  const VideoThumbnailCard({
    super.key,
    this.thumbnailUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail ou placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.3),
                    AppColors.secondary.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: thumbnailUrl != null
                  ? Image.network(
                      thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),

            // Overlay sombre
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),

            // Bouton play
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),

            // Titre en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.video_library,
        size: 64,
        color: Colors.white,
      ),
    );
  }
}
