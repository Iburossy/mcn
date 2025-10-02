const User = require('../models/User');
const { generateToken } = require('../middleware/auth');
const { getFirebaseAuth } = require('../config/firebase');

// @desc    Inscription d'un nouvel utilisateur
// @route   POST /api/auth/register
// @access  Public
const register = async (req, res, next) => {
  try {
    const { phoneNumber, pin, name, role } = req.body;

    // Vérifier si l'utilisateur existe déjà
    const userExists = await User.findOne({ phoneNumber });
    if (userExists) {
      return res.status(400).json({
        success: false,
        message: 'Un utilisateur avec ce numéro de téléphone existe déjà'
      });
    }

    // Créer l'utilisateur
    const user = await User.create({
      phoneNumber,
      pin,
      name,
      role: role || 'visitor'
    });

    // Générer le token
    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: 'Utilisateur créé avec succès',
      data: {
        user,
        token
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Connexion d'un utilisateur
// @route   POST /api/auth/login
// @access  Public
const login = async (req, res, next) => {
  try {
    const { phoneNumber, pin } = req.body;

    // Vérifier si l'utilisateur existe
    const user = await User.findOne({ phoneNumber }).select('+pin');
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Numéro de téléphone ou code PIN incorrect'
      });
    }

    // Vérifier si l'utilisateur est actif
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Compte désactivé'
      });
    }

    // Vérifier le code PIN
    const isPinValid = await user.comparePin(pin);
    if (!isPinValid) {
      return res.status(401).json({
        success: false,
        message: 'Numéro de téléphone ou code PIN incorrect'
      });
    }

    // Générer le token
    const token = generateToken(user._id);

    res.json({
      success: true,
      message: 'Connexion réussie',
      data: {
        user: user.toJSON(),
        token
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer le profil de l'utilisateur connecté
// @route   GET /api/auth/me
// @access  Private
const getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);

    res.json({
      success: true,
      data: user
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Mettre à jour le profil
// @route   PUT /api/auth/profile
// @access  Private
const updateProfile = async (req, res, next) => {
  try {
    const { name, preferences } = req.body;

    const user = await User.findById(req.user._id);

    if (name) user.name = name;
    if (preferences) {
      user.preferences = {
        ...user.preferences,
        ...preferences
      };
    }

    await user.save();

    res.json({
      success: true,
      message: 'Profil mis à jour avec succès',
      data: user
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Changer le code PIN
// @route   PUT /api/auth/pin
// @access  Private
const changePin = async (req, res, next) => {
  try {
    const { currentPin, newPin } = req.body;

    const user = await User.findById(req.user._id).select('+pin');

    // Vérifier le code PIN actuel
    const isPinValid = await user.comparePin(currentPin);
    if (!isPinValid) {
      return res.status(401).json({
        success: false,
        message: 'Code PIN actuel incorrect'
      });
    }

    // Mettre à jour le code PIN
    user.pin = newPin;
    await user.save();

    res.json({
      success: true,
      message: 'Code PIN changé avec succès'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Authentification Google
// @route   POST /api/auth/google
// @access  Public
const googleAuth = async (req, res, next) => {
  try {
    const { idToken, fcmToken } = req.body;

    if (!idToken) {
      return res.status(400).json({
        success: false,
        message: 'Token Google requis'
      });
    }

    // Vérifier le token avec Firebase
    const firebaseAuth = getFirebaseAuth();
    const decodedToken = await firebaseAuth.verifyIdToken(idToken);

    const { uid, email, name, picture } = decodedToken;

    // Chercher ou créer l'utilisateur
    let user = await User.findOne({ firebaseUid: uid });

    if (!user) {
      // Créer un nouvel utilisateur
      user = await User.create({
        firebaseUid: uid,
        email,
        name: name || email.split('@')[0],
        authProvider: 'google',
        role: 'visitor'
      });
    }

    // Ajouter le token FCM si fourni
    if (fcmToken) {
      user.addFcmToken(fcmToken);
      await user.save();
    }

    // Mettre à jour la dernière connexion
    user.lastLoginAt = new Date();
    await user.save();

    // Générer le token JWT
    const token = generateToken(user._id);

    res.json({
      success: true,
      message: 'Connexion Google réussie',
      data: {
        user,
        token
      }
    });
  } catch (error) {
    if (error.code === 'auth/id-token-expired') {
      return res.status(401).json({
        success: false,
        message: 'Token Google expiré'
      });
    }
    if (error.code === 'auth/argument-error') {
      return res.status(400).json({
        success: false,
        message: 'Token Google invalide'
      });
    }
    next(error);
  }
};

// @desc    Authentification Apple
// @route   POST /api/auth/apple
// @access  Public
const appleAuth = async (req, res, next) => {
  try {
    const { idToken, fcmToken } = req.body;

    if (!idToken) {
      return res.status(400).json({
        success: false,
        message: 'Token Apple requis'
      });
    }

    // Vérifier le token avec Firebase
    const firebaseAuth = getFirebaseAuth();
    const decodedToken = await firebaseAuth.verifyIdToken(idToken);

    const { uid, email, name } = decodedToken;

    // Chercher ou créer l'utilisateur
    let user = await User.findOne({ firebaseUid: uid });

    if (!user) {
      // Créer un nouvel utilisateur
      user = await User.create({
        firebaseUid: uid,
        email,
        name: name || email?.split('@')[0] || 'Utilisateur Apple',
        authProvider: 'apple',
        role: 'visitor'
      });
    }

    // Ajouter le token FCM si fourni
    if (fcmToken) {
      user.addFcmToken(fcmToken);
      await user.save();
    }

    // Mettre à jour la dernière connexion
    user.lastLoginAt = new Date();
    await user.save();

    // Générer le token JWT
    const token = generateToken(user._id);

    res.json({
      success: true,
      message: 'Connexion Apple réussie',
      data: {
        user,
        token
      }
    });
  } catch (error) {
    if (error.code === 'auth/id-token-expired') {
      return res.status(401).json({
        success: false,
        message: 'Token Apple expiré'
      });
    }
    if (error.code === 'auth/argument-error') {
      return res.status(400).json({
        success: false,
        message: 'Token Apple invalide'
      });
    }
    next(error);
  }
};

// @desc    Enregistrer un token FCM
// @route   POST /api/auth/fcm-token
// @access  Private
const registerFcmToken = async (req, res, next) => {
  try {
    const { fcmToken } = req.body;

    if (!fcmToken) {
      return res.status(400).json({
        success: false,
        message: 'Token FCM requis'
      });
    }

    const user = await User.findById(req.user._id);
    user.addFcmToken(fcmToken);
    await user.save();

    res.json({
      success: true,
      message: 'Token FCM enregistré avec succès'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Supprimer un token FCM
// @route   DELETE /api/auth/fcm-token
// @access  Private
const removeFcmToken = async (req, res, next) => {
  try {
    const { fcmToken } = req.body;

    if (!fcmToken) {
      return res.status(400).json({
        success: false,
        message: 'Token FCM requis'
      });
    }

    const user = await User.findById(req.user._id);
    user.removeFcmToken(fcmToken);
    await user.save();

    res.json({
      success: true,
      message: 'Token FCM supprimé avec succès'
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getMe,
  updateProfile,
  changePin,
  googleAuth,
  appleAuth,
  registerFcmToken,
  removeFcmToken
};
