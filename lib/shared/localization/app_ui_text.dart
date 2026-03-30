class AppUiText {
  const AppUiText(this.displayLanguage);

  final String displayLanguage;

  bool get isGerman => displayLanguage == 'de';
  bool get isEnglish => displayLanguage == 'en';
  bool get isDari => displayLanguage == 'fa';

  String either({required String german, required String english}) {
    if (isGerman) return german;
    return english;
  }

  String translate({
    String? de,
    required String en,
    String? fa,
  }) {
    if (isGerman && de != null) return de;
    if (isDari && fa != null) return fa;
    return en;
  }

  String vocabularyGroup(String englishName) {
    return either(
      german: _vocabularyGroupGermanLabels[englishName] ?? englishName,
      english: englishName,
    );
  }

  String vocabularyCategory(String englishName) {
    return either(
      german: _vocabularyCategoryGermanLabels[englishName] ?? englishName,
      english: englishName,
    );
  }

  String vocabularyTab(String key) {
    return either(
      german: _vocabularyTabGermanLabels[key] ?? key,
      english: _vocabularyTabEnglishLabels[key] ?? key,
    );
  }

  String offlineMessage() {
    return either(german: 'Du bist offline', english: 'You are offline');
  }

  String grammarLabel(String key) {
    if (isDari) return _grammarFarsiLabels[key] ?? key;
    return either(
      german: _grammarGermanLabels[key] ?? key,
      english: _grammarEnglishLabels[key] ?? key,
    );
  }

  String grammarSectionTitle(String title) {
    return either(
      german: _grammarSectionGermanTitles[title] ?? title,
      english: _grammarSectionEnglishTitles[title] ?? title,
    );
  }
}

const Map<String, String> _grammarGermanLabels = {
  'completed': 'Fertig',
  'reset_exercises': 'Übungen zurücksetzen',
  'start_exercises': 'Übungen starten',
  'download_prompt': 'Möchtest du dieses Thema zur Offline-Nutzung herunterladen?',
  'cancel': 'Abbrechen',
  'download': 'Herunterladen',
};

const Map<String, String> _grammarEnglishLabels = {
  'completed': 'Completed',
  'reset_exercises': 'Reset exercises',
  'start_exercises': 'Start exercises',
  'download_prompt': 'Do you want to download this topic for offline use?',
  'cancel': 'Cancel',
  'download': 'Download',
};

const Map<String, String> _grammarFarsiLabels = {
  'completed': 'تکمیل شده',
  'reset_exercises': 'بازنشانی تمرینات',
  'start_exercises': 'شروع تمرینات',
  'download_prompt': 'آیا می‌خواهید این موضوع را برای استفاده آفلاین دانلود کنید؟',
  'cancel': 'لغو',
  'download': 'دانلود',
};

const Map<String, String> _grammarSectionGermanTitles = {
  'Merke dir!': 'Merke dir!',
  'Beispiele': 'Beispiele',
  'Erklärung': 'Erklärung',
  'Regel': 'Regel',
  'Wichtige Regeln': 'Wichtige Regeln',
};

const Map<String, String> _grammarSectionEnglishTitles = {
  'Merke dir!': 'Remember!',
  'Beispiele': 'Examples',
  'Erklärung': 'Explanation',
  'Regel': 'Rule',
  'Wichtige Regeln': 'Important rules',
};

const Map<String, String> _vocabularyGroupGermanLabels = {
  'Daily Life Basics': 'Alltagsgrundlagen',
  'Personal Information': 'Persönliche Angaben',
  'Travel & Transport': 'Reisen & Verkehr',
  'Home & Housing': 'Wohnen & Zuhause',
  'Health & Body': 'Gesundheit & Körper',
  'Education': 'Bildung',
  'Work & Business': 'Arbeit & Wirtschaft',
  'Technology & IT': 'Technologie & IT',
  'Society & Public Life': 'Gesellschaft & öffentliches Leben',
  'Abstract & Formal Language': 'Abstrakte und formelle Sprache',
};

const Map<String, String> _vocabularyCategoryGermanLabels = {
  'Greetings': 'Begrüßungen',
  'Numbers': 'Zahlen',
  'Time': 'Zeit',
  'Days': 'Tage',
  'Family': 'Familie',
  'Home': 'Zuhause',
  'Food': 'Essen',
  'Shopping': 'Einkaufen',
  'Name & Origin': 'Name und Herkunft',
  'Address & Phone': 'Adresse und Telefon',
  'Age & Nationality': 'Alter und Staatsangehörigkeit',
  'Documents': 'Dokumente',
  'Train & Bus': 'Bahn und Bus',
  'Airport': 'Flughafen',
  'Ticket & Booking': 'Ticket und Buchung',
  'Hotel': 'Hotel',
  'Directions': 'Wegbeschreibung',
  'Rooms': 'Räume',
  'Furniture': 'Möbel',
  'Rent & Cleaning': 'Miete und Reinigung',
  'Repairs': 'Reparaturen',
  'Body Parts': 'Körperteile',
  'Symptoms': 'Symptome',
  'Doctor & Pharmacy': 'Arzt und Apotheke',
  'Emergency': 'Notfall',
  'School': 'Schule',
  'University': 'Universität',
  'Subjects': 'Fächer',
  'Exams & Homework': 'Prüfungen und Hausaufgaben',
  'Company': 'Unternehmen',
  'Meetings': 'Besprechungen',
  'Contracts': 'Verträge',
  'Office & Tasks': 'Büro und Aufgaben',
  'Salary & Projects': 'Gehalt und Projekte',
  'Application & Career': 'Bewerbung und Karriere',
  'Finance & Accounting': 'Finanzen und Buchhaltung',
  'Marketing & Sales': 'Marketing und Vertrieb',
  'Human Resources': 'Personalwesen',
  'Computer & Hardware': 'Computer und Hardware',
  'Software & App': 'Software und App',
  'Internet & Data': 'Internet und Daten',
  'Security': 'Sicherheit',
  'Government & Law': 'Regierung und Recht',
  'Authorities & Visa': 'Behörden und Visum',
  'Environment': 'Umwelt',
  'Media & Culture': 'Medien und Kultur',
  'Opinions & Arguments': 'Meinungen und Argumente',
  'Cause & Result': 'Ursache und Ergebnis',
  'Comparison': 'Vergleich',
};

const Map<String, String> _vocabularyTabGermanLabels = {
  'words': 'Wörter',
  'phrases': 'Phrasen',
  'favorites': 'Favoriten',
};

const Map<String, String> _vocabularyTabEnglishLabels = {
  'words': 'Words',
  'phrases': 'Phrases',
  'favorites': 'Favorites',
};
