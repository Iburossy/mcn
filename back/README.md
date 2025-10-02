# API Backend - Musée des Civilisations Noires

Backend API pour l'application mobile et web du Musée des Civilisations Noires - Hackathon Dakar Slush'D 2025.

## 🚀 Technologies

- **Node.js** avec Express.js
- **MongoDB** avec Mongoose
- **Cloudinary** pour le stockage des médias
- **JWT** pour l'authentification
- **QRCode** pour la génération de QR codes

## 📋 Prérequis

- Node.js (v16 ou supérieur)
- MongoDB (local ou MongoDB Atlas)
- Compte Cloudinary (gratuit)

## 🔧 Installation

1. **Cloner le projet et naviguer vers le dossier backend**
```bash
cd back
```

2. **Installer les dépendances**
```bash
npm install
```

3. **Configurer les variables d'environnement**

Créer un fichier `.env` à la racine du dossier `back` :
```bash
cp .env.example .env
```

Éditer le fichier `.env` avec vos configurations :
```env
# Configuration du serveur
PORT=5000
NODE_ENV=development

# Configuration MongoDB
MONGODB_URI=mongodb://localhost:27017/musee_civilisations_noires

# Configuration Cloudinary
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret

# Configuration JWT
JWT_SECRET=votre_secret_jwt_securise
JWT_EXPIRE=7d

# Configuration CORS
CORS_ORIGIN=http://localhost:3000,http://localhost:8080

# URL de base
BASE_URL=http://localhost:5000
FRONTEND_URL=http://localhost:8080
```

4. **Créer le dossier uploads**
```bash
mkdir uploads
mkdir uploads/temp
```

## 🎯 Démarrage

### Mode développement (avec nodemon)
```bash
npm run dev
```

### Mode production
```bash
npm start
```

Le serveur démarre sur `http://localhost:5000`

## 📡 Endpoints API

### 🏛️ Artworks (Œuvres)

| Méthode | Endpoint | Description | Auth |
|---------|----------|-------------|------|
| GET | `/api/artworks` | Liste toutes les œuvres | Public |
| GET | `/api/artworks/:id` | Détails d'une œuvre | Public |
| GET | `/api/artworks/qr/:qrCode` | Œuvre par QR Code | Public |
| GET | `/api/artworks/popular` | Œuvres populaires | Public |
| GET | `/api/artworks/:id/stats` | Statistiques d'une œuvre | Public |
| POST | `/api/artworks` | Créer une œuvre | Admin/Curator |
| PUT | `/api/artworks/:id` | Modifier une œuvre | Admin/Curator |
| DELETE | `/api/artworks/:id` | Supprimer une œuvre | Admin |
| POST | `/api/artworks/:id/media` | Upload médias | Admin/Curator |

### 🏢 Rooms (Salles virtuelles)

| Méthode | Endpoint | Description | Auth |
|---------|----------|-------------|------|
| GET | `/api/rooms` | Liste toutes les salles | Public |
| GET | `/api/rooms/:id` | Détails d'une salle | Public |
| GET | `/api/rooms/room/:roomId` | Salle par roomId | Public |
| POST | `/api/rooms` | Créer une salle | Admin |
| PUT | `/api/rooms/:id` | Modifier une salle | Admin |
| DELETE | `/api/rooms/:id` | Supprimer une salle | Admin |
| POST | `/api/rooms/:id/artworks` | Ajouter œuvre à salle | Admin/Curator |
| DELETE | `/api/rooms/:id/artworks/:artworkId` | Retirer œuvre | Admin/Curator |
| POST | `/api/rooms/:id/assets` | Upload assets 3D | Admin |

### 👤 Auth (Authentification)

| Méthode | Endpoint | Description | Auth |
|---------|----------|-------------|------|
| POST | `/api/auth/register` | Inscription | Public |
| POST | `/api/auth/login` | Connexion | Public |
| GET | `/api/auth/me` | Profil utilisateur | Private |
| PUT | `/api/auth/profile` | Modifier profil | Private |
| PUT | `/api/auth/pin` | Changer code PIN | Private |

**Note :** L'authentification utilise un **numéro de téléphone (5-10 chiffres)** et un **code PIN de 4 chiffres**.

### 📊 Visits (Historique de visites)

| Méthode | Endpoint | Description | Auth |
|---------|----------|-------------|------|
| POST | `/api/visits` | Enregistrer une visite | Public |
| GET | `/api/visits/device/:deviceId` | Historique par device | Public |
| GET | `/api/visits/user/:userId` | Historique utilisateur | Private |
| GET | `/api/visits/stats/global` | Statistiques globales | Admin/Curator |

### 🏥 Health Check

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/health` | Vérifier l'état du serveur |
| GET | `/` | Informations API |

## 📝 Exemples de requêtes

### Créer une œuvre
```bash
POST /api/artworks
Content-Type: application/json
Authorization: Bearer <token>

{
  "title": {
    "fr": "Masque Sénoufo",
    "en": "Senufo Mask",
    "wo": "Masque Sénoufo"
  },
  "description": {
    "fr": "Masque traditionnel utilisé lors des cérémonies...",
    "en": "Traditional mask used during ceremonies...",
    "wo": "Masque bu..."
  },
  "category": "masque",
  "period": "XIXe siècle",
  "origin": "Côte d'Ivoire",
  "images": ["https://..."],
  "roomId": "main-hall"
}
```

### Récupérer une œuvre par QR Code
```bash
GET /api/artworks/qr/MCN-ABC123
```

### Enregistrer une visite
```bash
POST /api/visits
Content-Type: application/json

{
  "artworkId": "65f1234567890abcdef12345",
  "deviceId": "unique-device-id",
  "duration": 120,
  "language": "fr",
  "audioPlayed": true,
  "source": "qr-scan"
}
```

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification.

1. **S'inscrire ou se connecter** pour obtenir un token
2. **Inclure le token** dans les requêtes protégées :
```
Authorization: Bearer <votre_token>
```

## 📦 Structure du projet

```
back/
├── src/
│   ├── config/
│   │   ├── database.js          # Configuration MongoDB
│   │   └── cloudinary.js        # Configuration Cloudinary
│   ├── controllers/
│   │   ├── artworkController.js # Logique métier artworks
│   │   ├── roomController.js    # Logique métier salles
│   │   ├── authController.js    # Logique authentification
│   │   └── visitController.js   # Logique historique visites
│   ├── middleware/
│   │   ├── auth.js              # Middleware authentification
│   │   ├── upload.js            # Middleware upload fichiers
│   │   ├── validator.js         # Validation des données
│   │   └── errorHandler.js      # Gestion des erreurs
│   ├── models/
│   │   ├── Artwork.js           # Modèle Œuvre
│   │   ├── VirtualRoom.js       # Modèle Salle virtuelle
│   │   ├── User.js              # Modèle Utilisateur
│   │   └── VisitHistory.js      # Modèle Historique
│   ├── routes/
│   │   ├── artworks.js          # Routes artworks
│   │   ├── rooms.js             # Routes salles
│   │   ├── auth.js              # Routes authentification
│   │   └── visits.js            # Routes visites
│   └── utils/
│       ├── qrGenerator.js       # Génération QR codes
│       └── helpers.js           # Fonctions utilitaires
├── uploads/                     # Dossier temporaire uploads
├── .env                         # Variables d'environnement
├── .env.example                 # Exemple de configuration
├── .gitignore                   # Fichiers ignorés par Git
├── package.json                 # Dépendances Node.js
├── server.js                    # Point d'entrée application
└── README.md                    # Documentation
```

## 🛠️ Configuration Cloudinary

1. Créer un compte sur [Cloudinary](https://cloudinary.com/)
2. Récupérer vos credentials dans le Dashboard
3. Les ajouter dans le fichier `.env`

Les médias sont organisés dans les dossiers :
- `musee/artworks/images` - Images des œuvres
- `musee/artworks/audio` - Fichiers audio
- `musee/artworks/videos` - Vidéos
- `musee/rooms/models` - Modèles 3D
- `musee/rooms/textures` - Textures 3D
- `musee/qrcodes` - QR codes générés

## 🗄️ Configuration MongoDB

### Local
```bash
# Installer MongoDB
# Démarrer MongoDB
mongod

# L'URI par défaut est :
mongodb://localhost:27017/musee_civilisations_noires
```

### MongoDB Atlas (Cloud)
1. Créer un compte sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Créer un cluster gratuit
3. Obtenir l'URI de connexion
4. Remplacer dans `.env` :
```
MONGODB_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/musee_civilisations_noires
```

## 🧪 Tests

Pour tester l'API, vous pouvez utiliser :
- **Postman** : Importer la collection d'endpoints
- **Thunder Client** (VS Code extension)
- **cURL** en ligne de commande

Exemple avec cURL :
```bash
# Health check
curl http://localhost:5000/health
# Liste des œuvres
curl http://localhost:5000/api/artworks

# Connexion
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"771234567","pin":"1234"}'
**Succès :**
```json
{
  "success": true,
  "data": { ... }
}
```

**Erreur :**
```json
{
  "success": false,
  "message": "Description de l'erreur"
}
```

## 📊 Codes de statut HTTP

- `200` - Succès
- `201` - Ressource créée
- `400` - Requête invalide
- `401` - Non authentifié
- `403` - Non autorisé
- `404` - Ressource non trouvée
- `500` - Erreur serveur

## 🔒 Sécurité

- Helmet.js pour les headers de sécurité
- Rate limiting (100 requêtes/15min par IP)
- Validation des données avec express-validator
- Hachage des mots de passe avec bcryptjs
- JWT pour l'authentification
- CORS configuré

## 📈 Performance

- Compression des réponses
- Pagination des résultats
- Index MongoDB optimisés
- Cache des requêtes fréquentes

## 🤝 Contribution

Ce projet est développé dans le cadre du Hackathon Dakar Slush'D 2025.

## 📄 Licence

ISC

## 👥 Support

Pour toute question ou problème, contactez l'équipe de développement.

---

**Développé avec ❤️ pour le Musée des Civilisations Noires**
