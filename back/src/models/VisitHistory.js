const mongoose = require('mongoose');

const visitHistorySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  deviceId: {
    type: String,
    index: true
  },
  artworkId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Artwork',
    required: true
  },
  visitDate: {
    type: Date,
    default: Date.now,
    index: true
  },
  duration: {
    type: Number,
    default: 0
  },
  language: {
    type: String,
    enum: ['fr', 'en', 'wo'],
    default: 'fr'
  },
  audioPlayed: {
    type: Boolean,
    default: false
  },
  videoPlayed: {
    type: Boolean,
    default: false
  },
  source: {
    type: String,
    enum: ['qr-scan', 'browse', 'search', 'virtual-tour'],
    default: 'browse'
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number],
      default: [0, 0]
    }
  }
}, {
  timestamps: true
});

// Index composé pour les statistiques
visitHistorySchema.index({ artworkId: 1, visitDate: -1 });
visitHistorySchema.index({ deviceId: 1, visitDate: -1 });
visitHistorySchema.index({ userId: 1, visitDate: -1 });

// Index géospatial
visitHistorySchema.index({ location: '2dsphere' });

module.exports = mongoose.model('VisitHistory', visitHistorySchema);
