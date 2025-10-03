import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/map_launcher.dart';
import '../../utils/helpers.dart';
import '../../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Image du musée
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.museum,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nom du musée
            Center(
              child: Text(
                MuseumLocation.name,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // Section Localisation
            _buildSection(
              context,
              icon: Icons.location_on,
              title: l10n.location,
              content: MuseumLocation.address,
              onTap: () async {
                final success = await MapLauncher.openDirections();
                if (!success && context.mounted) {
                  Helpers.showError(context, 'Impossible d\'ouvrir la carte');
                }
              },
            ),

            const SizedBox(height: 16),

            // Bouton "Comment s'y rendre"
            ElevatedButton.icon(
              onPressed: () async {
                final success = await MapLauncher.startNavigation();
                if (!success && context.mounted) {
                  Helpers.showError(context, 'Impossible de démarrer la navigation');
                }
              },
              icon: const Icon(Icons.directions),
              label: Text(l10n.howToGetThere),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 24),

            // Section Contact
            _buildSection(
              context,
              icon: Icons.phone,
              title: l10n.phone,
              content: MuseumLocation.phone,
              onTap: () async {
                final success = await MapLauncher.callMuseum();
                if (!success && context.mounted) {
                  Helpers.showError(context, 'Impossible d\'appeler');
                }
              },
            ),

            const SizedBox(height: 16),

            _buildSection(
              context,
              icon: Icons.email,
              title: l10n.email,
              content: MuseumLocation.email,
              onTap: () async {
                final success = await MapLauncher.emailMuseum();
                if (!success && context.mounted) {
                  Helpers.showError(context, 'Impossible d\'envoyer un email');
                }
              },
            ),

            const SizedBox(height: 32),

            // Section Horaires
            Text(l10n.openingHours, style: AppTextStyles.h3),
            const SizedBox(height: 12),
            _buildInfoRow(l10n.mondayToFriday, '9h00 - 18h00'),
            _buildInfoRow(l10n.saturday, '10h00 - 17h00'),
            _buildInfoRow(l10n.sunday, l10n.closed),

            const SizedBox(height: 32),

            // Section Tarifs
            Text(l10n.ticketPrices, style: AppTextStyles.h3),
            const SizedBox(height: 12),
            _buildInfoRow(l10n.adult, '2000 FCFA'),
            _buildInfoRow(l10n.student, '1000 FCFA'),
            _buildInfoRow(l10n.child, l10n.free),

            const SizedBox(height: 32),

            // Version de l'app
            Center(
              child: Text(
                'Version 1.0.0',
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(content, style: AppTextStyles.body1),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body1),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
