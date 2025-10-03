# Configuration Cloudinary

## Pourquoi Cloudinary ?

Les images base64 stockées directement dans MongoDB causent plusieurs problèmes :
- ❌ **Base de données volumineuse** : Une image peut faire plusieurs MB en base64
- ❌ **Performances lentes** : Chargement très lent des œuvres
- ❌ **Problèmes d'affichage** : Ne s'affichent pas sur mobile
- ❌ **Coûts élevés** : Stockage MongoDB coûteux

Cloudinary résout tous ces problèmes :
- ✅ **URLs légères** : Seulement ~100 caractères par image
- ✅ **CDN rapide** : Chargement ultra-rapide partout dans le monde
- ✅ **Optimisation automatique** : Compression, redimensionnement
- ✅ **Gratuit** : Plan gratuit généreux (25 GB stockage, 25 GB bande passante/mois)

## Étapes de configuration

### 1. Créer un compte Cloudinary

1. Aller sur [cloudinary.com](https://cloudinary.com)
2. Créer un compte gratuit
3. Accéder au Dashboard

### 2. Récupérer les identifiants

Dans le Dashboard Cloudinary, vous trouverez :
- **Cloud Name** : Ex: `dxxxxx`
- **API Key** : Ex: `123456789012345`
- **API Secret** : Ex: `abcdefghijklmnopqrstuvwxyz`

### 3. Configurer le backend

Ajouter dans le fichier `.env` du backend :

```env
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret
```

### 4. Redémarrer le backend

```bash
npm run dev
```

### 5. Nettoyer les images base64 existantes

```bash
node scripts/cleanBase64Images.js
```

Ce script va :
- Détecter toutes les images base64 dans la base de données
- Les supprimer
- Afficher un rapport

### 6. Re-uploader les images

Depuis l'interface admin web :
1. Éditer chaque œuvre qui n'a plus d'images
2. Uploader les images via le bouton "Ajouter des images"
3. Les images seront automatiquement uploadées sur Cloudinary

## Vérification

Une URL Cloudinary ressemble à :
```
https://res.cloudinary.com/votre_cloud_name/image/upload/v1234567890/mcn/artworks/abc123.jpg
```

Une URL base64 (à éviter) ressemble à :
```
data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBD...
```

## Avantages pour le mobile

- ✅ Chargement instantané des images
- ✅ Fonctionne même avec connexion lente
- ✅ Cache automatique
- ✅ Responsive (différentes tailles selon l'appareil)

## Support

Si vous rencontrez des problèmes :
1. Vérifier que les variables d'environnement sont bien définies
2. Redémarrer le backend
3. Vérifier les logs du backend lors de l'upload
