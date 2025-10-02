/**
 * Pagination helper
 * @param {number} page - Numéro de page
 * @param {number} limit - Nombre d'éléments par page
 * @returns {object} - Objet avec skip et limit
 */
const getPagination = (page = 1, limit = 10) => {
  const pageNum = parseInt(page, 10);
  const limitNum = parseInt(limit, 10);
  
  const skip = (pageNum - 1) * limitNum;
  
  return {
    skip,
    limit: limitNum,
    page: pageNum
  };
};

/**
 * Formatte la réponse paginée
 * @param {Array} data - Données
 * @param {number} total - Total d'éléments
 * @param {number} page - Page actuelle
 * @param {number} limit - Limite par page
 * @returns {object} - Réponse formatée
 */
const formatPaginatedResponse = (data, total, page, limit) => {
  const totalPages = Math.ceil(total / limit);
  
  return {
    success: true,
    data,
    pagination: {
      total,
      page,
      limit,
      totalPages,
      hasNextPage: page < totalPages,
      hasPrevPage: page > 1
    }
  };
};

/**
 * Nettoie les champs vides d'un objet
 * @param {object} obj - Objet à nettoyer
 * @returns {object} - Objet nettoyé
 */
const cleanObject = (obj) => {
  return Object.fromEntries(
    Object.entries(obj).filter(([_, v]) => v != null && v !== '')
  );
};

/**
 * Génère un slug à partir d'un texte
 * @param {string} text - Texte à convertir
 * @returns {string} - Slug
 */
const slugify = (text) => {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '');
};

/**
 * Formate une date en français
 * @param {Date} date - Date à formater
 * @returns {string} - Date formatée
 */
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
};

/**
 * Calcule la durée entre deux dates
 * @param {Date} start - Date de début
 * @param {Date} end - Date de fin
 * @returns {number} - Durée en secondes
 */
const calculateDuration = (start, end) => {
  return Math.floor((new Date(end) - new Date(start)) / 1000);
};

/**
 * Valide une langue supportée
 * @param {string} lang - Code langue
 * @returns {string} - Code langue validé ou 'fr' par défaut
 */
const validateLanguage = (lang) => {
  const supportedLanguages = ['fr', 'en', 'wo'];
  return supportedLanguages.includes(lang) ? lang : 'fr';
};

/**
 * Extrait l'ID public Cloudinary depuis une URL
 * @param {string} url - URL Cloudinary
 * @returns {string} - Public ID
 */
const extractCloudinaryPublicId = (url) => {
  if (!url) return null;
  
  const parts = url.split('/');
  const filename = parts[parts.length - 1];
  const publicId = filename.split('.')[0];
  
  // Reconstruire le chemin complet avec le dossier
  const folderIndex = parts.indexOf('musee');
  if (folderIndex !== -1) {
    const pathParts = parts.slice(folderIndex, -1);
    pathParts.push(publicId);
    return pathParts.join('/');
  }
  
  return publicId;
};

module.exports = {
  getPagination,
  formatPaginatedResponse,
  cleanObject,
  slugify,
  formatDate,
  calculateDuration,
  validateLanguage,
  extractCloudinaryPublicId
};
