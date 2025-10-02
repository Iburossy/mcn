const { body, param, query, validationResult } = require('express-validator');

// Middleware pour vérifier les résultats de validation
const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: 'Erreur de validation',
      errors: errors.array()
    });
  }
  next();
};

// Validations pour les artworks
const artworkValidation = {
  create: [
    body('title.fr').notEmpty().withMessage('Le titre en français est requis'),
    body('title.en').notEmpty().withMessage('Le titre en anglais est requis'),
    body('title.wo').notEmpty().withMessage('Le titre en wolof est requis'),
    body('description.fr').notEmpty().withMessage('La description en français est requise'),
    body('description.en').notEmpty().withMessage('La description en anglais est requise'),
    body('description.wo').notEmpty().withMessage('La description en wolof est requise'),
    body('category').isIn(['sculpture', 'peinture', 'textile', 'ceramique', 'bijoux', 'masque', 'instrument', 'autre'])
      .withMessage('Catégorie invalide'),
    body('period').notEmpty().withMessage('La période est requise'),
    body('origin').notEmpty().withMessage('L\'origine est requise'),
    validate
  ],
  update: [
    param('id').isMongoId().withMessage('ID invalide'),
    body('title.fr').optional().notEmpty().withMessage('Le titre en français ne peut pas être vide'),
    body('title.en').optional().notEmpty().withMessage('Le titre en anglais ne peut pas être vide'),
    body('title.wo').optional().notEmpty().withMessage('Le titre en wolof ne peut pas être vide'),
    body('category').optional().isIn(['sculpture', 'peinture', 'textile', 'ceramique', 'bijoux', 'masque', 'instrument', 'autre'])
      .withMessage('Catégorie invalide'),
    validate
  ],
  getById: [
    param('id').isMongoId().withMessage('ID invalide'),
    validate
  ],
  getByQR: [
    param('qrCode').notEmpty().withMessage('QR Code requis'),
    validate
  ]
};

// Validations pour les utilisateurs
const userValidation = {
  register: [
    body('phoneNumber')
      .matches(/^\d{5,10}$/)
      .withMessage('Le numéro de téléphone doit contenir entre 5 et 10 chiffres'),
    body('pin')
      .matches(/^\d{4}$/)
      .withMessage('Le code PIN doit contenir exactement 4 chiffres'),
    body('name').notEmpty().withMessage('Le nom est requis'),
    validate
  ],
  login: [
    body('phoneNumber')
      .matches(/^\d{5,10}$/)
      .withMessage('Le numéro de téléphone doit contenir entre 5 et 10 chiffres'),
    body('pin')
      .matches(/^\d{4}$/)
      .withMessage('Le code PIN doit contenir exactement 4 chiffres'),
    validate
  ],
  changePin: [
    body('currentPin')
      .matches(/^\d{4}$/)
      .withMessage('Le code PIN actuel doit contenir exactement 4 chiffres'),
    body('newPin')
      .matches(/^\d{4}$/)
      .withMessage('Le nouveau code PIN doit contenir exactement 4 chiffres'),
    validate
  ]
};

// Validations pour les salles virtuelles
const roomValidation = {
  create: [
    // roomId est généré automatiquement, donc optionnel
    body('name.fr').notEmpty().withMessage('Le nom en français est requis'),
    body('name.en').optional(),
    body('name.wo').optional(),
    validate
  ],
  update: [
    param('id').isMongoId().withMessage('ID invalide'),
    body('name.fr').optional().notEmpty().withMessage('Le nom en français ne peut pas être vide'),
    validate
  ]
};

// Validations pour l'historique de visite
const visitValidation = {
  create: [
    body('artworkId').isMongoId().withMessage('ID d\'œuvre invalide'),
    body('language').optional().isIn(['fr', 'en', 'wo']).withMessage('Langue invalide'),
    body('source').optional().isIn(['qr-scan', 'browse', 'search', 'virtual-tour']).withMessage('Source invalide'),
    validate
  ]
};

module.exports = {
  validate,
  artworkValidation,
  userValidation,
  roomValidation,
  visitValidation
};
