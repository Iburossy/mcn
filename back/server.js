require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const connectDB = require('./src/config/database');
const { initializeFirebaseApp } = require('./src/config/firebase');
const { errorHandler, notFound } = require('./src/middleware/errorHandler');
const { initWebSocket } = require('./src/config/websocket');

// Connexion à la base de données
connectDB();

// Initialisation Firebase (si configuration disponible)
initializeFirebaseApp();

// Initialisation de l'application
const app = express();

// Middlewares de sécurité
app.use(helmet());
app.use(compression());

// Configuration CORS
const corsOptions = {
  origin: process.env.CORS_ORIGIN ? process.env.CORS_ORIGIN.split(',') : '*',
  credentials: true,
  optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limite de 100 requêtes par IP
  message: 'Trop de requêtes depuis cette IP, veuillez réessayer plus tard.'
});
app.use('/api/', limiter);

// Middlewares de parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logger en développement
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Route de santé
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'API Musée des Civilisations Noires - Serveur opérationnel',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV
  });
});

// Routes API
app.use('/api/artworks', require('./src/routes/artworks'));
app.use('/api/rooms', require('./src/routes/rooms'));
app.use('/api/auth', require('./src/routes/auth'));
app.use('/api/visits', require('./src/routes/visits'));
app.use('/api/notifications', require('./src/routes/notifications'));
app.use('/api/upload', require('./src/routes/uploadRoutes'));

// Route racine
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Bienvenue sur l\'API du Musée des Civilisations Noires',
    version: '1.0.0',
    documentation: '/api/docs',
    endpoints: {
      artworks: '/api/artworks',
      rooms: '/api/rooms',
      auth: '/api/auth',
      visits: '/api/visits',
      notifications: '/api/notifications',
      health: '/health'
    }
  });
});

// Middleware pour les routes non trouvées
app.use(notFound);

// Middleware de gestion des erreurs
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
const server = app.listen(PORT, () => {
  console.log(`
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🏛️  MUSÉE DES CIVILISATIONS NOIRES - API              ║
║                                                           ║
║   🚀 Serveur démarré avec succès                         ║
║   📡 Port: ${PORT}                                        ║
║   🌍 Environnement: ${process.env.NODE_ENV || 'development'}                    ║
║   📅 ${new Date().toLocaleString('fr-FR')}               ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
  `);
  
  // Initialiser WebSocket
  initWebSocket(server);
});

// Gestion des erreurs non capturées
process.on('unhandledRejection', (err) => {
  console.error('❌ Erreur non gérée:', err);
  server.close(() => process.exit(1));
});

process.on('uncaughtException', (err) => {
  console.error('❌ Exception non capturée:', err);
  process.exit(1);
});

module.exports = app;
