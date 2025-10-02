const Artwork = require('../models/Artwork');
const VisitHistory = require('../models/VisitHistory');
const { uploadToCloudinary, deleteFromCloudinary } = require('../config/cloudinary');
const { generateQRCode, generateQRCodeBase64, generateUniqueQRId } = require('../utils/qrGenerator');
const { getPagination, formatPaginatedResponse, extractCloudinaryPublicId } = require('../utils/helpers');

// @desc    Récupérer toutes les œuvres
// @route   GET /api/artworks
// @access  Public
const getAllArtworks = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, category, roomId, search, isActive = true } = req.query;
    const { skip, limit: limitNum, page: pageNum } = getPagination(page, limit);

    // Construction du filtre
    const filter = { isActive };
    if (category) filter.category = category;
    if (roomId) filter.roomId = roomId;
    if (search) {
      filter.$or = [
        { 'title.fr': { $regex: search, $options: 'i' } },
        { 'title.en': { $regex: search, $options: 'i' } },
        { 'title.wo': { $regex: search, $options: 'i' } }
      ];
    }

    const [artworks, total] = await Promise.all([
      Artwork.find(filter)
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limitNum)
        .lean(),
      Artwork.countDocuments(filter)
    ]);

    res.json(formatPaginatedResponse(artworks, total, pageNum, limitNum));
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer une œuvre par ID
// @route   GET /api/artworks/:id
// @access  Public
const getArtworkById = async (req, res, next) => {
  try {
    const artwork = await Artwork.findById(req.params.id);

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    // Incrémenter le compteur de vues
    await artwork.incrementViewCount();

    res.json({
      success: true,
      data: artwork
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer une œuvre par QR Code
// @route   GET /api/artworks/qr/:qrCode
// @access  Public
const getArtworkByQRCode = async (req, res, next) => {
  try {
    const artwork = await Artwork.findOne({ qrCode: req.params.qrCode });

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée avec ce QR Code'
      });
    }

    // Incrémenter le compteur de vues
    await artwork.incrementViewCount();

    res.json({
      success: true,
      data: artwork
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Créer une nouvelle œuvre
// @route   POST /api/artworks
// @access  Private (Admin/Curator)
const createArtwork = async (req, res, next) => {
  try {
    const artworkData = req.body;

    // Générer un QR Code unique
    const qrCodeId = generateUniqueQRId();
    artworkData.qrCode = qrCodeId;

    // Créer l'œuvre
    const artwork = await Artwork.create(artworkData);

    // Générer le QR Code avec l'URL de l'œuvre
    const qrCodeUrl = `${process.env.FRONTEND_URL}/artwork/${artwork._id}`;
    const qrCodeImageUrl = await generateQRCode(artwork._id.toString(), qrCodeUrl);

    // Mettre à jour l'œuvre avec l'URL du QR Code (optionnel, peut être stocké séparément)
    artwork.qrCodeImage = qrCodeImageUrl;
    await artwork.save();

    res.status(201).json({
      success: true,
      message: 'Œuvre créée avec succès',
      data: artwork
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Mettre à jour une œuvre
// @route   PUT /api/artworks/:id
// @access  Private (Admin/Curator)
const updateArtwork = async (req, res, next) => {
  try {
    const artwork = await Artwork.findById(req.params.id);

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    // Nettoyer les données avant mise à jour
    const updateData = { ...req.body };
    
    // Si dimensions est une chaîne vide, la convertir en null
    if (updateData.dimensions === '' || updateData.dimensions === null) {
      updateData.dimensions = undefined;
    }
    
    // Si materials est une chaîne vide, la convertir en null
    if (updateData.materials === '' || updateData.materials === null) {
      updateData.materials = undefined;
    }

    // Mettre à jour les champs
    Object.keys(updateData).forEach(key => {
      if (updateData[key] !== undefined) {
        artwork[key] = updateData[key];
      }
    });

    await artwork.save();

    res.json({
      success: true,
      message: 'Œuvre mise à jour avec succès',
      data: artwork
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Supprimer une œuvre
// @route   DELETE /api/artworks/:id
// @access  Private (Admin)
const deleteArtwork = async (req, res, next) => {
  try {
    const artwork = await Artwork.findById(req.params.id);

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    // Supprimer les médias de Cloudinary
    const deletePromises = [];

    // Supprimer les images
    if (artwork.images && artwork.images.length > 0) {
      artwork.images.forEach(imageUrl => {
        const publicId = extractCloudinaryPublicId(imageUrl);
        if (publicId) {
          deletePromises.push(deleteFromCloudinary(publicId, 'image'));
        }
      });
    }

    // Supprimer les audios
    if (artwork.audio) {
      ['fr', 'en', 'wo'].forEach(lang => {
        if (artwork.audio[lang]) {
          const publicId = extractCloudinaryPublicId(artwork.audio[lang]);
          if (publicId) {
            deletePromises.push(deleteFromCloudinary(publicId, 'video'));
          }
        }
      });
    }

    // Supprimer la vidéo
    if (artwork.video) {
      const publicId = extractCloudinaryPublicId(artwork.video);
      if (publicId) {
        deletePromises.push(deleteFromCloudinary(publicId, 'video'));
      }
    }

    await Promise.allSettled(deletePromises);

    // Supprimer l'œuvre
    await artwork.deleteOne();

    res.json({
      success: true,
      message: 'Œuvre supprimée avec succès'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Upload des médias pour une œuvre
// @route   POST /api/artworks/:id/media
// @access  Private (Admin/Curator)
const uploadArtworkMedia = async (req, res, next) => {
  try {
    const artwork = await Artwork.findById(req.params.id);

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Aucun fichier uploadé'
      });
    }

    const uploadedMedia = {};

    // Upload des images
    if (req.files.images) {
      const images = Array.isArray(req.files.images) ? req.files.images : [req.files.images];
      const imageUrls = [];

      for (const image of images) {
        const result = await uploadToCloudinary(image, 'musee/artworks/images');
        imageUrls.push(result.url);
      }

      artwork.images = [...(artwork.images || []), ...imageUrls];
      uploadedMedia.images = imageUrls;
    }

    // Upload des audios (par langue)
    const languages = ['fr', 'en', 'wo'];
    for (const lang of languages) {
      if (req.files[`audio_${lang}`]) {
        const result = await uploadToCloudinary(req.files[`audio_${lang}`], 'musee/artworks/audio');
        if (!artwork.audio) artwork.audio = {};
        artwork.audio[lang] = result.url;
        uploadedMedia[`audio_${lang}`] = result.url;
      }
    }

    // Upload de la vidéo
    if (req.files.video) {
      const result = await uploadToCloudinary(req.files.video, 'musee/artworks/videos');
      artwork.video = result.url;
      uploadedMedia.video = result.url;
    }

    await artwork.save();

    res.json({
      success: true,
      message: 'Médias uploadés avec succès',
      data: {
        artwork,
        uploadedMedia
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer les statistiques d'une œuvre
// @route   GET /api/artworks/:id/stats
// @access  Public
const getArtworkStats = async (req, res, next) => {
  try {
    const artwork = await Artwork.findById(req.params.id);

    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    // Statistiques de visite
    const visitStats = await VisitHistory.aggregate([
      { $match: { artworkId: artwork._id } },
      {
        $group: {
          _id: null,
          totalVisits: { $sum: 1 },
          avgDuration: { $avg: '$duration' },
          audioPlayCount: { $sum: { $cond: ['$audioPlayed', 1, 0] } },
          videoPlayCount: { $sum: { $cond: ['$videoPlayed', 1, 0] } }
        }
      }
    ]);

    // Visites par langue
    const visitsByLanguage = await VisitHistory.aggregate([
      { $match: { artworkId: artwork._id } },
      {
        $group: {
          _id: '$language',
          count: { $sum: 1 }
        }
      }
    ]);

    // Visites par source
    const visitsBySource = await VisitHistory.aggregate([
      { $match: { artworkId: artwork._id } },
      {
        $group: {
          _id: '$source',
          count: { $sum: 1 }
        }
      }
    ]);

    res.json({
      success: true,
      data: {
        artwork: {
          id: artwork._id,
          title: artwork.title,
          viewCount: artwork.viewCount
        },
        stats: visitStats[0] || {
          totalVisits: 0,
          avgDuration: 0,
          audioPlayCount: 0,
          videoPlayCount: 0
        },
        visitsByLanguage,
        visitsBySource
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer les œuvres les plus populaires
// @route   GET /api/artworks/popular
// @access  Public
const getPopularArtworks = async (req, res, next) => {
  try {
    const { limit = 10 } = req.query;

    const artworks = await Artwork.find({ isActive: true })
      .sort({ viewCount: -1 })
      .limit(parseInt(limit))
      .lean();

    res.json({
      success: true,
      data: artworks
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllArtworks,
  getArtworkById,
  getArtworkByQRCode,
  createArtwork,
  updateArtwork,
  deleteArtwork,
  uploadArtworkMedia,
  getArtworkStats,
  getPopularArtworks
};
