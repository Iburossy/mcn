# 🎨 Frontend - Musée des Civilisations Noires

## Structure du Projet

```
front/
├── web/          # Application React (TypeScript) pour le web
└── mobile/       # Application Flutter pour iOS/Android
```

---

## 🌐 Application Web (React)

### Installation

```bash
cd web
npm install
```

### Démarrage

```bash
npm start
```

L'application sera accessible sur **http://localhost:3000**

### Build Production

```bash
npm run build
```

### Technologies

- React 18 + TypeScript
- React Router v6
- Axios
- Tailwind CSS
- Three.js / React Three Fiber
- Firebase SDK

---

## 📱 Application Mobile (Flutter)

### Installation

```bash
cd mobile
flutter pub get
```

### Démarrage

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (pour tester)
flutter run -d chrome
```

### Build Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Technologies

- Flutter 3.x
- Dart 3.x
- Provider / Riverpod
- Dio
- Firebase Auth
- Firebase Messaging
- QR Code Scanner

---

## 🔗 Configuration Backend

Les deux applications se connectent au backend Node.js :

**Development :**
```
http://localhost:5000/api
```

**Production :**
```
https://api.musee-civilisations.sn/api
```

---

## 📚 Documentation

- [Architecture Frontend](../FRONTEND_ARCHITECTURE.md)
- [Guide Firebase](../FIREBASE_SETUP.md)
- [API Documentation](../back/API_DOCUMENTATION.md)

---

## 🚀 Déploiement

### Web (React)

```bash
# Firebase Hosting
firebase deploy --only hosting

# Vercel
vercel --prod

# Netlify
netlify deploy --prod
```

### Mobile (Flutter)

- **Android** : Google Play Console
- **iOS** : Apple App Store Connect

---

**Bon développement ! 🎉**
