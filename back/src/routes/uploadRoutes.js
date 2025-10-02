const express = require('express');
const router = express.Router();
const multer = require('multer');
const { cloudinary, isCloudinaryConfigured } = require('../config/cloudinary');
const { protect, authorize } = require('../middleware/auth');

// Configuration Multer pour upload en mémoire
const storage = multer.memoryStorage();
const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB max
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Seules les images sont autorisées'), false);
    }
  },
});

/**
 * @route   POST /api/upload/image
 * @desc    Upload une image vers Cloudinary
 * @access  Private (Admin/Curator)
 */
router.post(
  '/image',
  protect,
  authorize('admin', 'curator'),
  upload.single('image'),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: 'Aucune image fournie',
        });
      }

      // Vérifier si Cloudinary est configuré
      if (!isCloudinaryConfigured()) {
        return res.status(503).json({
          success: false,
          message: 'Cloudinary non configuré. Utilisez le mode Base64 côté client.',
          error: 'CLOUDINARY_NOT_CONFIGURED',
        });
      }

      // Upload vers Cloudinary
      const result = await new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
          {
            folder: 'mcn/artworks',
            transformation: [
              { width: 1200, height: 1200, crop: 'limit' },
              { quality: 'auto' },
            ],
          },
          (error, result) => {
            if (error) reject(error);
            else resolve(result);
          }
        );

        uploadStream.end(req.file.buffer);
      });

      res.status(200).json({
        success: true,
        data: {
          url: result.secure_url,
          publicId: result.public_id,
        },
      });
    } catch (error) {
      console.error('Erreur upload image:', error);
      res.status(500).json({
        success: false,
        message: 'Erreur lors de l\'upload de l\'image',
        error: error.message,
      });
    }
  }
);

/**
 * @route   POST /api/upload/images
 * @desc    Upload plusieurs images vers Cloudinary
 * @access  Private (Admin/Curator)
 */
router.post(
  '/images',
  protect,
  authorize('admin', 'curator'),
  upload.array('images', 5),
  async (req, res) => {
    try {
      if (!req.files || req.files.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'Aucune image fournie',
        });
      }

      // Vérifier si Cloudinary est configuré
      if (!isCloudinaryConfigured()) {
        return res.status(503).json({
          success: false,
          message: 'Cloudinary non configuré. Utilisez le mode Base64 côté client.',
          error: 'CLOUDINARY_NOT_CONFIGURED',
        });
      }

      // Upload toutes les images
      const uploadPromises = req.files.map((file) => {
        return new Promise((resolve, reject) => {
          const uploadStream = cloudinary.uploader.upload_stream(
            {
              folder: 'mcn/artworks',
              transformation: [
                { width: 1200, height: 1200, crop: 'limit' },
                { quality: 'auto' },
              ],
            },
            (error, result) => {
              if (error) reject(error);
              else resolve(result);
            }
          );

          uploadStream.end(file.buffer);
        });
      });

      const results = await Promise.all(uploadPromises);

      const urls = results.map((result) => ({
        url: result.secure_url,
        publicId: result.public_id,
      }));

      res.status(200).json({
        success: true,
        data: urls,
      });
    } catch (error) {
      console.error('Erreur upload images:', error);
      res.status(500).json({
        success: false,
        message: 'Erreur lors de l\'upload des images',
        error: error.message,
      });
    }
  }
);

/**
 * @route   DELETE /api/upload/image/:publicId
 * @desc    Supprimer une image de Cloudinary
 * @access  Private (Admin/Curator)
 */
router.delete(
  '/image/:publicId',
  protect,
  authorize('admin', 'curator'),
  async (req, res) => {
    try {
      const publicId = req.params.publicId.replace(/_/g, '/');

      await cloudinary.uploader.destroy(publicId);

      res.status(200).json({
        success: true,
        message: 'Image supprimée avec succès',
      });
    } catch (error) {
      console.error('Erreur suppression image:', error);
      res.status(500).json({
        success: false,
        message: 'Erreur lors de la suppression de l\'image',
        error: error.message,
      });
    }
  }
);

module.exports = router;
