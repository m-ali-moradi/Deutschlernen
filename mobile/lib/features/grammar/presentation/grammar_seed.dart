class GrammarTopicView {
  const GrammarTopicView({
    required this.id,
    required this.title,
    required this.level,
    required this.category,
    required this.icon,
    required this.rule,
    required this.explanation,
    required this.examples,
    required this.progress,
  });

  final String id;
  final String title;
  final String level;
  final String category;
  final String icon;
  final String rule;
  final String explanation;
  final List<String> examples;
  final int progress;
}

const grammarTopicsSeed = <GrammarTopicView>[
  GrammarTopicView(
    id: 'g1',
    title: 'Bestimmte Artikel',
    level: 'A1',
    category: 'Artikel',
    icon: '📘',
    rule: 'Der, die, das hangen vom Genus des Nomens ab.',
    explanation:
        'Jedes deutsche Nomen hat ein grammatisches Geschlecht. Im Plural nutzt man immer die.',
    examples: [
      'Der Mann liest ein Buch.',
      'Die Frau trinkt Kaffee.',
      'Das Kind spielt im Garten.',
    ],
    progress: 80,
  ),
  GrammarTopicView(
    id: 'g2',
    title: 'Prasens',
    level: 'A1',
    category: 'Zeiten',
    icon: '⏰',
    rule: 'Verbendung richtet sich nach Person und Numerus.',
    explanation:
        'Im Prasens wird der Verbstamm mit Endungen wie -e, -st, -t, -en kombiniert.',
    examples: [
      'Ich lerne Deutsch.',
      'Du arbeitest jeden Tag.',
      'Wir gehen ins Kino.',
    ],
    progress: 65,
  ),
  GrammarTopicView(
    id: 'g3',
    title: 'Nebensatze mit weil',
    level: 'A2',
    category: 'Nebensatze',
    icon: '🔗',
    rule: 'Im Nebensatz steht das konjugierte Verb am Ende.',
    explanation:
        'Mit Konjunktionen wie weil, dass oder wenn wandert das finite Verb ans Satzende.',
    examples: [
      'Ich lerne Deutsch, weil ich in Berlin arbeite.',
      'Sie sagt, dass sie morgen kommt.',
      'Wenn es regnet, bleibe ich zu Hause.',
    ],
    progress: 40,
  ),
  GrammarTopicView(
    id: 'g4',
    title: 'Wechselprapositionen',
    level: 'A2',
    category: 'Prapositionen',
    icon: '📍',
    rule: 'Akkusativ bei Bewegung, Dativ bei Position.',
    explanation:
        'Zweiwege-Prapositionen verwenden den Akkusativ fur Richtungsanderung und Dativ fur Lage.',
    examples: [
      'Ich stelle das Buch auf den Tisch.',
      'Das Buch liegt auf dem Tisch.',
      'Er ist in der Schule.',
    ],
    progress: 30,
  ),
  GrammarTopicView(
    id: 'g5',
    title: 'Perfekt',
    level: 'A2',
    category: 'Zeiten',
    icon: '✅',
    rule: 'Perfekt = haben/sein + Partizip II.',
    explanation:
        'Die meisten Verben nutzen haben, Bewegungs- und Zustandswechsel-Verben oft sein.',
    examples: [
      'Ich habe Deutsch gelernt.',
      'Sie ist nach Berlin gefahren.',
      'Wir haben einen Film gesehen.',
    ],
    progress: 55,
  ),
  GrammarTopicView(
    id: 'g6',
    title: 'Konjunktiv II',
    level: 'B1',
    category: 'Konjunktiv',
    icon: '💭',
    rule: 'Konjunktiv II beschreibt Irreales, Wunsche und Hoflichkeit.',
    explanation:
        'Haufige Form: wurde + Infinitiv. Unregelmassige Formen: ware, hatte, konnte.',
    examples: [
      'Wenn ich reich ware, wurde ich reisen.',
      'Ich hatte gern einen Kaffee.',
      'Konnten Sie mir helfen?',
    ],
    progress: 20,
  ),
  GrammarTopicView(
    id: 'g7',
    title: 'Trennbare Verben',
    level: 'A2',
    category: 'Zeiten',
    icon: '🧩',
    rule: 'Bei trennbaren Verben steht die Vorsilbe im Hauptsatz am Ende.',
    explanation:
        'Im Prasens wird das Verb konjugiert und die trennbare Vorsilbe an das Satzende gestellt.',
    examples: [
      'Ich stehe jeden Tag um 6 Uhr auf.',
      'Wir rufen den Kunden morgen an.',
      'Sie kauft im Supermarkt ein.',
    ],
    progress: 15,
  ),
  GrammarTopicView(
    id: 'g8',
    title: 'Passiv im Alltag',
    level: 'B2',
    category: 'Zeiten',
    icon: '🏗️',
    rule: 'Passiv: werden + Partizip II; Fokus liegt auf der Handlung.',
    explanation:
        'Das Passiv wird genutzt, wenn die ausfuhrende Person unwichtig ist oder unbekannt bleibt.',
    examples: [
      'Der Vertrag wird heute unterschrieben.',
      'Die Daten werden sicher gespeichert.',
      'Die Anfrage wurde gestern bearbeitet.',
    ],
    progress: 10,
  ),
];

const grammarLevels = ['Alle', 'A1', 'A2', 'B1', 'B2'];
const grammarCategories = [
  'Alle',
  'Artikel',
  'Zeiten',
  'Nebensatze',
  'Prapositionen',
  'Konjunktiv',
];
