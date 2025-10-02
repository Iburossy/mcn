const mongoose = require('mongoose');

const artworkSchema = new mongoose.Schema({
  qrCode: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  title: {
    fr: { type: String, required: true },
    en: { type: String, required: true },
    wo: { type: String, required: true }
  },
  description: {
    fr: { type: String, required: true },
    en: { type: String, required: true },
    wo: { type: String, required: true }
  },
  audio: {
    fr: { type: String },
    en: { type: String },
    wo: { type: String }
  },
  audioGuide: {
    fr: { type: String },
    en: { type: String },
    wo: { type: String }
  },
  videoGuide: {
    fr: { type: String },
    en: { type: String },
    wo: { type: String }
  },
  images: [{
    type: String
  }],
  video: {
    type: String,
    default: null
  },
  model3D: {
    type: String,
    default: null
  },
  category: {
    type: String,
    required: true,
    enum: ['sculpture', 'peinture', 'textile', 'ceramique', 'bijoux', 'masque', 'instrument', 'autre']
  },
  period: {
    type: String,
    required: true
  },
  origin: {
    type: String,
    required: true
  },
  position: {
    x: { type: Number, default: 0 },
    y: { type: Number, default: 0 },
    z: { type: Number, default: 0 }
  },
  roomId: {
    type: String,
    default: 'main-hall'
  },
  viewCount: {
    type: Number,
    default: 0
  },
  culturalContext: {
    fr: { type: String },
    en: { type: String },
    wo: { type: String }
  },
  dimensions: {
    height: { type: Number },
    width: { type: Number },
    depth: { type: Number },
    unit: { type: String, default: 'cm' }
  },
  materials: [{
    type: String
  }],
  artist: {
    type: String,
    default: 'Inconnu'
  },
  acquisitionDate: {
    type: Date
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Validation: Au moins images OU model3D
artworkSchema.pre('validate', function(next) {
  if ((!this.images || this.images.length === 0) && !this.model3D) {
    next(new Error('Une œuvre doit avoir au moins des images ou un modèle 3D'));
  } else {
    next();
  }
});

// Index pour la recherche
artworkSchema.index({ 'title.fr': 'text', 'title.en': 'text', 'title.wo': 'text' });
artworkSchema.index({ category: 1, isActive: 1 });
artworkSchema.index({ roomId: 1 });

// Méthode pour incrémenter le compteur de vues
artworkSchema.methods.incrementViewCount = async function() {
  this.viewCount += 1;
  return await this.save();
};

// Méthode virtuelle pour obtenir l'URL complète du QR code
artworkSchema.virtual('qrCodeUrl').get(function() {
  return `${process.env.FRONTEND_URL}/artwork/${this._id}`;
});

// Assurer que les virtuels sont inclus dans JSON
artworkSchema.set('toJSON', { virtuals: true });
artworkSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Artwork', artworkSchema);
