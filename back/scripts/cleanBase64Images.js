const mongoose = require('mongoose');
require('dotenv').config();

// Connexion MongoDB
mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/musee_mcn')
  .then(() => console.log('✅ Connecté à MongoDB'))
  .catch(err => {
    console.error('❌ Erreur connexion MongoDB:', err);
    process.exit(1);
  });

const Artwork = require('../src/models/Artwork');

async function cleanBase64Images() {
  try {
    console.log('\n🔍 Recherche des œuvres avec images base64...\n');

    // Trouver toutes les œuvres
    const artworks = await Artwork.find({});
    console.log(`📊 Total d'œuvres: ${artworks.length}`);

    let cleanedCount = 0;
    let base64Count = 0;

    for (const artwork of artworks) {
      let hasBase64 = false;
      const cleanedImages = [];

      // Vérifier chaque image
      for (const image of artwork.images) {
        // Détecter les images base64 (commencent par data:image)
        if (image.startsWith('data:image')) {
          hasBase64 = true;
          base64Count++;
          console.log(`❌ Image base64 détectée dans "${artwork.title.fr || artwork.title.en}":`);
          console.log(`   Taille: ${(image.length / 1024).toFixed(2)} KB`);
          // Ne pas ajouter cette image à cleanedImages
        } else {
          // Garder les images normales (Cloudinary ou URLs)
          cleanedImages.push(image);
        }
      }

      // Si des images base64 ont été trouvées, mettre à jour l'œuvre
      if (hasBase64) {
        artwork.images = cleanedImages;
        await artwork.save();
        cleanedCount++;
        console.log(`✅ Œuvre "${artwork.title.fr || artwork.title.en}" nettoyée`);
        console.log(`   Images restantes: ${cleanedImages.length}\n`);
      }
    }

    console.log('\n📈 Résumé:');
    console.log(`   - Œuvres nettoyées: ${cleanedCount}`);
    console.log(`   - Images base64 supprimées: ${base64Count}`);
    console.log(`   - Œuvres sans problème: ${artworks.length - cleanedCount}`);

    if (cleanedCount > 0) {
      console.log('\n⚠️  IMPORTANT:');
      console.log('   Les images base64 ont été supprimées.');
      console.log('   Veuillez re-uploader les images via Cloudinary depuis l\'interface admin.');
    }

  } catch (error) {
    console.error('❌ Erreur:', error);
  } finally {
    await mongoose.connection.close();
    console.log('\n✅ Connexion fermée');
  }
}

// Exécuter le script
cleanBase64Images();
