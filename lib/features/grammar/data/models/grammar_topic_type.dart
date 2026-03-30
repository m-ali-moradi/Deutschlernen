import 'package:flutter/material.dart';
import '../../../../shared/localization/app_ui_text.dart';

/// Category gradient colors
///
/// Returns a list of two colors representing the gradient for a given category.
///
/// [category] The category name.
///
/// Returns a list of two colors.
List<Color> getGrammarCategoryGradient(String category) {
  switch (category) {
    case 'Artikel':
    case 'Articles':
    case 'حروف تعریف':
    case 'Artikel & Nomen':
      return const [Color(0xFF60A5FA), Color(0xFF2563EB)];
    case 'Satzbau':
    case 'Sentence structure':
    case 'ساختار جمله':
      return const [Color(0xFF22D3EE), Color(0xFF0891B2)];
    case 'Fälle':
    case 'Kasus':
    case 'Cases':
    case 'حالت‌ها':
      return const [Color(0xFFA78BFA), Color(0xFF7C3AED)];
    case 'Pronomen':
    case 'Pronouns':
    case 'ضمایر':
      return const [Color(0xFF2DD4BF), Color(0xFF0D9488)];
    case 'Zeiten':
    case 'Tenses':
    case 'زمان‌ها':
      return const [Color(0xFFFBBF24), Color(0xFFD97706)];
    case 'Verben':
    case 'Verbs':
    case 'افعال':
      return const [Color(0xFF4ADE80), Color(0xFF16A34A)];
    case 'Prapositionen':
    case 'Präpositionen':
    case 'Prepositions':
    case 'حروف اضافه':
      return const [Color(0xFFF472B6), Color(0xFFDB2777)];
    case 'Adjektive':
    case 'Adjectives':
    case 'صفات':
      return const [Color(0xFFE879F9), Color(0xFFA21CAF)];
    case 'Nebensatze':
    case 'Nebensätze':
    case 'Subordinate clauses':
    case 'جملات پیرو':
      return const [Color(0xFF2DD4BF), Color(0xFF0F766E)];
    case 'Konjunktiv':
    case 'Subjunctive':
    case 'وجه التزامی':
      return const [Color(0xFFC084FC), Color(0xFF7C3AED)];
    case 'Partikeln':
    case 'Particles':
    case 'ادات':
      return const [Color(0xFFFB7185), Color(0xFFE11D48)];
    case 'Relativsatze':
    case 'Relativsätze':
    case 'Relative clauses':
      return const [Color(0xFF818CF8), Color(0xFF6366F1)];
    default:
      return const [Color(0xFF9CA3AF), Color(0xFF4B5563)];
  }
}

/// List of grammar levels
const grammarLevels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];

/// List of grammar categories
const grammarCategories = [
  'Alle',
  'Artikel',
  'Satzbau',
  'Fälle',
  'Pronomen',
  'Zeiten',
  'Verben',
  'Präpositionen',
  'Adjektive',
  'Nebensätze',
  'Konjunktiv',
  'Partikeln'
];

/// Gets the label for a grammar category.
///
/// [strings] The UI text provider.
/// [category] The category name.
///
/// Returns the label for the category.
String getGrammarCategoryLabel(AppUiText strings, String category) {
  switch (category) {
    case 'Alle':
      return strings.translate(de: 'Alle', en: 'All', fa: 'همه');
    case 'Artikel':
      return strings.translate(de: 'Artikel', en: 'Articles', fa: 'حروف تعریف');
    case 'Satzbau':
      return strings.translate(
          de: 'Satzbau', en: 'Sentence structure', fa: 'ساختار جمله');
    case 'Fälle':
      return strings.translate(de: 'Fälle', en: 'Cases', fa: 'حالت‌ها');
    case 'Pronomen':
      return strings.translate(de: 'Pronomen', en: 'Pronouns', fa: 'ضمایر');
    case 'Zeiten':
      return strings.translate(de: 'Zeiten', en: 'Tenses', fa: 'زمان‌ها');
    case 'Verben':
      return strings.translate(de: 'Verben', en: 'Verbs', fa: 'افعال');
    case 'Präpositionen':
      return strings.translate(
          de: 'Präpositionen', en: 'Prepositions', fa: 'حروف اضافه');
    case 'Adjektive':
      return strings.translate(de: 'Adjektive', en: 'Adjectives', fa: 'صفات');
    case 'Nebensätze':
      return strings.translate(
          de: 'Nebensätze', en: 'Subordinate clauses', fa: 'جملات پیرو');
    case 'Konjunktiv':
      return strings.translate(
          de: 'Konjunktiv', en: 'Subjunctive', fa: 'وجه التزامی');
    case 'Partikeln':
      return strings.translate(de: 'Partikeln', en: 'Particles', fa: 'ادات');
    default:
      return category;
  }
}

/// Map of English topic titles
const Map<String, String> grammarEnglishTopicTitles = {
  'Bestimmte Artikel': 'Definite Articles',
  'Satzbau': 'Sentence Structure',
  'Nominativ & Akkusativ': 'Nominative & Accusative',
  'Personalpronomen': 'Personal Pronouns',
  'Präsens': 'Present Tense',
  'Modalverben': 'Modal Verbs',
  'Trennbare Verben': 'Separable Verbs',
  'Präpositionen (Akk/Dat)': 'Prepositions (Acc/Dat)',
  'Adjektive Grundlagen': 'Adjective Basics',
  'Pluralbildung': 'Plural Formation',
  'Negation': 'Negation',
  'Perfekt': 'Perfect Tense',
  'Präteritum': 'Simple Past',
  'Futur I': 'Future I',
  'Nebensätze': 'Subordinate Clauses',
  'Relativsätze (Grundlagen)': 'Relative Clauses (Basics)',
  'Infinitivkonstruktionen': 'Infinitive Constructions',
  'Wechselpräpositionen': 'Two-Way Prepositions',
  'Adjektivdeklination': 'Adjective Declension',
  'Komparativ & Superlativ': 'Comparative & Superlative',
  'Reflexive Verben': 'Reflexive Verbs',
  'Indefinitpronomen': 'Indefinite Pronouns',
  'Dativ': 'Dative',
  'Verben mit Präpositionen': 'Verbs with Prepositions',
  'Passiv (Grundlagen)': 'Passive Voice (Basics)',
  'Plusquamperfekt': 'Past Perfect',
  'Futur I & II': 'Future I & II',
  'Erweiterte Nebensätze': 'Advanced Subordinate Clauses',
  'Konditionalsätze': 'Conditional Clauses',
  'Konjunktiv II': 'Subjunctive II',
  'Relativsätze (Fortgeschritten)': 'Relative Clauses (Advanced)',
  'Partizipien als Adjektive': 'Participles as Adjectives',
  'Nominalisierung': 'Nominalization',
  'Indirekte Rede': 'Reported Speech',
  'Genitiv': 'Genitive',
  'n-Deklination': 'n-Declension',
  'Wortstellung (Fortgeschritten)': 'Advanced Word Order',
  'Konjunktiv I': 'Subjunctive I',
  'Konjunktiv II (Fortgeschritten)': 'Subjunctive II (Advanced)',
  'Passiv': 'Passive Voice',
  'Partizipialkonstruktionen': 'Participial Constructions',
  'Erweiterte Nebensätze (B2)': 'Advanced Subordinate Clauses',
  'Nominalstil': 'Nominal Style',
  'Konnektoren': 'Connectors',
  'Genitiv-Präpositionen': 'Genitive Prepositions',
  'Doppelkonnektoren': 'Paired Conjunctions',
  'Passiversatzformen': 'Passive Alternatives',
  'Funktionsverbgefüge': 'Light-Verb Constructions',
  'Modalpartikeln': 'Modal Particles',
  'Subjektive Modalverben': 'Subjective Modal Verbs',
  'Nomen-Verb-Verbindungen': 'Noun-Verb Collocations',
  'Erweiterte Passivformen': 'Advanced Passive Forms',
  'Weiterführende Nebensätze': 'Advanced Clause Patterns',
  'Apposition': 'Apposition',
  'Komplexe Attribute': 'Complex Attributes',
};
