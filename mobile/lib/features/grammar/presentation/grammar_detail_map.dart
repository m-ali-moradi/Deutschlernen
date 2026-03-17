import 'package:flutter/material.dart';
import 'grammar_section.dart';

// ignore_for_file: lines_longer_than_80_chars

const _a1Bg   = kA1Bg;   const _a1t = kA1Text;
const _a2Bg   = kA2Bg;   const _a2t = kA2Text;
const _b1Bg   = kB1Bg;   const _b1t = kB1Text;
const _b2Bg   = kB2Bg;   const _b2t = kB2Text;

final Map<String, GrammarDetailData> grammarDetailMap = {

  // ═══════════════════════════ A1 TOPICS ════════════════════════════════════

  'g1': GrammarDetailData(
    id: 'g1', subtitle: 'Artikel · Nomen', emoji: '📘',
    gradient: const [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Grundkonzept · Basic Concept',
        text: 'Every German noun has a grammatical gender: masculine (der), feminine (die), or neuter (das). In the plural, all genders use \'die\'. There is no reliable rule — you must learn the article with each noun.',
        bullets: ['der → masculine (der Mann, der Tisch)', 'die → feminine (die Frau, die Lampe)', 'das → neuter (das Kind, das Buch)', 'die → ALL plurals (die Männer, die Frauen)'],
      ),
      ConjugationSection(title: 'Artikel-Tabelle', color: SectionColor.blue, rows: [
        TableRow2('Maskulin', 'der Mann'), TableRow2('Feminin', 'die Frau'),
        TableRow2('Neutrum', 'das Kind'), TableRow2('Plural', 'die Kinder'),
      ]),
      TipSection(text: 'Nouns ending in -ung, -heit, -keit, -schaft, -tion are usually feminine (die). Nouns ending in -chen, -lein are always neuter (das).'),
      ComparisonSection(
        title: 'Bestimmt vs. Unbestimmt',
        headers: ['Bestimmt', 'Unbestimmt', 'Negation'],
        rows: [
          ComparisonRow(['der Mann', 'ein Mann', 'kein Mann']),
          ComparisonRow(['die Frau', 'eine Frau', 'keine Frau']),
          ComparisonRow(['das Kind', 'ein Kind', 'kein Kind']),
          ComparisonRow(['die Kinder', '– Kinder', 'keine Kinder']),
        ],
      ),
      ExamplesSection(title: 'Beispiele', color: SectionColor.blue, items: [
        ExPair('Der Mann liest ein Buch.', 'The man is reading a book.'),
        ExPair('Die Frau trinkt Kaffee.', 'The woman is drinking coffee.'),
        ExPair('Das Kind spielt im Garten.', 'The child is playing in the garden.'),
        ExPair('Ich habe keine Schwester.', 'I don\'t have a sister.'),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'Always learn the article together with the noun: der Tisch, die Lampe, das Buch.',
        'Compound nouns take the gender of the LAST word: der Schreibtisch.',
        '\'kein\' follows the same pattern as \'ein\' but is used for negation.',
        'In plural, there is no indefinite article — just use the noun alone.',
      ]),
    ],
  ),

  'g2': GrammarDetailData(
    id: 'g2', subtitle: 'Zeiten · Konjugation', emoji: '⏰',
    gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Grundkonzept · Basic Concept',
        text: 'The present tense (Präsens) is formed by removing the -en ending from the infinitive and adding personal endings. It\'s used for current, habitual, and even future events.',
        bullets: ['Remove -en from the infinitive to get the stem', 'Add endings: -e, -st, -t, -en, -t, -en', 'Some verbs have stem changes (e→i, a→ä)'],
      ),
      ConjugationSection(title: 'Regelmäßige Konjugation: lernen', color: SectionColor.amber, rows: [
        TableRow2('ich', 'lern-e'), TableRow2('du', 'lern-st'), TableRow2('er/sie/es', 'lern-t'),
        TableRow2('wir', 'lern-en'), TableRow2('ihr', 'lern-t'), TableRow2('Sie/sie', 'lern-en'),
      ]),
      ConjugationSection(title: 'Unregelmäßig: sein & haben', color: SectionColor.orange, rows: [
        TableRow2('ich', 'bin / habe'), TableRow2('du', 'bist / hast'), TableRow2('er/sie/es', 'ist / hat'),
        TableRow2('wir', 'sind / haben'), TableRow2('ihr', 'seid / habt'), TableRow2('Sie/sie', 'sind / haben'),
      ]),
      TipSection(text: 'Verbs with stems ending in -t, -d add an extra \'e\' before -st and -t: du arbeit-e-st, er arbeit-e-t.', variant: TipVariant.warning),
      ExamplesSection(title: 'Beispiele', color: SectionColor.amber, items: [
        ExPair('Ich lerne Deutsch.', 'I am learning German.'),
        ExPair('Du arbeitest jeden Tag.', 'You work every day.'),
        ExPair('Er spricht Englisch.', 'He speaks English. (e→i change)'),
        ExPair('Wir gehen morgen ins Kino.', 'We\'re going to the cinema tomorrow.'),
      ]),
      ComparisonSection(title: 'Stammvokaländerungen', headers: ['Typ', 'Infinitiv', 'er/sie/es'], rows: [
        ComparisonRow(['e → i', 'sprechen', 'spricht']), ComparisonRow(['e → ie', 'lesen', 'liest']),
        ComparisonRow(['a → ä', 'fahren', 'fährt']),    ComparisonRow(['au → äu', 'laufen', 'läuft']),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'The verb always takes Position 2 in a statement.',
        'Stem-vowel changes only happen with du, er/sie/es.',
        'sein, haben, werden are fully irregular — memorize them.',
        'Präsens can express future if a time word is present: Morgen fahre ich.',
      ]),
    ],
  ),

  'g3': GrammarDetailData(
    id: 'g3', subtitle: 'Nebensätze · Konjunktionen', emoji: '🔗',
    gradient: const [Color(0xFF14B8A6), Color(0xFF06B6D4)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(
        title: 'Nebensätze · Subordinate Clauses',
        text: 'Subordinating conjunctions push the conjugated verb to the END of the clause. The subordinate clause is separated from the main clause by a comma.',
        bullets: ['weil = because', 'dass = that', 'wenn = when / if', 'obwohl = although', 'während = while', 'bevor = before', 'nachdem = after', 'als = when (past, single event)'],
      ),
      TransformSection(
        title: 'Hauptsatz → Nebensatz',
        from: FromToLabel(label: 'HAUPTSATZ', text: 'Ich arbeite in Berlin.'),
        to:   FromToLabel(label: 'NEBENSATZ', text: '..., weil ich in Berlin arbeite.'),
        note: 'The verb moves to the END in the subordinate clause',
      ),
      ExamplesSection(title: 'weil & dass', color: SectionColor.teal, items: [
        ExPair('Ich lerne Deutsch, weil ich in Berlin arbeite.', 'I learn German because I work in Berlin.'),
        ExPair('Sie sagt, dass sie morgen kommt.', 'She says that she\'s coming tomorrow.'),
        ExPair('Ich weiß, dass er krank ist.', 'I know that he is sick.'),
      ]),
      ExamplesSection(title: 'wenn, obwohl, als', color: SectionColor.cyan, items: [
        ExPair('Wenn es regnet, bleibe ich zu Hause.', 'When/If it rains, I stay home.'),
        ExPair('Obwohl er müde war, hat er weitergearbeitet.', 'Although he was tired, he kept working.'),
        ExPair('Als ich Kind war, lebte ich in Kabul.', 'When I was a child, I lived in Kabul.'),
      ]),
      TipSection(text: 'wenn = repeated events or future / als = single event in the past.', variant: TipVariant.warning),
      ExamplesSection(title: 'bevor, nachdem, während', color: SectionColor.emerald, items: [
        ExPair('Bevor ich esse, wasche ich mir die Hände.', 'Before I eat, I wash my hands.'),
        ExPair('Nachdem er gegessen hatte, ging er spazieren.', 'After he had eaten, he went for a walk.'),
        ExPair('Während sie lernt, hört sie Musik.', 'While she studies, she listens to music.'),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'Subordinating conjunctions → verb at the END.',
        'Always separate with a comma.',
        'If the Nebensatz comes FIRST, the main clause starts with the verb (inversion).',
        'With Perfekt: ...weil ich Deutsch gelernt habe. (habe at the very end)',
      ]),
    ],
  ),

  'g4': GrammarDetailData(
    id: 'g4', subtitle: 'Präpositionen · Wechselpräpositionen', emoji: '📍',
    gradient: const [Color(0xFFEC4899), Color(0xFFF43F5E)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(
        title: 'Wechselpräpositionen · Two-Way Prepositions',
        text: 'Nine prepositions can take EITHER Akkusativ or Dativ. Akkusativ = movement/direction (WOHIN?), Dativ = location/position (WO?).',
        bullets: ['an, auf, hinter, in, neben, über, unter, vor, zwischen', 'WO? (Dativ) → position, no movement', 'WOHIN? (Akkusativ) → direction, movement toward'],
      ),
      ConjugationSection(title: 'Die 9 Wechselpräpositionen', color: SectionColor.pink, rows: [
        TableRow2('an', 'at / on (vertical)'), TableRow2('auf', 'on (horizontal)'), TableRow2('hinter', 'behind'),
        TableRow2('in', 'in / into'), TableRow2('neben', 'next to'), TableRow2('über', 'over / above'),
        TableRow2('unter', 'under / below'), TableRow2('vor', 'in front of / before'), TableRow2('zwischen', 'between'),
      ]),
      TransformSection(
        title: 'Akkusativ (WOHIN?) vs. Dativ (WO?)',
        from: FromToLabel(label: 'WOHIN? → Akkusativ', text: 'Ich stelle das Buch auf den Tisch.'),
        to:   FromToLabel(label: 'WO? → Dativ',       text: 'Das Buch liegt auf dem Tisch.'),
        note: 'Movement → Akk. / Position → Dat.',
      ),
      ExamplesSection(title: 'Akkusativ (Bewegung → WOHIN?)', color: SectionColor.pink, items: [
        ExPair('Ich gehe in die Schule.', 'I go into the school.'),
        ExPair('Er hängt das Bild an die Wand.', 'He hangs the picture on the wall.'),
        ExPair('Sie legt das Buch auf den Tisch.', 'She puts the book on the table.'),
      ]),
      ExamplesSection(title: 'Dativ (Position → WO?)', color: SectionColor.rose, items: [
        ExPair('Er ist in der Schule.', 'He is in the school.'),
        ExPair('Das Bild hängt an der Wand.', 'The picture hangs on the wall.'),
        ExPair('Das Buch liegt auf dem Tisch.', 'The book lies on the table.'),
      ]),
      TipSection(text: 'stellen/legen (action, Akk.) vs. stehen/liegen (position, Dat.): Ich stelle die Vase auf den Tisch ↔ Die Vase steht auf dem Tisch.', variant: TipVariant.success),
      RulesSection(title: 'Wichtige Regeln', items: [
        'WOHIN? → Akkusativ (direction/movement).', 'WO? → Dativ (position/location).',
        'Contractions: in + dem = im, in + das = ins, an + dem = am.',
        'Action verbs (stellen, legen) → Akkusativ. Position verbs (stehen, liegen) → Dativ.',
      ]),
    ],
  ),

  'g5': GrammarDetailData(
    id: 'g5', subtitle: 'Zeiten · Vergangenheit', emoji: '⏰',
    gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(
        title: 'Das Perfekt · Present Perfect',
        text: 'Perfekt is the most common past tense in spoken German. It\'s formed with haben or sein + Partizip II. Most verbs use \'haben\'; verbs of motion and change of state use \'sein\'.',
        bullets: ['haben + Partizip II: Ich habe gelernt.', 'sein + Partizip II: Ich bin gefahren.', 'sein-verbs: movement (gehen, fahren) and change (werden)'],
      ),
      FormulaSection(label: 'Perfekt-Formel', formula: 'haben/sein (konj.) + ... + Partizip II', colors: [Color(0xFFF59E0B), Color(0xFFEA580C)]),
      ConjugationSection(title: 'Partizip II Bildung', color: SectionColor.amber, rows: [
        TableRow2('Regelmäßig', 'ge- + Stamm + -t: gemacht, gelernt'),
        TableRow2('Unregelmäßig', 'ge- + Stamm + -en: geschrieben, gefahren'),
        TableRow2('Trennbar', 'Präfix + ge + Stamm: ein-ge-kauft'),
        TableRow2('Untrennbar', 'KEIN ge-: verstanden, bekommen'),
        TableRow2('-ieren Verben', 'KEIN ge-: studiert, telefoniert'),
      ]),
      ExamplesSection(title: 'Mit haben', color: SectionColor.amber, items: [
        ExPair('Ich habe Deutsch gelernt.', 'I have learned German.'),
        ExPair('Wir haben einen Film gesehen.', 'We watched a film.'),
        ExPair('Sie hat das Buch gelesen.', 'She read the book.'),
      ]),
      ExamplesSection(title: 'Mit sein', color: SectionColor.orange, items: [
        ExPair('Sie ist nach Berlin gefahren.', 'She went to Berlin.'),
        ExPair('Er ist gestern angekommen.', 'He arrived yesterday.'),
        ExPair('Wir sind ins Kino gegangen.', 'We went to the cinema.'),
        ExPair('Das Kind ist eingeschlafen.', 'The child fell asleep.'),
      ]),
      TipSection(text: 'sein + bleiben, sein, werden also use \'sein\' in Perfekt: Ich bin geblieben, Ich bin gewesen.'),
      RulesSection(title: 'Wichtige Regeln', items: [
        'Auxiliary verb (haben/sein) sits in Position 2.',
        'Partizip II goes to the END of the sentence.',
        'sein-verbs: motion (gehen, fahren), change of state (werden), bleiben, sein.',
        'No ge- with: ver-, be-, emp-, ent-, and -ieren verbs.',
      ]),
    ],
  ),

  'g6': GrammarDetailData(
    id: 'g6', subtitle: 'Konjunktiv · Wünsche & Bitten', emoji: '💭',
    gradient: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(
        title: 'Konjunktiv II',
        text: 'Konjunktiv II expresses unreal/hypothetical situations, wishes, polite requests, and advice. For most verbs, use \'würde + Infinitiv\'. Key verbs have their own forms.',
        bullets: ['Wünsche: Ich wünschte, ich wäre reich.', 'Höfliche Bitten: Könnten Sie mir helfen?', 'Hypothetisch: Wenn ich Zeit hätte, ...', 'Ratschläge: An deiner Stelle würde ich ...'],
      ),
      ConjugationSection(title: 'Wichtige Konjunktiv II Formen', color: SectionColor.violet, rows: [
        TableRow2('sein', 'wäre'), TableRow2('haben', 'hätte'), TableRow2('können', 'könnte'),
        TableRow2('müssen', 'müsste'), TableRow2('dürfen', 'dürfte'), TableRow2('werden', 'würde'),
        TableRow2('wissen', 'wüsste'), TableRow2('kommen', 'käme'),
      ]),
      FormulaSection(label: 'Für die meisten Verben', formula: 'würde + Infinitiv', colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
      ExamplesSection(title: 'Wünsche & Hypothesen', color: SectionColor.violet, items: [
        ExPair('Wenn ich reich wäre, würde ich reisen.', 'If I were rich, I would travel.'),
        ExPair('Ich hätte gern mehr Freizeit.', 'I would like more free time.'),
        ExPair('Wenn ich du wäre, würde ich das nicht tun.', 'If I were you, I wouldn\'t do that.'),
      ]),
      ExamplesSection(title: 'Höfliche Bitten', color: SectionColor.indigo, items: [
        ExPair('Könnten Sie mir bitte helfen?', 'Could you please help me?'),
        ExPair('Würden Sie bitte das Fenster öffnen?', 'Would you please open the window?'),
        ExPair('Dürfte ich Sie etwas fragen?', 'Might I ask you something?'),
        ExPair('Ich hätte gern einen Kaffee.', 'I would like a coffee.'),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'Use Konjunktiv II forms for: sein, haben, modal verbs, wissen.',
        'For all other verbs: würde + Infinitiv.',
        'Wishes: Wenn ich nur ... hätte/wäre/könnte!',
        'Advice: An deiner/Ihrer Stelle würde ich ...',
        'Konjunktiv II makes requests much more polite than Indikativ.',
      ]),
    ],
  ),

  'g7': GrammarDetailData(
    id: 'g7', subtitle: 'Nebensätze · Relativsätze B1', emoji: '🔗',
    gradient: const [Color(0xFF6366F1), Color(0xFFA855F7)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(
        title: 'Relativsätze · Advanced',
        text: 'At B1 level, you learn relative clauses with prepositions and with genitive relative pronouns (dessen, deren).',
      ),
      ExamplesSection(title: 'Mit Präpositionen', color: SectionColor.indigo, items: [
        ExPair('Der Mann, mit dem ich gesprochen habe, ist Arzt.', 'The man with whom I spoke is a doctor.'),
        ExPair('Die Stadt, in der ich wohne, ist schön.', 'The city in which I live is beautiful.'),
        ExPair('Das Thema, über das wir sprechen, ist wichtig.', 'The topic about which we speak is important.'),
      ]),
      ExamplesSection(title: 'Genitiv: dessen & deren', color: SectionColor.violet, items: [
        ExPair('Der Mann, dessen Auto gestohlen wurde, ist verärgert.', 'The man whose car was stolen is upset.'),
        ExPair('Die Frau, deren Tochter ich kenne, heißt Maria.', 'The woman whose daughter I know is called Maria.'),
      ]),
      ComparisonSection(title: 'Relativpronomen Übersicht', headers: ['', 'Mask.', 'Fem.', 'Neut.', 'Plural'], rows: [
        ComparisonRow(['Nom.', 'der', 'die', 'das', 'die']),
        ComparisonRow(['Akk.', 'den', 'die', 'das', 'die']),
        ComparisonRow(['Dat.', 'dem', 'der', 'dem', 'denen']),
        ComparisonRow(['Gen.', 'dessen', 'deren', 'dessen', 'deren']),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Preposition + relative pronoun: use correct case for the preposition.',
        'Genitive relatives: dessen (m/n), deren (f/pl).',
        'Verb goes to the END in all relative clauses.',
        'Always separated by commas.',
      ]),
    ],
  ),

  'g9': GrammarDetailData(
    id: 'g9', subtitle: 'Satzbau · Grundstruktur', emoji: '🏗️',
    gradient: const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Wortstellung · Word Order',
        text: 'In German, the conjugated verb ALWAYS stands in Position 2 in a main clause (Hauptsatz). The subject can move, but the verb stays put.',
        bullets: ['Position 1: Subject or other element (time, place)', 'Position 2: Conjugated verb (ALWAYS!)', 'Position 3+: Other elements', 'End: Second part of verb (participle, infinitive, prefix)'],
      ),
      TransformSection(
        title: 'Verb in Position 2',
        from: FromToLabel(label: 'NORMAL',    text: 'Ich lerne heute Deutsch.'),
        to:   FromToLabel(label: 'INVERSION', text: 'Heute lerne ich Deutsch.'),
        note: 'When another element takes Position 1, subject moves after the verb',
      ),
      ExamplesSection(title: 'Aussagesätze (Statements)', color: SectionColor.cyan, items: [
        ExPair('Ich gehe morgen ins Kino.', 'I\'m going to the cinema tomorrow.'),
        ExPair('Morgen gehe ich ins Kino.', 'Tomorrow I\'m going to the cinema.'),
        ExPair('Im Kino sehe ich einen Film.', 'In the cinema I watch a film.'),
      ]),
      ExamplesSection(title: 'Ja/Nein-Fragen (Verb first!)', color: SectionColor.blue, items: [
        ExPair('Lernst du Deutsch?', 'Are you learning German?'),
        ExPair('Gehst du morgen ins Kino?', 'Are you going to the cinema tomorrow?'),
        ExPair('Ist das dein Buch?', 'Is that your book?'),
      ]),
      ExamplesSection(title: 'W-Fragen', color: SectionColor.indigo, items: [
        ExPair('Wer ist das?', 'Who is that?'),
        ExPair('Was machst du?', 'What are you doing?'),
        ExPair('Warum lernst du Deutsch?', 'Why are you learning German?'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Verb ALWAYS in Position 2 in main clauses.',
        'Yes/No questions → verb in Position 1.',
        'W-questions → W-word in Position 1, verb in Position 2.',
        'und, oder, aber, denn don\'t change word order.',
      ]),
    ],
  ),

  'g10': GrammarDetailData(
    id: 'g10', subtitle: 'Kasus · Fälle', emoji: '🎯',
    gradient: const [Color(0xFF8B5CF6), Color(0xFFA855F7)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Die vier Fälle · The Four Cases',
        text: 'German has four cases that change the form of articles, pronouns, and adjectives. Focus on Nominativ (subject) and Akkusativ (direct object) first.',
        bullets: ['Nominativ = WER? (who?) → the subject', 'Akkusativ = WEN? (whom?) → the direct object', 'Dativ = WEM? (to whom?) → the indirect object', 'Genitiv = WESSEN? (whose?) → possession'],
      ),
      ComparisonSection(title: 'Artikel in Nominativ & Akkusativ', headers: ['', 'Nominativ', 'Akkusativ'], rows: [
        ComparisonRow(['Maskulin', 'der / ein', 'den / einen']),
        ComparisonRow(['Feminin', 'die / eine', 'die / eine']),
        ComparisonRow(['Neutrum', 'das / ein', 'das / ein']),
        ComparisonRow(['Plural', 'die / –', 'die / –']),
      ]),
      TipSection(text: 'Only MASCULINE changes in the Akkusativ! der → den, ein → einen. Everything else stays the same.', variant: TipVariant.success),
      ExamplesSection(title: 'Nominativ (Subjekt)', color: SectionColor.violet, items: [
        ExPair('Der Mann liest.', 'The man reads. (WER liest?)'),
        ExPair('Die Frau kocht.', 'The woman cooks. (WER kocht?)'),
        ExPair('Das Kind spielt.', 'The child plays. (WER spielt?)'),
      ]),
      ExamplesSection(title: 'Akkusativ (Direktes Objekt)', color: SectionColor.purple, items: [
        ExPair('Ich sehe den Mann.', 'I see the man. (WEN sehe ich?)'),
        ExPair('Sie kauft einen Tisch.', 'She buys a table. (WEN kauft sie?)'),
        ExPair('Wir lesen das Buch.', 'We read the book. (WAS lesen wir?)'),
        ExPair('Er hat keine Zeit.', 'He has no time.'),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'Nominativ: answers WER? or WAS? — always the subject.',
        'Akkusativ: answers WEN? or WAS? — the direct object.',
        'Only masculine articles change: der→den, ein→einen, kein→keinen.',
        'Feminine, neuter, and plural stay the same in Akkusativ.',
        'Many verbs require Akkusativ: haben, sehen, kaufen, lesen, finden.',
      ]),
    ],
  ),

  'g11': GrammarDetailData(
    id: 'g11', subtitle: 'Pronomen · Grundlagen', emoji: '👤',
    gradient: const [Color(0xFF14B8A6), Color(0xFF10B981)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(title: 'Personalpronomen', text: 'Personal pronouns replace nouns. They change depending on the case. At A1, focus on Nominativ and Akkusativ forms.'),
      ComparisonSection(title: 'Personalpronomen Tabelle', headers: ['Person', 'Nominativ', 'Akkusativ'], rows: [
        ComparisonRow(['1. Sg.', 'ich', 'mich']), ComparisonRow(['2. Sg.', 'du', 'dich']),
        ComparisonRow(['3. Sg. m.', 'er', 'ihn']), ComparisonRow(['3. Sg. f.', 'sie', 'sie']),
        ComparisonRow(['3. Sg. n.', 'es', 'es']), ComparisonRow(['1. Pl.', 'wir', 'uns']),
        ComparisonRow(['2. Pl.', 'ihr', 'euch']), ComparisonRow(['3. Pl./formal', 'sie/Sie', 'sie/Sie']),
      ]),
      ExamplesSection(title: 'Possessivpronomen', color: SectionColor.teal, items: [
        ExPair('Das ist mein Buch.', 'That is my book.'),
        ExPair('Wo ist dein Schlüssel?', 'Where is your key?'),
        ExPair('Sein Auto ist neu.', 'His car is new.'),
        ExPair('Ihre Tasche ist groß.', 'Her/Their bag is big.'),
      ]),
      ConjugationSection(title: 'Possessivpronomen Übersicht', color: SectionColor.emerald, rows: [
        TableRow2('ich', 'mein'), TableRow2('du', 'dein'), TableRow2('er/es', 'sein'),
        TableRow2('sie', 'ihr'), TableRow2('wir', 'unser'), TableRow2('ihr', 'euer'), TableRow2('sie/Sie', 'ihr/Ihr'),
      ]),
      TipSection(text: 'Possessive pronouns take the SAME endings as \'ein/kein\': mein Tisch (m.), meine Lampe (f.), mein Buch (n.).'),
      RulesSection(title: 'Merke dir!', items: [
        'Personal pronouns change with case — learn Nominativ and Akkusativ first.',
        'Possessive pronouns agree with the NOUN they modify, not the owner.',
        'Interrogative pronouns: Wer? (who/Nom), Wen? (whom/Akk), Was? (what).',
        '\'Sie\' (capital) = formal you, \'sie\' (lowercase) = she or they.',
      ]),
    ],
  ),

  'g12': GrammarDetailData(
    id: 'g12', subtitle: 'Verben · Modalverben', emoji: '🔧',
    gradient: const [Color(0xFFF43F5E), Color(0xFFEC4899)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Modalverben · Modal Verbs',
        text: 'Modal verbs express ability, permission, obligation, or desire. They are used with a second verb in the infinitive, which goes to the END of the sentence.',
        bullets: ['können = can, be able to', 'müssen = must, have to', 'wollen = want to', 'sollen = should, supposed to', 'dürfen = may, be allowed to', 'möchten = would like to'],
      ),
      FormulaSection(label: 'Satzstruktur', formula: 'Subjekt + Modalverb (konj.) + ... + Infinitiv', colors: [Color(0xFFF43F5E), Color(0xFFEC4899)]),
      ConjugationSection(title: 'können / müssen / wollen', color: SectionColor.rose, rows: [
        TableRow2('ich', 'kann / muss / will'), TableRow2('du', 'kannst / musst / willst'),
        TableRow2('er/sie/es', 'kann / muss / will'), TableRow2('wir', 'können / müssen / wollen'),
        TableRow2('ihr', 'könnt / müsst / wollt'), TableRow2('Sie/sie', 'können / müssen / wollen'),
      ]),
      TipSection(text: 'Modal verbs have NO ending for ich and er/sie/es in Präsens: ich kann, er muss, sie will.', variant: TipVariant.warning),
      ExamplesSection(title: 'Beispiele', color: SectionColor.pink, items: [
        ExPair('Ich kann Deutsch sprechen.', 'I can speak German.'),
        ExPair('Du musst morgen arbeiten.', 'You must work tomorrow.'),
        ExPair('Sie will nach Berlin fahren.', 'She wants to go to Berlin.'),
        ExPair('Darf ich hier rauchen?', 'May I smoke here?'),
        ExPair('Ich möchte einen Kaffee.', 'I would like a coffee.'),
      ]),
      RulesSection(title: 'Wichtige Regeln', items: [
        'The modal verb is conjugated and sits in Position 2.',
        'The main verb stays in the INFINITIVE at the END of the sentence.',
        'ich and er/sie/es have the SAME form (no ending).',
        'möchten is Konjunktiv II of mögen — used as a polite modal.',
      ]),
    ],
  ),

  'g13': GrammarDetailData(
    id: 'g13', subtitle: 'Verben · Trennbare Verben', emoji: '✂️',
    gradient: const [Color(0xFF22C55E), Color(0xFF10B981)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Trennbare Verben · Separable Verbs',
        text: 'Many German verbs have a separable prefix that detaches and goes to the END of the sentence in Präsens and Imperativ.',
        bullets: ['Common prefixes: ab-, an-, auf-, aus-, ein-, mit-, vor-, zu-, zurück-', 'The prefix carries meaning and changes the verb\'s definition', 'In Perfekt: ge- goes BETWEEN prefix and stem: auf-ge-standen'],
      ),
      TransformSection(
        title: 'Wie funktioniert es?',
        from: FromToLabel(label: 'INFINITIV', text: 'aufstehen (to get up)'),
        to:   FromToLabel(label: 'PRÄSENS',   text: 'Ich stehe um 7 Uhr auf.'),
        note: 'Prefix \'auf\' goes to the end of the clause',
      ),
      ExamplesSection(title: 'Beispiele im Präsens', color: SectionColor.green, items: [
        ExPair('Ich stehe um 7 Uhr auf.', 'I get up at 7 o\'clock. (aufstehen)'),
        ExPair('Sie kauft im Supermarkt ein.', 'She shops at the supermarket. (einkaufen)'),
        ExPair('Der Zug kommt um 10 Uhr an.', 'The train arrives at 10. (ankommen)'),
        ExPair('Er ruft mich morgen an.', 'He calls me tomorrow. (anrufen)'),
      ]),
      ExamplesSection(title: 'Im Perfekt (ge- in der Mitte!)', color: SectionColor.emerald, items: [
        ExPair('Ich bin um 7 Uhr aufgestanden.', 'I got up at 7 o\'clock.'),
        ExPair('Sie hat im Supermarkt eingekauft.', 'She shopped at the supermarket.'),
        ExPair('Der Zug ist angekommen.', 'The train has arrived.'),
      ]),
      TipSection(text: 'Inseparable prefixes (be-, emp-, ent-, er-, ge-, miss-, ver-, zer-) NEVER separate and have NO ge- in Partizip II.', variant: TipVariant.warning),
      RulesSection(title: 'Merke dir!', items: [
        'Separable prefixes are stressed: ÁNrufen, ÁUFstehen.',
        'With modal verbs, the verb stays together: Ich muss aufstehen.',
        'In subordinate clauses: …weil ich aufstehe.',
        'Perfekt: prefix + ge + stem + t/en: ein-ge-kauft, auf-ge-standen.',
      ]),
    ],
  ),

  'g14': GrammarDetailData(
    id: 'g14', subtitle: 'Präpositionen · A1', emoji: '📍',
    gradient: const [Color(0xFFEC4899), Color(0xFFF43F5E)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(title: 'Präpositionen mit festem Kasus', text: 'German prepositions require a specific case. Learn two groups: those that always take Akkusativ and those that always take Dativ.'),
      ConjugationSection(title: 'Akkusativ-Präpositionen', color: SectionColor.pink, rows: [
        TableRow2('durch', 'through'), TableRow2('für', 'for'), TableRow2('ohne', 'without'),
        TableRow2('gegen', 'against'), TableRow2('um', 'around / at (time)'),
      ]),
      ConjugationSection(title: 'Dativ-Präpositionen', color: SectionColor.rose, rows: [
        TableRow2('mit', 'with'), TableRow2('nach', 'to / after'), TableRow2('aus', 'from / out of'),
        TableRow2('bei', 'at / near'), TableRow2('von', 'from / of'), TableRow2('zu', 'to'), TableRow2('seit', 'since / for'),
      ]),
      ExamplesSection(title: 'Mit Akkusativ', color: SectionColor.pink, items: [
        ExPair('Ich gehe durch den Park.', 'I walk through the park.'),
        ExPair('Das Geschenk ist für dich.', 'The gift is for you.'),
        ExPair('Ohne meinen Schlüssel kann ich nicht rein.', 'Without my key I can\'t get in.'),
      ]),
      ExamplesSection(title: 'Mit Dativ', color: SectionColor.rose, items: [
        ExPair('Ich fahre mit dem Bus.', 'I go by bus.'),
        ExPair('Sie kommt aus der Türkei.', 'She comes from Turkey.'),
        ExPair('Nach dem Essen gehen wir spazieren.', 'After dinner we go for a walk.'),
      ]),
      TipSection(text: 'Mnemonic for Akkusativ: DOGFU (Durch, Ohne, Gegen, Für, Um). For Dativ: mit nach bei seit von zu aus.', variant: TipVariant.success),
      RulesSection(title: 'Merke dir!', items: [
        'Akkusativ prepositions: durch, für, ohne, gegen, um.',
        'Dativ prepositions: mit, nach, aus, bei, von, zu, seit.',
        'Contractions: zu + dem = zum, zu + der = zur, bei + dem = beim.',
      ]),
    ],
  ),

  'g15': GrammarDetailData(
    id: 'g15', subtitle: 'Adjektive · Grundlagen', emoji: '🎨',
    gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(
        title: 'Prädikative vs. Attributive Adjektive',
        text: 'Adjectives after sein/werden (predicate) have NO ending. Adjectives placed BEFORE a noun (attributive) must take an ending matching gender, case, and article.',
        bullets: ['Prädikativ: Das Auto ist schnell. (no ending)', 'Attributiv: Das schnellE Auto fährt. (with ending)'],
      ),
      ExamplesSection(title: 'Prädikative Adjektive (kein Endung)', color: SectionColor.indigo, items: [
        ExPair('Das Buch ist interessant.', 'The book is interesting.'),
        ExPair('Der Film war gut.', 'The film was good.'),
        ExPair('Die Blumen sind schön.', 'The flowers are beautiful.'),
      ]),
      ComparisonSection(title: 'Adjektivendungen nach bestimmtem Artikel', headers: ['Kasus', 'Maskulin', 'Feminin', 'Neutrum'], rows: [
        ComparisonRow(['Nominativ', 'der alt-e Mann', 'die alt-e Frau', 'das alt-e Kind']),
        ComparisonRow(['Akkusativ', 'den alt-en Mann', 'die alt-e Frau', 'das alt-e Kind']),
      ]),
      ExamplesSection(title: 'Attributive Adjektive', color: SectionColor.violet, items: [
        ExPair('Der große Mann arbeitet hier.', 'The tall man works here.'),
        ExPair('Ich lese ein interessantes Buch.', 'I\'m reading an interesting book.'),
        ExPair('Sie hat eine neue Tasche.', 'She has a new bag.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'After sein, werden, bleiben → NO ending: Das Haus ist groß.',
        'Before a noun → ALWAYS an ending: ein großES Haus.',
        'After der/die/das → mostly -e or -en.',
        'After ein → adjective shows the gender: ein großER Mann, ein großES Kind.',
      ]),
    ],
  ),

  'g16': GrammarDetailData(
    id: 'g16', subtitle: 'Zeiten · Präteritum', emoji: '📜',
    gradient: const [Color(0xFF78716C), Color(0xFF57534E)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(
        title: 'Das Präteritum · Simple Past',
        text: 'Präteritum is used mainly in written German. In spoken language, only sein, haben, and modal verbs are commonly used in Präteritum.',
        bullets: ['Regular verbs: stem + -te, -test, -te, -ten, -tet, -ten', 'Irregular verbs: stem change + no ending for ich/er', 'Mixed verbs: stem change + -te endings (bringen → brachte)'],
      ),
      ConjugationSection(title: 'sein & haben im Präteritum', color: SectionColor.stone, rows: [
        TableRow2('ich', 'war / hatte'), TableRow2('du', 'warst / hattest'), TableRow2('er/sie/es', 'war / hatte'),
        TableRow2('wir', 'waren / hatten'), TableRow2('ihr', 'wart / hattet'), TableRow2('Sie/sie', 'waren / hatten'),
      ]),
      ConjugationSection(title: 'Modalverben im Präteritum', color: SectionColor.amber, rows: [
        TableRow2('können', 'konnte'), TableRow2('müssen', 'musste'), TableRow2('wollen', 'wollte'),
        TableRow2('sollen', 'sollte'), TableRow2('dürfen', 'durfte'), TableRow2('mögen', 'mochte'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.stone, items: [
        ExPair('Ich war gestern in Berlin.', 'I was in Berlin yesterday.'),
        ExPair('Er hatte keine Zeit.', 'He had no time.'),
        ExPair('Sie konnte nicht kommen.', 'She couldn\'t come.'),
        ExPair('Der König lebte in einem Schloss.', 'The king lived in a castle. (narrative)'),
      ]),
      ComparisonSection(title: 'Perfekt vs. Präteritum', headers: ['Perfekt (gesprochen)', 'Präteritum (geschrieben)'], rows: [
        ComparisonRow(['Ich habe gelernt.', 'Ich lernte.']), ComparisonRow(['Er ist gegangen.', 'Er ging.']),
        ComparisonRow(['Sie hat gesagt.', 'Sie sagte.']),   ComparisonRow(['Ich bin gewesen.', 'Ich war.']),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'In speech: use Präteritum only for sein, haben, and modals.',
        'In writing (stories, news): Präteritum is standard.',
        'Regular: Stamm + -te (machte, lernte).',
        'Modal verbs lose their Umlaut in Präteritum: können → konnte.',
      ]),
    ],
  ),

  'g17': GrammarDetailData(
    id: 'g17', subtitle: 'Zeiten · Futur I', emoji: '🔮',
    gradient: const [Color(0xFF0EA5E9), Color(0xFF3B82F6)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Futur I · Future Tense', text: 'Futur I is formed with \'werden\' + Infinitiv. It expresses future plans, predictions, and assumptions. Often Präsens + time word is used instead.'),
      FormulaSection(label: 'Formel', formula: 'werden (konj.) + ... + Infinitiv', colors: [Color(0xFF0EA5E9), Color(0xFF3B82F6)]),
      ConjugationSection(title: 'werden konjugiert', color: SectionColor.sky, rows: [
        TableRow2('ich', 'werde'), TableRow2('du', 'wirst'), TableRow2('er/sie/es', 'wird'),
        TableRow2('wir', 'werden'), TableRow2('ihr', 'werdet'), TableRow2('Sie/sie', 'werden'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.sky, items: [
        ExPair('Ich werde morgen nach Berlin fahren.', 'I will go to Berlin tomorrow.'),
        ExPair('Es wird regnen.', 'It will rain.'),
        ExPair('Sie wird Ärztin werden.', 'She will become a doctor.'),
      ]),
      TipSection(text: 'In everyday speech, Präsens + time word is preferred: \'Ich fahre morgen\' instead of \'Ich werde morgen fahren\'.'),
      RulesSection(title: 'Merke dir!', items: [
        'werden sits in Position 2, infinitive goes to the END.',
        'Used for: future plans, predictions, promises, assumptions.',
        'With \'wohl\' or \'wahrscheinlich\' → assumption: Er wird wohl kommen.',
      ]),
    ],
  ),

  'g18': GrammarDetailData(
    id: 'g18', subtitle: 'Nebensätze · Relativsätze', emoji: '🔗',
    gradient: const [Color(0xFF6366F1), Color(0xFF3B82F6)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Relativsätze · Relative Clauses', text: 'Relative clauses give additional information about a noun. The relative pronoun agrees in gender and number with the noun, but its case depends on its role in the relative clause.'),
      ComparisonSection(title: 'Relativpronomen', headers: ['', 'Maskulin', 'Feminin', 'Neutrum', 'Plural'], rows: [
        ComparisonRow(['Nom.', 'der', 'die', 'das', 'die']),
        ComparisonRow(['Akk.', 'den', 'die', 'das', 'die']),
        ComparisonRow(['Dat.', 'dem', 'der', 'dem', 'denen']),
      ]),
      ExamplesSection(title: 'Nominativ Relativsätze', color: SectionColor.indigo, items: [
        ExPair('Der Mann, der dort steht, ist mein Chef.', 'The man who stands there is my boss.'),
        ExPair('Die Frau, die dort arbeitet, ist nett.', 'The woman who works there is nice.'),
        ExPair('Das Kind, das spielt, ist mein Sohn.', 'The child who is playing is my son.'),
      ]),
      ExamplesSection(title: 'Akkusativ Relativsätze', color: SectionColor.blue, items: [
        ExPair('Der Mann, den ich kenne, heißt Peter.', 'The man whom I know is called Peter.'),
        ExPair('Die Frau, die ich gesehen habe, ist Ärztin.', 'The woman whom I saw is a doctor.'),
        ExPair('Das Buch, das ich lese, ist spannend.', 'The book that I\'m reading is exciting.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Gender/number: matches the noun it refers to.',
        'Case: determined by the role inside the relative clause.',
        'Verb goes to the END of the relative clause.',
        'Always separated by commas.',
      ]),
    ],
  ),

  'g19': GrammarDetailData(
    id: 'g19', subtitle: 'Infinitivkonstruktionen', emoji: '🔄',
    gradient: const [Color(0xFF84CC16), Color(0xFF22C55E)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Infinitiv mit zu', text: 'Infinitive constructions with \'zu\' are used after certain verbs, adjectives, and nouns. Special forms: um...zu (purpose), ohne...zu (without doing), anstatt...zu (instead of doing).'),
      ExamplesSection(title: 'zu + Infinitiv', color: SectionColor.lime, items: [
        ExPair('Ich versuche, Deutsch zu lernen.', 'I try to learn German.'),
        ExPair('Es ist wichtig, pünktlich zu kommen.', 'It is important to come on time.'),
        ExPair('Ich habe keine Lust, aufzuräumen.', 'I don\'t feel like cleaning up.'),
      ]),
      ExamplesSection(title: 'um ... zu (Zweck / Purpose)', color: SectionColor.green, items: [
        ExPair('Ich lerne Deutsch, um in Berlin zu arbeiten.', 'I learn German in order to work in Berlin.'),
        ExPair('Er fährt nach München, um seine Freunde zu besuchen.', 'He drives to Munich to visit his friends.'),
      ]),
      ExamplesSection(title: 'ohne ... zu / anstatt ... zu', color: SectionColor.emerald, items: [
        ExPair('Er ging, ohne etwas zu sagen.', 'He left without saying anything.'),
        ExPair('Anstatt zu lernen, spielt sie am Handy.', 'Instead of studying, she plays on her phone.'),
      ]),
      TipSection(text: 'With separable verbs, \'zu\' goes BETWEEN the prefix and the verb: auf-zu-räumen, ein-zu-kaufen, an-zu-fangen.', variant: TipVariant.warning),
      RulesSection(title: 'Merke dir!', items: [
        'zu + Infinitiv always goes to the END.',
        'um...zu = in order to (purpose).',
        'ohne...zu = without doing. anstatt...zu = instead of doing.',
        'Separable verbs: zu goes in the middle: auf-zu-stehen.',
      ]),
    ],
  ),

  'g20': GrammarDetailData(
    id: 'g20', subtitle: 'Adjektive · Deklination', emoji: '🎨',
    gradient: const [Color(0xFFD946EF), Color(0xFFEC4899)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Adjektivdeklination · Adjective Declension', text: 'When an adjective comes BEFORE a noun, it gets an ending. The ending depends on: 1) the type of article (definite, indefinite, or none), 2) the gender, 3) the case.'),
      ComparisonSection(title: 'Nach bestimmtem Artikel (der/die/das)', headers: ['Kasus', 'Maskulin', 'Feminin', 'Neutrum', 'Plural'], rows: [
        ComparisonRow(['Nom.', 'der alt-e', 'die alt-e', 'das alt-e', 'die alt-en']),
        ComparisonRow(['Akk.', 'den alt-en', 'die alt-e', 'das alt-e', 'die alt-en']),
        ComparisonRow(['Dat.', 'dem alt-en', 'der alt-en', 'dem alt-en', 'den alt-en']),
      ]),
      ComparisonSection(title: 'Nach unbestimmtem Artikel (ein/eine)', headers: ['Kasus', 'Maskulin', 'Feminin', 'Neutrum'], rows: [
        ComparisonRow(['Nom.', 'ein alt-er', 'eine alt-e', 'ein alt-es']),
        ComparisonRow(['Akk.', 'einen alt-en', 'eine alt-e', 'ein alt-es']),
        ComparisonRow(['Dat.', 'einem alt-en', 'einer alt-en', 'einem alt-en']),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.fuchsia, items: [
        ExPair('Der neue Kollege ist nett.', 'The new colleague is nice.'),
        ExPair('Ich kaufe einen roten Pullover.', 'I buy a red sweater.'),
        ExPair('Sie arbeitet in einem großen Büro.', 'She works in a big office.'),
        ExPair('Die alten Bücher sind interessant.', 'The old books are interesting.'),
      ]),
      TipSection(text: 'The SIGNAL (strong ending showing gender) must appear somewhere — either on the article or the adjective.', variant: TipVariant.success),
      RulesSection(title: 'Merke dir!', items: [
        'After der/die/das → mostly -e (Nom.) or -en (other cases).',
        'After ein → adjective shows gender: ein großER Mann, ein großES Kind.',
        'After kein/possessives → same as ein.',
        'Dativ plural: always -en everywhere.',
      ]),
    ],
  ),

  'g21': GrammarDetailData(
    id: 'g21', subtitle: 'Adjektive · Steigerung', emoji: '📊',
    gradient: const [Color(0xFFF97316), Color(0xFFEF4444)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Komparativ & Superlativ', text: 'German comparatives add -er to the adjective, superlatives add -(e)sten. Many common adjectives also get an Umlaut (a→ä, o→ö, u→ü).', bullets: ['Komparativ: Adjektiv + -er (+ als)', 'Superlativ: am + Adjektiv + -sten', 'Gleichheit: genauso ... wie / nicht so ... wie']),
      ConjugationSection(title: 'Regelmäßige Steigerung', color: SectionColor.orange, rows: [
        TableRow2('schnell', 'schneller / am schnellsten'), TableRow2('klein', 'kleiner / am kleinsten'), TableRow2('billig', 'billiger / am billigsten'),
      ]),
      ConjugationSection(title: 'Mit Umlaut', color: SectionColor.red, rows: [
        TableRow2('alt', 'älter / am ältesten'), TableRow2('groß', 'größer / am größten'),
        TableRow2('jung', 'jünger / am jüngsten'), TableRow2('kalt', 'kälter / am kältesten'),
      ]),
      ConjugationSection(title: 'Unregelmäßig', color: SectionColor.amber, rows: [
        TableRow2('gut', 'besser / am besten'), TableRow2('viel', 'mehr / am meisten'),
        TableRow2('gern', 'lieber / am liebsten'), TableRow2('hoch', 'höher / am höchsten'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.orange, items: [
        ExPair('Berlin ist größer als München.', 'Berlin is bigger than Munich.'),
        ExPair('Deutsch ist genauso schwer wie Französisch.', 'German is just as hard as French.'),
        ExPair('Das ist das beste Restaurant in der Stadt.', 'That is the best restaurant in the city.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Komparativ: + er, Superlativ: am + sten.', 'One-syllable adjectives often get Umlaut: alt → älter.',
        'als = than (comparison), wie = as (equality).', 'Irregular: gut-besser-best, viel-mehr-meist.',
      ]),
    ],
  ),

  'g22': GrammarDetailData(
    id: 'g22', subtitle: 'Verben · Reflexive Verben', emoji: '🪞',
    gradient: const [Color(0xFF06B6D4), Color(0xFF14B8A6)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Reflexive Verben', text: 'Reflexive verbs have a pronoun that refers back to the subject. The reflexive pronoun can be in the Akkusativ or Dativ, depending on the verb.'),
      ComparisonSection(title: 'Reflexivpronomen', headers: ['Person', 'Akkusativ', 'Dativ'], rows: [
        ComparisonRow(['ich', 'mich', 'mir']), ComparisonRow(['du', 'dich', 'dir']),
        ComparisonRow(['er/sie/es', 'sich', 'sich']), ComparisonRow(['wir', 'uns', 'uns']),
        ComparisonRow(['ihr', 'euch', 'euch']), ComparisonRow(['sie/Sie', 'sich', 'sich']),
      ]),
      ExamplesSection(title: 'Akkusativ-Reflexiv', color: SectionColor.cyan, items: [
        ExPair('Ich freue mich auf die Ferien.', 'I look forward to the holidays.'),
        ExPair('Er setzt sich auf den Stuhl.', 'He sits down on the chair.'),
        ExPair('Wir interessieren uns für Kunst.', 'We are interested in art.'),
      ]),
      ExamplesSection(title: 'Dativ-Reflexiv', color: SectionColor.teal, items: [
        ExPair('Ich wasche mir die Hände.', 'I wash my hands.'),
        ExPair('Kannst du dir das vorstellen?', 'Can you imagine that?'),
        ExPair('Er merkt sich das Wort.', 'He memorizes the word.'),
      ]),
      TipSection(text: 'Use Dativ reflexive when there\'s ALSO a direct object (Akkusativ): \'Ich wasche MICH\' vs. \'Ich wasche MIR die Hände\'.'),
      RulesSection(title: 'Merke dir!', items: [
        '3rd person reflexive is always \'sich\' (Akk. and Dat.).',
        'If the sentence has another Akk. object, the reflexive is Dativ.',
        'Common reflexive verbs: sich freuen, sich setzen, sich interessieren, sich fühlen.',
      ]),
    ],
  ),

  'g23': GrammarDetailData(
    id: 'g23', subtitle: 'Pronomen · Indefinitpronomen', emoji: '❓',
    gradient: const [Color(0xFF64748B), Color(0xFF475569)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Indefinitpronomen', text: 'Indefinite pronouns refer to unspecified people or things. They are essential for everyday conversation.'),
      ConjugationSection(title: 'Übersicht', color: SectionColor.slate, rows: [
        TableRow2('man', 'one / people (general)'), TableRow2('jemand', 'someone'), TableRow2('niemand', 'no one'),
        TableRow2('etwas', 'something'), TableRow2('nichts', 'nothing'), TableRow2('alle', 'all / everyone'),
        TableRow2('viele', 'many'), TableRow2('einige', 'some'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.slate, items: [
        ExPair('Man spricht hier Deutsch.', 'People speak German here.'),
        ExPair('Jemand hat angerufen.', 'Someone called.'),
        ExPair('Niemand war zu Hause.', 'No one was home.'),
        ExPair('Ich habe etwas für dich.', 'I have something for you.'),
        ExPair('Alle sind eingeladen.', 'Everyone is invited.'),
      ]),
      TipSection(text: '\'man\' always uses 3rd person singular: Man MUSS das lernen. It is NOT the same as \'Mann\' (man)!', variant: TipVariant.warning),
      RulesSection(title: 'Merke dir!', items: [
        'man → 3rd person singular, used for general statements.',
        'etwas/nichts are invariable (no declension).',
        'alle + plural verb, viele/einige + plural verb.',
      ]),
    ],
  ),

  'g24': GrammarDetailData(
    id: 'g24', subtitle: 'Zeiten · Plusquamperfekt', emoji: '⏪',
    gradient: const [Color(0xFFD97706), Color(0xFFA16207)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Das Plusquamperfekt · Past Perfect', text: 'The Plusquamperfekt describes an action that happened BEFORE another past action. It\'s formed with hatte/war + Partizip II.'),
      FormulaSection(label: 'Formel', formula: 'hatte/war (Präteritum) + ... + Partizip II', colors: [Color(0xFFD97706), Color(0xFFA16207)]),
      TransformSection(
        title: 'Zeitfolge · Sequence of Events',
        from: FromToLabel(label: 'ZUERST (Plusquamperfekt)', text: 'Nachdem er gegessen hatte, ...'),
        to:   FromToLabel(label: 'DANN (Präteritum/Perfekt)',  text: '... ging er spazieren.'),
        note: 'Plusquamperfekt = the earlier action',
      ),
      ExamplesSection(title: 'Beispiele', color: SectionColor.amber, items: [
        ExPair('Nachdem ich gegessen hatte, ging ich spazieren.', 'After I had eaten, I went for a walk.'),
        ExPair('Er war schon gegangen, als ich ankam.', 'He had already left when I arrived.'),
        ExPair('Sie hatte das Buch gelesen, bevor sie den Film sah.', 'She had read the book before she saw the film.'),
      ]),
      TipSection(text: 'Plusquamperfekt is almost always used with \'nachdem\'. After \'nachdem\' → Plusquamperfekt in subordinate clause.'),
      RulesSection(title: 'Merke dir!', items: [
        'hatte (for haben-verbs) / war (for sein-verbs) + Partizip II.',
        'Used for the EARLIER of two past events.',
        'Same Partizip II as Perfekt — only the auxiliary changes to Präteritum.',
      ]),
    ],
  ),

  'g25': GrammarDetailData(
    id: 'g25', subtitle: 'Zeiten · Futur I & II', emoji: '🔮',
    gradient: const [Color(0xFF0EA5E9), Color(0xFF6366F1)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Futur I & Futur II', text: 'Futur I (werden + Infinitiv) expresses future events. Futur II (werden + Partizip II + haben/sein) expresses something completed by a future point, or assumptions about the past.'),
      FormulaSection(label: 'Futur I',  formula: 'werden (konj.) + Infinitiv',                  colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)]),
      FormulaSection(label: 'Futur II', formula: 'werden (konj.) + Partizip II + haben/sein',    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
      ExamplesSection(title: 'Futur I', color: SectionColor.sky, items: [
        ExPair('Ich werde morgen kommen.', 'I will come tomorrow.'),
        ExPair('Es wird wohl regnen.', 'It will probably rain.'),
      ]),
      ExamplesSection(title: 'Futur II', color: SectionColor.indigo, items: [
        ExPair('Bis morgen werde ich das Buch gelesen haben.', 'By tomorrow I will have read the book.'),
        ExPair('Er wird wohl schon gegangen sein.', 'He will probably have already left.'),
      ]),
      TipSection(text: 'Futur II with \'wohl\' = assumption about the past: \'Er wird das vergessen haben\' = He has probably forgotten that.'),
      RulesSection(title: 'Merke dir!', items: [
        'Futur I: werden + Infinitiv → future or assumption.',
        'Futur II: werden + P.II + haben/sein → completed future or past assumption.',
        'With \'wohl\', \'wahrscheinlich\' → assumption, not future.',
      ]),
    ],
  ),

  'g26': GrammarDetailData(
    id: 'g26', subtitle: 'Nebensätze · Erweitert', emoji: '🔗',
    gradient: const [Color(0xFF14B8A6), Color(0xFF10B981)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Erweiterte Nebensätze · B1', text: 'At B1 level, new subordinating conjunctions for purpose, result, condition, and time.', bullets: ['damit = so that (different subject)', 'sodass = so that (result)', 'falls = in case / if', 'seitdem = since (time)', 'solange = as long as', 'sobald = as soon as', 'je ... desto = the more ... the more']),
      ExamplesSection(title: 'damit & sodass', color: SectionColor.teal, items: [
        ExPair('Ich erkläre es langsam, damit du es verstehst.', 'I explain it slowly so that you understand.'),
        ExPair('Er war so müde, sodass er sofort einschlief.', 'He was so tired that he fell asleep immediately.'),
      ]),
      TipSection(text: '\'damit\' (different subjects) vs. \'um...zu\' (same subject): Ich erkläre es, damit du es verstehst vs. Ich lerne, um die Prüfung zu bestehen.', variant: TipVariant.warning),
      ExamplesSection(title: 'falls, seitdem, solange, sobald', color: SectionColor.emerald, items: [
        ExPair('Falls es regnet, bleiben wir zu Hause.', 'In case it rains, we\'ll stay home.'),
        ExPair('Seitdem er hier arbeitet, ist er glücklicher.', 'Since he works here, he\'s happier.'),
        ExPair('Sobald er ankommt, rufe ich dich an.', 'As soon as he arrives, I\'ll call you.'),
      ]),
      ExamplesSection(title: 'je ... desto / je ... umso', color: SectionColor.cyan, items: [
        ExPair('Je mehr ich lerne, desto besser verstehe ich.', 'The more I learn, the better I understand.'),
        ExPair('Je schneller du fährst, desto gefährlicher ist es.', 'The faster you drive, the more dangerous it is.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'All subordinating conjunctions → verb at the END.',
        'damit vs. um...zu: different subjects → damit, same subject → um...zu.',
        'je + Komparativ ..., desto/umso + Komparativ + Verb.',
      ]),
    ],
  ),

  'g27': GrammarDetailData(
    id: 'g27', subtitle: 'Konditionalsätze', emoji: '🔀',
    gradient: const [Color(0xFF8B5CF6), Color(0xFFA855F7)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Konditionalsätze · Conditional Sentences', text: 'Real conditions (possible situations, use Präsens or Futur) vs. unreal conditions (hypothetical, use Konjunktiv II).'),
      ExamplesSection(title: 'Reale Bedingungen (Indikativ)', color: SectionColor.violet, items: [
        ExPair('Wenn es regnet, bleibe ich zu Hause.', 'If it rains, I stay home.'),
        ExPair('Wenn du willst, können wir gehen.', 'If you want, we can go.'),
        ExPair('Falls er kommt, sag mir Bescheid.', 'If he comes, let me know.'),
      ]),
      ExamplesSection(title: 'Irreale Bedingungen (Konjunktiv II)', color: SectionColor.purple, items: [
        ExPair('Wenn ich reich wäre, würde ich reisen.', 'If I were rich, I would travel.'),
        ExPair('Wenn ich Zeit hätte, würde ich dir helfen.', 'If I had time, I would help you.'),
        ExPair('Wenn er Deutsch könnte, würde er in Berlin arbeiten.', 'If he could speak German, he would work in Berlin.'),
      ]),
      ComparisonSection(title: 'Real vs. Irreal', headers: ['', 'Real (möglich)', 'Irreal (hypothetisch)'], rows: [
        ComparisonRow(['Verb', 'Indikativ', 'Konjunktiv II']),
        ComparisonRow(['wenn-Satz', 'Wenn es regnet, ...', 'Wenn es regnen würde, ...']),
        ComparisonRow(['Hauptsatz', '... bleibe ich zu Hause.', '... würde ich zu Hause bleiben.']),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Real: wenn + Indikativ → possible, might happen.',
        'Irreal: wenn + Konjunktiv II → hypothetical, not real.',
        'Common Konj. II forms: wäre, hätte, könnte, müsste, würde.',
      ]),
    ],
  ),

  'g28': GrammarDetailData(
    id: 'g28', subtitle: 'Partizipien als Adjektive', emoji: '🧩',
    gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Partizip I & II als Adjektive', text: 'Partizip I (present) describes ongoing actions, Partizip II describes completed actions. Both can be used as adjectives before nouns, taking regular adjective endings.',
        bullets: ['Partizip I: Infinitiv + -d → lachend, schlafend', 'Partizip II: gelernt, geschrieben, gefahren', 'Both take normal adjective endings when used before a noun'],
      ),
      ExamplesSection(title: 'Partizip I als Adjektiv', color: SectionColor.indigo, items: [
        ExPair('der lachende Mann', 'the laughing man'),
        ExPair('das schlafende Kind', 'the sleeping child'),
        ExPair('die weinende Frau', 'the crying woman'),
      ]),
      ExamplesSection(title: 'Partizip II als Adjektiv', color: SectionColor.violet, items: [
        ExPair('die geöffnete Tür', 'the opened door'),
        ExPair('das gelesene Buch', 'the read book'),
        ExPair('ein gekochtes Ei', 'a boiled egg'),
      ]),
      TipSection(text: 'Partizip I = active/ongoing (the crying woman is still crying). Partizip II = passive/completed (the opened door was opened by someone).'),
      RulesSection(title: 'Merke dir!', items: [
        'Partizip I: Infinitiv + -d: lachend, arbeitend, spielend.',
        'Add normal adjective endings: der lachend-e Mann.',
        'Partizip II as adjective: die geöffnet-e Tür.',
        'Common in formal/written German.',
      ]),
    ],
  ),

  'g29': GrammarDetailData(
    id: 'g29', subtitle: 'Nominalisierung', emoji: '📝',
    gradient: const [Color(0xFFEC4899), Color(0xFFD946EF)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Nominalisierung · Nominalization', text: 'Verbs and adjectives can be turned into nouns. They are always capitalized, always neuter (das), and take normal noun endings. Very common in formal German.'),
      ConjugationSection(title: 'Verben → Nomen', color: SectionColor.pink, rows: [
        TableRow2('lernen', 'das Lernen'), TableRow2('schreiben', 'das Schreiben'),
        TableRow2('arbeiten', 'das Arbeiten'), TableRow2('reisen', 'das Reisen'),
      ]),
      ExamplesSection(title: 'Verb-Nominalisierungen', color: SectionColor.fuchsia, items: [
        ExPair('Beim Lernen hört er Musik.', 'While studying, he listens to music.'),
        ExPair('Das Lesen macht mir Spaß.', 'Reading is fun for me.'),
        ExPair('Ich bin für das Kochen zuständig.', 'I am responsible for cooking.'),
      ]),
      ExamplesSection(title: 'Adjektiv-Nominalisierungen', color: SectionColor.pink, items: [
        ExPair('Etwas Gutes ist passiert.', 'Something good happened.'),
        ExPair('Er hat etwas Neues gelernt.', 'He learned something new.'),
        ExPair('Das Beste ist der Anfang.', 'The best (part) is the beginning.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Nominalized verbs are always neuter (das Lernen, das Schreiben).',
        'Used in formal texts to condense information.',
        'Nominalized adjectives: etwas Gutes, nichts Neues, alles Wichtige.',
        'Often replaces a subordinate clause: statt zu arbeiten → das Arbeiten.',
      ]),
    ],
  ),

  'g30': GrammarDetailData(
    id: 'g30', subtitle: 'Indirekte Rede · Einführung', emoji: '🗣️',
    gradient: const [Color(0xFF14B8A6), Color(0xFF0891B2)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Indirekte Rede · Reported Speech', text: 'Indirect speech reports what someone said without quoting them directly. It uses Konjunktiv I (or Konjunktiv II as substitute).'),
      ConjugationSection(title: 'Konjunktiv I - sein & haben', color: SectionColor.teal, rows: [
        TableRow2('er/sie sei', 'he/she be'), TableRow2('er/sie habe', 'he/she have'),
        TableRow2('er/sie gehe', 'he/she go'), TableRow2('er/sie komme', 'he/she come'),
      ]),
      ExamplesSection(title: 'Direkte → Indirekte Rede', color: SectionColor.teal, items: [
        ExPair('Direkt: "Ich komme morgen."', 'Direct: "I\'m coming tomorrow."'),
        ExPair('Indirekt: Er sagt, er komme morgen.', 'Indirect: He says (that) he\'s coming tomorrow.'),
        ExPair('Direkt: "Ich habe keine Zeit."', 'Direct: "I have no time."'),
        ExPair('Indirekt: Sie sagt, sie habe keine Zeit.', 'Indirect: She says she has no time.'),
      ]),
      TipSection(text: 'When Konjunktiv I = Indikativ (e.g. \'kommen\' → \'kommen\'), use Konjunktiv II instead: er komme (Konj.I) but sie käme (Konj.II if forms are identical).', variant: TipVariant.info),
      RulesSection(title: 'Merke dir!', items: [
        'Konjunktiv I forms for 3rd person: er sei, er habe, er gehe.',
        'Used in newspapers, reports, formal writing.',
        'Distancing function: the speaker is not confirming the truth.',
        'If Konj. I = Indikativ, use Konj. II instead.',
      ]),
    ],
  ),

  'g31': GrammarDetailData(
    id: 'g31', subtitle: 'Konjunktiv I · Indirekte Rede', emoji: '💬',
    gradient: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Konjunktiv I in der indirekten Rede', text: 'In written/formal German, Konjunktiv I marks reported speech. Forms are derived from the infinitive stem.'),
      ComparisonSection(title: 'Konjunktiv I Formen', headers: ['Person', 'sein', 'haben', 'kommen'], rows: [
        ComparisonRow(['er/sie/es', 'sei', 'habe', 'komme']),
        ComparisonRow(['sie (pl.)', 'seien', 'haben*', 'kommen*']),
      ]),
      ExamplesSection(title: 'In der Praxis', color: SectionColor.violet, items: [
        ExPair('Der Sprecher erklärte, er sei bereit.', 'The speaker explained he was ready.'),
        ExPair('Sie berichtete, sie habe alles geklärt.', 'She reported she had cleared everything.'),
        ExPair('Laut Bericht sei das Problem gelöst.', 'According to the report, the problem is solved.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Konjunktiv I is standard in newspaper/news reporting.',
        'Shows the speaker distances themselves from the content.',
        'If Konj. I = Indikativ form, use Konj. II instead.',
        'The most important form: er/sie sei (sein), er/sie habe (haben).',
      ]),
    ],
  ),

  'g32': GrammarDetailData(
    id: 'g32', subtitle: 'Konjunktiv II · Fortgeschritten', emoji: '💭',
    gradient: const [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Konjunktiv II · Irreal in der Vergangenheit', text: 'Advanced Konjunktiv II covers unreal conditions in the past: hätte/wäre + Partizip II.', bullets: ['Gegenwart: Wenn ich Zeit hätte, würde ich kommen.', 'Vergangenheit: Wenn ich Zeit gehabt hätte, wäre ich gekommen.', 'Both hätte and wäre + Partizip II for past unreal']),
      ExamplesSection(title: 'Irreale Vergangenheit', color: SectionColor.violet, items: [
        ExPair('Wenn ich früher gelernt hätte, hätte ich bestanden.', 'If I had studied earlier, I would have passed.'),
        ExPair('Ich wäre gegangen, aber ich war krank.', 'I would have gone, but I was sick.'),
        ExPair('Wenn sie angerufen hätte, wäre ich gekommen.', 'If she had called, I would have come.'),
      ]),
      ComparisonSection(title: 'Gegenwart vs. Vergangenheit', headers: ['', 'Gegenwart', 'Vergangenheit'], rows: [
        ComparisonRow(['wenn-Satz', 'Wenn ich Zeit hätte', 'Wenn ich Zeit gehabt hätte']),
        ComparisonRow(['Hauptsatz', 'würde ich kommen', 'wäre ich gekommen']),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Past unreal: hätte/wäre + Partizip II.',
        'hätte for haben-verbs, wäre for sein-verbs.',
        'Double Konjunktiv II in both clauses.',
        'wäre + Partizip II for motion/state change verbs in the past.',
      ]),
    ],
  ),

  'g33': GrammarDetailData(
    id: 'g33', subtitle: 'Partizipialkonstruktionen', emoji: '🧩',
    gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Partizipialkonstruktionen · B2', text: 'Participial constructions replace subordinate clauses, making text more concise and formal. They use Partizip I or II with additional elements.'),
      TransformSection(
        title: 'Nebensatz → Partizipialkonstruktion',
        from: FromToLabel(label: 'NEBENSATZ', text: 'Da er vom Regen überrascht wurde, blieb er zu Hause.'),
        to:   FromToLabel(label: 'PARTIZIP',  text: 'Vom Regen überrascht, blieb er zu Hause.'),
        note: 'Participial phrase moves to the front',
      ),
      ExamplesSection(title: 'Partizip I (aktiv)', color: SectionColor.indigo, items: [
        ExPair('die lachende Frau', 'the laughing woman (who is laughing)'),
        ExPair('der gestern eingereichte Bericht', 'the report submitted yesterday'),
        ExPair('Das Buch, vor Jahren geschrieben, ist aktuell.', 'The book, written years ago, is relevant.'),
      ]),
      TipSection(text: 'Participial constructions are very common in formal/academic writing but rare in spoken German.', variant: TipVariant.info),
      RulesSection(title: 'Merke dir!', items: [
        'Partizip I (laufend, lachend) = active/ongoing process.',
        'Partizip II (geschrieben, gekauft) = passive/completed.',
        'Takes normal adjective endings when before a noun.',
        'Common in newspapers, reports, and academic texts.',
      ]),
    ],
  ),

  'g34': GrammarDetailData(
    id: 'g34', subtitle: 'Erweiterte Nebensätze · B2', emoji: '🔗',
    gradient: const [Color(0xFF14B8A6), Color(0xFF0D9488)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Erweiterte Nebensätze · B2', text: 'New conjunctions at B2 level for manner, result, and concomitance.', bullets: ['indem = by doing', 'wodurch = through which (result)', 'wobei = whereby, while', 'insofern = insofar as', 'während = while / whereas (contrast)']),
      ExamplesSection(title: 'indem & wodurch', color: SectionColor.teal, items: [
        ExPair('Er löste das Problem, indem er den Code refaktorierte.', 'He solved the problem by refactoring the code.'),
        ExPair('Sie verpasste den Zug, wodurch sie zu spät kam.', 'She missed the train, through which she came too late.'),
      ]),
      ExamplesSection(title: 'wobei & während (Kontrast)', color: SectionColor.cyan, items: [
        ExPair('Er arbeitet, wobei er Musik hört.', 'He works, while (at the same time) listening to music.'),
        ExPair('Er arbeitet, während sie pausiert.', 'He works, whereas she takes a break.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'All subordinating conjunctions → verb at the end.',
        'indem = manner (how something is done).',
        'wodurch = result/consequence.',
        'während = simultaneous time OR contrast.',
      ]),
    ],
  ),

  'g35': GrammarDetailData(
    id: 'g35', subtitle: 'Nominalstil · Formelle Sprache', emoji: '📝',
    gradient: const [Color(0xFF475569), Color(0xFF334155)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Nominalstil · Nominal Style', text: 'Formal German uses noun-heavy constructions (Nominalstil) instead of verbal constructions. This condenses information into fewer clauses.',
        bullets: ['Verbal: Er analysierte die Daten gestern.', 'Nominal: Die gestrige Analyse der Daten ...', 'Very common in official documents, academic writing, news']),
      TransformSection(
        title: 'Verbal → Nominal',
        from: FromToLabel(label: 'VERBAL', text: 'Er hat die Daten analysiert.'),
        to:   FromToLabel(label: 'NOMINAL', text: 'Die Analyse der Daten erfolgte durch ihn.'),
        note: 'Verb becomes noun, sentence structure changes',
      ),
      ExamplesSection(title: 'Nominalstil in der Praxis', color: SectionColor.slate, items: [
        ExPair('Die Durchführung der Analyse dauerte zwei Tage.', 'The execution of the analysis took two days.'),
        ExPair('Nach Abschluss der Prüfung erfolgt die Auswertung.', 'After completion of the exam, the evaluation follows.'),
        ExPair('Die Verbesserung der Prozesse ist notwendig.', 'The improvement of processes is necessary.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Verbs → nouns: analysieren → die Analyse, verbessern → die Verbesserung.',
        'Prepositions link noun phrases: nach, durch, bei, infolge.',
        'Common in law, science, journalism, and business.',
        'Makes texts denser and more formal but harder to read.',
      ]),
    ],
  ),

  'g36': GrammarDetailData(
    id: 'g36', subtitle: 'Konnektoren & Textverknüpfung', emoji: '🧲',
    gradient: const [Color(0xFF3B82F6), Color(0xFF6366F1)],
    levelBg: _b2Bg, levelText: _b2t,
    sections: const [
      ConceptSection(title: 'Textverknüpfung · Text Cohesion', text: 'Connectors structure arguments and create cohesion. They express contrast, consequence, or addition.'),
      ConjugationSection(title: 'Wichtige Konnektoren', color: SectionColor.blue, rows: [
        TableRow2('allerdings', 'however, though'), TableRow2('dennoch', 'nevertheless, still'),
        TableRow2('hingegen', 'on the other hand'), TableRow2('folglich', 'consequently, therefore'),
        TableRow2('somit', 'thus, therefore'), TableRow2('außerdem', 'furthermore, besides'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.indigo, items: [
        ExPair('Er hat viel gelernt; dennoch fiel die Prüfung schwer.', 'He studied a lot; nevertheless, the exam was hard.'),
        ExPair('Die Zahlen steigen, folglich investieren wir mehr.', 'The numbers rise, consequently we invest more.'),
        ExPair('Sie ist klug; außerdem ist sie sehr fleißig.', 'She is clever; furthermore, she is very diligent.'),
      ]),
      TipSection(text: 'These connectors take Position 1 in a sentence → they cause inversion: \'Dennoch GEHT er.\' (not: \'Dennoch er geht.\')', variant: TipVariant.warning),
      RulesSection(title: 'Merke dir!', items: [
        'Connectors taking Position 1 cause inversion.',
        'allerdings/jedoch = restriction. dennoch/trotzdem = concession.',
        'folglich/somit = consequence. außerdem/zudem = addition.',
        'hindegen/dagegen = contrast.',
      ]),
    ],
  ),

  'g37': GrammarDetailData(
    id: 'g37', subtitle: 'Artikel · Plural', emoji: '📘',
    gradient: const [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(title: 'Pluralbildung · Forming Plurals', text: 'German nouns form their plurals in several ways. Unfortunately there are no universal rules — you must learn each noun\'s plural form.',
        bullets: ['-e / -¨e: der Tag → die Tage, der Stuhl → die Stühle', '-er / -¨er: das Kind → die Kinder, der Mann → die Männer', '-(e)n: die Frau → die Frauen, der Student → die Studenten', '-s: das Auto → die Autos', 'no change or umlaut: der Vater → die Väter']),
      ConjugationSection(title: 'Pluraltypen', color: SectionColor.blue, rows: [
        TableRow2('-e / -¨e', 'der Tag → die Tage'), TableRow2('-er / -¨er', 'das Kind → die Kinder'),
        TableRow2('-(e)n', 'die Frau → die Frauen'), TableRow2('-s', 'das Auto → die Autos'),
        TableRow2('-¨ / –', 'der Vater → die Väter'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.blue, items: [
        ExPair('der Mann → die Männer', 'the man → the men'),
        ExPair('das Buch → die Bücher', 'the book → the books'),
        ExPair('die Schule → die Schulen', 'the school → the schools'),
        ExPair('das Auto → die Autos', 'the car → the cars'),
      ]),
      TipSection(text: 'All plurals use \'die\' as their article. In the Dative plural, all nouns add -n unless the plural already ends in -n or -s.'),
      RulesSection(title: 'Merke dir!', items: [
        'Always learn the plural with the noun: die Nacht, die Nächte.',
        'Feminine nouns in -e: usually add -n → die Lampe → die Lampen.',
        'Nouns from English/French: usually -s → das Café → die Cafés.',
        'Dative plural: always add -n: den Männern, den Kindern.',
      ]),
    ],
  ),

  'g38': GrammarDetailData(
    id: 'g38', subtitle: 'Satzbau · Verneinung', emoji: '🚫',
    gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
    levelBg: _a1Bg, levelText: _a1t,
    sections: const [
      ConceptSection(title: 'Verneinung · Negation', text: 'German uses \'nicht\' to negate verbs, adjectives, and adverbs, and \'kein\' to negate nouns.',
        bullets: ['nicht = negates verbs, adjectives, adverbs, specific elements', 'kein = negates nouns (replaces ein/–)', 'Position of nicht: usually before what is negated, or at the end']),
      ComparisonSection(title: 'nicht vs. kein', headers: ['', 'Affirmativ', 'Negation'], rows: [
        ComparisonRow(['Verb', 'Ich lerne.', 'Ich lerne nicht.']),
        ComparisonRow(['Adj.', 'Das ist gut.', 'Das ist nicht gut.']),
        ComparisonRow(['ein-Nomen', 'Ich habe ein Auto.', 'Ich habe kein Auto.']),
        ComparisonRow(['Pl. Nomen', 'Ich habe Bücher.', 'Ich habe keine Bücher.']),
      ]),
      ExamplesSection(title: 'nicht in der Praxis', color: SectionColor.red, items: [
        ExPair('Ich komme nicht.', 'I\'m not coming.'),
        ExPair('Er ist nicht müde.', 'He is not tired.'),
        ExPair('Ich gehe nicht heute, sondern morgen.', 'I\'m not going today, but tomorrow.'),
        ExPair('Das ist nicht mein Buch.', 'That is not my book.'),
      ]),
      ExamplesSection(title: 'kein in der Praxis', color: SectionColor.orange, items: [
        ExPair('Ich habe kein Geld.', 'I have no money.'),
        ExPair('Er hat keine Zeit.', 'He has no time.'),
        ExPair('Wir haben keine Bücher.', 'We have no books.'),
      ]),
      RulesSection(title: 'Merke dir!', items: [
        'Use \'kein\' to negate nouns with ein/–.',
        'kein follows the same endings as ein: kein, keine, keinen, keinem...',
        'nicht goes to the END in simple sentences: Ich komme nicht.',
        'nicht goes BEFORE adjectives, adverbs, and specific elements.',
      ]),
    ],
  ),

  'g39': GrammarDetailData(
    id: 'g39', subtitle: 'Fälle · Dativ', emoji: '⚖️',
    gradient: const [Color(0xFFF43F5E), Color(0xFFEC4899)],
    levelBg: _a2Bg, levelText: _a2t,
    sections: const [
      ConceptSection(title: 'Der Dativ · The Dative Case', text: 'The Dative case marks the indirect object (to/for whom). It is also required after certain prepositions and verbs.',
        bullets: ['Answers: WEM? (to/for whom?)', 'Always after: mit, nach, aus, bei, von, zu, seit, gegenüber', 'After Wechselpräpositionen in WO? position', 'With verbs: helfen, danken, gefallen, gehören, antworten']),
      ComparisonSection(title: 'Dativartikel', headers: ['', 'Mask.', 'Fem.', 'Neut.', 'Plural'], rows: [
        ComparisonRow(['bestimmt', 'dem', 'der', 'dem', 'den']),
        ComparisonRow(['unbestimmt', 'einem', 'einer', 'einem', '–']),
        ComparisonRow(['kein', 'keinem', 'keiner', 'keinem', 'keinen']),
      ]),
      ExamplesSection(title: 'Indirektes Objekt', color: SectionColor.rose, items: [
        ExPair('Ich gebe dem Mann das Buch.', 'I give the man the book. (WEM gebe ich?)'),
        ExPair('Sie schreibt ihrer Mutter einen Brief.', 'She writes her mother a letter.'),
        ExPair('Er hilft seinem Freund.', 'He helps his friend.'),
      ]),
      ExamplesSection(title: 'Dativverben', color: SectionColor.pink, items: [
        ExPair('Das Buch gehört mir.', 'The book belongs to me.'),
        ExPair('Dieser Film gefällt mir.', 'I like this film. (lit: This film pleases me)'),
        ExPair('Ich danke Ihnen.', 'I thank you.'),
      ]),
      TipSection(text: 'Dative plural: all nouns add -n unless plural already ends in -n or -s: den Männ-ern, den Kind-ern.'),
      RulesSection(title: 'Merke dir!', items: [
        'Dativ = WEM? Always after: mit, nach, aus, bei, von, zu, seit.',
        'Only masculine changes again: dem, einem, keinem.',
        'Dative plural: article den + noun + n (if not already).',
        'Dative verbs: helfen, gefallen, gehören, danken, antworten.',
      ]),
    ],
  ),

  'g40': GrammarDetailData(
    id: 'g40', subtitle: 'Verben · Feste Präpositionen', emoji: '🔧',
    gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Verben mit festen Präpositionen', text: 'Many German verbs require a fixed preposition that determines the case of the following noun phrase. These must be memorized.'),
      ConjugationSection(title: 'Verb + Akkusativ-Präposition', color: SectionColor.green, rows: [
        TableRow2('warten auf + Akk.', 'to wait for'),  TableRow2('sich freuen auf + Akk.', 'to look forward to'),
        TableRow2('denken an + Akk.', 'to think of'),   TableRow2('glauben an + Akk.', 'to believe in'),
        TableRow2('sich erinnern an + Akk.', 'to remember'), TableRow2('sich interessieren für + Akk.', 'to be interested in'),
      ]),
      ConjugationSection(title: 'Verb + Dativ-Präposition', color: SectionColor.emerald, rows: [
        TableRow2('sprechen über + Akk.', 'to talk about'), TableRow2('sich ärgern über + Akk.', 'to be annoyed about'),
        TableRow2('abhängen von + Dat.', 'to depend on'),   TableRow2('träumen von + Dat.', 'to dream of'),
        TableRow2('leiden an + Dat.', 'to suffer from'),    TableRow2('teilnehmen an + Dat.', 'to participate in'),
      ]),
      ExamplesSection(title: 'Beispiele', color: SectionColor.green, items: [
        ExPair('Wir warten auf den Zug.', 'We are waiting for the train.'),
        ExPair('Ich freue mich auf die Ferien.', 'I look forward to the holidays.'),
        ExPair('Er träumt von einer Reise nach Japan.', 'He dreams of a trip to Japan.'),
        ExPair('Das hängt von dem Wetter ab.', 'That depends on the weather.'),
      ]),
      TipSection(text: 'Use \'da(r)-\' before prepositions to refer to things: \'Worauf wartest du? — Darauf.\' (on it) vs. \'Auf wen wartest du? — Auf ihn.\' (on him, person).'),
      RulesSection(title: 'Merke dir!', items: [
        'The preposition is FIXED — it doesn\'t change with meaning.',
        'Refer to things with da(r)- compounds: darauf, davon, daran.',
        'Refer to people with normal prepositional phrases: auf ihn, von ihr.',
        'Ask for things with wo(r)-: Worauf wartest du?',
      ]),
    ],
  ),

  'g41': GrammarDetailData(
    id: 'g41', subtitle: 'Zeiten · Passiv Grundlagen', emoji: '🏗️',
    gradient: const [Color(0xFF6366F1), Color(0xFFA855F7)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Das Passiv · The Passive Voice', text: 'The passive voice shifts focus from the actor to the action. German has two types: Vorgangspassiv (werden, action) and Zustandspassiv (sein, result/state).',
        bullets: ['Vorgangspassiv: werden + Partizip II = the action happening', 'Zustandspassiv: sein + Partizip II = the resulting state', 'Agent (by whom): von + Dativ']),
      FormulaSection(label: 'Vorgangspassiv', formula: 'werden (konj.) + ... + Partizip II', colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
      FormulaSection(label: 'Zustandspassiv', formula: 'sein (konj.) + ... + Partizip II',   colors: [Color(0xFFA855F7), Color(0xFF7C3AED)]),
      ExamplesSection(title: 'Vorgangspassiv (Zeiten)', color: SectionColor.indigo, items: [
        ExPair('Der Vertrag wird unterschrieben.', 'The contract is being signed. (Präsens)'),
        ExPair('Der Vertrag wurde unterschrieben.', 'The contract was signed. (Präteritum)'),
        ExPair('Der Vertrag ist unterschrieben worden.', 'The contract has been signed. (Perfekt)'),
      ]),
      ExamplesSection(title: 'Zustandspassiv', color: SectionColor.violet, items: [
        ExPair('Die Tür ist geöffnet.', 'The door is open. (result)'),
        ExPair('Die Aufgabe ist erledigt.', 'The task is done. (result)'),
        ExPair('Der Brief ist geschrieben.', 'The letter is written. (result)'),
      ]),
      TipSection(text: 'Vorgangspassiv describes what is HAPPENING. Zustandspassiv describes the RESULT. Compare: Die Tür wird geöffnet (someone opens it) vs. Die Tür ist geöffnet (it is open).', variant: TipVariant.info),
      RulesSection(title: 'Merke dir!', items: [
        'Vorgangspassiv: werden + Partizip II (in all tenses).',
        'Zustandspassiv: sein + Partizip II (describes result).',
        'Agent: von + Dativ: Das Haus wurde vom Architekten gebaut.',
        'Perfekt Vorgangspassiv: ist + Partizip II + worden (not geworden!).',
      ]),
    ],
  ),

  'g42': GrammarDetailData(
    id: 'g42', subtitle: 'Fälle · Genitiv', emoji: '⚖️',
    gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Der Genitiv · The Genitive Case', text: 'The Genitive shows possession or belonging. It answers \'WESSEN?\' (whose?). Masculine and neuter nouns add -s/-es, articles change.',
        bullets: ['Maskulin/Neutrum: des + Nomen + -(e)s', 'Feminin/Plural: der + Nomen (no change)', 'Genitiv-Präpositionen: wegen, trotz, aufgrund, während, statt']),
      ComparisonSection(title: 'Genitiv Artikel', headers: ['', 'Mask.', 'Fem.', 'Neut.', 'Plural'], rows: [
        ComparisonRow(['bestimmt', 'des (-s)', 'der', 'des (-s)', 'der']),
        ComparisonRow(['unbestimmt', 'eines (-s)', 'einer', 'eines (-s)', '–']),
      ]),
      ExamplesSection(title: 'Genitiv als Possessiv', color: SectionColor.violet, items: [
        ExPair('das Auto des Mannes', 'the man\'s car'),
        ExPair('die Farbe der Wand', 'the color of the wall'),
        ExPair('der Name eines Studenten', 'the name of a student'),
        ExPair('die Meinung der Leute', 'the opinion of the people'),
      ]),
      ConjugationSection(title: 'Genitiv-Präpositionen', color: SectionColor.purple, rows: [
        TableRow2('wegen', 'because of (+ Genitiv)'), TableRow2('trotz', 'despite (+ Genitiv)'),
        TableRow2('aufgrund', 'due to (+ Genitiv)'), TableRow2('während', 'during (+ Genitiv)'),
        TableRow2('statt/anstatt', 'instead of (+ Genitiv)'), TableRow2('außerhalb', 'outside of (+ Genitiv)'),
      ]),
      TipSection(text: 'In spoken German, \'wegen\' is often used with Dativ: \'wegen dem Wetter\' instead of \'wegen des Wetters\'. In writing, always use Genitiv.', variant: TipVariant.info),
      RulesSection(title: 'Merke dir!', items: [
        'Genitive shows possession: Das Auto des Mannes.',
        'Masculine/neuter nouns add -(e)s: des Mannes, des Kindes.',
        'Feminine and plural: just change the article: der Frau, der Kinder.',
        'Genitiv prepositions: wegen, trotz, aufgrund, während, statt.',
      ]),
    ],
  ),

  'g43': GrammarDetailData(
    id: 'g43', subtitle: 'Fälle · Schwache Nomen', emoji: '⚖️',
    gradient: const [Color(0xFFF43F5E), Color(0xFFEF4444)],
    levelBg: _b1Bg, levelText: _b1t,
    sections: const [
      ConceptSection(title: 'Schwache Nomen · Weak Nouns', text: 'A special group of masculine nouns add -(e)n in ALL cases except Nominativ singular. These are called weak nouns (n-Deklination).',
        bullets: ['These are ALL masculine nouns', 'Add -n or -en in Gen., Dat., Akk. singular and ALL plural forms', 'Typical endings: -e (der Löwe), -ent (der Student), -ist (der Journalist), -and/-ant, -at, -ot, -et']),
      ComparisonSection(title: 'Deklination: der Mensch', headers: ['Kasus', 'Singular', 'Plural'], rows: [
        ComparisonRow(['Nom.', 'der Mensch', 'die Menschen']),
        ComparisonRow(['Akk.', 'den Menschen', 'die Menschen']),
        ComparisonRow(['Dat.', 'dem Menschen', 'den Menschen']),
        ComparisonRow(['Gen.', 'des Menschen', 'der Menschen']),
      ]),
      ConjugationSection(title: 'Beispiele schwacher Nomen', color: SectionColor.red, rows: [
        TableRow2('der Student', 'des/dem/den Studenten'), TableRow2('der Journalist', 'des/dem/den Journalisten'),
        TableRow2('der Kollege', 'des/dem/den Kollegen'), TableRow2('der Löwe', 'des/dem/den Löwen'),
        TableRow2('der Herr', 'des Herrn, dem/den Herrn'), TableRow2('der Mensch', 'des/dem/den Menschen'),
      ]),
      TipSection(text: 'A helpful trick: if the noun can refer to a male person and ends in -e, -ent, -ist, -and, -at, -ot, -et → it\'s probably a weak noun!', variant: TipVariant.success),
      RulesSection(title: 'Merke dir!', items: [
        'Weak nouns: add -(e)n in EVERY case except Nominativ singular.',
        'All weak nouns are MASCULINE (+ das Herz as special case).',
        'Common endings: -e, -ent, -ist, -and, -ant, -at.',
        'Watch out: Der Kollege → Ich kenne den Kollegen.',
      ]),
    ],
  ),
};
