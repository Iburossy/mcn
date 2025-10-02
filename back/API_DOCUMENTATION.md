# 📚 Documentation API - Musée des Civilisations Noires

## Base URL
```
http://localhost:5000
```

---

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens). Pour les routes protégées, inclure le token dans le header :

```
Authorization: Bearer <votre_token>
```

---

## 📋 Endpoints

### 1. Artworks (Œuvres d'art)

#### 1.1 Liste toutes les œuvres
```http
GET /api/artworks
```

**Query Parameters:**
- `page` (number, optional) - Numéro de page (défaut: 1)
- `limit` (number, optional) - Éléments par page (défaut: 10)
- `category` (string, optional) - Filtrer par catégorie
- `roomId` (string, optional) - Filtrer par salle
- `search` (string, optional) - Recherche dans les titres
- `isActive` (boolean, optional) - Filtrer par statut actif (défaut: true)

**Réponse:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "65f1234567890abcdef12345",
      "qrCode": "MCN-001",
      "title": {
        "fr": "Masque Sénoufo",
        "en": "Senufo Mask",
        "wo": "Masque Sénoufo"
      },
      "description": {
        "fr": "Masque traditionnel...",
        "en": "Traditional mask...",
        "wo": "Masque bu..."
      },
      "images": ["https://..."],
      "category": "masque",
      "period": "XIXe siècle",
      "origin": "Côte d'Ivoire",
      "roomId": "main-hall",
      "viewCount": 42,
      "createdAt": "2025-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 50,
    "page": 1,
    "limit": 10,
    "totalPages": 5,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

#### 1.2 Récupérer une œuvre par ID
```http
GET /api/artworks/:id
```

**Réponse:**
```json
{
  "success": true,
  "data": {
    "_id": "65f1234567890abcdef12345",
    "qrCode": "MCN-001",
    "title": { ... },
    "description": { ... },
    "audio": {
      "fr": "https://cloudinary.../audio_fr.mp3",
      "en": "https://cloudinary.../audio_en.mp3",
      "wo": "https://cloudinary.../audio_wo.mp3"
    },
    "images": ["https://..."],
    "video": "https://cloudinary.../video.mp4",
    "category": "masque",
    "viewCount": 43
  }
}
```

#### 1.3 Récupérer une œuvre par QR Code
```http
GET /api/artworks/qr/:qrCode
```

**Exemple:**
```http
GET /api/artworks/qr/MCN-001
```

#### 1.4 Œuvres populaires
```http
GET /api/artworks/popular?limit=10
```

#### 1.5 Statistiques d'une œuvre
```http
GET /api/artworks/:id/stats
```

**Réponse:**
```json
{
  "success": true,
  "data": {
    "artwork": {
      "id": "65f1234567890abcdef12345",
      "title": { ... },
      "viewCount": 156
    },
    "stats": {
      "totalVisits": 156,
      "avgDuration": 120,
      "audioPlayCount": 89,
      "videoPlayCount": 34
    },
    "visitsByLanguage": [
      { "_id": "fr", "count": 78 },
      { "_id": "en", "count": 56 },
      { "_id": "wo", "count": 22 }
    ],
    "visitsBySource": [
      { "_id": "qr-scan", "count": 120 },
      { "_id": "browse", "count": 36 }
    ]
  }
}
```

#### 1.6 Créer une œuvre (Admin/Curator)
```http
POST /api/artworks
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "title": {
    "fr": "Titre en français",
    "en": "Title in English",
    "wo": "Titre en wolof"
  },
  "description": {
    "fr": "Description en français",
    "en": "Description in English",
    "wo": "Description en wolof"
  },
  "category": "masque",
  "period": "XIXe siècle",
  "origin": "Côte d'Ivoire",
  "images": ["https://..."],
  "roomId": "main-hall",
  "culturalContext": {
    "fr": "Contexte culturel...",
    "en": "Cultural context...",
    "wo": "Contexte culturel..."
  },
  "materials": ["Bois", "Pigments"],
  "artist": "Artisan anonyme"
}
```

#### 1.7 Mettre à jour une œuvre (Admin/Curator)
```http
PUT /api/artworks/:id
Authorization: Bearer <token>
Content-Type: application/json
```

#### 1.8 Supprimer une œuvre (Admin)
```http
DELETE /api/artworks/:id
Authorization: Bearer <token>
```

#### 1.9 Upload de médias (Admin/Curator)
```http
POST /api/artworks/:id/media
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Form Data:**
- `images` (files) - Jusqu'à 10 images
- `audio_fr` (file) - Audio en français
- `audio_en` (file) - Audio en anglais
- `audio_wo` (file) - Audio en wolof
- `video` (file) - Vidéo

---

### 2. Virtual Rooms (Salles virtuelles)

#### 2.1 Liste toutes les salles
```http
GET /api/rooms
```

**Réponse:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "65f...",
      "roomId": "main-hall",
      "name": {
        "fr": "Hall Principal",
        "en": "Main Hall",
        "wo": "Hall bu Njëkk"
      },
      "description": { ... },
      "artworks": [
        {
          "artworkId": {
            "_id": "65f...",
            "title": { ... },
            "images": ["https://..."]
          },
          "position": { "x": 0, "y": 1, "z": -5 },
          "rotation": { "x": 0, "y": 0, "z": 0 },
          "scale": { "x": 1, "y": 1, "z": 1 }
        }
      ],
      "lighting": { ... },
      "cameraStart": { ... },
      "order": 1
    }
  ]
}
```

#### 2.2 Récupérer une salle par ID
```http
GET /api/rooms/:id
```

#### 2.3 Récupérer une salle par roomId
```http
GET /api/rooms/room/:roomId
```

**Exemple:**
```http
GET /api/rooms/room/main-hall
```

#### 2.4 Créer une salle (Admin)
```http
POST /api/rooms
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "roomId": "new-room",
  "name": {
    "fr": "Nouvelle Salle",
    "en": "New Room",
    "wo": "Salle bu Bees"
  },
  "description": { ... },
  "lighting": {
    "ambient": {
      "color": "#ffffff",
      "intensity": 0.6
    },
    "directional": [
      {
        "color": "#ffffff",
        "intensity": 1,
        "position": { "x": 10, "y": 15, "z": 10 }
      }
    ]
  },
  "cameraStart": {
    "position": { "x": 0, "y": 1.6, "z": 8 },
    "lookAt": { "x": 0, "y": 1.6, "z": 0 }
  },
  "order": 6
}
```

#### 2.5 Ajouter une œuvre à une salle (Admin/Curator)
```http
POST /api/rooms/:id/artworks
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "artworkId": "65f1234567890abcdef12345",
  "position": { "x": 0, "y": 1, "z": -5 },
  "rotation": { "x": 0, "y": 0, "z": 0 },
  "scale": { "x": 1, "y": 1, "z": 1 }
}
```

#### 2.6 Retirer une œuvre d'une salle (Admin/Curator)
```http
DELETE /api/rooms/:id/artworks/:artworkId
Authorization: Bearer <token>
```

#### 2.7 Upload assets 3D (Admin)
```http
POST /api/rooms/:id/assets
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Form Data:**
- `model3D` (file) - Modèle 3D (GLTF/GLB)
- `floorTexture` (file) - Texture du sol
- `wallTexture` (file) - Texture des murs

---

### 3. Authentication (Authentification)

#### 3.1 Inscription
```bash
POST /api/auth/register
Content-Type: application/json

{
  "phoneNumber": "771234567",
  "pin": "1234",
  "name": "Nom Complet",
  "role": "visitor"
}
```

**Réponse :**
```json
{
  "success": true,
  "message": "Utilisateur créé avec succès",
  "data": {
    "user": {
      "_id": "65f...",
      "phoneNumber": "771234567",
      "name": "Nom Complet",
      "role": "visitor"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### 3.2 Connexion
```http
POST /api/auth/login
Content-Type: application/json

{
  "phoneNumber": "771234567",
  "pin": "1234"
}
```

#### 3.3 Profil utilisateur
```http
GET /api/auth/me
Authorization: Bearer <token>
```

#### 3.4 Mettre à jour le profil
```http
PUT /api/auth/profile
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "name": "Nouveau Nom",
  "preferences": {
    "language": "wo",
    "notifications": true
  }
}
```
#### 3.5 Changer le code PIN
```http
PUT /api/auth/pin
Authorization: Bearer <token>
Content-Type: application/json

{
  "currentPin": "1234",
  "newPin": "5678"
}

#### 4.1 Enregistrer une visite
```http
POST /api/visits
Content-Type: application/json
```

**Body:**
```json
{
  "artworkId": "65f1234567890abcdef12345",
  "deviceId": "unique-device-identifier",
  "duration": 120,
  "language": "fr",
  "audioPlayed": true,
  "videoPlayed": false,
  "source": "qr-scan",
  "location": {
    "coordinates": [14.6928, -17.4467]
  }
}
```

**Sources possibles:**
- `qr-scan` - Scan de QR code
- `browse` - Navigation dans l'app
- `search` - Résultat de recherche
- `virtual-tour` - Visite virtuelle 3D

#### 4.2 Historique par device
```http
GET /api/visits/device/:deviceId?page=1&limit=20
```

#### 4.3 Historique utilisateur (Private)
```http
GET /api/visits/user/:userId?page=1&limit=20
Authorization: Bearer <token>
```

#### 4.4 Statistiques globales (Admin/Curator)
```http
GET /api/visits/stats/global?startDate=2025-01-01&endDate=2025-12-31
Authorization: Bearer <token>
```

**Réponse:**
```json
{
  "success": true,
  "data": {
    "general": {
      "totalVisits": 1250,
      "avgDuration": 145,
      "totalAudioPlays": 890,
      "totalVideoPlays": 340
    },
    "visitsByDay": [
      { "_id": "2025-01-15", "count": 45 },
      { "_id": "2025-01-16", "count": 52 }
    ],
    "topArtworks": [
      {
        "_id": "65f...",
        "count": 156,
        "title": { ... },
        "images": ["https://..."],
        "category": "masque"
      }
    ],
    "visitsByLanguage": [
      { "_id": "fr", "count": 650 },
      { "_id": "en", "count": 450 },
      { "_id": "wo", "count": 150 }
    ],
    "visitsBySource": [
      { "_id": "qr-scan", "count": 800 },
      { "_id": "browse", "count": 300 },
      { "_id": "virtual-tour", "count": 150 }
    ]
  }
}
```

---

## 🔑 Rôles et Permissions

### Visitor (Visiteur)
- Consulter les œuvres et salles
- Enregistrer des visites
- Voir son historique

### Curator (Conservateur)
- Toutes les permissions Visitor
- Créer/modifier des œuvres
- Upload de médias
- Gérer les œuvres dans les salles

### Admin (Administrateur)
- Toutes les permissions Curator
- Supprimer des œuvres
- Créer/modifier/supprimer des salles
- Voir les statistiques globales

---

## 📊 Codes de statut HTTP

- `200` - Succès
- `201` - Ressource créée
- `400` - Requête invalide
- `401` - Non authentifié
- `403` - Non autorisé (permissions insuffisantes)
- `404` - Ressource non trouvée
- `500` - Erreur serveur

---

## 🎯 Catégories d'œuvres

- `sculpture`
- `peinture`
- `textile`
- `ceramique`
- `bijoux`
- `masque`
- `instrument`
- `autre`

---

## 🌍 Langues supportées

- `fr` - Français
- `en` - English
- `wo` - Wolof

---

## 📝 Exemples cURL

### Récupérer toutes les œuvres
```bash
curl http://localhost:5000/api/artworks
```

### Connexion
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"771234567","pin":"1234"}'
```

### Créer une œuvre (avec token)
```bash
curl -X POST http://localhost:5000/api/artworks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": {"fr":"Test","en":"Test","wo":"Test"},
    "description": {"fr":"Test","en":"Test","wo":"Test"},
    "category": "sculpture",
    "period": "Moderne",
    "origin": "Sénégal"
  }'
```

### Enregistrer une visite
```bash
curl -X POST http://localhost:5000/api/visits \
  -H "Content-Type: application/json" \
  -d '{
    "artworkId": "65f1234567890abcdef12345",
    "deviceId": "test-device-123",
    "duration": 120,
    "language": "fr",
    "source": "qr-scan"
  }'
```

---

**Pour plus d'informations, consulter le README.md**
