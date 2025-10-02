const QRCode = require('qrcode');
const { uploadToCloudinary } = require('../config/cloudinary');
const fs = require('fs');
const path = require('path');

/**
 * Génère un QR code pour une œuvre d'art
 * @param {string} artworkId - ID de l'œuvre
 * @param {string} qrCodeData - Données à encoder (URL ou texte)
 * @returns {Promise<string>} - URL du QR code uploadé sur Cloudinary
 */
const generateQRCode = async (artworkId, qrCodeData) => {
  try {
    // Créer le dossier temporaire s'il n'existe pas
    const tempDir = path.join(__dirname, '../../uploads/temp');
    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir, { recursive: true });
    }

    // Chemin temporaire pour le QR code
    const tempPath = path.join(tempDir, `qr-${artworkId}-${Date.now()}.png`);

    // Options du QR code
    const options = {
      errorCorrectionLevel: 'H',
      type: 'image/png',
      quality: 0.95,
      margin: 1,
      width: 512,
      color: {
        dark: '#000000',
        light: '#FFFFFF'
      }
    };

    // Générer le QR code
    await QRCode.toFile(tempPath, qrCodeData, options);

    // Upload sur Cloudinary
    const result = await uploadToCloudinary(
      { path: tempPath },
      'musee/qrcodes'
    );

    // Supprimer le fichier temporaire
    fs.unlinkSync(tempPath);

    return result.url;
  } catch (error) {
    console.error('Erreur génération QR code:', error);
    throw new Error('Impossible de générer le QR code');
  }
};

/**
 * Génère un QR code en base64 (pour affichage direct)
 * @param {string} qrCodeData - Données à encoder
 * @returns {Promise<string>} - QR code en base64
 */
const generateQRCodeBase64 = async (qrCodeData) => {
  try {
    const options = {
      errorCorrectionLevel: 'H',
      type: 'image/png',
      quality: 0.95,
      margin: 1,
      width: 512
    };

    const qrCodeBase64 = await QRCode.toDataURL(qrCodeData, options);
    return qrCodeBase64;
  } catch (error) {
    console.error('Erreur génération QR code base64:', error);
    throw new Error('Impossible de générer le QR code');
  }
};

/**
 * Génère un identifiant unique pour le QR code
 * @returns {string} - Identifiant unique
 */
const generateUniqueQRId = () => {
  const timestamp = Date.now().toString(36);
  const randomStr = Math.random().toString(36).substring(2, 9);
  return `MCN-${timestamp}-${randomStr}`.toUpperCase();
};

module.exports = {
  generateQRCode,
  generateQRCodeBase64,
  generateUniqueQRId
};
