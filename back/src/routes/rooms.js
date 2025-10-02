const express = require('express');
const router = express.Router();
const {
  getAllRooms,
  getRoomById,
  getRoomByRoomId,
  createRoom,
  updateRoom,
  deleteRoom,
  addArtworkToRoom,
  removeArtworkFromRoom,
  uploadRoomAssets
} = require('../controllers/roomController');
const { protect, authorize } = require('../middleware/auth');
const { upload, handleUploadError } = require('../middleware/upload');
const { roomValidation } = require('../middleware/validator');

// Routes publiques
router.get('/', getAllRooms);
router.get('/room/:roomId', getRoomByRoomId);
router.get('/:id', getRoomById);

// Routes protégées (Admin)
router.post(
  '/',
  protect,
  authorize('admin'),
  roomValidation.create,
  createRoom
);

router.put(
  '/:id',
  protect,
  authorize('admin'),
  roomValidation.update,
  updateRoom
);

router.delete(
  '/:id',
  protect,
  authorize('admin'),
  deleteRoom
);

// Gestion des œuvres dans les salles
router.post(
  '/:id/artworks',
  protect,
  authorize('admin', 'curator'),
  addArtworkToRoom
);

router.delete(
  '/:id/artworks/:artworkId',
  protect,
  authorize('admin', 'curator'),
  removeArtworkFromRoom
);

// Upload des assets 3D
router.post(
  '/:id/assets',
  protect,
  authorize('admin'),
  upload.fields([
    { name: 'model3D', maxCount: 1 },
    { name: 'floorTexture', maxCount: 1 },
    { name: 'wallTexture', maxCount: 1 }
  ]),
  handleUploadError,
  uploadRoomAssets
);

module.exports = router;
