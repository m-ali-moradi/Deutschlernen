import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';

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

/// Category icons
///
/// Returns an IconData representing the category, with optional topic-specific overrides.
IconData getGrammarCategoryIcon(String category, [String? title]) {
  // Topic-specific overrides for a more professional and unique look
  if (title != null) {
    final t = title.toLowerCase();
    
    // Articles & Nouns
    if (t.contains('plural')) return Icons.plus_one_rounded;
    if (t.contains('n-deklination')) return Icons.format_indent_increase_rounded;
    if (t.contains('artikel')) return Icons.text_fields_rounded;
    if (t.contains('nomen')) return Icons.smart_button_rounded;
    
    // Cases
    if (t.contains('akkusativ') || t.contains('dativ') || t.contains('genitiv') || t.contains('nominativ')) {
      return Icons.compare_arrows_rounded;
    }
    
    // Verbs & Tenses
    if (t.contains('präsens')) return Icons.timer_rounded;
    if (t.contains('perfekt')) return Icons.history_rounded;
    if (t.contains('präteritum')) return Icons.auto_stories_rounded;
    if (t.contains('futur')) return Icons.update_rounded;
    if (t.contains('modalverben')) return Icons.psychology_rounded;
    if (t.contains('trennbare')) return Icons.content_cut_rounded;
    if (t.contains('reflexive')) return Icons.settings_backup_restore_rounded;
    if (t.contains('passiv')) return Icons.inbox_rounded;
    if (t.contains('konjunktiv')) return Icons.auto_awesome_rounded;
    if (t.contains('imperativ')) return Icons.priority_high_rounded;
    if (t.contains('infinitiv')) return Icons.all_inclusive_rounded;
    if (t.contains('partizip')) return Icons.extension_rounded;
    if (t.contains('partikeln')) return Icons.grain_rounded;
    if (t.contains('rede')) return Icons.record_voice_over_rounded;
    if (t.contains('nomen-verb')) return Icons.handshake_rounded;
    
    // Sentence Structure
    if (t.contains('negation')) return Icons.block_rounded;
    if (t.contains('zahlen') || t.contains('nummer')) return Icons.numbers_rounded;
    if (t.contains('zeit')) return Icons.access_time_rounded;
    if (t.contains('nebensätze') || t.contains('relativsätze') || t.contains('konnektoren') || t.contains('konjunktionen')) {
      return Icons.link_rounded;
    }
    if (t.contains('wortstellung')) return Icons.low_priority_rounded;
    if (t.contains('apposition')) return Icons.add_circle_outline_rounded;
    
    // Adjectives & Nouns
    if (t.contains('komparativ') || t.contains('superlativ')) return Icons.leaderboard_rounded;
    if (t.contains('deklination')) return Icons.format_paint_rounded;
    if (t.contains('adjektive')) return Icons.brush_rounded;
    if (t.contains('nominalisierung') || t.contains('nominalstil')) return Icons.format_list_bulleted_rounded;
    
    // Pronouns
    if (t.contains('pronomen')) return Icons.person_rounded;
    
    // Prepositions
    if (t.contains('wechselpräpositionen')) return Icons.multiple_stop_rounded;
  }

  // Fallback to category-based icons
  switch (category) {
    case 'Artikel':
    case 'Articles':
    case 'حروف تعریف':
    case 'Artikel & Nomen':
      return Icons.article_rounded;
    case 'Satzbau':
    case 'Sentence structure':
    case 'ساختار جمله':
      return Icons.account_tree_rounded;
    case 'Fälle':
    case 'Kasus':
    case 'Cases':
    case 'حالت‌ها':
      return Icons.layers_rounded;
    case 'Pronomen':
    case 'Pronouns':
    case 'ضمایر':
      return Icons.people_outline_rounded;
    case 'Zeiten':
    case 'Tenses':
    case 'زمان‌ها':
      return Icons.schedule_rounded;
    case 'Verben':
    case 'Verbs':
    case 'افعال':
      return Icons.play_arrow_rounded;
    case 'Prapositionen':
    case 'Präpositionen':
    case 'Prepositions':
    case 'حروف اضافه':
      return Icons.place_rounded;
    case 'Adjektive':
    case 'Adjectives':
    case 'صفات':
      return Icons.color_lens_rounded;
    case 'Nebensatze':
    case 'Nebensätze':
    case 'Subordinate clauses':
    case 'جملات پیرو':
      return Icons.link_rounded;
    case 'Konjunktiv':
    case 'Subjunctive':
    case 'وجه التزامی':
      return Icons.psychology_rounded;
    case 'Partikeln':
    case 'Particles':
    case 'ادات':
      return Icons.grain_rounded;
    case 'Relativsatze':
    case 'Relativsätze':
    case 'Relative clauses':
      return Icons.alt_route_rounded;
    default:
      return Icons.book_rounded;
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
  'Unbestimmte Artikel': 'Indefinite Articles',
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



