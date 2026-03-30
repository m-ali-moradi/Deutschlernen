const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// To run this, you should have your service account key file.
// If you don't have it, go to Firebase Console > Project Settings > Service Accounts
// Generate and download a new private key.
// Set the path here or use GOOGLE_APPLICATION_CREDENTIALS environment variable.

const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS || './service-account-key.json';

if (!fs.existsSync(serviceAccountPath)) {
  console.error('Error: Service account key not found at ' + serviceAccountPath);
  console.error('Please download it from Firebase Console and save it as service-account-key.json in the project root.');
  process.exit(1);
}

const serviceAccount = require(path.resolve(serviceAccountPath));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const CATEGORIES_PATH = 'content/v1/vocabulary_categories';
const GROUPS_PATH = 'content/v1/vocabulary_groups';
const WORDS_PATH = 'content/v1/vocabulary_words';

function mapLegacyCategory(category) {
  switch (category) {
    case 'Unternehmensführung': return 'Company';
    case 'Meetings': return 'Meetings';
    case 'Akademischer Diskurs': return 'University';
    case 'Abstrakte Konzepte': return 'Opinions & Arguments';
    case 'Bildung & Schule': return 'School';
    case 'Bewerbung': return 'Application & Career';
    case 'Finanzen': return 'Finance & Accounting';
    case 'Marketing & Vertrieb': return 'Marketing & Sales';
    case 'Personalwesen': return 'Human Resources';
    case 'Visa & Behörden': return 'Authorities & Visa';
    case 'IT & Technologie':
    case 'IT & Technik': return 'Software & App';
    case 'Telekommunikation': return 'Software & App';
    case 'Berufe': return 'Application & Career';
    case 'Gesundheit': return 'Doctor & Pharmacy';
    case 'Alltag & Basics': return 'Greetings';
    case 'Office': return 'Office & Tasks';
    case 'Verträge & Recht': return 'Government & Law';
    default: return category;
  }
}

async function uploadGroups() {
  console.log('Uploading Groups...');
  const groupsFile = path.resolve(__dirname, '../assets/content/vocabulary/groups.json');
  const groups = JSON.parse(fs.readFileSync(groupsFile, 'utf8'));
  
  for (const group of groups) {
    await db.collection(GROUPS_PATH).doc(group.id).set(group);
    console.log(`Uploaded group: ${group.name}`);
  }
}

async function uploadCategories() {
  console.log('Uploading Categories...');
  const catsFile = path.resolve(__dirname, '../assets/content/vocabulary/categories.json');
  const cats = JSON.parse(fs.readFileSync(catsFile, 'utf8'));
  
  for (const cat of cats) {
    await db.collection(CATEGORIES_PATH).doc(cat.id).set(cat);
    console.log(`Uploaded category: ${cat.name}`);
  }
}

async function uploadVocabularyWords() {
  console.log('Uploading Vocabulary Words...');
  const vocabDir = path.resolve(__dirname, '../assets/content/vocabulary');
  const levels = ['A1', 'A2', 'B1', 'B2', 'C1'];
  
  for (const level of levels) {
    const levelDir = path.join(vocabDir, level);
    if (!fs.existsSync(levelDir)) continue;
    
    const files = fs.readdirSync(levelDir).filter(f => f.endsWith('.json'));
    for (const file of files) {
      console.log(`Processing ${level}/${file}...`);
      let words = JSON.parse(fs.readFileSync(path.join(levelDir, file), 'utf8'));
      if (!Array.isArray(words)) {
        words = [words];
      }
      
      for (const word of words) {
        if (!word.id) continue;
        
        // Map legacy categories if needed (like the app does)
        const category = word.category || '';
        const mappedCategory = mapLegacyCategory(category);
        
        const mappedWord = {
          ...word,
          category: mappedCategory,
          level: level,
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        };
        await db.collection(WORDS_PATH).doc(word.id).set(mappedWord);
      }
    }
  }
}

async function main() {
  try {
    await uploadGroups();
    await uploadCategories();
    await uploadVocabularyWords();
    console.log('All vocabulary content uploaded successfully!');
  } catch (error) {
    console.error('Migration failed:', error);
  }
}

main();
