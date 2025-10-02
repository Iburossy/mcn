# 🚀 Quick Start - Backend API

## Installation Rapide (5 minutes)

### 1. Installer les dépendances
```bash
cd back
npm install
```

### 2. Créer le fichier .env
Copier `.env.example` vers `.env` et configurer :

```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/musee_civilisations_noires
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret
JWT_SECRET=musee_secret_key_2025
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:3000,http://localhost:8080
BASE_URL=http://localhost:5000
FRONTEND_URL=http://localhost:8080
```

### 3. Initialiser la base de données
```bash
npm run seed
```

### 4. Démarrer le serveur
```bash
npm run dev
```

✅ Le serveur est maintenant accessible sur **http://localhost:5000**

---

## 🧪 Tester l'API

### Test 1 : Health Check
```bash
curl http://localhost:5000/health
```

### Test 2 : Connexion
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"771234567","pin":"1234"}'
```

**Réponse attendue :**
```json
{
  "success": true,
  "message": "Connexion réussie",
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Test 3 : Liste des œuvres
```bash
curl http://localhost:5000/api/artworks
```

---

## 📱 Comptes de Test

| Rôle | Téléphone | PIN | Nom |
|------|-----------|-----|-----|
| **Admin** | 771234567 | 1234 | Administrateur Musée |
| **Curator** | 779876543 | 5678 | Conservateur Principal |
| **Visitor** | 701112233 | 9999 | Visiteur Test |

---

## 🔑 Authentification

### Inscription
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "701234567",
    "pin": "1234",
    "name": "Nouveau Visiteur",
    "role": "visitor"
  }'
```

### Connexion
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "771234567",
    "pin": "1234"
  }'
```

**Copier le token retourné** pour les requêtes protégées.

---

## 📡 Endpoints Principaux

### Artworks (Œuvres)
```bash
# Liste toutes les œuvres
GET http://localhost:5000/api/artworks

# Détails d'une œuvre
GET http://localhost:5000/api/artworks/:id

# Œuvre par QR Code
GET http://localhost:5000/api/artworks/qr/MCN-001

# Œuvres populaires
GET http://localhost:5000/api/artworks/popular?limit=10
```

### Rooms (Salles)
```bash
# Liste toutes les salles
GET http://localhost:5000/api/rooms

# Détails d'une salle
GET http://localhost:5000/api/rooms/:id

# Salle par roomId
GET http://localhost:5000/api/rooms/room/main-hall
```

### Visits (Visites)
```bash
# Enregistrer une visite
POST http://localhost:5000/api/visits
Content-Type: application/json

{
  "artworkId": "65f1234567890abcdef12345",
  "deviceId": "device-123",
  "duration": 120,
  "language": "fr",
  "audioPlayed": true,
  "source": "qr-scan"
}
```

---

## 🔧 Commandes Utiles

```bash
# Démarrer en mode développement
npm run dev

# Démarrer en mode production
npm start

# Réinitialiser la base de données
npm run seed

# Installer une nouvelle dépendance
npm install <package-name>
```

---

## 📦 Importer dans Postman

1. Ouvrir Postman
2. Cliquer sur **Import**
3. Sélectionner le fichier `POSTMAN_COLLECTION.json`
4. La collection "Musée des Civilisations Noires API" est prête !

**Variables de collection :**
- `base_url` : http://localhost:5000
- `token` : (sera automatiquement rempli après login)

---

## 🐛 Problèmes Courants

### MongoDB ne démarre pas
```bash
# Windows
mongod

# macOS/Linux
sudo systemctl start mongod
```

### Port 5000 déjà utilisé
Changer le PORT dans `.env` :
```env
PORT=5001
```

### Erreur Cloudinary
Vérifier les credentials dans `.env`. Pour tester sans Cloudinary, utiliser des URLs d'images publiques.

---

## 📚 Documentation Complète

- **README.md** - Documentation détaillée
- **API_DOCUMENTATION.md** - Tous les endpoints
- **INSTALLATION.md** - Guide d'installation complet
- **AUTH_CHANGES.md** - Système d'authentification
- **BACKEND_SUMMARY.md** - Résumé complet

---

## 🎯 Prochaines Étapes

1. ✅ Backend démarré
2. 🔄 Tester les endpoints avec Postman
3. 🎨 Développer le frontend Flutter
4. 🌐 Intégrer Three.js pour la visite 3D
5. 🚀 Déployer en production

---

**Le backend est prêt ! Bon développement ! 🎉**
