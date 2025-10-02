

# 🔥 Intégration Firebase Complète

## ✅ Fonctionnalités Implémentées

### 1. **Authentification Multi-Providers**
- ✅ Authentification locale (phoneNumber + PIN)
- ✅ Google Sign-In via Firebase
- ✅ Apple Sign-In via Firebase
- ✅ Gestion automatique des utilisateurs (création/connexion)

### 2. **Notifications Push (FCM)**
- ✅ Enregistrement des tokens FCM
- ✅ Envoi de notifications individuelles
- ✅ Envoi de notifications multiples
- ✅ Broadcast à tous les utilisateurs
- ✅ Notifications par topic
- ✅ Souscription/Désabonnement aux topics

---

## 📡 Nouveaux Endpoints API

### Authentification

#### Google Sign-In
```http
POST /api/auth/google
Content-Type: application/json

{
  "idToken": "GOOGLE_ID_TOKEN_FROM_FIREBASE_AUTH",
  "fcmToken": "FCM_DEVICE_TOKEN" (optionnel)
}
```

**Réponse :**
```json
{
  "success": true,
  "message": "Connexion Google réussie",
  "data": {
    "user": {
      "_id": "...",
      "firebaseUid": "google_uid",
      "email": "user@gmail.com",
      "name": "User Name",
      "authProvider": "google",
      "role": "visitor"
    },
    "token": "JWT_TOKEN"
  }
}
```

#### Apple Sign-In
```http
POST /api/auth/apple
Content-Type: application/json

{
  "idToken": "APPLE_ID_TOKEN_FROM_FIREBASE_AUTH",
  "fcmToken": "FCM_DEVICE_TOKEN" (optionnel)
}
```

#### Enregistrer un Token FCM
```http
POST /api/auth/fcm-token
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "fcmToken": "FCM_DEVICE_TOKEN"
}
```

#### Supprimer un Token FCM
```http
DELETE /api/auth/fcm-token
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "fcmToken": "FCM_DEVICE_TOKEN"
}
```

---

### Notifications Push

#### Envoyer à un utilisateur
```http
POST /api/notifications/send
Authorization: Bearer JWT_TOKEN (Admin/Curator)
Content-Type: application/json

{
  "userId": "USER_ID",
  "title": "Nouvelle exposition",
  "body": "Découvrez notre nouvelle collection",
  "data": {
    "artworkId": "65f...",
    "action": "view_artwork"
  },
  "imageUrl": "https://..." (optionnel)
}
```

#### Envoyer à plusieurs utilisateurs
```http
POST /api/notifications/send-multiple
Authorization: Bearer JWT_TOKEN (Admin/Curator)
Content-Type: application/json

{
  "userIds": ["USER_ID_1", "USER_ID_2"],
  "title": "Titre",
  "body": "Message"
}
```

#### Broadcast (tous les utilisateurs)
```http
POST /api/notifications/broadcast
Authorization: Bearer JWT_TOKEN (Admin uniquement)
Content-Type: application/json

{
  "title": "Annonce importante",
  "body": "Le musée sera fermé demain"
}
```

#### Envoyer par topic
```http
POST /api/notifications/topic
Authorization: Bearer JWT_TOKEN (Admin/Curator)
Content-Type: application/json

{
  "topic": "new_artworks",
  "title": "Nouvelle œuvre ajoutée",
  "body": "Masque Sénoufo disponible"
}
```

#### Souscrire à un topic
```http
POST /api/notifications/subscribe
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "topic": "new_artworks"
}
```

#### Se désabonner d'un topic
```http
POST /api/notifications/unsubscribe
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "topic": "new_artworks"
}
```

---

## 🔧 Configuration Requise

### 1. Variables d'environnement (.env)

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=musee-civilisations-noires
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@musee-civilisations-noires.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n"
FIREBASE_DATABASE_URL=https://musee-civilisations-noires.firebaseio.com
```

### 2. Obtenir les credentials Firebase

#### Via Firebase Console (Recommandé)

1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Créer un nouveau projet ou sélectionner un existant
3. **Paramètres du projet** (⚙️) → **Comptes de service**
4. Cliquer sur **Générer une nouvelle clé privée**
5. Télécharger le fichier JSON

#### Extraire les valeurs du JSON

```json
{
  "type": "service_account",
  "project_id": "COPIER_ICI",
  "private_key_id": "...",
  "private_key": "COPIER_ICI (avec \\n)",
  "client_email": "COPIER_ICI",
  "client_id": "...",
  "auth_uri": "...",
  "token_uri": "...",
  "auth_provider_x509_cert_url": "...",
  "client_x509_cert_url": "..."
}
```

Copier dans `.env` :
```env
FIREBASE_PROJECT_ID=<project_id>
FIREBASE_CLIENT_EMAIL=<client_email>
FIREBASE_PRIVATE_KEY="<private_key>"
FIREBASE_DATABASE_URL=https://<project_id>.firebaseio.com
```

#### Via Firebase CLI

```bash
# Se connecter
firebase login

# Initialiser le projet
cd back
firebase init

# Sélectionner:
# - Authentication
# - Cloud Messaging
# - (Optionnel) Hosting

# Créer/sélectionner le projet
firebase use --add
```

---

## 🎯 Activer Google Sign-In

### Dans Firebase Console

1. **Authentication** → **Sign-in method**
2. Activer **Google**
3. Configurer l'email du projet
4. Copier le **Web client ID** (pour Flutter)

### Tester avec cURL

```bash
# 1. Obtenir un ID Token depuis le frontend Flutter
# 2. L'envoyer au backend

curl -X POST http://localhost:5000/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "GOOGLE_ID_TOKEN_HERE"
  }'
```

---

## 🍎 Activer Apple Sign-In

### Prérequis

- Compte Apple Developer (99$/an)
- App ID configuré
- Services ID créé
- Clé d'authentification générée

### Dans Firebase Console

1. **Authentication** → **Sign-in method**
2. Activer **Apple**
3. Configurer :
   - **Services ID** (depuis Apple Developer)
   - **OAuth code flow**
   - **Team ID** et **Key ID**

### Configuration Apple Developer

1. Créer un **App ID** : `com.musee.civilisations`
2. Créer un **Services ID** : `com.musee.civilisations.service`
3. Générer une **Key** pour Sign in with Apple
4. Configurer les **Return URLs** dans Services ID

---

## 📱 Intégration Flutter

### Packages requis

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  firebase_messaging: ^14.7.10
  google_sign_in: ^6.1.6
  sign_in_with_apple: ^5.0.0
  http: ^1.1.0
```

### Initialiser Firebase

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### Google Sign-In

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> signInWithGoogle() async {
  try {
    // 1. Connexion Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;

    // 2. Créer les credentials Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 3. Se connecter à Firebase
    final userCredential = 
        await FirebaseAuth.instance.signInWithCredential(credential);

    // 4. Obtenir l'ID Token
    final idToken = await userCredential.user?.getIdToken();

    // 5. Envoyer au backend
    final response = await http.post(
      Uri.parse('http://YOUR_BACKEND_URL/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idToken': idToken,
        'fcmToken': await getFcmToken(), // Optionnel
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jwtToken = data['data']['token'];
      // Stocker le JWT token
      await storage.write(key: 'auth_token', value: jwtToken);
      print('Connexion réussie !');
    }
  } catch (e) {
    print('Erreur: $e');
  }
}
```

### Apple Sign-In

```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> signInWithApple() async {
  try {
    // 1. Connexion Apple
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // 2. Créer les credentials Firebase
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // 3. Se connecter à Firebase
    final userCredential = 
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // 4. Obtenir l'ID Token
    final idToken = await userCredential.user?.getIdToken();

    // 5. Envoyer au backend
    final response = await http.post(
      Uri.parse('http://YOUR_BACKEND_URL/api/auth/apple'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idToken': idToken,
        'fcmToken': await getFcmToken(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jwtToken = data['data']['token'];
      await storage.write(key: 'auth_token', value: jwtToken);
      print('Connexion réussie !');
    }
  } catch (e) {
    print('Erreur: $e');
  }
}
```

### Notifications Push (FCM)

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

// Initialiser FCM
Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Demander la permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permission accordée');

    // Obtenir le token FCM
    String? token = await messaging.getToken();
    print('FCM Token: $token');

    // Enregistrer le token sur le backend
    await registerFcmToken(token!);

    // Écouter les notifications en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notification reçue: ${message.notification?.title}');
      // Afficher une notification locale
    });

    // Gérer les clics sur les notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification cliquée: ${message.data}');
      // Naviguer vers l'écran approprié
    });
  }
}

// Enregistrer le token FCM
Future<void> registerFcmToken(String fcmToken) async {
  final jwtToken = await storage.read(key: 'auth_token');
  
  await http.post(
    Uri.parse('http://YOUR_BACKEND_URL/api/auth/fcm-token'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    },
    body: jsonEncode({'fcmToken': fcmToken}),
  );
}

// Obtenir le token FCM
Future<String?> getFcmToken() async {
  return await FirebaseMessaging.instance.getToken();
}
```

---

## 🧪 Tests

### Test 1 : Google Sign-In

```bash
# Depuis Postman ou cURL
POST http://localhost:5000/api/auth/google
Content-Type: application/json

{
  "idToken": "GOOGLE_ID_TOKEN"
}
```

### Test 2 : Envoyer une notification

```bash
POST http://localhost:5000/api/notifications/send
Authorization: Bearer ADMIN_JWT_TOKEN
Content-Type: application/json

{
  "userId": "USER_ID",
  "title": "Test",
  "body": "Ceci est un test"
}
```

### Test 3 : Broadcast

```bash
POST http://localhost:5000/api/notifications/broadcast
Authorization: Bearer ADMIN_JWT_TOKEN
Content-Type: application/json

{
  "title": "Annonce",
  "body": "Message à tous"
}
```

---

## 📊 Structure des Fichiers

```
back/
├── src/
│   ├── config/
│   │   └── firebase.js              ✅ Configuration Firebase Admin SDK
│   ├── controllers/
│   │   ├── authController.js        ✅ Google/Apple auth + FCM tokens
│   │   └── notificationController.js ✅ Gestion notifications
│   ├── services/
│   │   └── notificationService.js   ✅ Logique métier notifications
│   ├── models/
│   │   └── User.js                  ✅ Support multi-providers + FCM
│   └── routes/
│       ├── auth.js                  ✅ Routes auth étendues
│       └── notifications.js         ✅ Routes notifications
├── .env                             ⚠️  Credentials Firebase (SECRET!)
└── FIREBASE_SETUP.md                📚 Guide complet
```

---

## ⚠️ Sécurité

### Ne JAMAIS commiter :
- ❌ `.env`
- ❌ `serviceAccountKey.json`
- ❌ Clés privées Firebase
- ❌ Tokens FCM

### Vérifier `.gitignore` :
```gitignore
.env
serviceAccountKey.json
firebase-debug.log
.firebase/
```

---

## 🎯 Cas d'Usage

### 1. Notification lors d'une nouvelle œuvre

```javascript
// Quand une nouvelle œuvre est ajoutée
const artwork = await Artwork.create({ ... });

// Notifier tous les utilisateurs abonnés
await sendNotificationToTopic('new_artworks', {
  title: 'Nouvelle œuvre disponible',
  body: artwork.title.fr,
  data: {
    artworkId: artwork._id.toString(),
    action: 'view_artwork'
  },
  imageUrl: artwork.images[0]
});
```

### 2. Rappel de visite

```javascript
// Envoyer un rappel à un utilisateur
await sendNotificationToUser(userId, {
  title: 'Continuez votre visite',
  body: 'Découvrez les œuvres que vous n\'avez pas encore vues',
  data: {
    action: 'continue_visit'
  }
});
```

### 3. Événement spécial

```javascript
// Broadcast à tous les utilisateurs
await sendNotificationToAll({
  title: 'Événement spécial ce weekend',
  body: 'Visite guidée gratuite samedi à 14h',
  data: {
    eventId: 'event_123',
    action: 'view_event'
  }
});
```

---

## 📚 Ressources

- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Apple Sign-In Flutter](https://pub.dev/packages/sign_in_with_apple)

---

## ✅ Checklist Finale

- [x] Firebase Admin SDK installé
- [x] Configuration Firebase créée
- [x] Google Sign-In implémenté
- [x] Apple Sign-In implémenté
- [x] FCM tokens gérés
- [x] Service de notifications créé
- [x] Routes notifications ajoutées
- [x] Modèle User étendu
- [x] Documentation complète

**L'intégration Firebase est complète et prête pour le hackathon ! 🎉**
