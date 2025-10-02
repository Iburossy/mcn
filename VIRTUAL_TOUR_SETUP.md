# Configuration Visite Virtuelle 3D

## 📦 Installation des Dépendances

```bash
cd front/web
npm install three @types/three
```

## 🏗️ Architecture

### Composants Créés (Principe DRY)

```
components/VirtualTour/
├── Scene3D.tsx              # Composant React wrapper
├── VirtualTourEngine.ts     # Moteur Three.js réutilisable
└── index.ts                 # Export centralisé
```

### Fonctionnalités Implémentées

✅ **Navigation 3D**
- WASD ou Flèches pour se déplacer
- Souris pour regarder autour
- PointerLockControls pour une expérience immersive

✅ **Scène 3D**
- Sol avec ombres
- Murs de la salle
- Support du modèle 3D de la salle (GLB)

✅ **Éclairage Réaliste**
- Lumière ambiante
- Lumière directionnelle avec ombres
- Spots pour les œuvres

✅ **Interactions**
- Raycasting pour détecter les clics
- Callback pour les œuvres cliquées
- Navigation vers la page de détail

✅ **Performance**
- Nettoyage automatique des ressources
- Gestion mémoire optimisée
- Responsive

## 🎮 Contrôles

| Touche | Action |
|--------|--------|
| W / ↑  | Avancer |
| S / ↓  | Reculer |
| A / ←  | Gauche |
| D / →  | Droite |
| Souris | Regarder |
| Clic   | Verrouiller/Déverrouiller la souris |

## 🔄 Workflow

1. **Charger la salle** → `roomService.getRoomById()`
2. **Initialiser Three.js** → `VirtualTourEngine`
3. **Charger le modèle 3D** → GLTFLoader
4. **Naviguer** → PointerLockControls
5. **Interagir** → Raycaster + Callbacks

## 🎨 Personnalisation

### Ajouter des Œuvres

```typescript
// Dans VirtualTourEngine.ts
private loadArtworks(): void {
  this.room.artworks?.forEach(artwork => {
    // Créer un mesh pour chaque œuvre
    const artworkMesh = new THREE.Mesh(
      new THREE.PlaneGeometry(1, 1.5),
      new THREE.MeshStandardMaterial({
        map: textureLoader.load(artwork.image)
      })
    );
    artworkMesh.userData.artworkId = artwork.artworkId;
    this.scene.add(artworkMesh);
  });
}
```

### Modifier l'Éclairage

```typescript
// Dans setupLighting()
const ambientLight = new THREE.AmbientLight(0xffffff, 0.4);
const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
```

## 🚀 Prochaines Étapes

- [ ] Ajouter une minimap
- [ ] Charger les œuvres depuis la base de données
- [ ] Ajouter des effets de post-processing
- [ ] Optimiser les performances (LOD, culling)
- [ ] Ajouter des sons ambiants
- [ ] Support VR/AR

## 📝 Notes

- Le moteur est **réutilisable** pour d'autres salles
- Architecture **modulaire** et **maintenable**
- Code **propre** avec TypeScript
- **Principe DRY** appliqué partout
