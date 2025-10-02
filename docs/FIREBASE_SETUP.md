# 🔥 Configuration Firebase - Musée des Civilisations Noires

## Guide d'Installation Firebase

### Étape 1 : Connexion à Firebase

```bash
firebase login
```

Si vous êtes sur un serveur distant ou sans navigateur :
```bash
firebase login --no-localhost
```

### Étape 2 : Initialiser Firebase dans le projet

```bash
cd back
firebase init
```

**Sélectionner les services suivants :**
- ✅ **Authentication** (pour Google/Apple Sign-In)
- ✅ **Cloud Messaging** (pour les notifications push)
- ✅ **Hosting** (optionnel, pour déployer le frontend)

**Configuration recommandée :**
1. **Créer un nouveau projet** ou sélectionner un existant
2. **Nom du projet** : `musee-civilisations-noires` (ou votre choix)
3. **Authentication** : Activer Google et Apple
4. **Messaging** : Accepter la configuration par défaut

### Étape 3 : Créer un Service Account

1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionner votre projet
3. **Paramètres du projet** (⚙️ en haut à gauche) → **Comptes de service**
4. Cliquer sur **Générer une nouvelle clé privée**
5. Télécharger le fichier JSON

### Étape 4 : Configurer les variables d'environnement

Ouvrir le fichier JSON téléchargé et copier les valeurs dans `.env` :

```env
# Configuration Firebase
FIREBASE_PROJECT_ID=votre-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@votre-project.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nVOTRE_CLE_PRIVEE\n-----END PRIVATE KEY-----\n"
FIREBASE_DATABASE_URL=https://votre-project.firebaseio.com
```

**⚠️ Important :** 
- Garder les guillemets autour de `FIREBASE_PRIVATE_KEY`
- Ne pas commiter le fichier `.env` (déjà dans `.gitignore`)
- Le fichier JSON du service account doit rester secret

### Étape 5 : Activer Google Sign-In

1. Dans Firebase Console → **Authentication** → **Sign-in method**
2. Activer **Google**
3. Configurer l'email du projet
4. Copier le **Web client ID** (pour le frontend Flutter)

### Étape 6 : Activer Apple Sign-In

1. Dans Firebase Console → **Authentication** → **Sign-in method**
2. Activer **Apple**
3. Configurer :
   - **Services ID** (depuis Apple Developer)
   - **OAuth code flow** (recommandé)
   - **Team ID** et **Key ID** (depuis Apple Developer)

**Prérequis Apple :**
- Compte Apple Developer (99$/an)
- App ID configuré
- Services ID créé
- Clé d'authentification générée

### Étape 7 : Configurer Cloud Messaging (FCM)

1. Dans Firebase Console → **Paramètres du projet** → **Cloud Messaging**
2. Copier la **Server key** (Legacy) si nécessaire
3. Pour Android : Télécharger `google-services.json`
4. Pour iOS : Télécharger `GoogleService-Info.plist`

**Ces fichiers seront utilisés dans le frontend Flutter.**

---

## 🚀 Commandes Firebase CLI Utiles

### Lister les projets
```bash
firebase projects:list
```

### Sélectionner un projet
```bash
firebase use <project-id>
```

### Voir la configuration actuelle
```bash
firebase projects:current
```

### Déployer les règles de sécurité
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

### Tester localement
```bash
firebase emulators:start
```

---

## 📱 Configuration Frontend Flutter

### Android (`android/app/google-services.json`)

1. Télécharger depuis Firebase Console
2. Placer dans `android/app/`
3. Ajouter dans `android/build.gradle` :
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

4. Ajouter dans `android/app/build.gradle` :
```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS (`ios/Runner/GoogleService-Info.plist`)

1. Télécharger depuis Firebase Console
2. Placer dans `ios/Runner/`
3. Ouvrir Xcode et ajouter le fichier au projet

### Packages Flutter requis

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  firebase_messaging: ^14.7.10
  google_sign_in: ^6.1.6
  sign_in_with_apple: ^5.0.0
```

---

## 🔐 Configuration OAuth

### Google Sign-In

**Backend (.env) :**
```env
GOOGLE_CLIENT_ID=votre-client-id.apps.googleusercontent.com
```

**Flutter :**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'VOTRE_WEB_CLIENT_ID',
);
```

### Apple Sign-In

**Backend (.env) :**
```env
APPLE_SERVICE_ID=com.votreapp.service
APPLE_TEAM_ID=VOTRE_TEAM_ID
APPLE_KEY_ID=VOTRE_KEY_ID
APPLE_PRIVATE_KEY_PATH=/path/to/AuthKey_XXXXX.p8
```

**Flutter :**
```dart
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);
```

---

## 🧪 Tester l'intégration

### Test 1 : Vérifier Firebase Admin SDK

```bash
cd back
npm run dev
```

Vérifier dans les logs :
```
✅ Firebase initialisé
```

### Test 2 : Tester l'authentification Google (via Postman)

```bash
POST http://localhost:5000/api/auth/google
Content-Type: application/json

{
  "idToken": "GOOGLE_ID_TOKEN_FROM_FRONTEND"
}
```

### Test 3 : Envoyer une notification test

```bash
POST http://localhost:5000/api/notifications/send
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "userId": "USER_ID",
  "title": "Test Notification",
  "body": "Ceci est un test"
}
```

---

## 📊 Structure des fichiers Firebase

```
back/
├── .firebaserc              # Configuration du projet Firebase
├── firebase.json            # Configuration des services Firebase
├── .env                     # Variables d'environnement (SECRET!)
├── serviceAccountKey.json   # Clé de service (SECRET! - ne pas commiter)
└── src/
    └── config/
        └── firebase.js      # Initialisation Firebase Admin SDK
```

---

## ⚠️ Sécurité

### À NE JAMAIS commiter :
- ❌ `.env`
- ❌ `serviceAccountKey.json`
- ❌ Clés privées Firebase
- ❌ Tokens d'accès

### À commiter :
- ✅ `.env.example` (template sans valeurs réelles)
- ✅ `firebase.json` (configuration publique)
- ✅ `.firebaserc` (référence au projet)
- ✅ Code source

### Vérifier `.gitignore` :
```gitignore
# Firebase
.env
serviceAccountKey.json
firebase-debug.log
.firebase/

# Secrets
*.pem
*.p8
*.key
```

---

## 🔄 Migration des utilisateurs existants

Si vous avez déjà des utilisateurs avec phoneNumber/PIN, ils peuvent continuer à se connecter normalement. Les nouveaux utilisateurs peuvent choisir :

1. **Authentification locale** : phoneNumber + PIN
2. **Google Sign-In** : OAuth Google
3. **Apple Sign-In** : OAuth Apple

Le modèle User supporte les 3 méthodes via le champ `authProvider`.

---

## 📚 Ressources

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Admin SDK Node.js](https://firebase.google.com/docs/admin/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Google Sign-In](https://developers.google.com/identity/sign-in/web)
- [Apple Sign-In](https://developer.apple.com/sign-in-with-apple/)

---

## 🎯 Prochaines étapes

1. ✅ Firebase CLI installé
2. 🔄 Créer/configurer le projet Firebase
3. ⏳ Télécharger le service account
4. ⏳ Configurer `.env`
5. ⏳ Activer Google/Apple Sign-In
6. ⏳ Implémenter les endpoints backend
7. ⏳ Intégrer dans Flutter

---

**Besoin d'aide ? Consultez la documentation officielle Firebase ou contactez l'équipe.**
