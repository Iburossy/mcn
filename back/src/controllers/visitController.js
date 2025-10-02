const VisitHistory = require('../models/VisitHistory');
const Artwork = require('../models/Artwork');
const { getPagination, formatPaginatedResponse } = require('../utils/helpers');

// @desc    Enregistrer une visite
// @route   POST /api/visits
// @access  Public
const createVisit = async (req, res, next) => {
  try {
    const { artworkId, deviceId, duration, language, audioPlayed, videoPlayed, source, location } = req.body;

    // Vérifier que l'œuvre existe
    const artwork = await Artwork.findById(artworkId);
    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    const visitData = {
      artworkId,
      deviceId,
      duration: duration || 0,
      language: language || 'fr',
      audioPlayed: audioPlayed || false,
      videoPlayed: videoPlayed || false,
      source: source || 'browse'
    };

    // Ajouter l'utilisateur si authentifié
    if (req.user) {
      visitData.userId = req.user._id;
    }

    // Ajouter la localisation si fournie
    if (location && location.coordinates) {
      visitData.location = {
        type: 'Point',
        coordinates: location.coordinates
      };
    }

    const visit = await VisitHistory.create(visitData);

    res.status(201).json({
      success: true,
      message: 'Visite enregistrée avec succès',
      data: visit
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer l'historique des visites d'un utilisateur
// @route   GET /api/visits/user/:userId
// @access  Private
const getUserVisitHistory = async (req, res, next) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const { skip, limit: limitNum, page: pageNum } = getPagination(page, limit);

    const userId = req.params.userId || req.user._id;

    const [visits, total] = await Promise.all([
      VisitHistory.find({ userId })
        .populate('artworkId', 'title images category')
        .sort({ visitDate: -1 })
        .skip(skip)
        .limit(limitNum)
        .lean(),
      VisitHistory.countDocuments({ userId })
    ]);

    res.json(formatPaginatedResponse(visits, total, pageNum, limitNum));
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer l'historique par deviceId
// @route   GET /api/visits/device/:deviceId
// @access  Public
const getDeviceVisitHistory = async (req, res, next) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const { skip, limit: limitNum, page: pageNum } = getPagination(page, limit);

    const [visits, total] = await Promise.all([
      VisitHistory.find({ deviceId: req.params.deviceId })
        .populate('artworkId', 'title images category')
        .sort({ visitDate: -1 })
        .skip(skip)
        .limit(limitNum)
        .lean(),
      VisitHistory.countDocuments({ deviceId: req.params.deviceId })
    ]);

    res.json(formatPaginatedResponse(visits, total, pageNum, limitNum));
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer les statistiques globales
// @route   GET /api/visits/stats
// @access  Private (Admin)
const getGlobalStats = async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;

    const matchStage = {};
    if (startDate || endDate) {
      matchStage.visitDate = {};
      if (startDate) matchStage.visitDate.$gte = new Date(startDate);
      if (endDate) matchStage.visitDate.$lte = new Date(endDate);
    }

    // Statistiques générales
    const generalStats = await VisitHistory.aggregate([
      ...(Object.keys(matchStage).length > 0 ? [{ $match: matchStage }] : []),
      {
        $group: {
          _id: null,
          totalVisits: { $sum: 1 },
          avgDuration: { $avg: '$duration' },
          totalAudioPlays: { $sum: { $cond: ['$audioPlayed', 1, 0] } },
          totalVideoPlays: { $sum: { $cond: ['$videoPlayed', 1, 0] } }
        }
      }
    ]);

    // Visites par jour
    const visitsByDay = await VisitHistory.aggregate([
      ...(Object.keys(matchStage).length > 0 ? [{ $match: matchStage }] : []),
      {
        $group: {
          _id: {
            $dateToString: { format: '%Y-%m-%d', date: '$visitDate' }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { _id: 1 } },
      { $limit: 30 }
    ]);

    // Œuvres les plus visitées
    const topArtworks = await VisitHistory.aggregate([
      ...(Object.keys(matchStage).length > 0 ? [{ $match: matchStage }] : []),
      {
        $group: {
          _id: '$artworkId',
          count: { $sum: 1 }
        }
      },
      { $sort: { count: -1 } },
      { $limit: 10 },
      {
        $lookup: {
          from: 'artworks',
          localField: '_id',
          foreignField: '_id',
          as: 'artwork'
        }
      },
      { $unwind: '$artwork' },
      {
        $project: {
          count: 1,
          title: '$artwork.title',
          images: '$artwork.images',
          category: '$artwork.category'
        }
      }
    ]);

    // Visites par langue
    const visitsByLanguage = await VisitHistory.aggregate([
      ...(Object.keys(matchStage).length > 0 ? [{ $match: matchStage }] : []),
      {
        $group: {
          _id: '$language',
          count: { $sum: 1 }
        }
      }
    ]);

    // Visites par source
    const visitsBySource = await VisitHistory.aggregate([
      ...(Object.keys(matchStage).length > 0 ? [{ $match: matchStage }] : []),
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
        general: generalStats[0] || {
          totalVisits: 0,
          avgDuration: 0,
          totalAudioPlays: 0,
          totalVideoPlays: 0
        },
        visitsByDay,
        topArtworks,
        visitsByLanguage,
        visitsBySource
      }
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createVisit,
  getUserVisitHistory,
  getDeviceVisitHistory,
  getGlobalStats
};
