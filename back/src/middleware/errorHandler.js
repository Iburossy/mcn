// Middleware de gestion des erreurs
const errorHandler = (err, req, res, next) => {
  console.error('Erreur:', err);

  // Erreur Mongoose - ID invalide
  if (err.name === 'CastError') {
    return res.status(400).json({
      success: false,
      message: 'Ressource non trouvée - ID invalide'
    });
  }

  // Erreur Mongoose - Validation
  if (err.name === 'ValidationError') {
    const messages = Object.values(err.errors).map(e => e.message);
    return res.status(400).json({
      success: false,
      message: 'Erreur de validation',
      errors: messages
    });
  }

  // Erreur Mongoose - Duplicate key
  if (err.code === 11000) {
    const field = Object.keys(err.keyPattern)[0];
    return res.status(400).json({
      success: false,
      message: `Le champ ${field} existe déjà`
    });
  }

  // Erreur JWT
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      success: false,
      message: 'Token invalide'
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      message: 'Token expiré'
    });
  }

  // Erreur par défaut
  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Erreur serveur',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

// Middleware pour les routes non trouvées
const notFound = (req, res, next) => {
  res.status(404).json({
    success: false,
    message: `Route non trouvée - ${req.originalUrl}`
  });
};

module.exports = { errorHandler, notFound };
