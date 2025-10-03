import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../profile/profile_screen.dart';
import '../artworks/artworks_screen.dart';
import '../favorites/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _screens = [
    const _HomeTab(),
    const ArtworksScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musée des Civilisations Noires'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.museum, size: 60, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Bienvenue',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text('Sections', style: AppTextStyles.h3),
            const SizedBox(height: 16),

            // Grille de sections
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildSectionCard(
                  context: context,
                  icon: Icons.palette,
                  title: 'Œuvres',
                  color: Colors.orange,
                  onTap: () {
                    // Changer vers l'onglet Explorer
                    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                    homeState?._changeTab(1);
                  },
                ),
                _buildSectionCard(
                  context: context,
                  icon: Icons.room,
                  title: 'Salles',
                  color: Colors.blue,
                  onTap: () {
                    // TODO: Naviguer vers les salles
                  },
                ),
                _buildSectionCard(
                  context: context,
                  icon: Icons.view_in_ar,
                  title: 'Visite 3D',
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Naviguer vers la visite 3D
                  },
                ),
                _buildSectionCard(
                  context: context,
                  icon: Icons.headphones,
                  title: 'Audio-guides',
                  color: Colors.green,
                  onTap: () {
                    // TODO: Naviguer vers les audio-guides
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

