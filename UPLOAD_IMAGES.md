# 📸 Système d'Upload d'Images

## ✅ Fonctionnalités Implémentées

### Frontend
- ✅ Composant `ImageUpload` avec drag & drop visuel
- ✅ Preview des images avant upload
- ✅ Validation (format, taille max 5MB)
- ✅ Suppression d'images
- ✅ Indication image principale
- ✅ Limite configurable (max 5 images par défaut)
- ✅ Double mode : Cloudinary OU Base64 (fallback)

### Backend
- ✅ Route `/api/upload/image` - Upload une image
- ✅ Route `/api/upload/images` - Upload multiple
- ✅ Route `/api/upload/image/:id` - Supprimer image
- ✅ Protection admin/curator
- ✅ Validation fichiers
- ✅ Compression automatique (1200x1200)
- ✅ Organisation dans dossier `mcn/artworks`

## 🚀 Utilisation

### 1. Configuration Cloudinary (Recommandé)

Éditez `back/.env` :
```env
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret
```

**Obtenir les credentials :**
1. Créer compte sur https://cloudinary.com (gratuit)
2. Dashboard → Account Details
3. Copier Cloud Name, API Key, API Secret

### 2. Sans Cloudinary (Mode Base64)

Si Cloudinary n'est pas configuré, le système utilise automatiquement le mode Base64 :
- ✅ Fonctionne immédiatement
- ⚠️ Images stockées en base64 dans MongoDB
- ⚠️ Augmente la taille de la BDD
- ⚠️ Moins performant pour grandes images

## 📝 Utilisation dans le Code

### Dans ArtworkForm.tsx

```tsx
import ImageUpload from '../../components/ImageUpload';

<ImageUpload
  images={formData.images}
  onChange={(images) => setFormData({ ...formData, images })}
  maxImages={5}
/>
```

### Upload Manuel (Service)

```typescript
import { uploadService } from '../services';

// Upload une image
const result = await uploadService.uploadImage(file);
console.log(result.url); // URL Cloudinary

// Upload plusieurs
const results = await uploadService.uploadImages([file1, file2]);

// Supprimer
await uploadService.deleteImage(publicId);
```

## 🎨 Composant ImageUpload

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `images` | `string[]` | - | URLs des images |
| `onChange` | `(images: string[]) => void` | - | Callback changement |
| `maxImages` | `number` | `5` | Nombre max d'images |

### Fonctionnalités

- ✅ **Preview** - Affichage grille responsive
- ✅ **Drag & Drop** - Réorganiser images (TODO)
- ✅ **Image principale** - Première image = principale
- ✅ **Suppression** - Bouton delete sur chaque image
- ✅ **Validation** - Format + taille
- ✅ **Loading** - Indicateur pendant upload
- ✅ **Erreurs** - Messages d'erreur clairs

## 🔧 Backend API

### POST /api/upload/image
Upload une seule image

**Request:**
```
Content-Type: multipart/form-data
Authorization: Bearer <token>

Body: FormData avec 'image' file
```

**Response:**
```json
{
  "success": true,
  "data": {
    "url": "https://res.cloudinary.com/...",
    "publicId": "mcn/artworks/abc123"
  }
}
```

### POST /api/upload/images
Upload plusieurs images

**Request:**
```
Content-Type: multipart/form-data
Authorization: Bearer <token>

Body: FormData avec 'images' files (max 5)
```

**Response:**
```json
{
  "success": true,
  "data": [
    { "url": "...", "publicId": "..." },
    { "url": "...", "publicId": "..." }
  ]
}
```

### DELETE /api/upload/image/:publicId
Supprimer une image

**Response:**
```json
{
  "success": true,
  "message": "Image supprimée avec succès"
}
```

## 📦 Dépendances

### Backend
```json
{
  "multer": "^1.4.5-lts.1",
  "cloudinary": "^1.41.0"
}
```

Déjà installées ✅

### Frontend
Aucune dépendance supplémentaire requise ✅

## 🎯 Prochaines Améliorations

- [ ] Drag & drop pour réorganiser
- [ ] Crop/resize avant upload
- [ ] Progress bar détaillée
- [ ] Upload en arrière-plan
- [ ] Compression côté client
- [ ] Support vidéos

## 🐛 Dépannage

### Erreur "Invalid cloud_name"
→ Vérifier `.env` : `CLOUDINARY_CLOUD_NAME` correct

### Images trop grandes
→ Augmenter limite dans `server.js` : `limit: '10mb'`

### Upload lent
→ Activer compression Cloudinary (déjà fait)

### Mode Base64 utilisé
→ Normal si Cloudinary non configuré, fonctionne quand même !

## ✅ Test

1. Aller sur `/admin/artworks/new`
2. Cliquer "Ajouter des images"
3. Sélectionner 1-5 images
4. Vérifier preview
5. Créer l'œuvre
6. ✅ Images sauvegardées !
