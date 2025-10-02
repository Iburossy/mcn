const {
  sendNotificationToUser,
  sendNotificationToMultipleUsers,
  sendNotificationToAll,
  sendNotificationToTopic,
  subscribeToTopic,
  unsubscribeFromTopic
} = require('../services/notificationService');

// @desc    Envoyer une notification à un utilisateur
// @route   POST /api/notifications/send
// @access  Private (Admin/Curator)
const sendToUser = async (req, res, next) => {
  try {
    const { userId, title, body, data, imageUrl } = req.body;

    if (!userId || !title || !body) {
      return res.status(400).json({
        success: false,
        message: 'userId, title et body sont requis'
      });
    }

    const result = await sendNotificationToUser(userId, {
      title,
      body,
      data,
      imageUrl
    });

    res.json({
      success: true,
      message: 'Notification envoyée avec succès',
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Envoyer une notification à plusieurs utilisateurs
// @route   POST /api/notifications/send-multiple
// @access  Private (Admin/Curator)
const sendToMultiple = async (req, res, next) => {
  try {
    const { userIds, title, body, data, imageUrl } = req.body;

    if (!userIds || !Array.isArray(userIds) || userIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'userIds (tableau) est requis'
      });
    }

    if (!title || !body) {
      return res.status(400).json({
        success: false,
        message: 'title et body sont requis'
      });
    }

    const result = await sendNotificationToMultipleUsers(userIds, {
      title,
      body,
      data,
      imageUrl
    });

    res.json({
      success: true,
      message: 'Notifications envoyées',
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Envoyer une notification à tous les utilisateurs
// @route   POST /api/notifications/broadcast
// @access  Private (Admin)
const broadcast = async (req, res, next) => {
  try {
    const { title, body, data, imageUrl } = req.body;

    if (!title || !body) {
      return res.status(400).json({
        success: false,
        message: 'title et body sont requis'
      });
    }

    const result = await sendNotificationToAll({
      title,
      body,
      data,
      imageUrl
    });

    res.json({
      success: true,
      message: 'Notification diffusée à tous les utilisateurs',
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Envoyer une notification par topic
// @route   POST /api/notifications/topic
// @access  Private (Admin/Curator)
const sendToTopic = async (req, res, next) => {
  try {
    const { topic, title, body, data, imageUrl } = req.body;

    if (!topic || !title || !body) {
      return res.status(400).json({
        success: false,
        message: 'topic, title et body sont requis'
      });
    }

    const result = await sendNotificationToTopic(topic, {
      title,
      body,
      data,
      imageUrl
    });

    res.json({
      success: true,
      message: `Notification envoyée au topic: ${topic}`,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Souscrire à un topic
// @route   POST /api/notifications/subscribe
// @access  Private
const subscribe = async (req, res, next) => {
  try {
    const { topic } = req.body;

    if (!topic) {
      return res.status(400).json({
        success: false,
        message: 'topic est requis'
      });
    }

    const result = await subscribeToTopic(req.user._id, topic);

    res.json({
      success: true,
      message: `Souscription au topic: ${topic}`,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Se désabonner d'un topic
// @route   POST /api/notifications/unsubscribe
// @access  Private
const unsubscribe = async (req, res, next) => {
  try {
    const { topic } = req.body;

    if (!topic) {
      return res.status(400).json({
        success: false,
        message: 'topic est requis'
      });
    }

    const result = await unsubscribeFromTopic(req.user._id, topic);

    res.json({
      success: true,
      message: `Désabonnement du topic: ${topic}`,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  sendToUser,
  sendToMultiple,
  broadcast,
  sendToTopic,
  subscribe,
  unsubscribe
};
