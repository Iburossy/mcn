# 🚀 Setup Guide - React Web App

## Installation

```bash
cd front/web
npm install
```

## Configuration

1. Copier `.env.example` vers `.env`
2. Configurer l'URL de l'API backend :
```env
REACT_APP_API_URL=http://localhost:5000/api
```

## Démarrage

```bash
npm start
```

L'application sera accessible sur **http://localhost:3000**

## Structure du Projet

```
src/
├── components/          # Composants réutilisables
│   ├── Layout/         # Header, Footer, Layout
│   └── Common/         # Loading, ErrorMessage, etc.
├── pages/              # Pages de l'application
│   ├── HomePage.tsx
│   ├── LoginPage.tsx
│   └── ...
├── services/           # Services API
│   ├── api.ts          # Client Axios
│   ├── authService.ts
│   ├── artworkService.ts
│   └── ...
├── contexts/           # Context API (State Management)
│   ├── AuthContext.tsx
│   └── LanguageContext.tsx
├── types/              # TypeScript types
│   └── index.ts
├── config/             # Configuration
│   └── constants.ts
├── App.tsx             # Composant principal
└── index.tsx           # Point d'entrée
```

## Fonctionnalités Implémentées

### ✅ Configuration de Base
- [x] React 19 + TypeScript
- [x] React Router v6
- [x] Tailwind CSS
- [x] Axios pour les appels API
- [x] Context API pour le state management

### ✅ Services API
- [x] Client Axios configuré avec intercepteurs
- [x] Service d'authentification (login, register, Google, Apple)
- [x] Service des œuvres (CRUD, filtres, stats)
- [x] Service des salles (CRUD, 3D)
- [x] Service des visites (tracking, historique)

### ✅ Contexts
- [x] AuthContext (authentification, user, token)
- [x] LanguageContext (FR/EN/WO)

### ✅ Composants
- [x] Layout (Header, Footer)
- [x] Loading spinner
- [x] ErrorMessage

### ✅ Pages
- [x] HomePage (hero, œuvres populaires)
- [x] LoginPage (téléphone + PIN)

### ⏳ À Implémenter
- [ ] Page liste des œuvres (avec filtres)
- [ ] Page détails d'une œuvre
- [ ] Page liste des salles
- [ ] Page visite virtuelle 3D
- [ ] Page profil utilisateur
- [ ] Dashboard admin
- [ ] Page d'inscription

## Scripts Disponibles

```bash
# Démarrer en développement
npm start

# Build pour production
npm run build

# Tests
npm test

# Linter
npm run lint
```

## Technologies Utilisées

- **React 19** - Framework UI
- **TypeScript** - Typage statique
- **React Router v6** - Navigation
- **Tailwind CSS** - Styling
- **Axios** - HTTP client
- **Context API** - State management

## Connexion au Backend

L'application se connecte au backend Node.js sur `http://localhost:5000/api`

Assurez-vous que le backend est démarré :
```bash
cd ../../back
npm run dev
```

## Prochaines Étapes

1. **Implémenter les pages manquantes** :
   - ArtworksPage (liste avec filtres)
   - ArtworkDetailPage (détails + audio/vidéo)
   - RoomsPage
   - VirtualTourPage (Three.js)
   - ProfilePage
   - RegisterPage

2. **Ajouter Three.js pour la visite 3D** :
   ```bash
   npm install three @react-three/fiber @react-three/drei
   ```

3. **Améliorer l'UX** :
   - Animations
   - Transitions
   - Responsive design
   - PWA (offline support)

4. **Tests** :
   - Tests unitaires (Jest)
   - Tests d'intégration
   - Tests E2E (Cypress)

---

**L'application React est prête pour le développement ! 🎉**
