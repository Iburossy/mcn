import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vous n\'êtes pas connecté',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            );
          }

          final user = authProvider.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Nom
                Text(
                  user.name,
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: 8),

                // Téléphone
                Text(
                  user.phoneNumber,
                  style: AppTextStyles.body2,
                ),
                
                if (user.email != null && user.email!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.email!,
                    style: AppTextStyles.body2.copyWith(color: Colors.grey),
                  ),
                ],

                const SizedBox(height: 32),

                // Options
                _buildOption(
                  icon: Icons.favorite_outline,
                  title: 'Mes favoris',
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.history,
                  title: 'Historique',
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.help_outline,
                  title: 'Aide',
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.logout,
                  title: 'Déconnexion',
                  onTap: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  isDestructive: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
