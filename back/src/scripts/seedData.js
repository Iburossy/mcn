require('dotenv').config();
const mongoose = require('mongoose');
const Artwork = require('../models/Artwork');
const VirtualRoom = require('../models/VirtualRoom');
const User = require('../models/User');

// Connexion à MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('✅ MongoDB connecté'))
.catch(err => {
  console.error('❌ Erreur connexion MongoDB:', err);
  process.exit(1);
});

// Données de test pour les œuvres
const sampleArtworks = [
  {
    qrCode: 'MCN-001',
    title: {
      fr: 'Masque Sénoufo',
      en: 'Senufo Mask',
      wo: 'Masque Sénoufo'
    },
    description: {
      fr: 'Masque traditionnel utilisé lors des cérémonies d\'initiation. Les Sénoufos sont un peuple d\'Afrique de l\'Ouest présent en Côte d\'Ivoire, au Mali et au Burkina Faso.',
      en: 'Traditional mask used during initiation ceremonies. The Senufo are a West African people present in Ivory Coast, Mali and Burkina Faso.',
      wo: 'Masque bu njëkk ci sérémonies initiation. Sénoufos dañu nekk ci Afrique de l\'Ouest.'
    },
    images: ['https://res.cloudinary.com/demo/image/upload/sample.jpg'],
    category: 'masque',
    period: 'XIXe siècle',
    origin: 'Côte d\'Ivoire',
    roomId: 'main-hall',
    culturalContext: {
      fr: 'Utilisé dans les rites du Poro, société secrète masculine',
      en: 'Used in Poro rites, male secret society',
      wo: 'Njëkk ci rite Poro'
    },
    materials: ['Bois', 'Pigments naturels'],
    artist: 'Artisan Sénoufo anonyme'
  },
  {
    qrCode: 'MCN-002',
    title: {
      fr: 'Statue Nok',
      en: 'Nok Statue',
      wo: 'Statue Nok'
    },
    description: {
      fr: 'Sculpture en terre cuite de la culture Nok, l\'une des plus anciennes civilisations d\'Afrique subsaharienne (500 av. J.-C. - 200 ap. J.-C.).',
      en: 'Terracotta sculpture from the Nok culture, one of the oldest civilizations in sub-Saharan Africa (500 BC - 200 AD).',
      wo: 'Sculpture bu terre cuite ci culture Nok, benn ci civilisations yu gën a mag ci Afrique subsaharienne.'
    },
    images: ['https://res.cloudinary.com/demo/image/upload/sample.jpg'],
    category: 'sculpture',
    period: '500 av. J.-C. - 200 ap. J.-C.',
    origin: 'Nigeria',
    roomId: 'ancient-civilizations',
    culturalContext: {
      fr: 'Témoignage de la maîtrise technique et artistique de la culture Nok',
      en: 'Testament to the technical and artistic mastery of the Nok culture',
      wo: 'Xam-xam bu technique ak artistique ci culture Nok'
    },
    materials: ['Terre cuite'],
    artist: 'Artisan Nok anonyme'
  },
  {
    qrCode: 'MCN-003',
    title: {
      fr: 'Textile Kente',
      en: 'Kente Cloth',
      wo: 'Textile Kente'
    },
    description: {
      fr: 'Tissu traditionnel ghanéen tissé à la main, symbole de richesse et de prestige. Chaque motif et couleur a une signification particulière.',
      en: 'Traditional Ghanaian hand-woven fabric, symbol of wealth and prestige. Each pattern and color has a particular meaning.',
      wo: 'Textile traditionnel bu Ghana bu tëj ci loxo, alal bu alal ak prestige.'
    },
    images: ['https://res.cloudinary.com/demo/image/upload/sample.jpg'],
    category: 'textile',
    period: 'XVIIe siècle - Contemporain',
    origin: 'Ghana',
    roomId: 'textiles-room',
    culturalContext: {
      fr: 'Porté lors des grandes occasions par les chefs Ashanti',
      en: 'Worn on great occasions by Ashanti chiefs',
      wo: 'Samp ci événements yu mag ci chefs Ashanti'
    },
    materials: ['Coton', 'Soie'],
    artist: 'Tisserands Ashanti'
  },
  {
    qrCode: 'MCN-004',
    title: {
      fr: 'Tambour Djembé',
      en: 'Djembe Drum',
      wo: 'Tambour Djembé'
    },
    description: {
      fr: 'Instrument de percussion traditionnel d\'Afrique de l\'Ouest, sculpté dans un tronc d\'arbre et recouvert de peau de chèvre.',
      en: 'Traditional West African percussion instrument, carved from a tree trunk and covered with goat skin.',
      wo: 'Instrument bu percussion traditionnel ci Afrique de l\'Ouest.'
    },
    images: ['https://res.cloudinary.com/demo/image/upload/sample.jpg'],
    category: 'instrument',
    period: 'XIIe siècle - Contemporain',
    origin: 'Mali',
    roomId: 'music-room',
    culturalContext: {
      fr: 'Utilisé dans les cérémonies, fêtes et communications entre villages',
      en: 'Used in ceremonies, celebrations and communications between villages',
      wo: 'Njëkk ci sérémonies, fêtes ak communication ci biir gox yi'
    },
    materials: ['Bois de lenke', 'Peau de chèvre', 'Cordes'],
    artist: 'Artisan Malinké'
  },
  {
    qrCode: 'MCN-005',
    title: {
      fr: 'Couronne Yoruba',
      en: 'Yoruba Crown',
      wo: 'Couronne Yoruba'
    },
    description: {
      fr: 'Couronne perlée portée par les rois Yoruba, ornée de motifs symboliques et de perles de verre colorées.',
      en: 'Beaded crown worn by Yoruba kings, decorated with symbolic motifs and colored glass beads.',
      wo: 'Couronne bu perles bu sampe ci rois Yoruba.'
    },
    images: ['https://res.cloudinary.com/demo/image/upload/sample.jpg'],
    category: 'bijoux',
    period: 'XIXe siècle',
    origin: 'Nigeria',
    roomId: 'royalty-room',
    culturalContext: {
      fr: 'Symbole du pouvoir divin et de l\'autorité royale',
      en: 'Symbol of divine power and royal authority',
      wo: 'Alal bu pouvoir divin ak autorité royale'
    },
    materials: ['Perles de verre', 'Tissu', 'Cuir'],
    artist: 'Artisan Yoruba de la cour royale'
  }
];

// Données de test pour les salles virtuelles
const sampleRooms = [
  {
    roomId: 'main-hall',
    name: {
      fr: 'Hall Principal',
      en: 'Main Hall',
      wo: 'Hall bu Njëkk'
    },
    description: {
      fr: 'Salle d\'accueil présentant une vue d\'ensemble des collections',
      en: 'Welcome hall presenting an overview of the collections',
      wo: 'Salle d\'accueil bu wone vue d\'ensemble ci collections yi'
    },
    order: 1,
    lighting: {
      ambient: {
        color: '#ffffff',
        intensity: 0.6
      },
      directional: [
        {
          color: '#ffffff',
          intensity: 1,
          position: { x: 10, y: 15, z: 10 }
        }
      ]
    },
    cameraStart: {
      position: { x: 0, y: 1.6, z: 8 },
      lookAt: { x: 0, y: 1.6, z: 0 }
    }
  },
  {
    roomId: 'ancient-civilizations',
    name: {
      fr: 'Civilisations Anciennes',
      en: 'Ancient Civilizations',
      wo: 'Civilisations yu Gën a Mag'
    },
    description: {
      fr: 'Découvrez les grandes civilisations africaines antiques',
      en: 'Discover the great ancient African civilizations',
      wo: 'Gis civilisations africaines antiques yu mag'
    },
    order: 2,
    lighting: {
      ambient: {
        color: '#fff5e6',
        intensity: 0.5
      },
      directional: [
        {
          color: '#ffd700',
          intensity: 0.8,
          position: { x: 5, y: 10, z: 5 }
        }
      ]
    }
  },
  {
    roomId: 'textiles-room',
    name: {
      fr: 'Salle des Textiles',
      en: 'Textiles Room',
      wo: 'Salle bu Textiles'
    },
    description: {
      fr: 'Collection de textiles traditionnels africains',
      en: 'Collection of traditional African textiles',
      wo: 'Collection bu textiles traditionnels africains'
    },
    order: 3
  },
  {
    roomId: 'music-room',
    name: {
      fr: 'Salle de la Musique',
      en: 'Music Room',
      wo: 'Salle bu Musique'
    },
    description: {
      fr: 'Instruments de musique traditionnels',
      en: 'Traditional musical instruments',
      wo: 'Instruments bu musique traditionnels'
    },
    order: 4
  },
  {
    roomId: 'royalty-room',
    name: {
      fr: 'Salle de la Royauté',
      en: 'Royalty Room',
      wo: 'Salle bu Royauté'
    },
    description: {
      fr: 'Objets et insignes des cours royales africaines',
      en: 'Objects and insignia of African royal courts',
      wo: 'Objets ak insignes ci cours royales africaines'
    },
    order: 5
  }
];

// Données de test pour les utilisateurs
const sampleUsers = [
  {
    phoneNumber: '771234567',
    pin: '1234',
    name: 'Administrateur Musée',
    role: 'admin'
  },
  {
    phoneNumber: '779876543',
    pin: '5678',
    name: 'Conservateur Principal',
    role: 'curator'
  },
  {
    phoneNumber: '701112233',
    pin: '9999',
    name: 'Visiteur Test',
    role: 'visitor'
  }
];

// Fonction pour insérer les données
const seedDatabase = async () => {
  try {
    console.log('🗑️  Suppression des données existantes...');
    await Artwork.deleteMany({});
    await VirtualRoom.deleteMany({});
    await User.deleteMany({});

    console.log('📦 Insertion des salles virtuelles...');
    const rooms = await VirtualRoom.insertMany(sampleRooms);
    console.log(`✅ ${rooms.length} salles créées`);

    console.log('🎨 Insertion des œuvres...');
    const artworks = await Artwork.insertMany(sampleArtworks);
    console.log(`✅ ${artworks.length} œuvres créées`);

    console.log('👥 Insertion des utilisateurs...');
    const users = await User.insertMany(sampleUsers);
    console.log(`✅ ${users.length} utilisateurs créés`);

    console.log('\n🎉 Base de données initialisée avec succès!\n');
    console.log('📋 Comptes de test créés:');
    console.log('   Admin: 771234567 / PIN: 1234');
    console.log('   Curator: 779876543 / PIN: 5678');
    console.log('   Visitor: 701112233 / PIN: 9999\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Erreur lors de l\'initialisation:', error);
    process.exit(1);
  }
};

// Exécuter le script
seedDatabase();
