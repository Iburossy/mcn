const multer = require('multer');
const path = require('path');

// Configuration du stockage temporaire
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

// Filtrer les types de fichiers
const fileFilter = (req, file, cb) => {
  // Types de fichiers autorisés
  const allowedImageTypes = /jpeg|jpg|png|gif|webp|svg/;
  const allowedAudioTypes = /mp3|wav|ogg|m4a/;
  const allowedVideoTypes = /mp4|webm|ogg/;
  const allowed3DTypes = /gltf|glb|obj|fbx/;

  const extname = allowedImageTypes.test(path.extname(file.originalname).toLowerCase()) ||
                  allowedAudioTypes.test(path.extname(file.originalname).toLowerCase()) ||
                  allowedVideoTypes.test(path.extname(file.originalname).toLowerCase()) ||
                  allowed3DTypes.test(path.extname(file.originalname).toLowerCase());

  const mimetype = file.mimetype.startsWith('image/') ||
                   file.mimetype.startsWith('audio/') ||
                   file.mimetype.startsWith('video/') ||
                   file.mimetype === 'model/gltf-binary' ||
                   file.mimetype === 'model/gltf+json' ||
                   file.mimetype === 'application/octet-stream';

  if (extname && mimetype) {
    return cb(null, true);
  } else {
    cb(new Error('Type de fichier non supporté. Formats acceptés: images (jpg, png, gif, webp, svg), audio (mp3, wav, ogg, m4a), vidéo (mp4, webm, ogg), 3D (gltf, glb, obj, fbx)'));
  }
};

// Configuration de multer
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 50 * 1024 * 1024 // 50MB max
  },
  fileFilter: fileFilter
});

// Middleware pour gérer les erreurs d'upload
const handleUploadError = (err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        message: 'Fichier trop volumineux. Taille maximale: 50MB'
      });
    }
    return res.status(400).json({
      success: false,
      message: `Erreur d'upload: ${err.message}`
    });
  } else if (err) {
    return res.status(400).json({
      success: false,
      message: err.message
    });
  }
  next();
};

module.exports = {
  upload,
  handleUploadError
};
