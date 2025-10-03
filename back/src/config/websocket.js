const WebSocket = require('ws');

let wss = null;

/**
 * Initialiser le serveur WebSocket
 */
const initWebSocket = (server) => {
  wss = new WebSocket.Server({ server, path: '/ws' });

  wss.on('connection', (ws, req) => {
    const clientIp = req.socket.remoteAddress;
    console.log(`🔌 Nouveau client WebSocket connecté: ${clientIp}`);

    ws.on('message', (message) => {
      try {
        const data = JSON.parse(message);
        console.log('📨 Message WebSocket reçu:', data);
      } catch (error) {
        console.error('❌ Erreur parsing message WebSocket:', error);
      }
    });

    ws.on('close', () => {
      console.log(`🔌 Client WebSocket déconnecté: ${clientIp}`);
    });

    ws.on('error', (error) => {
      console.error('❌ Erreur WebSocket:', error);
    });

    // Envoyer un message de bienvenue
    ws.send(JSON.stringify({ type: 'connected', message: 'Connecté au serveur WebSocket' }));
  });

  console.log('✅ Serveur WebSocket initialisé sur /ws');
  return wss;
};

/**
 * Diffuser un événement à tous les clients connectés
 */
const broadcast = (event, data) => {
  if (!wss) {
    console.warn('⚠️ WebSocket non initialisé');
    return;
  }

  const message = JSON.stringify({ type: event, data, timestamp: Date.now() });

  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });

  console.log(`📡 Événement diffusé: ${event}`);
};

/**
 * Événements spécifiques
 */
const events = {
  artworkCreated: (artwork) => broadcast('artwork:created', artwork),
  artworkUpdated: (artwork) => broadcast('artwork:updated', artwork),
  artworkDeleted: (artworkId) => broadcast('artwork:deleted', { id: artworkId }),
  roomCreated: (room) => broadcast('room:created', room),
  roomUpdated: (room) => broadcast('room:updated', room),
  roomDeleted: (roomId) => broadcast('room:deleted', { id: roomId }),
};

module.exports = {
  initWebSocket,
  broadcast,
  events,
};
