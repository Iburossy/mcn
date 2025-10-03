# 🎨 Guide Complet - Modèles 3D GLB

## ✅ Système Implémenté

Votre application supporte maintenant les **modèles 3D interactifs** pour chaque œuvre !

### 🎯 Fonctionnalités

- ✅ Visualisation 3D interactive (rotation, zoom, pan)
- ✅ Format GLB (optimisé web)
- ✅ Contrôles intuitifs (souris)
- ✅ Mode plein écran
- ✅ Éclairage professionnel
- ✅ Instructions à l'écran
- ✅ Chargement progressif
- ✅ Limite 10 MB par modèle

## 📋 Workflow Complet

### Étape 1: Générer le Modèle 3D

**Outil : Instant3D** (https://app.instant3d.ai)

1. **Upload Photo**
   - Choisir une photo nette de l'œuvre
   - Fond uni recommandé
   - Bonne luminosité

2. **Générer**
   - Cliquer "Generate 3D Model"
   - Attendre 30-60 secondes
   - Le modèle s'affiche

3. **Télécharger en GLB**
   - Cliquer sur l'onglet **GLB** ✅
   - Cliquer "Download Model"
   - Fichier téléchargé : `model_xxxxx.glb`

### Étape 2: Préparer le Fichier

**Renommer :**
```bash
# Avant
model_1234567.glb

# Après (descriptif)
masque_gelede_001.glb
sculpture_bronze_002.glb
textile_kente_003.glb
```

**Vérifier la taille :**
```bash
# Windows PowerShell
Get-Item masque_gelede_001.glb | Select-Object Name, @{Name="Size(MB)";Expression={[math]::Round($_.Length/1MB,2)}}

# Résultat attendu : < 10 MB
```

**Si > 10 MB, compresser :**
```bash
# Option 1: En ligne
# Aller sur https://gltf.report/
# Glisser-déposer le fichier
# Télécharger la version compressée

# Option 2: CLI
npm install -g gltf-pipeline
gltf-pipeline -i masque_gelede_001.glb -o masque_gelede_001_compressed.glb -d
```

### Étape 3: Placer le Fichier

**Emplacement :**
```
front/web/public/models/masque_gelede_001.glb
```

**Commande :**
```bash
# Copier depuis Téléchargements
cp ~/Downloads/masque_gelede_001.glb front/web/public/models/

# Ou glisser-déposer dans VS Code
```

### Étape 4: Ajouter dans l'Admin

1. **Ouvrir l'admin**
   ```
   http://localhost:8080/admin/artworks
   ```

2. **Éditer l'œuvre**
   - Cliquer sur "Modifier" (icône crayon)
   - Ou créer une nouvelle œuvre

3. **Section "Modèle 3D (GLB)"**
   - Champ : "Chemin du Modèle 3D"
   - Entrer : `/models/masque_gelede_001.glb`
   - ⚠️ Important : Commencer par `/models/`

4. **Sauvegarder**
   - Cliquer "Mettre à jour" ou "Créer l'œuvre"

### Étape 5: Vérifier

1. **Aller sur la page de détail**
   ```
   http://localhost:8080/artworks/[id]
   ```

2. **Vérifier l'affichage**
   - Section "🎨 Modèle 3D Interactif" apparaît
   - Le modèle se charge (spinner)
   - Le modèle s'affiche en 3D

3. **Tester les contrôles**
   - Clic gauche + glisser : Rotation
   - Molette : Zoom
   - Clic droit + glisser : Déplacement
   - Bouton plein écran

## 🎮 Contrôles Utilisateur

### Souris

| Action | Résultat |
|--------|----------|
| **Clic gauche + glisser** | Rotation 360° |
| **Molette haut/bas** | Zoom in/out |
| **Clic droit + glisser** | Déplacement (pan) |
| **Double-clic** | Reset position |

### Boutons

| Bouton | Action |
|--------|--------|
| **⛶ Plein écran** | Mode immersif |
| **ESC** | Quitter plein écran |

## 📊 Spécifications Techniques

### Format

- **Type** : GLB (GLTF Binary)
- **Version** : GLTF 2.0
- **Taille max** : 10 MB
- **Compression** : Draco (optionnel)

### Contenu

- ✅ Géométrie (mesh)
- ✅ Textures (incluses)
- ✅ Matériaux (PBR)
- ✅ Normales
- ❌ Animations (non utilisées)

### Performance

| Métrique | Valeur Idéale | Maximum |
|----------|---------------|---------|
| Taille fichier | 2-5 MB | 10 MB |
| Polygones | 10K-50K | 100K |
| Textures | 1024x1024 | 2048x2048 |
| Temps chargement | < 2s | < 5s |

## 🎨 Exemples d'Utilisation

### Exemple 1: Masque Traditionnel

```
Photo → Instant3D → GLB (3.2 MB)
↓
Renommer: masque_gelede_001.glb
↓
Placer: /public/models/masque_gelede_001.glb
↓
Admin: /models/masque_gelede_001.glb
↓
✅ Visible sur la page de détail
```

### Exemple 2: Sculpture

```
Photo → Instant3D → GLB (12 MB) ⚠️ Trop gros
↓
Compresser: gltf-pipeline → GLB (6 MB) ✅
↓
Renommer: sculpture_bronze_002.glb
↓
Placer: /public/models/sculpture_bronze_002.glb
↓
Admin: /models/sculpture_bronze_002.glb
↓
✅ Visible sur la page de détail
```

## 🔧 Dépannage

### Problème : Modèle ne s'affiche pas

**Vérifications :**

1. **Fichier existe ?**
   ```bash
   ls front/web/public/models/
   # Doit lister votre fichier .glb
   ```

2. **Chemin correct ?**
   ```
   ✅ /models/oeuvre1.glb
   ❌ ./models/oeuvre1.glb
   ❌ models/oeuvre1.glb
   ❌ /public/models/oeuvre1.glb
   ```

3. **Extension correcte ?**
   ```
   ✅ .glb (minuscule)
   ❌ .GLB (majuscule)
   ❌ .gltf
   ```

4. **Console navigateur ?**
   ```
   F12 → Console
   Chercher erreurs en rouge
   ```

### Problème : Chargement lent

**Solutions :**

1. **Compresser le fichier**
   ```bash
   gltf-pipeline -i input.glb -o output.glb -d
   ```

2. **Réduire résolution textures**
   - Instant3D : Options avancées
   - Choisir résolution plus basse

3. **Simplifier géométrie**
   - Instant3D : Réduire détails
   - Moins de polygones

### Problème : Modèle déformé

**Causes :**

- Photo de mauvaise qualité
- Angle de prise de vue inadéquat
- Fond trop chargé

**Solutions :**

- Reprendre photo avec fond uni
- Angle de face ou 3/4
- Bonne luminosité
- Re-générer sur Instant3D

### Problème : Erreur "Failed to load"

**Vérifier :**

1. Fichier corrompu → Re-télécharger
2. Format incorrect → Vérifier que c'est bien GLB
3. Serveur redémarré → Relancer `npm start`

## 📚 Structure des Données

### Backend (MongoDB)

```javascript
{
  _id: "123",
  title: { fr: "Masque Gelede", ... },
  images: ["url1.jpg", "url2.jpg"],
  model3D: "/models/masque_gelede_001.glb",  // ← Nouveau champ
  // ... autres champs
}
```

### Frontend (TypeScript)

```typescript
interface Artwork {
  _id: string;
  title: MultilingualText;
  images: string[];
  model3D?: string;  // ← Nouveau champ
  // ... autres champs
}
```

## 🎯 Bonnes Pratiques

### Nommage

```
[type]_[nom]_[numero].glb

✅ Bon :
- masque_gelede_001.glb
- sculpture_bronze_002.glb
- textile_kente_003.glb

❌ Mauvais :
- model.glb (trop générique)
- IMG_1234.glb (pas descriptif)
- masque gelede.glb (espaces)
```

### Organisation

```
public/models/
├── README.md
├── masques/
│   ├── gelede_001.glb
│   └── dogon_002.glb
├── sculptures/
│   ├── bronze_001.glb
│   └── bois_002.glb
└── textiles/
    ├── kente_001.glb
    └── bogolan_002.glb
```

### Documentation

Tenir un fichier `INVENTORY.md` :

```markdown
# Inventaire Modèles 3D

| ID | Nom | Fichier | Taille | Date |
|----|-----|---------|--------|------|
| 001 | Masque Gelede | masque_gelede_001.glb | 3.2 MB | 02/10/2025 |
| 002 | Sculpture Bronze | sculpture_bronze_002.glb | 6.1 MB | 02/10/2025 |
```

## 🚀 Optimisations Avancées

### Compression Draco

```bash
# Compression maximale
gltf-pipeline -i input.glb -o output.glb -d --draco.compressionLevel=10

# Réduction ~70% de la taille !
```

### Lazy Loading

Les modèles se chargent uniquement quand nécessaire (déjà implémenté).

### Préchargement

```typescript
// Précharger un modèle
import { preloadModel } from '../components/Model3DViewer';

preloadModel('/models/oeuvre1.glb');
```

## 📊 Statistiques

### Temps de Chargement Estimés

| Taille | 4G | WiFi | Fibre |
|--------|-----|------|-------|
| 2 MB | 4s | 1s | 0.5s |
| 5 MB | 10s | 2s | 1s |
| 10 MB | 20s | 4s | 2s |

### Espace Disque

```
100 œuvres × 5 MB = 500 MB
200 œuvres × 5 MB = 1 GB
```

## ✅ Checklist Finale

### Pour Chaque Œuvre

- [ ] Photo de qualité uploadée sur Instant3D
- [ ] Modèle 3D généré
- [ ] Téléchargé en format GLB
- [ ] Taille vérifiée (< 10 MB)
- [ ] Fichier renommé (descriptif)
- [ ] Placé dans `/public/models/`
- [ ] Chemin ajouté dans l'admin
- [ ] Testé sur la page de détail
- [ ] Contrôles fonctionnels
- [ ] Performance acceptable

## 🎉 Résultat Final

Vos visiteurs peuvent maintenant :

- ✅ Voir chaque œuvre en 3D
- ✅ Tourner à 360°
- ✅ Zoomer pour voir les détails
- ✅ Explorer sous tous les angles
- ✅ Mode plein écran immersif

**Expérience utilisateur enrichie ! 🚀**
