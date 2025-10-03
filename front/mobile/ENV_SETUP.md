# 🔧 Configuration des Variables d'Environnement

## 📝 Setup Initial

### 1. Créer le fichier .env

```bash
cp .env.example .env
```

### 2. Configurer selon votre environnement

Éditez le fichier `.env` avec les bonnes valeurs :

```env
# Android Emulator
API_BASE_URL=http://10.0.2.2:5000/api

# iOS Simulator
# API_BASE_URL=http://localhost:5000/api

# Appareil physique (remplacez par l'IP de votre machine)
# API_BASE_URL=http://192.168.1.100:5000/api

# Production
# API_BASE_URL=https://api.musee.com/api

API_TIMEOUT=30
```

## 🌐 Adresses selon la Plateforme

### Android Emulator
```env
API_BASE_URL=http://10.0.2.2:5000/api
```
**Pourquoi ?** `10.0.2.2` est l'adresse spéciale qui pointe vers `localhost` de la machine hôte.

### iOS Simulator
```env
API_BASE_URL=http://localhost:5000/api
```
**Pourquoi ?** L'iOS Simulator peut accéder directement à `localhost`.

### Appareil Physique
```env
API_BASE_URL=http://192.168.1.100:5000/api
```
**Pourquoi ?** Vous devez utiliser l'adresse IP locale de votre machine sur le réseau.

**Pour trouver votre IP :**
- Windows : `ipconfig`
- Mac/Linux : `ifconfig` ou `ip addr`

### Production
```env
API_BASE_URL=https://api.musee.com/api
```

## ⚙️ Variables Disponibles

| Variable | Description | Valeur par défaut |
|----------|-------------|-------------------|
| `API_BASE_URL` | URL de base de l'API | `http://10.0.2.2:5000/api` |
| `API_TIMEOUT` | Timeout des requêtes (secondes) | `30` |

## 🔒 Sécurité

- ✅ Le fichier `.env` est dans `.gitignore`
- ✅ Ne commitez JAMAIS le fichier `.env`
- ✅ Utilisez `.env.example` comme template
- ✅ Partagez `.env.example` avec l'équipe

## 🚀 Utilisation

Les variables sont chargées automatiquement au démarrage de l'app :

```dart
// Dans main.dart
await dotenv.load(fileName: ".env");

// Utilisation
ApiConfig.baseUrl  // Lit depuis .env
ApiConfig.timeout  // Lit depuis .env
```

## 🧪 Test de Configuration

Pour vérifier que votre configuration fonctionne :

1. Lancez votre backend sur `localhost:5000`
2. Lancez l'app mobile
3. Vérifiez les logs dans la console :
   ```
   🌐 API Base URL: http://10.0.2.2:5000/api
   ```

## ❌ Dépannage

### Erreur "DioException [bad response]"
- Vérifiez que le backend est démarré
- Vérifiez l'URL dans `.env`
- Pour Android Emulator, utilisez `10.0.2.2` et non `localhost`

### Erreur "Connection refused"
- Vérifiez que le port est correct (5000)
- Vérifiez le firewall de votre machine
- Pour appareil physique, vérifiez que vous êtes sur le même réseau WiFi

### Variables non chargées
- Vérifiez que `.env` existe à la racine du projet mobile
- Vérifiez que `.env` est dans `pubspec.yaml` sous `assets`
- Relancez l'app après modification du `.env`

## 📱 Environnements Multiples

Vous pouvez créer plusieurs fichiers :

```
.env              # Développement (Android Emulator)
.env.ios          # iOS Simulator
.env.production   # Production
```

Puis charger selon l'environnement :

```dart
await dotenv.load(fileName: ".env.ios");
```
