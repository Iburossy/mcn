# 🔐 Modifications du Système d'Authentification

## Changements Effectués

Le système d'authentification a été modifié pour utiliser :
- **Numéro de téléphone** (5-10 chiffres) au lieu d'email
- **Code PIN de 4 chiffres** au lieu d'un mot de passe

---

## 📋 Détails des Modifications

### 1. Modèle User (`src/models/User.js`)

**Avant :**
```javascript
{
  email: String (unique),
  password: String (min 6 caractères)
}
```

**Après :**
```javascript
{
  phoneNumber: String (5-10 chiffres, unique),
  pin: String (4 chiffres exactement)
}
```

**Validations :**
- `phoneNumber` : Regex `/^\d{5,10}$/` (5 à 10 chiffres)
- `pin` : Regex `/^\d{4}$/` (exactement 4 chiffres)

### 2. Controller Auth (`src/controllers/authController.js`)

**Inscription (Register) :**
```javascript
// Avant
{ email, password, name, role }

// Après
{ phoneNumber, pin, name, role }
```

**Connexion (Login) :**
```javascript
// Avant
{ email, password }

// Après
{ phoneNumber, pin }
```

**Changement de mot de passe → Changement de PIN :**
```javascript
// Avant
PUT /api/auth/password
{ currentPassword, newPassword }

// Après
PUT /api/auth/pin
{ currentPin, newPin }
```

### 3. Validations (`src/middleware/validator.js`)

**userValidation.register :**
```javascript
body('phoneNumber')
  .matches(/^\d{5,10}$/)
  .withMessage('Le numéro de téléphone doit contenir entre 5 et 10 chiffres'),
body('pin')
  .matches(/^\d{4}$/)
  .withMessage('Le code PIN doit contenir exactement 4 chiffres')
```

**userValidation.login :**
```javascript
body('phoneNumber')
  .matches(/^\d{5,10}$/)
  .withMessage('Le numéro de téléphone doit contenir entre 5 et 10 chiffres'),
body('pin')
  .matches(/^\d{4}$/)
  .withMessage('Le code PIN doit contenir exactement 4 chiffres')
```

**userValidation.changePin (nouveau) :**
```javascript
body('currentPin')
  .matches(/^\d{4}$/)
  .withMessage('Le code PIN actuel doit contenir exactement 4 chiffres'),
body('newPin')
  .matches(/^\d{4}$/)
  .withMessage('Le nouveau code PIN doit contenir exactement 4 chiffres')
```

### 4. Routes (`src/routes/auth.js`)

**Changement :**
```javascript
// Avant
router.put('/password', protect, changePassword);

// Après
router.put('/pin', protect, userValidation.changePin, changePin);
```

### 5. Données de Test (`src/scripts/seedData.js`)

**Comptes de test mis à jour :**

| Rôle | Téléphone | PIN | Nom |
|------|-----------|-----|-----|
| Admin | 771234567 | 1234 | Administrateur Musée |
| Curator | 779876543 | 5678 | Conservateur Principal |
| Visitor | 701112233 | 9999 | Visiteur Test |

### 6. Collection Postman

**Register :**
```json
{
  "phoneNumber": "123456789",
  "pin": "1234",
  "name": "Test User",
  "role": "visitor"
}
```

**Login :**
```json
{
  "phoneNumber": "771234567",
  "pin": "1234"
}
```

---

## 🔒 Sécurité

Le code PIN est **hashé avec bcryptjs** avant d'être stocké en base de données, exactement comme l'ancien mot de passe.

**Méthodes :**
- `user.comparePin(candidatePin)` - Compare le PIN fourni avec le hash
- Le PIN n'est jamais retourné dans les réponses JSON

---

## 📡 Nouveaux Endpoints

### Inscription
```http
POST /api/auth/register
Content-Type: application/json

{
  "phoneNumber": "771234567",
  "pin": "1234",
  "name": "Nom Utilisateur",
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
      "_id": "...",
      "phoneNumber": "771234567",
      "name": "Nom Utilisateur",
      "role": "visitor"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Connexion
```http
POST /api/auth/login
Content-Type: application/json

{
  "phoneNumber": "771234567",
  "pin": "1234"
}
```

**Réponse :**
```json
{
  "success": true,
  "message": "Connexion réussie",
  "data": {
    "user": {
      "_id": "...",
      "phoneNumber": "771234567",
      "name": "Administrateur Musée",
      "role": "admin"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Changer le PIN
```http
PUT /api/auth/pin
Authorization: Bearer <token>
Content-Type: application/json

{
  "currentPin": "1234",
  "newPin": "5678"
}
```

**Réponse :**
```json
{
  "success": true,
  "message": "Code PIN changé avec succès"
}
```

---

## ✅ Tests

### Tester avec cURL

**Inscription :**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "701234567",
    "pin": "1234",
    "name": "Test User",
    "role": "visitor"
  }'
```

**Connexion :**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "771234567",
    "pin": "1234"
  }'
```

**Changer le PIN :**
```bash
curl -X PUT http://localhost:5000/api/auth/pin \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "currentPin": "1234",
    "newPin": "5678"
  }'
```

---

## 🔄 Migration des Données

Si vous avez déjà des utilisateurs avec email/password dans la base de données, vous devez :

1. **Supprimer les anciennes données :**
```bash
npm run seed
```

2. **Ou migrer manuellement** en créant un script de migration

---

## 📱 Intégration Flutter

### Exemple d'inscription
```dart
final response = await http.post(
  Uri.parse('$baseUrl/api/auth/register'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'phoneNumber': phoneController.text,
    'pin': pinController.text,
    'name': nameController.text,
    'role': 'visitor',
  }),
);
```

### Exemple de connexion
```dart
final response = await http.post(
  Uri.parse('$baseUrl/api/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'phoneNumber': phoneController.text,
    'pin': pinController.text,
  }),
);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  final token = data['data']['token'];
  // Stocker le token
  await storage.write(key: 'auth_token', value: token);
}
```

---

## ⚠️ Messages d'Erreur

**Numéro invalide :**
```json
{
  "success": false,
  "message": "Erreur de validation",
  "errors": [
    {
      "msg": "Le numéro de téléphone doit contenir entre 5 et 10 chiffres",
      "param": "phoneNumber"
    }
  ]
}
```

**PIN invalide :**
```json
{
  "success": false,
  "message": "Erreur de validation",
  "errors": [
    {
      "msg": "Le code PIN doit contenir exactement 4 chiffres",
      "param": "pin"
    }
  ]
}
```

**Numéro déjà utilisé :**
```json
{
  "success": false,
  "message": "Un utilisateur avec ce numéro de téléphone existe déjà"
}
```

**Identifiants incorrects :**
```json
{
  "success": false,
  "message": "Numéro de téléphone ou code PIN incorrect"
}
```

---

## 🎯 Avantages de ce Système

1. **Simplicité** : Plus facile pour les utilisateurs (pas besoin de retenir un email)
2. **Accessibilité** : Adapté au contexte africain où les numéros de téléphone sont plus utilisés
3. **Sécurité** : Le PIN est hashé avec bcryptjs
4. **Validation** : Regex stricte pour éviter les erreurs de saisie
5. **UX** : Interface de connexion plus simple (clavier numérique uniquement)

---

## 📝 Checklist de Migration

- [x] Modèle User modifié (phoneNumber + pin)
- [x] Controller Auth adapté (register, login, changePin)
- [x] Validations mises à jour
- [x] Routes modifiées
- [x] Script seed mis à jour
- [x] Collection Postman adaptée
- [x] Documentation créée

---

**Le système d'authentification est maintenant prêt avec numéro de téléphone + PIN !** 🎉
