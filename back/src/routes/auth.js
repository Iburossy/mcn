const express = require('express');
const router = express.Router();
const {
  register,
  login,
  getMe,
  updateProfile,
  changePin,
  googleAuth,
  appleAuth,
  registerFcmToken,
  removeFcmToken
} = require('../controllers/authController');
const { protect } = require('../middleware/auth');
const { userValidation } = require('../middleware/validator');

// Routes publiques
router.post('/register', userValidation.register, register);
router.post('/login', userValidation.login, login);
router.post('/google', googleAuth);
router.post('/apple', appleAuth);

// Routes protégées
router.get('/me', protect, getMe);
router.put('/profile', protect, updateProfile);
router.put('/pin', protect, userValidation.changePin, changePin);
router.post('/fcm-token', protect, registerFcmToken);
router.delete('/fcm-token', protect, removeFcmToken);

module.exports = router;
