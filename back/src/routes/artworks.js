const express = require('express');
const router = express.Router();
const {
  getAllArtworks,
  getArtworkById,
  getArtworkByQRCode,
  createArtwork,
  updateArtwork,
  deleteArtwork,
  uploadArtworkMedia,
  getArtworkStats,
  getPopularArtworks
} = require('../controllers/artworkController');
const { protect, authorize } = require('../middleware/auth');
const { upload, handleUploadError } = require('../middleware/upload');
const { artworkValidation } = require('../middleware/validator');

// Routes publiques
router.get('/', getAllArtworks);
router.get('/popular', getPopularArtworks);
router.get('/qr/:qrCode', artworkValidation.getByQR, getArtworkByQRCode);
router.get('/:id', artworkValidation.getById, getArtworkById);
router.get('/:id/stats', artworkValidation.getById, getArtworkStats);

// Routes protégées (Admin/Curator)
router.post(
  '/',
  protect,
  authorize('admin', 'curator'),
  artworkValidation.create,
  createArtwork
);

router.put(
  '/:id',
  protect,
  authorize('admin', 'curator'),
  artworkValidation.update,
  updateArtwork
);

router.delete(
  '/:id',
  protect,
  authorize('admin'),
  artworkValidation.getById,
  deleteArtwork
);

// Upload de médias
router.post(
  '/:id/media',
  protect,
  authorize('admin', 'curator'),
  upload.fields([
    { name: 'images', maxCount: 10 },
    { name: 'audio_fr', maxCount: 1 },
    { name: 'audio_en', maxCount: 1 },
    { name: 'audio_wo', maxCount: 1 },
    { name: 'video', maxCount: 1 }
  ]),
  handleUploadError,
  uploadArtworkMedia
);

module.exports = router;
