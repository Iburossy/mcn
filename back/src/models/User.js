const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  authProvider: {
    type: String,
    enum: ['local', 'google', 'apple'],
    default: 'local'
  },
  phoneNumber: {
    type: String,
    unique: true,
    sparse: true,
    trim: true
  },
  pin: {
    type: String
  },
  firebaseUid: {
    type: String,
    unique: true,
    sparse: true
  },
  email: {
    type: String,
    lowercase: true,
    trim: true
  },
  name: {
    type: String,
    required: true
  },
  role: {
    type: String,
    enum: ['admin', 'curator', 'visitor'],
    default: 'visitor'
  },
  preferences: {
    language: {
      type: String,
      enum: ['fr', 'en', 'wo'],
      default: 'fr'
    },
    notifications: {
      type: Boolean,
      default: true
    }
  },
  isActive: {
    type: Boolean,
    default: true
  },
  fcmTokens: [{ type: String }],
  lastLoginAt: {
    type: Date
  }
}, {
  timestamps: true
});

// Validation conditionnelle selon le fournisseur d'authentification
userSchema.pre('validate', function(next) {
  if (this.authProvider === 'local') {
    if (!this.phoneNumber) {
      this.invalidate('phoneNumber', 'Le numéro de téléphone est requis pour l\'authentification locale');
    } else if (!/^\d{5,10}$/.test(this.phoneNumber)) {
      this.invalidate('phoneNumber', 'Le numéro de téléphone doit contenir entre 5 et 10 chiffres');
    }

    if (!this.pin) {
      this.invalidate('pin', 'Le code PIN est requis pour l\'authentification locale');
    } else if (!/^\d{4}$/.test(this.pin)) {
      this.invalidate('pin', 'Le code PIN doit contenir exactement 4 chiffres');
    }
  } else {
    if (!this.firebaseUid) {
      this.invalidate('firebaseUid', 'L\'identifiant Firebase est requis pour l\'authentification externe');
    }

    if (!this.email) {
      this.invalidate('email', 'L\'adresse email est requise pour l\'authentification externe');
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
      this.invalidate('email', 'Adresse email invalide');
    }
  }

  next();
});

// Hash du code PIN avant sauvegarde
userSchema.pre('save', async function(next) {
  if (!this.isModified('pin') || !this.pin) {
    return next();
  }

  const salt = await bcrypt.genSalt(10);
  this.pin = await bcrypt.hash(this.pin, salt);
  next();
});

// Méthode pour comparer les codes PIN
userSchema.methods.comparePin = async function(candidatePin) {
  if (!this.pin) {
    return false;
  }
  return await bcrypt.compare(candidatePin, this.pin);
};

// Gestion des tokens FCM
userSchema.methods.addFcmToken = function(token) {
  if (!token) return;
  if (!Array.isArray(this.fcmTokens)) {
    this.fcmTokens = [];
  }
  if (!this.fcmTokens.includes(token)) {
    this.fcmTokens.push(token);
  }
};

userSchema.methods.removeFcmToken = function(token) {
  if (!token || !Array.isArray(this.fcmTokens)) return;
  this.fcmTokens = this.fcmTokens.filter((t) => t !== token);
};

// Ne pas retourner le PIN ni les tokens dans les réponses JSON
userSchema.methods.toJSON = function() {
  const obj = this.toObject();
  delete obj.pin;
  delete obj.fcmTokens;
  return obj;
};

module.exports = mongoose.model('User', userSchema);
