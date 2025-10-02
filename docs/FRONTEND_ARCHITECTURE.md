# 🎨 Architecture Frontend - Musée des Civilisations Noires

## 📁 Structure du Projet

```
musee/
├── back/                          # Backend Node.js/Express
│   └── ...
├── front/
│   ├── web/                       # Application React (Web)
│   │   ├── public/
│   │   ├── src/
│   │   │   ├── components/        # Composants réutilisables
│   │   │   ├── pages/             # Pages de l'application
│   │   │   ├── services/          # API calls
│   │   │   ├── contexts/          # Context API (state management)
│   │   │   ├── hooks/             # Custom hooks
│   │   │   ├── utils/             # Utilitaires
│   │   │   ├── types/             # TypeScript types
│   │   │   └── App.tsx
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── mobile/                    # Application Flutter (iOS/Android)
│       ├── lib/
│       │   ├── models/            # Modèles de données
│       │   ├── services/          # API services
│       │   ├── screens/           # Écrans de l'app
│       │   ├── widgets/           # Widgets réutilisables
│       │   ├── providers/         # State management (Provider/Riverpod)
│       │   ├── utils/             # Utilitaires
│       │   └── main.dart
│       ├── android/
│       ├── ios/
│       └── pubspec.yaml
│
└── docs/
```

---

## 🌐 Application Web (React + TypeScript)

### Technologies

- **React 18** avec TypeScript
- **React Router** pour la navigation
- **Axios** pour les appels API
- **Context API** ou **Redux Toolkit** pour le state management
- **Tailwind CSS** pour le styling
- **Three.js / React Three Fiber** pour la visite virtuelle 3D
- **Firebase SDK** pour l'authentification

### Fonctionnalités Principales

1. **Page d'accueil**
   - Présentation du musée
   - Œuvres populaires
   - Appel à l'action (Scanner QR / Explorer)

2. **Catalogue des œuvres**
   - Liste paginée avec filtres
   - Recherche
   - Tri par catégorie, période, origine

3. **Détails d'une œuvre**
   - Informations complètes (multilingue)
   - Galerie d'images
   - Lecteur audio
   - Vidéo (si disponible)
   - Contexte culturel

4. **Visite virtuelle 3D**
   - Navigation dans les salles en 3D
   - Interaction avec les œuvres
   - Mini-carte de navigation

5. **Authentification**
   - Connexion locale (téléphone + PIN)
   - Google Sign-In
   - Apple Sign-In

6. **Dashboard Admin** (si admin/curator)
   - Gestion des œuvres
   - Gestion des salles
   - Statistiques
   - Envoi de notifications

---

## 📱 Application Mobile (Flutter)

### Technologies

- **Flutter 3.x**
- **Dart 3.x**
- **Provider** ou **Riverpod** pour le state management
- **Dio** pour les appels API
- **Firebase Auth** pour l'authentification
- **Firebase Messaging** pour les notifications push
- **QR Code Scanner** pour scanner les QR codes
- **Cached Network Image** pour le cache des images
- **Shared Preferences** pour le stockage local
- **Flutter Secure Storage** pour les tokens

### Fonctionnalités Principales

1. **Onboarding**
   - Introduction au musée
   - Permissions (caméra, notifications)

2. **Scanner QR Code**
   - Scanner le QR code d'une œuvre
   - Affichage immédiat des détails

3. **Catalogue des œuvres**
   - Liste avec images
   - Filtres et recherche
   - Mode offline (cache)

4. **Détails d'une œuvre**
   - Informations multilingues
   - Galerie d'images
   - Lecteur audio intégré
   - Partage

5. **Historique de visite**
   - Œuvres consultées
   - Temps passé
   - Statistiques personnelles

6. **Authentification**
   - Connexion locale (téléphone + PIN)
   - Google Sign-In
   - Apple Sign-In (iOS)

7. **Notifications Push**
   - Nouvelles œuvres
   - Événements
   - Rappels de visite

8. **Mode Offline**
   - Cache des œuvres consultées
   - Synchronisation automatique

---

## 🔗 API Integration

### Base URL

```typescript
// Development
const API_BASE_URL = 'http://localhost:5000/api';

// Production
const API_BASE_URL = 'https://api.musee-civilisations.sn/api';
```

### Endpoints Principaux

```typescript
// Artworks
GET    /artworks                    // Liste des œuvres
GET    /artworks/:id                // Détails d'une œuvre
GET    /artworks/qr/:qrCode         // Œuvre par QR code
GET    /artworks/popular            // Œuvres populaires

// Rooms
GET    /rooms                       // Liste des salles
GET    /rooms/:id                   // Détails d'une salle

// Auth
POST   /auth/register               // Inscription locale
POST   /auth/login                  // Connexion locale
POST   /auth/google                 // Connexion Google
POST   /auth/apple                  // Connexion Apple
GET    /auth/me                     // Profil utilisateur
POST   /auth/fcm-token              // Enregistrer token FCM

// Visits
POST   /visits                      // Enregistrer une visite
GET    /visits/user                 // Historique utilisateur

// Notifications (Admin)
POST   /notifications/send          // Envoyer notification
POST   /notifications/broadcast     // Broadcast
```

---

## 🎨 Design System

### Couleurs

```css
/* Palette principale */
--primary: #8B4513;        /* Marron (terre africaine) */
--secondary: #DAA520;      /* Or (richesse culturelle) */
--accent: #DC143C;         /* Rouge (vitalité) */
--dark: #2C1810;           /* Marron foncé */
--light: #F5E6D3;          /* Beige clair */

/* Neutres */
--white: #FFFFFF;
--black: #000000;
--gray-100: #F7F7F7;
--gray-200: #E5E5E5;
--gray-300: #D4D4D4;
--gray-500: #737373;
--gray-700: #404040;
--gray-900: #171717;

/* Status */
--success: #22C55E;
--warning: #F59E0B;
--error: #EF4444;
--info: #3B82F6;
```

### Typographie

```css
/* Fonts */
--font-primary: 'Inter', sans-serif;
--font-heading: 'Playfair Display', serif;
--font-mono: 'Fira Code', monospace;

/* Sizes */
--text-xs: 0.75rem;      /* 12px */
--text-sm: 0.875rem;     /* 14px */
--text-base: 1rem;       /* 16px */
--text-lg: 1.125rem;     /* 18px */
--text-xl: 1.25rem;      /* 20px */
--text-2xl: 1.5rem;      /* 24px */
--text-3xl: 1.875rem;    /* 30px */
--text-4xl: 2.25rem;     /* 36px */
```

### Spacing

```css
--spacing-1: 0.25rem;    /* 4px */
--spacing-2: 0.5rem;     /* 8px */
--spacing-3: 0.75rem;    /* 12px */
--spacing-4: 1rem;       /* 16px */
--spacing-6: 1.5rem;     /* 24px */
--spacing-8: 2rem;       /* 32px */
--spacing-12: 3rem;      /* 48px */
--spacing-16: 4rem;      /* 64px */
```

---

## 🔐 Authentification Flow

### React (Web)

```typescript
// 1. Google Sign-In
import { signInWithPopup, GoogleAuthProvider } from 'firebase/auth';

const signInWithGoogle = async () => {
  const provider = new GoogleAuthProvider();
  const result = await signInWithPopup(auth, provider);
  const idToken = await result.user.getIdToken();
  
  // Envoyer au backend
  const response = await axios.post('/auth/google', { idToken });
  const { token } = response.data.data;
  
  // Stocker le JWT
  localStorage.setItem('auth_token', token);
};
```

### Flutter (Mobile)

```dart
// 1. Google Sign-In
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = 
      await googleUser!.authentication;
  
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  final userCredential = 
      await FirebaseAuth.instance.signInWithCredential(credential);
  final idToken = await userCredential.user?.getIdToken();
  
  // Envoyer au backend
  final response = await dio.post('/auth/google', 
    data: {'idToken': idToken}
  );
  
  final token = response.data['data']['token'];
  await storage.write(key: 'auth_token', value: token);
}
```

---

## 📦 State Management

### React (Context API)

```typescript
// contexts/AuthContext.tsx
interface AuthContextType {
  user: User | null;
  token: string | null;
  login: (phone: string, pin: string) => Promise<void>;
  loginWithGoogle: () => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  
  // ... implementation
  
  return (
    <AuthContext.Provider value={{ user, token, login, logout, ... }}>
      {children}
    </AuthContext.Provider>
  );
};
```

### Flutter (Provider)

```dart
// providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  
  User? get user => _user;
  bool get isAuthenticated => _token != null;
  
  Future<void> login(String phone, String pin) async {
    final response = await _apiService.login(phone, pin);
    _user = response.user;
    _token = response.token;
    await _storage.write(key: 'auth_token', value: _token);
    notifyListeners();
  }
  
  Future<void> loginWithGoogle() async {
    // ... implementation
  }
  
  void logout() {
    _user = null;
    _token = null;
    _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
```

---

## 🌍 Internationalisation (i18n)

### React

```typescript
// i18n/index.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      fr: { translation: require('./locales/fr.json') },
      en: { translation: require('./locales/en.json') },
      wo: { translation: require('./locales/wo.json') }
    },
    lng: 'fr',
    fallbackLng: 'fr',
    interpolation: { escapeValue: false }
  });
```

### Flutter

```dart
// l10n/app_localizations.dart
class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = 
      _AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale('fr', ''),
    Locale('en', ''),
    Locale('wo', ''),
  ];
  
  String get welcome => Intl.message('Bienvenue', name: 'welcome');
  // ...
}
```

---

## 🚀 Déploiement

### React Web

```bash
# Build
npm run build

# Déployer sur Firebase Hosting
firebase deploy --only hosting

# Ou sur Vercel
vercel --prod
```

### Flutter Mobile

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Publier sur stores
# - Google Play Console
# - Apple App Store Connect
```

---

## 📊 Performance

### React

- **Code Splitting** : React.lazy() et Suspense
- **Memoization** : useMemo, useCallback, React.memo
- **Image Optimization** : WebP, lazy loading
- **Bundle Analysis** : webpack-bundle-analyzer

### Flutter

- **Lazy Loading** : ListView.builder
- **Image Caching** : cached_network_image
- **State Optimization** : Provider selectors
- **Build Optimization** : const constructors

---

## 🧪 Tests

### React

```bash
# Unit tests
npm test

# E2E tests (Cypress)
npm run cypress:open
```

### Flutter

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widgets/

# Integration tests
flutter drive --target=test_driver/app.dart
```

---

**Architecture prête pour le développement ! 🎉**
