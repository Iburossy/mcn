# 🔧 Troubleshooting - Visite Virtuelle

## ❌ Problème: Chargement Infini

### Causes Possibles

1. **Backend non démarré**
2. **URL incorrecte (pas de paramètre `?room=ID`)**
3. **Salle inexistante dans la base de données**
4. **Problème réseau**
5. **CORS bloqué**

## 🔍 Diagnostic

### 1. Vérifier la Console du Navigateur (F12)

Vous devriez voir :
```
🔍 Chargement de la salle: [ID]
✅ Réponse reçue: { success: true, data: {...} }
✅ Salle chargée: { fr: "...", en: "...", wo: "..." }
```

**Si vous voyez :**
```
❌ Erreur: Network Error
```
→ Le backend n'est pas démarré

```
❌ Erreur: 404
```
→ La salle n'existe pas

```
❌ Erreur: Timeout
```
→ Le serveur est trop lent ou bloqué

### 2. Vérifier l'URL

**URL Correcte :**
```
http://localhost:3000/virtual-tour?room=68ddc128fadce8314e902f
```

**URL Incorrecte :**
```
http://localhost:3000/virtual-tour
```
→ Manque le paramètre `?room=ID`

### 3. Vérifier le Backend

```bash
# Terminal 1 - Backend
cd back
npm start

# Devrait afficher:
# Server running on port 5000
```

**Tester l'API directement :**
```bash
curl http://localhost:5000/api/rooms
```

### 4. Vérifier la Base de Données

```bash
# MongoDB
mongosh
use musee
db.virtualrooms.find()
```

**Vérifier qu'il y a des salles :**
```javascript
{
  _id: ObjectId("..."),
  roomId: "SALLE-01",
  name: { fr: "...", en: "...", wo: "..." },
  ...
}
```

## ✅ Solutions

### Solution 1: Démarrer le Backend

```bash
cd back
npm start
```

### Solution 2: Créer une Salle

Si aucune salle n'existe :

```bash
# Aller sur l'admin
http://localhost:3000/admin/rooms/new

# Créer une salle avec:
- Nom (FR): "Hall Principal"
- Description (FR): "Salle d'accueil..."
```

### Solution 3: Corriger l'URL

Depuis la page des salles, cliquer sur **"Explorer en 3D"** au lieu d'accéder directement à `/virtual-tour`.

### Solution 4: Vérifier .env

```bash
# front/web/.env
REACT_APP_API_URL=http://localhost:5000/api
```

## 🧪 Tests Rapides

### Test 1: Backend Actif

```bash
curl http://localhost:5000/api/rooms
```

**Attendu :**
```json
{
  "success": true,
  "data": [...]
}
```

### Test 2: Salle Spécifique

```bash
curl http://localhost:5000/api/rooms/[ID]
```

**Attendu :**
```json
{
  "success": true,
  "data": {
    "_id": "...",
    "roomId": "SALLE-01",
    "name": {...}
  }
}
```

### Test 3: Frontend

1. Ouvrir la console (F12)
2. Aller sur `/rooms`
3. Cliquer "Explorer en 3D"
4. Vérifier les logs

## 📋 Checklist de Debug

- [ ] Backend démarré (`npm start` dans `/back`)
- [ ] Frontend démarré (`npm start` dans `/front/web`)
- [ ] MongoDB actif
- [ ] Au moins une salle existe dans la DB
- [ ] URL contient `?room=ID`
- [ ] Console ne montre pas d'erreurs
- [ ] Network tab montre la requête API
- [ ] Pas d'erreur CORS

## 🚨 Erreurs Courantes

### "Aucune salle spécifiée"
→ URL manque `?room=ID`
→ **Solution:** Cliquer sur "Explorer en 3D" depuis la page des salles

### "Timeout: Le serveur ne répond pas"
→ Backend non démarré
→ **Solution:** `cd back && npm start`

### "Salle non trouvée"
→ ID invalide ou salle supprimée
→ **Solution:** Vérifier dans MongoDB ou créer une nouvelle salle

### "Network Error"
→ Backend non accessible
→ **Solution:** Vérifier que le backend tourne sur le port 5000

## 💡 Logs Ajoutés

La page affiche maintenant des logs détaillés :

```
🔍 Chargement de la salle: [ID]
✅ Réponse reçue: [response]
✅ Salle chargée: [name]
❌ Erreur: [message]
```

## 🎯 Workflow de Test

1. **Démarrer Backend**
   ```bash
   cd back
   npm start
   ```

2. **Démarrer Frontend**
   ```bash
   cd front/web
   npm start
   ```

3. **Créer une Salle** (si nécessaire)
   - Aller sur `/admin/rooms/new`
   - Remplir le formulaire
   - Sauvegarder

4. **Tester la Visite**
   - Aller sur `/rooms`
   - Cliquer "Explorer en 3D"
   - Vérifier que la scène 3D se charge

## 📞 Support

Si le problème persiste, vérifiez :
1. Les logs de la console navigateur
2. Les logs du backend
3. L'onglet Network (F12)
4. MongoDB est bien connecté
