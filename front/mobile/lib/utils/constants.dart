import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Couleurs de l'application
class AppColors {
  static const Color primary = Color(0xFFD2691E); // Marron/Orange (couleur musée)
  static const Color secondary = Color(0xFF8B4513); // Marron foncé
  static const Color accent = Color(0xFFFFA500); // Orange
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
}

/// Configuration API
class ApiConfig {
  // Charger depuis .env
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000/api';
  
  static Duration get timeout {
    final timeoutSeconds = int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30') ?? 30;
    return Duration(seconds: timeoutSeconds);
  }
  
  // Pour débugger, afficher l'URL utilisée
  static String get debugUrl => baseUrl;
}

/// Clés de stockage local
class StorageKeys {
  static const String onboardingComplete = 'onboarding_complete';
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String language = 'language';
  static const String favoriteArtworks = 'favorite_artworks';
}

/// Routes de l'application
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String artworks = '/artworks';
  static const String artworkDetail = '/artwork/:id';
  static const String rooms = '/rooms';
  static const String roomDetail = '/room/:id';
  static const String virtualTour = '/virtual-tour';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
}

/// Langues supportées
enum AppLanguage {
  fr('Français', 'fr'),
  en('English', 'en'),
  wo('Wolof', 'wo');

  final String name;
  final String code;

  const AppLanguage(this.name, this.code);
}

/// Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
}

/// Styles de texte
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
