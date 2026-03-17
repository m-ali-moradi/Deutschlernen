// ─── Grammar Seed Data — synced from Figma Make ─────────────────────────────
// Matches GrammarPage.tsx and store.tsx topic list exactly.

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
  // ─── A1 ──────────────────────────────────────────────────────────────────

  GrammarTopicView(
    id: 'g1', title: 'Bestimmte Artikel', level: 'A1', category: 'Artikel', icon: '📘',
    rule: 'Der (maskulin), Die (feminin), Das (neutrum) — bestimmte Artikel hängen vom Genus ab.',
    explanation: 'In German, every noun has a grammatical gender. The definite articles are: der (masculine), die (feminine), das (neuter). In plural, all genders use \'die\'.',
    examples: ['Der Mann liest ein Buch.', 'Die Frau trinkt Kaffee.', 'Das Kind spielt im Garten.', 'Die Kinder gehen zur Schule.'],
    progress: 80,
  ),

  GrammarTopicView(
    id: 'g9', title: 'Satzbau', level: 'A1', category: 'Satzbau', icon: '🏗️',
    rule: 'Das konjugierte Verb steht immer auf Position 2 im Hauptsatz.',
    explanation: 'In German main clauses, the conjugated verb always occupies Position 2. In yes/no questions, the verb moves to Position 1. W-questions have the W-word in Position 1 and verb in Position 2.',
    examples: ['Ich gehe morgen ins Kino.', 'Morgen gehe ich ins Kino.', 'Gehst du morgen ins Kino?', 'Wo wohnst du?'],
    progress: 75,
  ),

  GrammarTopicView(
    id: 'g10', title: 'Nominativ & Akkusativ', level: 'A1', category: 'Fälle', icon: '🎯',
    rule: 'Nominativ = Subjekt (WER?), Akkusativ = direktes Objekt (WEN?). Nur maskulin ändert sich: der→den.',
    explanation: 'German has four cases. At A1, focus on Nominativ (subject) and Akkusativ (direct object). Only masculine articles change in the Akkusativ: der→den, ein→einen.',
    examples: ['Der Mann liest. (Nom)', 'Ich sehe den Mann. (Akk)', 'Sie kauft einen Tisch.', 'Wir lesen das Buch.'],
    progress: 70,
  ),

  GrammarTopicView(
    id: 'g11', title: 'Personalpronomen', level: 'A1', category: 'Pronomen', icon: '👤',
    rule: 'Personalpronomen ersetzen Nomen und ändern sich nach Kasus.',
    explanation: 'Personal pronouns replace nouns and change based on case. Possessive pronouns (mein, dein, sein, ihr) follow the same endings as ein/kein.',
    examples: ['Ich sehe ihn.', 'Das ist mein Buch.', 'Wo ist dein Schlüssel?', 'Wer ist das?'],
    progress: 60,
  ),

  GrammarTopicView(
    id: 'g2', title: 'Präsens', level: 'A1', category: 'Zeiten', icon: '⏰',
    rule: 'Im Präsens konjugiert man das Verb nach Person und Numerus.',
    explanation: 'The present tense in German is formed by adding endings to the verb stem: -e, -st, -t, -en, -t, -en. Some verbs have stem changes (e→i, a→ä).',
    examples: ['Ich lerne Deutsch.', 'Du arbeitest jeden Tag.', 'Er spricht Englisch.', 'Wir gehen ins Kino.'],
    progress: 65,
  ),

  GrammarTopicView(
    id: 'g12', title: 'Modalverben', level: 'A1', category: 'Verben', icon: '🔧',
    rule: 'Modalverb (konjugiert, Pos. 2) + Infinitiv (am Ende).',
    explanation: 'Modal verbs (können, müssen, wollen, sollen, dürfen, möchten) express ability, obligation, or desire. The main verb goes to the end as infinitive.',
    examples: ['Ich kann Deutsch sprechen.', 'Du musst morgen arbeiten.', 'Darf ich hier rauchen?', 'Ich möchte einen Kaffee.'],
    progress: 55,
  ),

  GrammarTopicView(
    id: 'g13', title: 'Trennbare Verben', level: 'A1', category: 'Verben', icon: '✂️',
    rule: 'Im Präsens trennt sich das Präfix und geht ans Satzende.',
    explanation: 'Separable verbs have a prefix that detaches in Präsens and goes to the end. In Perfekt, ge- goes between prefix and stem: auf-ge-standen.',
    examples: ['Ich stehe um 7 Uhr auf.', 'Sie kauft im Supermarkt ein.', 'Der Zug kommt um 10 an.', 'Ich bin aufgestanden.'],
    progress: 50,
  ),

  GrammarTopicView(
    id: 'g14', title: 'Präpositionen (Akk/Dat)', level: 'A1', category: 'Präpositionen', icon: '📍',
    rule: 'Akk: durch, für, ohne, gegen, um. Dat: mit, nach, aus, bei, von, zu, seit.',
    explanation: 'Some prepositions always take Akkusativ (DOGFU), others always take Dativ. The article changes based on the required case.',
    examples: ['Ich gehe durch den Park.', 'Das ist für dich.', 'Ich fahre mit dem Bus.', 'Sie kommt aus der Türkei.'],
    progress: 45,
  ),

  GrammarTopicView(
    id: 'g15', title: 'Adjektive Grundlagen', level: 'A1', category: 'Adjektive', icon: '🎨',
    rule: 'Prädikativ (nach sein): keine Endung. Attributiv (vor Nomen): mit Endung.',
    explanation: 'Predicate adjectives (after sein) have no ending. Attributive adjectives (before nouns) take endings based on gender, case, and article type.',
    examples: ['Das Buch ist interessant.', 'Der große Mann arbeitet hier.', 'Ich lese ein interessantes Buch.', 'Sie hat eine neue Tasche.'],
    progress: 40,
  ),

  GrammarTopicView(
    id: 'g37', title: 'Pluralbildung', level: 'A1', category: 'Artikel', icon: '📚',
    rule: '5 Pluraltypen: -e, -er, -n/-en, -s, Umlaut. Immer Artikel \'die\'.',
    explanation: 'German has five main plural patterns. There is no single rule — the plural must be learned with each noun. All plurals use the article \'die\'.',
    examples: ['der Tisch → die Tische', 'das Kind → die Kinder', 'die Frau → die Frauen', 'das Auto → die Autos'],
    progress: 70,
  ),

  GrammarTopicView(
    id: 'g38', title: 'Negation', level: 'A1', category: 'Satzbau', icon: '🚫',
    rule: '\'nicht\' negiert Verben/Adjektive. \'kein\' negiert Nomen mit ein/eine oder ohne Artikel.',
    explanation: '\'nicht\' negates verbs, adjectives, adverbs, and specific nouns. \'kein\' replaces ein/eine or zero article before nouns.',
    examples: ['Ich komme nicht.', 'Das ist nicht gut.', 'Ich habe kein Auto.', 'Er trinkt keinen Kaffee.'],
    progress: 75,
  ),

  // ─── A2 ──────────────────────────────────────────────────────────────────

  GrammarTopicView(
    id: 'g5', title: 'Perfekt', level: 'A2', category: 'Zeiten', icon: '⏰',
    rule: 'Perfekt = haben/sein + Partizip II',
    explanation: 'The Perfekt tense is formed with an auxiliary verb (haben or sein) and the past participle. Most verbs use \'haben\'; verbs of motion/change use \'sein\'.',
    examples: ['Ich habe Deutsch gelernt.', 'Sie ist nach Berlin gefahren.', 'Wir haben einen Film gesehen.', 'Er ist gestern angekommen.'],
    progress: 55,
  ),

  GrammarTopicView(
    id: 'g16', title: 'Präteritum', level: 'A2', category: 'Zeiten', icon: '📜',
    rule: 'Regelmäßig: Stamm + -te. Unregelmäßig: Stammvokaländerung.',
    explanation: 'Präteritum is mainly used in written German. In speech, only sein (war), haben (hatte), and modals (konnte, musste) are common in Präteritum.',
    examples: ['Ich war gestern in Berlin.', 'Er hatte keine Zeit.', 'Sie konnte nicht kommen.', 'Der König lebte in einem Schloss.'],
    progress: 45,
  ),

  GrammarTopicView(
    id: 'g17', title: 'Futur I', level: 'A2', category: 'Zeiten', icon: '🔮',
    rule: 'werden (konjugiert) + Infinitiv',
    explanation: 'Futur I expresses future plans and predictions. However, Präsens + time word is more common in everyday speech.',
    examples: ['Ich werde morgen kommen.', 'Es wird regnen.', 'Sie wird Ärztin werden.', 'Wir werden das schaffen!'],
    progress: 35,
  ),

  GrammarTopicView(
    id: 'g3', title: 'Nebensätze', level: 'A2', category: 'Nebensätze', icon: '🔗',
    rule: 'Im Nebensatz steht das konjugierte Verb am Ende.',
    explanation: 'Subordinating conjunctions (weil, dass, wenn, obwohl, als, bevor, nachdem, während) push the verb to the end of the clause.',
    examples: ['Ich lerne Deutsch, weil ich in Berlin arbeite.', 'Sie sagt, dass sie morgen kommt.', 'Wenn es regnet, bleibe ich zu Hause.', 'Als ich Kind war, lebte ich in Kabul.'],
    progress: 40,
  ),

  GrammarTopicView(
    id: 'g18', title: 'Relativsätze (Grundlagen)', level: 'A2', category: 'Nebensätze', icon: '🔗',
    rule: 'Relativpronomen: Genus/Numerus vom Bezugswort, Kasus aus dem Relativsatz.',
    explanation: 'Relative clauses add information about a noun. The pronoun matches the noun in gender/number but takes its case from its role in the relative clause.',
    examples: ['Der Mann, der dort steht, ist mein Chef.', 'Die Frau, die ich kenne, arbeitet bei Siemens.', 'Das Buch, das ich lese, ist interessant.', 'Die Leute, denen ich half, waren dankbar.'],
    progress: 35,
  ),

  GrammarTopicView(
    id: 'g19', title: 'Infinitivkonstruktionen', level: 'A2', category: 'Verben', icon: '🔄',
    rule: 'zu + Infinitiv / um...zu / ohne...zu / anstatt...zu',
    explanation: 'Infinitive constructions with \'zu\' are used after certain verbs and adjectives. um...zu (purpose), ohne...zu (without), anstatt...zu (instead of).',
    examples: ['Ich versuche, Deutsch zu lernen.', 'Ich lerne, um in Berlin zu arbeiten.', 'Er ging, ohne etwas zu sagen.', 'Anstatt zu lernen, spielt sie.'],
    progress: 30,
  ),

  GrammarTopicView(
    id: 'g4', title: 'Wechselpräpositionen', level: 'A2', category: 'Präpositionen', icon: '📍',
    rule: 'Wechselpräpositionen: Akkusativ (WOHIN?) oder Dativ (WO?).',
    explanation: 'Nine prepositions (an, auf, hinter, in, neben, über, unter, vor, zwischen) take Akkusativ for movement and Dativ for location.',
    examples: ['Ich stelle das Buch auf den Tisch. (Akk)', 'Das Buch liegt auf dem Tisch. (Dat)', 'Er geht in die Schule. (Akk)', 'Er ist in der Schule. (Dat)'],
    progress: 30,
  ),

  GrammarTopicView(
    id: 'g20', title: 'Adjektivdeklination', level: 'A2', category: 'Adjektive', icon: '🎨',
    rule: 'Endung hängt ab von: Artikeltyp, Genus, Kasus.',
    explanation: 'Adjective endings depend on the article type (definite/indefinite/none), gender, and case. After der/die/das mostly -e or -en. After ein the adjective shows gender.',
    examples: ['Der neue Kollege ist nett.', 'Ich kaufe einen roten Pullover.', 'Sie arbeitet in einem großen Büro.', 'Die alten Bücher sind interessant.'],
    progress: 25,
  ),

  GrammarTopicView(
    id: 'g21', title: 'Komparativ & Superlativ', level: 'A2', category: 'Adjektive', icon: '📊',
    rule: 'Komparativ: +er (als). Superlativ: am +sten / der/die/das +ste.',
    explanation: 'Comparatives add -er, superlatives add -(e)sten. Many common adjectives get an Umlaut. Irregular: gut-besser-best, viel-mehr-meist.',
    examples: ['Berlin ist größer als München.', 'Das ist das beste Restaurant.', 'Er ist nicht so groß wie sein Bruder.', 'Deutsch ist genauso schwer wie Französisch.'],
    progress: 25,
  ),

  GrammarTopicView(
    id: 'g22', title: 'Reflexive Verben', level: 'A2', category: 'Verben', icon: '🪞',
    rule: 'Reflexivpronomen (mich/mir, dich/dir, sich, uns, euch) bezieht sich auf das Subjekt.',
    explanation: 'Reflexive verbs use a pronoun referring back to the subject. Akkusativ or Dativ depending on whether there\'s another direct object.',
    examples: ['Ich freue mich auf die Ferien.', 'Er setzt sich auf den Stuhl.', 'Ich wasche mir die Hände.', 'Kannst du dir das vorstellen?'],
    progress: 20,
  ),

  GrammarTopicView(
    id: 'g23', title: 'Indefinitpronomen', level: 'A2', category: 'Pronomen', icon: '❓',
    rule: 'man, jemand, niemand, etwas, nichts, alle, viele, einige.',
    explanation: 'Indefinite pronouns refer to unspecified people or things. \'man\' uses 3rd person singular. jemand/niemand are for people, etwas/nichts for things.',
    examples: ['Man spricht hier Deutsch.', 'Jemand hat angerufen.', 'Niemand war zu Hause.', 'Alle sind eingeladen.'],
    progress: 20,
  ),

  GrammarTopicView(
    id: 'g39', title: 'Dativ', level: 'A2', category: 'Fälle', icon: '🎯',
    rule: 'Dativ = indirektes Objekt (WEM?). Artikel: dem/der/dem/den+n.',
    explanation: 'The Dativ case marks the indirect object (WEM?). Articles change: der→dem, die→der, das→dem, die(pl)→den+n. Many verbs and prepositions require Dativ.',
    examples: ['Ich gebe dem Mann das Buch.', 'Sie hilft der Frau.', 'Er dankt den Kindern.', 'Ich schenke meiner Mutter Blumen.'],
    progress: 30,
  ),

  GrammarTopicView(
    id: 'g40', title: 'Verben mit Präpositionen', level: 'A2', category: 'Verben', icon: '🔧',
    rule: 'Viele Verben haben feste Präpositionen: warten auf (Akk), sprechen über (Akk).',
    explanation: 'Many German verbs require a specific preposition with a fixed case. These must be memorized as a unit: sich freuen auf (Akk), Angst haben vor (Dat).',
    examples: ['Ich warte auf den Bus.', 'Sie denkt an ihre Familie.', 'Er interessiert sich für Kunst.', 'Wir sprechen über das Problem.'],
    progress: 25,
  ),

  GrammarTopicView(
    id: 'g41', title: 'Passiv (Grundlagen)', level: 'A2', category: 'Zeiten', icon: '⏰',
    rule: 'Präsens Passiv: werden + P.II. Perfekt Passiv: sein + P.II + worden.',
    explanation: 'Basic passive voice: Präsens Passiv with werden + Partizip II, and Perfekt Passiv with sein + P.II + worden. Agent with \'von + Dativ\'.',
    examples: ['Das Essen wird gekocht.', 'Der Brief wird geschrieben.', 'Das Auto ist repariert worden.', 'Die E-Mail wurde von ihm geschickt.'],
    progress: 20,
  ),

  // ─── B1 ──────────────────────────────────────────────────────────────────

  GrammarTopicView(
    id: 'g24', title: 'Plusquamperfekt', level: 'B1', category: 'Zeiten', icon: '⏪',
    rule: 'hatte/war (Präteritum) + Partizip II',
    explanation: 'Plusquamperfekt describes an action before another past action. Formed with hatte/war + Partizip II. Almost always used with nachdem.',
    examples: ['Nachdem ich gegessen hatte, ging ich spazieren.', 'Er war schon gegangen, als ich ankam.', 'Sie hatte das Buch gelesen, bevor sie den Film sah.'],
    progress: 15,
  ),

  GrammarTopicView(
    id: 'g25', title: 'Futur I & II', level: 'B1', category: 'Zeiten', icon: '🔮',
    rule: 'Futur I: werden + Inf. Futur II: werden + P.II + haben/sein.',
    explanation: 'Futur I for future events. Futur II for completed future or assumptions about the past. With \'wohl\' = assumption.',
    examples: ['Ich werde morgen kommen.', 'Bis morgen werde ich das Buch gelesen haben.', 'Er wird wohl schon gegangen sein.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g26', title: 'Erweiterte Nebensätze', level: 'B1', category: 'Nebensätze', icon: '🔗',
    rule: 'damit, sodass, falls, seitdem, solange, sobald, je...desto',
    explanation: 'B1 introduces new subordinating conjunctions for purpose, result, condition, and proportional relationships.',
    examples: ['Ich erkläre es langsam, damit du es verstehst.', 'Falls es regnet, bleiben wir zu Hause.', 'Je mehr ich lerne, desto besser verstehe ich.'],
    progress: 15,
  ),

  GrammarTopicView(
    id: 'g27', title: 'Konditionalsätze', level: 'B1', category: 'Nebensätze', icon: '🔀',
    rule: 'Real: wenn + Indikativ. Irreal: wenn + Konjunktiv II.',
    explanation: 'Real conditions use Indikativ for possible situations. Unreal conditions use Konjunktiv II for hypothetical situations.',
    examples: ['Wenn es regnet, bleibe ich zu Hause.', 'Wenn ich reich wäre, würde ich reisen.', 'Wenn ich Zeit hätte, würde ich dir helfen.'],
    progress: 20,
  ),

  GrammarTopicView(
    id: 'g6', title: 'Konjunktiv II', level: 'B1', category: 'Konjunktiv', icon: '💭',
    rule: 'Konjunktiv II drückt irreale Situationen, Wünsche und höfliche Bitten aus.',
    explanation: 'Konjunktiv II is used for hypothetical situations, wishes, and polite requests. For most verbs, use \'würde\' + infinitive. Common verbs have special forms: wäre, hätte, könnte.',
    examples: ['Wenn ich reich wäre, würde ich reisen.', 'Ich hätte gern einen Kaffee.', 'Könnten Sie mir bitte helfen?', 'Wenn ich Zeit hätte, würde ich mehr lernen.'],
    progress: 20,
  ),

  GrammarTopicView(
    id: 'g7', title: 'Relativsätze (Fortgeschritten)', level: 'B1', category: 'Nebensätze', icon: '🔗',
    rule: 'Relativsätze mit Präpositionen und Genitiv (dessen, deren).',
    explanation: 'Advanced relative clauses use prepositions + relative pronouns and genitive forms (dessen, deren) for possession.',
    examples: ['Der Mann, mit dem ich sprach, ist Arzt.', 'Die Stadt, in der ich wohne, ist schön.', 'Der Mann, dessen Auto rot ist, ist mein Nachbar.'],
    progress: 15,
  ),

  GrammarTopicView(
    id: 'g28', title: 'Partizipien als Adjektive', level: 'B1', category: 'Verben', icon: '📝',
    rule: 'Partizip I (Inf+d) = laufend. Partizip II (ge...t/en). Beide als Adjektive deklinierbar.',
    explanation: 'Both participles can be used as adjectives. Partizip I expresses an ongoing action (spielend = playing), Partizip II a completed state (repariert = repaired).',
    examples: ['Das spielende Kind lacht.', 'Das reparierte Auto fährt wieder.', 'Die schlafende Katze liegt auf dem Sofa.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g29', title: 'Nominalisierung', level: 'B1', category: 'Verben', icon: '🔄',
    rule: 'Verb → das + Infinitiv (das Lesen). Adjektiv → substantiviert (der Alte).',
    explanation: 'Nominalization turns verbs and adjectives into nouns. Nominalized infinitives are always neuter (das Lesen). Common in formal German.',
    examples: ['Das Lesen macht mir Spaß.', 'Das Gute daran ist...', 'Was gibt es Neues?', 'Der Kranke braucht Ruhe.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g30', title: 'Indirekte Rede', level: 'B1', category: 'Konjunktiv', icon: '💬',
    rule: 'Konjunktiv I (formal) oder dass + Indikativ (Alltag).',
    explanation: 'Reported speech uses Konjunktiv I in formal contexts. In everyday speech, \'dass + Indikativ\' is standard.',
    examples: ['Er sagt, er sei müde.', 'Sie sagt, sie habe keine Zeit.', 'Er sagt, dass er müde ist.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g42', title: 'Genitiv', level: 'B1', category: 'Fälle', icon: '🎯',
    rule: 'Genitiv = Besitz (WESSEN?). Artikel: des/der. Maskulin/Neutrum: Nomen + -(e)s.',
    explanation: 'The Genitiv case expresses possession (WESSEN?). Masculine and neuter nouns add -(e)s. Used after certain prepositions and in formal/written German.',
    examples: ['Das Auto des Mannes ist rot.', 'Die Tasche der Frau liegt dort.', 'Trotz des Regens gehen wir.', 'Während des Unterrichts schläft er.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g43', title: 'n-Deklination', level: 'B1', category: 'Fälle', icon: '📋',
    rule: 'Schwache Nomen (maskulin) erhalten -n/-en in allen Fällen außer Nominativ Singular.',
    explanation: 'Weak masculine nouns add -n or -en in Akkusativ, Dativ, and Genitiv singular. Includes: der Junge, der Kunde, der Kollege, der Herr, der Student, der Mensch.',
    examples: ['Ich sehe den Studenten.', 'Er hilft dem Kollegen.', 'Das Büro des Herrn ist dort.', 'Ich kenne den Kunden.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g44', title: 'Wortstellung (Fortgeschritten)', level: 'B1', category: 'Satzbau', icon: '🏗️',
    rule: 'TeKaMoLo: Temporal, Kausal, Modal, Lokal.',
    explanation: 'Advanced word order follows TeKaMoLo (Time-Cause-Manner-Place). Adverbs and connectors have specific positions.',
    examples: ['Ich fahre morgen wegen der Arbeit schnell nach Berlin.', 'Er hat gestern aus Langeweile allein im Park gesessen.', 'Deshalb muss er heute unbedingt ins Büro gehen.'],
    progress: 10,
  ),

  // ─── B2 ──────────────────────────────────────────────────────────────────

  GrammarTopicView(
    id: 'g31', title: 'Konjunktiv I', level: 'B2', category: 'Konjunktiv', icon: '📰',
    rule: 'Infinitivstamm + -e, -est, -e, -en, -et, -en. Für indirekte Rede in formellen Texten.',
    explanation: 'Konjunktiv I is fully used in B2 for indirect speech in news, academic texts, and formal communications. If identical to Indikativ, use Konjunktiv II.',
    examples: ['Der Minister sagte, die Lage sei ernst.', 'Experten behaupten, das Klima werde sich verändern.', 'Er sagte, er habe kein Geld.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g32', title: 'Konjunktiv II (Fortgeschritten)', level: 'B2', category: 'Konjunktiv', icon: '💭',
    rule: 'Vergangenheit: hätte/wäre + P.II. Als ob + Konj. II.',
    explanation: 'Advanced Konjunktiv II covers past irreality, als ob constructions, and würde as alternative to archaic forms.',
    examples: ['Wenn ich das gewusst hätte, wäre ich gekommen.', 'Er tut so, als ob er alles wüsste.', 'Hätte ich mehr gelernt, hätte ich bestanden.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g8', title: 'Passiv', level: 'B2', category: 'Zeiten', icon: '⏰',
    rule: 'Vorgangspassiv: werden + Partizip II / Zustandspassiv: sein + Partizip II',
    explanation: 'German has two types of passive. Vorgangspassiv (process) uses \'werden\' + past participle. Zustandspassiv (state) uses \'sein\' + past participle.',
    examples: ['Das Auto wird repariert. (Vorgang)', 'Das Auto ist repariert. (Zustand)', 'Der Brief wurde gestern geschrieben.', 'Die Tür ist geöffnet.'],
    progress: 10,
  ),

  GrammarTopicView(
    id: 'g33', title: 'Partizipialkonstruktionen', level: 'B2', category: 'Verben', icon: '📐',
    rule: 'Partizip I/II als erweiterte Attribute, ersetzen Relativsätze.',
    explanation: 'Participial constructions replace relative clauses in formal writing. Extended attributive structures place modifiers before the participle.',
    examples: ['Die am Fenster stehende Frau ist meine Chefin.', 'Vom Regen überrascht, blieb er zu Hause.', 'Die kürzlich renovierte Wohnung sieht toll aus.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g34', title: 'Erweiterte Nebensätze (B2)', level: 'B2', category: 'Nebensätze', icon: '🔗',
    rule: 'indem, wodurch, wobei, insofern, während (Kontrast).',
    explanation: 'B2 introduces sophisticated conjunctions: indem (by doing), wodurch (through which), wobei (whereby), während (contrast).',
    examples: ['Man lernt, indem man viel übt.', 'Er verdient gut, wobei er nicht viel arbeitet.', 'Während er Sport liebt, hasst sie Bewegung.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g35', title: 'Nominalstil', level: 'B2', category: 'Satzbau', icon: '🏛️',
    rule: 'Nominale Ausdrücke ersetzen Nebensätze in formellen Texten.',
    explanation: 'Nominal style replaces verb phrases with noun phrases. Characteristic of academic, legal, and formal German.',
    examples: ['Nach der Analyse der Daten...', 'Aufgrund des Kostenanstiegs...', 'Trotz des schlechten Wetters...'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g36', title: 'Konnektoren', level: 'B2', category: 'Satzbau', icon: '🔗',
    rule: 'allerdings, dennoch, hingegen, folglich, somit, außerdem.',
    explanation: 'Sophisticated adverbial connectors for argumentation: contrast (allerdings, dennoch), consequence (folglich, somit), addition (außerdem).',
    examples: ['Die Preise sind gestiegen; allerdings sind die Löhne gleich geblieben.', 'Dennoch gingen wir spazieren.', 'Folglich steigen auch die Preise.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g45', title: 'Genitiv-Präpositionen', level: 'B2', category: 'Präpositionen', icon: '📍',
    rule: 'trotz, wegen, während, aufgrund, anstatt, innerhalb, außerhalb + Genitiv.',
    explanation: 'Many prepositions require the Genitiv case, especially in formal and written German.',
    examples: ['Trotz des schlechten Wetters gingen wir spazieren.', 'Wegen der Verspätung verpasste er den Termin.', 'Innerhalb eines Jahres hat er Deutsch gelernt.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g46', title: 'Doppelkonnektoren', level: 'B2', category: 'Satzbau', icon: '🔗',
    rule: 'nicht nur...sondern auch, sowohl...als auch, weder...noch, entweder...oder, zwar...aber.',
    explanation: 'Two-part connectors create sophisticated sentence structures for correlating ideas, contrasting, or listing.',
    examples: ['Er spricht nicht nur Deutsch, sondern auch Französisch.', 'Sowohl der Chef als auch die Mitarbeiter sind zufrieden.', 'Weder das Essen noch der Service war gut.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g47', title: 'Passiversatzformen', level: 'B2', category: 'Verben', icon: '⏰',
    rule: 'Alternativen zum Passiv: man, sich lassen, sein + zu + Inf, -bar/-lich.',
    explanation: 'German offers several alternatives to the passive voice: \'man\' (impersonal), \'sich lassen\' (can be done), \'sein + zu + Infinitiv\' (must/can be done).',
    examples: ['Man spricht hier Deutsch.', 'Das lässt sich leicht erklären.', 'Die Aufgabe ist bis morgen zu erledigen.', 'Das Problem ist lösbar.'],
    progress: 5,
  ),

  GrammarTopicView(
    id: 'g48', title: 'Funktionsverbgefüge', level: 'B2', category: 'Verben', icon: '⚙️',
    rule: 'Verb + Nomen ersetzen einfache Verben: zur Verfügung stellen = bereitstellen.',
    explanation: 'Fixed verb-noun combinations common in formal German. The verb is \'light\' and the noun carries the meaning.',
    examples: ['Ich stelle Ihnen die Daten zur Verfügung.', 'Er hat eine Entscheidung getroffen.', 'Sie nimmt Einfluss auf die Politik.'],
    progress: 5,
  ),

  // ─── C1 ──────────────────────────────────────────────────────────────────

  GrammarTopicView(
    id: 'g49', title: 'Modalpartikeln', level: 'C1', category: 'Partikeln', icon: '💬',
    rule: 'doch, mal, ja, eben, halt, wohl, schon, eigentlich — unbetonte Nuancen.',
    explanation: 'Modal particles add emotional nuance, attitude, or emphasis. They are unstressed, have no direct translation, and are essential for natural-sounding German.',
    examples: ['Komm doch mal her!', 'Das ist ja interessant!', 'Das ist eben so.', 'Er wird wohl kommen.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g50', title: 'Subjektive Modalverben', level: 'C1', category: 'Verben', icon: '🔧',
    rule: 'Modalverben drücken Vermutung aus: muss (sicher), dürfte (wahrscheinlich), kann (möglich).',
    explanation: 'Modal verbs have subjective meanings expressing degrees of certainty: müssen (certain), dürfen (probable), können (possible).',
    examples: ['Er muss krank sein. (= sicher)', 'Sie dürfte schon da sein. (= wahrscheinlich)', 'Das kann stimmen. (= möglich)', 'Er will das nicht gewusst haben.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g51', title: 'Nomen-Verb-Verbindungen', level: 'C1', category: 'Verben', icon: '🔗',
    rule: 'Feste Verbindungen: in Betracht ziehen, Bescheid geben, in Kauf nehmen.',
    explanation: 'Fixed noun-verb collocations essential in formal/academic German. The verb is often \'light\' and the noun carries meaning.',
    examples: ['Ich ziehe das in Betracht.', 'Bitte geben Sie mir Bescheid.', 'Das müssen wir in Kauf nehmen.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g52', title: 'Erweiterte Passivformen', level: 'C1', category: 'Zeiten', icon: '⏰',
    rule: 'Subjektloses Passiv, bekommen-Passiv, Passiv in allen Zeiten.',
    explanation: 'Advanced passive includes: subjektloses Passiv (Es wird getanzt), bekommen/kriegen-Passiv (recipient passive), and passive in all tenses.',
    examples: ['Hier wird nicht geraucht!', 'Es wurde die ganze Nacht getanzt.', 'Er bekommt das Buch geschenkt.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g53', title: 'Weiterführende Nebensätze', level: 'C1', category: 'Nebensätze', icon: '🔗',
    rule: 'was, wo, worüber, weshalb als Relativpronomen. Freie Relativsätze.',
    explanation: 'Advanced relative clauses use \'was\' (whole clauses, indefinites, superlatives), \'wo\' (places/times), and wo(r)-compounds.',
    examples: ['Er hat bestanden, was mich freut.', 'Das Beste, was passieren kann.', 'Die Stadt, wo ich geboren bin.', 'Das ist etwas, worüber wir reden müssen.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g54', title: 'Apposition', level: 'C1', category: 'Satzbau', icon: '📋',
    rule: 'Einschub, der ein Nomen näher bestimmt. Steht im gleichen Kasus.',
    explanation: 'An apposition is a noun phrase placed next to another noun to explain or identify it. It takes the same case as the noun it refers to.',
    examples: ['Berlin, die Hauptstadt Deutschlands, ist groß.', 'Herr Müller, unser neuer Chef, kommt aus München.', 'Ich sprach mit Frau Schmidt, der Leiterin.'],
    progress: 0,
  ),

  GrammarTopicView(
    id: 'g55', title: 'Komplexe Attribute', level: 'C1', category: 'Satzbau', icon: '📐',
    rule: 'Erweiterte Attribute vor dem Nomen, typisch für Fachsprache.',
    explanation: 'Complex pre-noun attributes compress relative clauses into extended adjective/participle phrases. Very common in academic and legal texts.',
    examples: ['die seit langem diskutierte Frage', 'der von allen unterschriebene Vertrag', 'das in der letzten Sitzung beschlossene Gesetz'],
    progress: 0,
  ),
];

const grammarLevels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];

const grammarCategories = [
  'Alle', 'Artikel', 'Satzbau', 'Fälle', 'Pronomen', 'Zeiten',
  'Verben', 'Präpositionen', 'Adjektive', 'Nebensätze', 'Konjunktiv', 'Partikeln',
];
