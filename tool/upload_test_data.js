const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Authenticate via the service account key
const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS || './service-account-key.json';

if (!fs.existsSync(serviceAccountPath)) {
  console.error('Error: Service account key not found at ' + serviceAccountPath);
  process.exit(1);
}

const serviceAccount = require(path.resolve(serviceAccountPath));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Target Firestore collections
const CATEGORIES_PATH = 'content/v1/vocabulary_categories';
const GROUPS_PATH = 'content/v1/vocabulary_groups';
const WORDS_PATH = 'content/v1/vocabulary_words';

async function main() {
  const dataFile = path.resolve(__dirname, 'test_data.json');
  if (!fs.existsSync(dataFile)) {
    console.error('test_data.json not found!');
    process.exit(1);
  }

  // Parse the standalone testing JSON file
  const { groups, categories, words } = JSON.parse(fs.readFileSync(dataFile, 'utf8'));

  console.log('Uploading Test Groups...');
  for (const group of groups || []) {
    await db.collection(GROUPS_PATH).doc(group.id).set(group);
    console.log(`Uploaded group: ${group.name}`);
  }

  console.log('Uploading Test Categories...');
  for (const cat of categories || []) {
    await db.collection(CATEGORIES_PATH).doc(cat.id).set(cat);
    console.log(`Uploaded category: ${cat.name}`);
  }

  console.log('Uploading Test Words...');
  for (const word of words || []) {
    const wordPayload = {
      ...word,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };
    await db.collection(WORDS_PATH).doc(word.id).set(wordPayload);
    console.log(`Uploaded word: ${word.german}`);
  }

  console.log('\nAll test data uploaded successfully!');
  console.log('You can ignore or delete test_data.json and upload_test_data.js when done.');
}

main().catch(console.error);
