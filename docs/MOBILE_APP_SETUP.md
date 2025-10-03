# 📱 Application Mobile Flutter - Setup

## 🎯 Fonctionnalités Implémentées

### ✅ Onboarding (3 écrans)

**Écran 1 : Découvrez le Musée**
- Image d'illustration
- Titre et description
- Bouton "Suivant"

**Écran 2 : Visite Virtuelle 3D**
- Image d'illustration
- Titre et description
- Bouton "Suivant"

**Écran 3 : Explorez les Œuvres**
- Image d'illustration
- Titre et description
- Bouton "Commencer"

### ✅ Splash Screen

- Logo animé
- Titre du musée
- Loading indicator
- Navigation automatique vers onboarding ou home

### ✅ Structure de Base

```
lib/
├── models/              # Modèles de données
│   └── onboarding_item.dart
├── screens/             # Écrans de l'app
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   └── home/
│       └── home_screen.dart
├── utils/               # Utilitaires
│   └── constants.dart
└── main.dart
```

## 📦 Dépendances Ajoutées

```yaml
dependencies:
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^14.0.0
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Image
  cached_network_image: ^3.3.1
  
  # Smooth Page Indicator (onboarding)
  smooth_page_indicator: ^1.1.0
  
  # Intl & Localization
  intl: ^0.19.0
```

## 🎨 Design System

### Couleurs

```dart
AppColors.primary     // #D2691E (Marron/Orange)
AppColors.secondary   // #8B4513 (Marron foncé)
AppColors.accent      // #FFA500 (Orange)
AppColors.background  // #F5F5F5
```

### Styles de Texte

```dart
AppTextStyles.h1      // 32px, bold
AppTextStyles.h2      // 24px, bold
AppTextStyles.h3      // 20px, w600
AppTextStyles.body1   // 16px
AppTextStyles.body2   // 14px
AppTextStyles.caption // 12px
```

## 🚀 Installation

### 1. Installer les dépendances

```bash
cd front/mobile
flutter pub get
```

### 2. Ajouter les images d'onboarding

Créer les dossiers :
```bash
mkdir -p assets/images/onboarding
mkdir -p assets/icons
```

Ajouter 3 images :
- `assets/images/onboarding/onboarding_1.png`
- `assets/images/onboarding/onboarding_2.png`
- `assets/images/onboarding/onboarding_3.png`

### 3. Lancer l'application

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (pour tester)
flutter run -d chrome
```

## 📱 Workflow de l'App

```
Splash Screen (3s)
    ↓
Vérifier onboarding_complete
    ↓
├─ Non → Onboarding (3 écrans)
│          ↓
│      Home Screen
│
└─ Oui → Home Screen directement
```

## 🎮 Fonctionnement de l'Onboarding

### Navigation

- **Swipe** : Changer de page
- **Bouton "Suivant"** : Page suivante
- **Bouton "Passer"** : Aller directement au home
- **Bouton "Commencer"** : Terminer l'onboarding

### Indicateur de Page

- Utilise `smooth_page_indicator`
- Effet "Worm" animé
- Couleur primaire pour la page active

### Persistance

```dart
SharedPreferences.setBool('onboarding_complete', true);
```

L'onboarding ne s'affiche qu'une seule fois.

## 🔧 Configuration API

Dans `lib/utils/constants.dart` :

```dart
class ApiConfig {
  // Android Emulator
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // iOS Simulator
  // static const String baseUrl = 'http://localhost:5000/api';
  
  // Production
  // static const String baseUrl = 'https://api.musee.com/api';
}
```

## 📝 Prochaines Étapes

### À Implémenter

- [ ] Écran d'accueil avec sections
- [ ] Liste des œuvres
- [ ] Détail d'une œuvre
- [ ] Liste des salles
- [ ] Visite virtuelle 3D (WebView ou native)
- [ ] Favoris
- [ ] Profil utilisateur
- [ ] Paramètres (langue, notifications)
- [ ] Audio-guides
- [ ] Recherche
- [ ] Filtres
- [ ] Mode hors-ligne

### Services à Créer

```
lib/services/
├── api_service.dart       # Client HTTP
├── artwork_service.dart   # API œuvres
├── room_service.dart      # API salles
├── auth_service.dart      # Authentification
└── storage_service.dart   # Local storage
```

### Providers à Créer

```
lib/providers/
├── artwork_provider.dart  # State des œuvres
├── room_provider.dart     # State des salles
├── auth_provider.dart     # State auth
└── language_provider.dart # State langue
```

## 🎯 Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release

# Analyser le code
flutter analyze

# Formater le code
flutter format lib/

# Tests
flutter test

# Clean
flutter clean
```

## 📊 Structure Complète Prévue

```
lib/
├── models/
│   ├── artwork.dart
│   ├── room.dart
│   ├── user.dart
│   └── onboarding_item.dart
├── services/
│   ├── api_service.dart
│   ├── artwork_service.dart
│   ├── room_service.dart
│   └── auth_service.dart
├── providers/
│   ├── artwork_provider.dart
│   ├── room_provider.dart
│   └── auth_provider.dart
├── screens/
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── artworks/
│   ├── rooms/
│   ├── profile/
│   └── settings/
├── widgets/
│   ├── artwork_card.dart
│   ├── room_card.dart
│   └── custom_app_bar.dart
├── utils/
│   ├── constants.dart
│   ├── helpers.dart
│   └── validators.dart
└── main.dart
```

## ✅ Résumé

L'application mobile est maintenant configurée avec :
- ✅ Splash screen animé
- ✅ Onboarding de 3 écrans
- ✅ Navigation fluide
- ✅ Design system cohérent
- ✅ Structure modulaire
- ✅ Prête pour le développement

🎉 **Prêt à développer les fonctionnalités principales !**
