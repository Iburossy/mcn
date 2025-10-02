const VirtualRoom = require('../models/VirtualRoom');
const Artwork = require('../models/Artwork');
const { uploadToCloudinary, deleteFromCloudinary } = require('../config/cloudinary');
const { extractCloudinaryPublicId } = require('../utils/helpers');

// @desc    Récupérer toutes les salles virtuelles
// @route   GET /api/rooms
// @access  Public
const getAllRooms = async (req, res, next) => {
  try {
    const { isActive = true } = req.query;

    const rooms = await VirtualRoom.find({ isActive })
      .populate('artworks.artworkId', 'title images qrCode')
      .sort({ order: 1 })
      .lean();

    res.json({
      success: true,
      data: rooms
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer une salle par ID
// @route   GET /api/rooms/:id
// @access  Public
const getRoomById = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id)
      .populate('artworks.artworkId');

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    res.json({
      success: true,
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Récupérer une salle par roomId
// @route   GET /api/rooms/room/:roomId
// @access  Public
const getRoomByRoomId = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findOne({ roomId: req.params.roomId })
      .populate('artworks.artworkId');

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    res.json({
      success: true,
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Créer une nouvelle salle virtuelle
// @route   POST /api/rooms
// @access  Private (Admin)
const createRoom = async (req, res, next) => {
  try {
    const room = await VirtualRoom.create(req.body);

    res.status(201).json({
      success: true,
      message: 'Salle créée avec succès',
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Mettre à jour une salle
// @route   PUT /api/rooms/:id
// @access  Private (Admin)
const updateRoom = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id);

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    Object.keys(req.body).forEach(key => {
      if (req.body[key] !== undefined) {
        room[key] = req.body[key];
      }
    });

    await room.save();

    res.json({
      success: true,
      message: 'Salle mise à jour avec succès',
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Supprimer une salle
// @route   DELETE /api/rooms/:id
// @access  Private (Admin)
const deleteRoom = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id);

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    // Supprimer les assets 3D de Cloudinary
    const deletePromises = [];

    if (room.model3DUrl) {
      const publicId = extractCloudinaryPublicId(room.model3DUrl);
      if (publicId) {
        deletePromises.push(deleteFromCloudinary(publicId, 'raw'));
      }
    }

    if (room.floorTexture) {
      const publicId = extractCloudinaryPublicId(room.floorTexture);
      if (publicId) {
        deletePromises.push(deleteFromCloudinary(publicId, 'image'));
      }
    }

    if (room.wallTexture) {
      const publicId = extractCloudinaryPublicId(room.wallTexture);
      if (publicId) {
        deletePromises.push(deleteFromCloudinary(publicId, 'image'));
      }
    }

    await Promise.allSettled(deletePromises);

    await room.deleteOne();

    res.json({
      success: true,
      message: 'Salle supprimée avec succès'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Ajouter une œuvre à une salle
// @route   POST /api/rooms/:id/artworks
// @access  Private (Admin/Curator)
const addArtworkToRoom = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id);

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    const { artworkId, position, rotation, scale } = req.body;

    // Vérifier que l'œuvre existe
    const artwork = await Artwork.findById(artworkId);
    if (!artwork) {
      return res.status(404).json({
        success: false,
        message: 'Œuvre non trouvée'
      });
    }

    // Ajouter l'œuvre à la salle
    room.artworks.push({
      artworkId,
      position: position || { x: 0, y: 0, z: 0 },
      rotation: rotation || { x: 0, y: 0, z: 0 },
      scale: scale || { x: 1, y: 1, z: 1 }
    });

    // Mettre à jour le roomId de l'œuvre
    artwork.roomId = room.roomId;
    await artwork.save();

    await room.save();

    res.json({
      success: true,
      message: 'Œuvre ajoutée à la salle avec succès',
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Retirer une œuvre d'une salle
// @route   DELETE /api/rooms/:id/artworks/:artworkId
// @access  Private (Admin/Curator)
const removeArtworkFromRoom = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id);

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    room.artworks = room.artworks.filter(
      item => item.artworkId.toString() !== req.params.artworkId
    );

    await room.save();

    res.json({
      success: true,
      message: 'Œuvre retirée de la salle avec succès',
      data: room
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Upload des assets 3D pour une salle
// @route   POST /api/rooms/:id/assets
// @access  Private (Admin)
const uploadRoomAssets = async (req, res, next) => {
  try {
    const room = await VirtualRoom.findById(req.params.id);

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Salle non trouvée'
      });
    }

    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Aucun fichier uploadé'
      });
    }

    const uploadedAssets = {};

    // Upload du modèle 3D
    if (req.files.model3D) {
      const result = await uploadToCloudinary(req.files.model3D, 'musee/rooms/models');
      room.model3DUrl = result.url;
      uploadedAssets.model3D = result.url;
    }

    // Upload de la texture du sol
    if (req.files.floorTexture) {
      const result = await uploadToCloudinary(req.files.floorTexture, 'musee/rooms/textures');
      room.floorTexture = result.url;
      uploadedAssets.floorTexture = result.url;
    }

    // Upload de la texture des murs
    if (req.files.wallTexture) {
      const result = await uploadToCloudinary(req.files.wallTexture, 'musee/rooms/textures');
      room.wallTexture = result.url;
      uploadedAssets.wallTexture = result.url;
    }

    await room.save();

    res.json({
      success: true,
      message: 'Assets uploadés avec succès',
      data: {
        room,
        uploadedAssets
      }
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllRooms,
  getRoomById,
  getRoomByRoomId,
  createRoom,
  updateRoom,
  deleteRoom,
  addArtworkToRoom,
  removeArtworkFromRoom,
  uploadRoomAssets
};
