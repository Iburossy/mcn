# 🚀 Guide d'Installation Rapide - Backend

## Étape 1 : Installation des dépendances

```bash
cd back
npm install
```

## Étape 2 : Configuration de l'environnement

Créer un fichier `.env` à la racine du dossier `back` avec le contenu suivant :

```env
# Configuration du serveur
PORT=5000
NODE_ENV=development

# Configuration MongoDB (choisir l'une des options)
# Option 1 - MongoDB Local
MONGODB_URI=mongodb://localhost:27017/mcn

# Option 2 - MongoDB Atlas (Cloud - Recommandé)
# MONGODB_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/mcn

# Configuration Cloudinary (Obligatoire)
# Créer un compte gratuit sur https://cloudinary.com
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret

# Configuration JWT
JWT_SECRET=musee_secret_key_2025_hackathon_dakar_slushd
JWT_EXPIRE=7d

# Configuration CORS
CORS_ORIGIN=http://localhost:3000,http://10.0.2.2:8080

# URL de base
BASE_URL=http://localhost:5000
FRONTEND_URL=http://10.0.2.2:8080
```

## Étape 3 : Démarrer MongoDB

### Option A - MongoDB Local
```bash
# Windows
mongod

# macOS/Linux
sudo systemctl start mongod
```

### Option B - MongoDB Atlas (Recommandé)
1. Créer un compte sur https://www.mongodb.com/cloud/atlas
2. Créer un cluster gratuit
3. Créer un utilisateur de base de données
4. Obtenir l'URI de connexion
5. Remplacer dans `.env`

## Étape 4 : Initialiser la base de données avec des données de test

```bash
npm run seed
```

Cette commande va créer :
- 5 œuvres d'art de test
- 5 salles virtuelles
- 3 utilisateurs de test

**Comptes de test créés :**
- Admin : `771234567` / PIN: `1234`
- Curator : `779876543` / PIN: `5678`
- Visitor : `701112233` / PIN: `9999`

## Étape 5 : Démarrer le serveur

### Mode développement (avec auto-reload)
```bash
npm run dev
```

### Mode production
```bash
npm start
```

Le serveur démarre sur **http://localhost:5000**

## ✅ Vérification

Ouvrir dans le navigateur : http://localhost:5000/health

Vous devriez voir :
```json
{
  "success": true,
  "message": "API Musée des Civilisations Noires - Serveur opérationnel",
  "timestamp": "2025-10-02T...",
  "environment": "development"
}
```

## 🔧 Configuration Cloudinary (Important)

1. Aller sur https://cloudinary.com
2. Créer un compte gratuit
3. Dans le Dashboard, copier :
   - Cloud Name
   - API Key
   - API Secret
4. Les coller dans le fichier `.env`

**Sans Cloudinary, l'upload de médias ne fonctionnera pas !**

## 📝 Commandes utiles

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

## 🐛 Résolution de problèmes

### Erreur : "MongoDB connection failed"
- Vérifier que MongoDB est démarré
- Vérifier l'URI dans `.env`
- Pour MongoDB Atlas, vérifier que votre IP est autorisée

### Erreur : "Cloudinary configuration error"
- Vérifier les credentials Cloudinary dans `.env`
- S'assurer d'avoir créé un compte Cloudinary

### Port déjà utilisé
- Changer le PORT dans `.env`
- Ou arrêter le processus utilisant le port 5000

### Erreur : "Cannot find module"
- Supprimer `node_modules` et `package-lock.json`
- Réinstaller : `npm install`

## 🎯 Prochaines étapes

Une fois le backend démarré :
1. Tester les endpoints avec Postman ou cURL
2. Consulter la documentation complète dans `README.md`
3. Passer au développement du frontend Flutter

---

**Besoin d'aide ?** Consulter le fichier `README.md` pour plus de détails.
