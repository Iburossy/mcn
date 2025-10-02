const express = require('express');
const router = express.Router();
const {
  createVisit,
  getUserVisitHistory,
  getDeviceVisitHistory,
  getGlobalStats
} = require('../controllers/visitController');
const { protect, authorize } = require('../middleware/auth');
const { visitValidation } = require('../middleware/validator');

// Routes publiques
router.post('/', visitValidation.create, createVisit);
router.get('/device/:deviceId', getDeviceVisitHistory);

// Routes protégées
router.get('/user/:userId?', protect, getUserVisitHistory);
router.get('/stats/global', protect, authorize('admin', 'curator'), getGlobalStats);

module.exports = router;
