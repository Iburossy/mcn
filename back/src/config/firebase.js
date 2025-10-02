const admin = require('firebase-admin');

let firebaseInitialized = false;

const initializeFirebaseApp = () => {
  if (firebaseInitialized) {
    return admin.app();
  }

  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  let privateKey = process.env.FIREBASE_PRIVATE_KEY;
  const databaseURL = process.env.FIREBASE_DATABASE_URL;

  if (!projectId || !clientEmail || !privateKey) {
    console.warn('⚠️  Firebase non configuré. Certains services peuvent être indisponibles.');
    return null;
  }

  if (!privateKey.includes('BEGIN PRIVATE KEY')) {
    // Support for JSON escaped new lines
    privateKey = privateKey.replace(/\\n/g, '\n');
  }

  admin.initializeApp({
    credential: admin.credential.cert({
      projectId,
      clientEmail,
      privateKey
    }),
    databaseURL
  });

  firebaseInitialized = true;
  console.log('✅ Firebase initialisé');
  return admin.app();
};

const getFirebaseApp = () => {
  if (!firebaseInitialized && !admin.apps.length) {
    initializeFirebaseApp();
  }

  if (!admin.apps.length) {
    return null;
  }

  return admin.app();
};

const getFirebaseAuth = () => {
  const app = getFirebaseApp();
  if (!app) {
    throw new Error('Firebase Auth non configuré');
  }
  return admin.auth(app);
};

const getFirebaseMessaging = () => {
  const app = getFirebaseApp();
  if (!app) {
    throw new Error('Firebase Messaging non configuré');
  }
  return admin.messaging(app);
};

module.exports = {
  initializeFirebaseApp,
  getFirebaseApp,
  getFirebaseAuth,
  getFirebaseMessaging
};
