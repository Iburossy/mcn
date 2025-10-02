const mongoose = require('mongoose');

const virtualRoomSchema = new mongoose.Schema({
  roomId: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  name: {
    fr: { type: String, required: true },
    en: { type: String, required: true },
    wo: { type: String, required: true }
  },
  description: {
    fr: { type: String },
    en: { type: String },
    wo: { type: String }
  },
  model3DUrl: {
    type: String,
    default: null
  },
  floorTexture: {
    type: String,
    default: null
  },
  wallTexture: {
    type: String,
    default: null
  },
  artworks: [{
    artworkId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Artwork'
    },
    position: {
      x: { type: Number, required: true },
      y: { type: Number, required: true },
      z: { type: Number, required: true }
    },
    rotation: {
      x: { type: Number, default: 0 },
      y: { type: Number, default: 0 },
      z: { type: Number, default: 0 }
    },
    scale: {
      x: { type: Number, default: 1 },
      y: { type: Number, default: 1 },
      z: { type: Number, default: 1 }
    }
  }],
  lighting: {
    ambient: {
      color: { type: String, default: '#ffffff' },
      intensity: { type: Number, default: 0.5 }
    },
    directional: [{
      color: { type: String, default: '#ffffff' },
      intensity: { type: Number, default: 1 },
      position: {
        x: { type: Number, default: 10 },
        y: { type: Number, default: 10 },
        z: { type: Number, default: 10 }
      }
    }]
  },
  cameraStart: {
    position: {
      x: { type: Number, default: 0 },
      y: { type: Number, default: 1.6 },
      z: { type: Number, default: 5 }
    },
    lookAt: {
      x: { type: Number, default: 0 },
      y: { type: Number, default: 1.6 },
      z: { type: Number, default: 0 }
    }
  },
  navigationPoints: [{
    name: { type: String, required: true },
    position: {
      x: { type: Number, required: true },
      y: { type: Number, required: true },
      z: { type: Number, required: true }
    }
  }],
  adjacentRooms: [{
    roomId: { type: String, required: true },
    doorPosition: {
      x: { type: Number, required: true },
      y: { type: Number, required: true },
      z: { type: Number, required: true }
    }
  }],
  isActive: {
    type: Boolean,
    default: true
  },
  order: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

// Index
virtualRoomSchema.index({ isActive: 1, order: 1 });

module.exports = mongoose.model('VirtualRoom', virtualRoomSchema);
