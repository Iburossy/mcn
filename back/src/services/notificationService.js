const { getFirebaseMessaging } = require('../config/firebase');
const User = require('../models/User');

/**
 * Envoyer une notification à un utilisateur spécifique
 */
const sendNotificationToUser = async (userId, notification) => {
  try {
    const user = await User.findById(userId);
    
    if (!user || !user.fcmTokens || user.fcmTokens.length === 0) {
      throw new Error('Aucun token FCM trouvé pour cet utilisateur');
    }

    const messaging = getFirebaseMessaging();
    const { title, body, data = {}, imageUrl } = notification;

    const message = {
      notification: {
        title,
        body,
        ...(imageUrl && { imageUrl })
      },
      data: {
        ...data,
        timestamp: new Date().toISOString()
      },
      tokens: user.fcmTokens
    };

    const response = await messaging.sendEachForMulticast(message);

    // Supprimer les tokens invalides
    if (response.failureCount > 0) {
      const tokensToRemove = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          tokensToRemove.push(user.fcmTokens[idx]);
        }
      });

      if (tokensToRemove.length > 0) {
        user.fcmTokens = user.fcmTokens.filter(token => !tokensToRemove.includes(token));
        await user.save();
      }
    }

    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount
    };
  } catch (error) {
    console.error('Erreur lors de l\'envoi de notification:', error);
    throw error;
  }
};

/**
 * Envoyer une notification à plusieurs utilisateurs
 */
const sendNotificationToMultipleUsers = async (userIds, notification) => {
  const results = await Promise.allSettled(
    userIds.map(userId => sendNotificationToUser(userId, notification))
  );

  const successCount = results.filter(r => r.status === 'fulfilled').length;
  const failureCount = results.filter(r => r.status === 'rejected').length;

  return {
    success: true,
    successCount,
    failureCount,
    results
  };
};

/**
 * Envoyer une notification à tous les utilisateurs
 */
const sendNotificationToAll = async (notification) => {
  try {
    const users = await User.find({
      fcmTokens: { $exists: true, $ne: [] },
      isActive: true
    });

    const userIds = users.map(u => u._id.toString());
    return await sendNotificationToMultipleUsers(userIds, notification);
  } catch (error) {
    console.error('Erreur lors de l\'envoi de notification globale:', error);
    throw error;
  }
};

/**
 * Envoyer une notification par topic
 */
const sendNotificationToTopic = async (topic, notification) => {
  try {
    const messaging = getFirebaseMessaging();
    const { title, body, data = {}, imageUrl } = notification;

    const message = {
      notification: {
        title,
        body,
        ...(imageUrl && { imageUrl })
      },
      data: {
        ...data,
        timestamp: new Date().toISOString()
      },
      topic
    };

    const response = await messaging.send(message);

    return {
      success: true,
      messageId: response
    };
  } catch (error) {
    console.error('Erreur lors de l\'envoi de notification par topic:', error);
    throw error;
  }
};

/**
 * Souscrire un utilisateur à un topic
 */
const subscribeToTopic = async (userId, topic) => {
  try {
    const user = await User.findById(userId);
    
    if (!user || !user.fcmTokens || user.fcmTokens.length === 0) {
      throw new Error('Aucun token FCM trouvé pour cet utilisateur');
    }

    const messaging = getFirebaseMessaging();
    const response = await messaging.subscribeToTopic(user.fcmTokens, topic);

    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount
    };
  } catch (error) {
    console.error('Erreur lors de la souscription au topic:', error);
    throw error;
  }
};

/**
 * Désabonner un utilisateur d'un topic
 */
const unsubscribeFromTopic = async (userId, topic) => {
  try {
    const user = await User.findById(userId);
    
    if (!user || !user.fcmTokens || user.fcmTokens.length === 0) {
      throw new Error('Aucun token FCM trouvé pour cet utilisateur');
    }

    const messaging = getFirebaseMessaging();
    const response = await messaging.unsubscribeFromTopic(user.fcmTokens, topic);

    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount
    };
  } catch (error) {
    console.error('Erreur lors du désabonnement du topic:', error);
    throw error;
  }
};

module.exports = {
  sendNotificationToUser,
  sendNotificationToMultipleUsers,
  sendNotificationToAll,
  sendNotificationToTopic,
  subscribeToTopic,
  unsubscribeFromTopic
};
