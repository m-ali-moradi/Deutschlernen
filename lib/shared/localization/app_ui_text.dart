import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';

/// Riverpod provider for the global [AppUiText] instance.
///
/// Automatically updates when the system or user-selected [displayLanguageProvider] changes,
/// triggering UI rebuilds for all listening widgets to reflect the new language immediately.
final appUiTextProvider = Provider<AppUiText>((ref) {
  final lang = ref.watch(displayLanguageProvider);
  return AppUiText(lang);
});

/// A centralized utility for providing localized UI text throughout the application.
///
/// This class handles translation logic for three primary languages:
/// *   **German (de)**: The target learning language and primary UI language for DACH region users.
/// *   **English (en)**: The default fallback and instructional language.
/// *   **Dari/Farsi (fa)**: Support for Persian-speaking learners, treated as a single logical grouping.
///
/// Interaction with Riverpod is managed via [appUiTextProvider].
class AppUiText {
  /// Initializes the translation utility with a specific [displayLanguage] code.
  const AppUiText(this.displayLanguage);

  /// The current active ISO language code (e.g., 'en', 'de', 'fa').
  final String displayLanguage;

  /// Returns true if the app is currently displaying German.
  bool get isGerman => displayLanguage == 'de';

  /// Returns true if the app is currently displaying English.
  bool get isEnglish => displayLanguage == 'en';

  /// Returns true if the app is currently displaying Dari or Farsi.
  ///
  /// Note: Both 'fa' and 'dari' codes map to the same Persian localization logic.
  bool get isDari => displayLanguage == 'fa' || displayLanguage == 'dari';

  /// Simple binary helper for selecting between German and English text.
  String either({required String german, required String english}) {
    if (isGerman) return german;
    return english;
  }

  /// Complex translation helper supporting German, English, and Farsi.
  ///
  /// Fallback priority:
  /// 1. Requested Language (if provided)
  /// 2. English (Required default)
  String translate({
    String? de,
    required String en,
    String? fa,
  }) {
    if (isGerman && de != null) return de;
    if (isDari && fa != null) return fa;
    return en;
  }

  // --- Vocabulary Domain Localizations ---

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

  // --- Common UI Localizations ---

  String offlineMessage() {
    return either(german: 'Du bist offline', english: 'You are offline');
  }

  String noPinnedGroupsMessage() {
    return either(
      german: 'Keine Gruppen angeheftet. Wähle oben eine Gruppe aus.',
      english: 'No groups pinned. Select a group from above.',
    );
  }

  String homeScreenTitle() {
    return either(german: 'Lerne Deutsch', english: 'Learn German');
  }

  String homeScreenSubtitle() {
    return either(
      german: 'Setze deine Reise fort.',
      english: 'Continue your journey.',
    );
  }

  // --- Sections & Features ---

  String exerciseSectionTitle() {
    return either(german: 'Übungen', english: 'Exercises');
  }

  String exerciseSubtitle() {
    return either(german: 'Tests & Quiz', english: 'Tests & quizzes');
  }

  String practiceSectionTitle() {
    return either(german: 'Dein Training', english: 'Your Training');
  }

  String practiceSubtitle() {
    return either(
      german: 'Tägliche Übungen und Prüfungsvorbereitung',
      english: 'Daily exercises and exam preparation',
    );
  }

  String dialogueSectionTitle() {
    return either(german: 'Dialoge', english: 'Dialogues');
  }

  String dialogueSubtitle() {
    return either(
      german: 'Realistische Gespräche üben',
      english: 'Practice realistic conversations',
    );
  }

  String dialoguePlay() {
    return either(german: 'Abspielen', english: 'Play');
  }

  String dialogueRead() {
    return either(german: 'Lesen', english: 'Read');
  }

  String dialogueNoDialoguesFound() {
    return either(
        german: 'Keine Dialoge gefunden.', english: 'No dialogues found.');
  }

  String examsSectionTitle() {
    return either(german: 'Offizielle Prüfungen', english: 'Official Exams');
  }

  String examsSubtitle() {
    return either(
      german: 'Infos und Anleitungen zu offiziellen Prüfungen',
      english: 'Info and guides on official exams',
    );
  }

  // --- Filter & Action UI ---

  String examsOfficial() {
    return either(german: 'OFFIZIELLE', english: 'OFFICIAL');
  }

  String filterAll() {
    return either(german: 'Alle', english: 'All');
  }

  // --- Exam Metadata ---

  String examStructureAndDuration() {
    return either(german: 'Struktur & Dauer', english: 'Structure & Duration');
  }

  String examTips() {
    return either(german: 'Tipps', english: 'Tips');
  }

  String examOfficialResources() {
    return either(
        german: 'Offizielle Ressourcen', english: 'Official Resources');
  }

  String examSource(String source) {
    return either(german: 'Quelle: $source', english: 'Source: $source');
  }

  String examSourceInfo() {
    return either(
      german: 'Offizielle Prüfungsinformationen',
      english: 'Official Exam Information',
    );
  }

  String examMinutes() {
    return either(german: 'Min.', english: 'min');
  }

  String examModules() {
    return either(german: 'Module', english: 'Modules');
  }

  String examBreak() {
    return either(german: 'Pause', english: 'Break');
  }

  String unitMinutes(int value) {
    return either(german: '$value Min.', english: '$value min');
  }

  String unitModules(int value) {
    return either(german: '$value Module', english: '$value Modules');
  }

  // --- Exercise Interface ---

  String exerciseTypesTitle() {
    return either(german: 'Übungstypen', english: 'Exercise types');
  }

  String exerciseQuestionsAvailable(int count) {
    return either(
      german: '$count Fragen verfügbar',
      english: '$count questions available',
    );
  }

  String exerciseCompletedCount(int completedCount, int totalCount) {
    return either(
      german: '$completedCount/$totalCount abgeschlossen',
      english: '$completedCount/$totalCount completed',
    );
  }

  String examGrading() {
    return either(german: 'Bewertungsschema', english: 'Grading Scheme');
  }

  String examPoints() {
    return either(german: 'Punkte', english: 'Points');
  }

  String examGrade() {
    return either(german: 'Note', english: 'Grade');
  }

  String exerciseWeakAreasTitle() {
    return either(german: 'Deine Schwachstellen', english: 'Your weak areas');
  }

  String exerciseWeakAreasHint() {
    return either(
      german: 'Tippe auf ein Thema, um direkt dort zu üben.',
      english: 'Tap a topic to practice it directly.',
    );
  }

  String exerciseNoExercisesFound() {
    return either(
        german: 'Keine Übungen gefunden.', english: 'No exercises found.');
  }

  String exerciseNoExercisesFoundForTopic() {
    return either(
      german: 'Keine Übungen für dieses Grammatikthema gefunden.',
      english: 'No exercises found for this grammar topic.',
    );
  }

  String exerciseUnsupportedType() {
    return either(
      german: 'Nicht unterstützter Übungstyp',
      english: 'Unsupported exercise type',
    );
  }

  String exerciseAlreadyAnswered() {
    return either(german: 'Bereits beantwortet.', english: 'Already answered.');
  }

  String exerciseCorrect() {
    return either(
        german: 'Richtig! Gut gemacht!', english: 'Correct! Well done!');
  }

  String exerciseSentenceOrderPrompt() {
    return translate(
      de: 'Bringen Sie die Sätze in die richtige Reihenfolge.',
      en: 'Put the words in the correct order.',
      fa: 'کلمات را به ترتیب درست قرار دهید.',
    );
  }

  String exerciseIncorrectCorrect(String correctAnswer) {
    return either(
      german: 'Die richtige Antwort ist: $correctAnswer',
      english: 'The correct answer is: $correctAnswer',
    );
  }

  String exerciseNext() {
    return either(german: 'Weiter', english: 'Next');
  }

  String exerciseFinish() {
    return either(german: 'Fertig', english: 'Finish');
  }

  String exerciseSessionComplete() {
    return either(
      german: 'Sitzung abgeschlossen!',
      english: 'Session complete!',
    );
  }

  String exerciseScoreLabel(int score, int total) {
    return either(
        german: 'Punkte: $score / $total', english: 'Score: $score / $total');
  }

  String exerciseTryAgain() {
    return either(german: 'Nochmal versuchen', english: 'Try again');
  }

  String exerciseBackToTopic() {
    return either(german: 'Zurück zum Thema', english: 'Back to topic');
  }

  String exerciseResultTitle() {
    return either(german: 'Ergebnis', english: 'Results');
  }

  // --- Grammar Domain Localizations ---

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

// --- Static Dictionary Mappings ---

const Map<String, String> _grammarGermanLabels = {
  'completed': 'Fertig',
  'reset_exercises': 'Übungen zurücksetzen',
  'start_exercises': 'Übungen starten',
  'cancel': 'Abbrechen',
};

const Map<String, String> _grammarEnglishLabels = {
  'completed': 'Completed',
  'reset_exercises': 'Reset exercises',
  'start_exercises': 'Start exercises',
  'cancel': 'Cancel',
};

const Map<String, String> _grammarFarsiLabels = {
  'completed': 'تکمیل شده',
  'reset_exercises': 'بازنشانی تمرینات',
  'start_exercises': 'شروع تمرینات',
  'cancel': 'لغو',
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
  'Authorities & Visa': 'Behörden & Visum',
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
  'Registration / Anmeldung': 'Anmeldung',
  'Residence Permit / Visa': 'Aufenthaltstitel / Visum',
  'Appointments': 'Termine',
  'Forms & Documents': 'Formulare und Dokumente',
  'Offices / Authorities': 'Ämter / Behörden',
  'Tax ID / Identification Numbers': 'Steuer-ID / Ausweisnummern',
  'Insurance': 'Versicherung',
  'Legal Procedures': 'Rechtliche Verfahren',
  'Important Phrases': 'Wichtige Phrasen',
  'Opinions & Arguments': 'Meinungen und Argumente',
  'Cause & Result': 'Ursache und Ergebnis',
  'Comparison': 'Vergleich',
  'Condition / Hypothesis': 'Bedingung / Hypothese',
  'Linking Words': 'Verknüpfungswörter',
};

const Map<String, String> _vocabularyTabGermanLabels = {
  'words': 'Wörter',
  'hard_words': 'Schwere Wörter',
  'favorites': 'Favoriten',
};

const Map<String, String> _vocabularyTabEnglishLabels = {
  'words': 'Words',
  'hard_words': 'Hard words',
  'favorites': 'Favorites',
};
