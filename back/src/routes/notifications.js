const express = require('express');
const router = express.Router();
const {
  sendToUser,
  sendToMultiple,
  broadcast,
  sendToTopic,
  subscribe,
  unsubscribe
} = require('../controllers/notificationController');
const { protect, authorize } = require('../middleware/auth');

// Routes protégées - Admin/Curator uniquement
router.post('/send', protect, authorize('admin', 'curator'), sendToUser);
router.post('/send-multiple', protect, authorize('admin', 'curator'), sendToMultiple);
router.post('/broadcast', protect, authorize('admin'), broadcast);
router.post('/topic', protect, authorize('admin', 'curator'), sendToTopic);

// Routes protégées - Tous les utilisateurs authentifiés
router.post('/subscribe', protect, subscribe);
router.post('/unsubscribe', protect, unsubscribe);

module.exports = router;
