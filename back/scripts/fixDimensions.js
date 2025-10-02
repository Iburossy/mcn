const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const fixDimensions = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Connecté à MongoDB');

    const db = mongoose.connection.db;
    const collection = db.collection('artworks');

    // Mettre à jour toutes les œuvres avec dimensions = ""
    const result1 = await collection.updateMany(
      { dimensions: "" },
      { $unset: { dimensions: "" } }
    );
    console.log(`✅ ${result1.modifiedCount} œuvres avec dimensions vides corrigées`);

    // Mettre à jour toutes les œuvres avec materials = ""
    const result2 = await collection.updateMany(
      { materials: "" },
      { $unset: { materials: "" } }
    );
    console.log(`✅ ${result2.modifiedCount} œuvres avec materials vides corrigées`);

    console.log('✅ Migration terminée !');
    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('❌ Erreur:', error);
    process.exit(1);
  }
};

fixDimensions();
