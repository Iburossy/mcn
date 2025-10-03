# 🐛 Debug Visite Virtuelle 3D

## Problèmes Corrigés

### ✅ 1. Chargement Asynchrone des Œuvres
**Problème :** `loadArtworks()` n'était pas attendu
**Solution :** Ajout de `.catch()` pour gérer les erreurs

```typescript
this.loadArtworks().catch(err => {
  console.error('Erreur lors du chargement des œuvres:', err);
});
```

### ✅ 2. Filtre API Incorrect
**Problème :** Utilisait `room` au lieu de `roomId`
**Solution :** Correction du paramètre

```typescript
const response = await artworkService.getArtworks({ roomId: this.room.roomId });
```

### ✅ 3. Curseur qui Bug
**Problème :** Conflit entre CSS et Three.js
**Solution :** Gestion du curseur dans `onMouseMove()`

```typescript
this.container.style.cursor = intersects.length > 0 ? 'pointer' : 'grab';
```

### ✅ 4. Images Manquantes
**Problème :** Pas de fallback si image absente
**Solution :** Vérification et placeholder

```typescript
let imageUrl = '/placeholder.jpg';
if (artwork.images && artwork.images.length > 0) {
  imageUrl = artwork.images[0];
}
```

## 🔍 Console Logs Ajoutés

Pour débugger, vérifiez la console :

```
✅ [nombre] œuvre(s) chargée(s)
✅ Texture chargée pour: [titre]
⚠️ Aucune œuvre trouvée pour cette salle
⚠️ Pas d'image pour l'œuvre: [titre]
❌ Erreur lors du chargement des œuvres: [erreur]
```

## 🧪 Tests à Effectuer

### 1. Vérifier le Chargement
```javascript
// Dans la console du navigateur
console.log('Room:', room);
console.log('Artworks:', artworks);
```

### 2. Vérifier les Contrôles
- ✅ Clic gauche + glisser → Rotation
- ✅ Molette → Zoom
- ✅ Clic droit + glisser → Pan
- ✅ Clic sur œuvre → Modal

### 3. Vérifier les Interactions
- ✅ Hover sur œuvre → Curseur pointer + glow
- ✅ Clic sur œuvre → Flash + modal
- ✅ Pas de hover → Curseur grab

## 🚨 Problèmes Potentiels

### Si les Œuvres ne s'Affichent Pas

**Vérifier :**
1. Les œuvres ont bien un `roomId` correspondant
2. L'API retourne des données
3. Les images sont accessibles
4. La console n'affiche pas d'erreurs

**Solution :**
```bash
# Vérifier dans MongoDB
db.artworks.find({ roomId: "SALLE-01" })

# Vérifier l'API
curl http://localhost:5000/api/artworks?roomId=SALLE-01
```

### Si les Contrôles ne Fonctionnent Pas

**Vérifier :**
1. OrbitControls est bien initialisé
2. `enableDamping` est activé
3. Pas de conflit avec d'autres event listeners

**Solution :**
```typescript
// Dans VirtualTourEngine
console.log('Controls:', this.controls);
console.log('Controls enabled:', this.controls.enabled);
```

### Si les Clics ne Fonctionnent Pas

**Vérifier :**
1. `artworkMeshes` contient des meshes
2. Raycaster est configuré correctement
3. `onArtworkClick` callback est défini

**Solution :**
```typescript
// Dans onClick()
console.log('Artworks meshes:', this.artworkMeshes.length);
console.log('Intersects:', intersects.length);
```

## 🔧 Commandes de Debug

### Dans la Console du Navigateur

```javascript
// Vérifier la scène
window.scene = engineRef.current.scene;
console.log('Scene children:', window.scene.children.length);

// Vérifier les œuvres
console.log('Artworks:', engineRef.current.artworks);

// Forcer un re-render
engineRef.current.renderer.render(
  engineRef.current.scene, 
  engineRef.current.camera
);
```

## ✅ Checklist de Vérification

- [ ] Les œuvres sont dans la base de données
- [ ] Les œuvres ont un `roomId` valide
- [ ] Les images des œuvres sont accessibles
- [ ] L'API retourne les œuvres correctement
- [ ] La console ne montre pas d'erreurs
- [ ] Les contrôles répondent
- [ ] Le hover fonctionne
- [ ] Le clic ouvre le modal
- [ ] Les textures se chargent

## 📝 Logs Attendus

```
Chargement des œuvres pour la salle: SALLE-01 ID: 68ddc...
Réponse API œuvres: { success: true, data: [...] }
✅ 4 œuvre(s) chargée(s)
Chargement image: http://localhost:5000/uploads/...
✅ Texture chargée pour: Masque Sénoufo
✅ Texture chargée pour: enfant
...
```

## 🎯 Performance

Si la scène est lente :

1. **Réduire les ombres**
```typescript
this.renderer.shadowMap.enabled = false;
```

2. **Réduire la qualité**
```typescript
this.renderer.setPixelRatio(1);
```

3. **Limiter les lumières**
```typescript
// Désactiver certains spots
```
