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
    title: 'Satzbau Grundlagen',
    level: 'A1',
    category: 'Satzbau',
    icon: '🧱',
    rule: 'Im Aussagesatz steht das konjugierte Verb an Position 2.',
    explanation:
        'Die erste Position kann durch Subjekt, Zeit oder Ort besetzt werden. Bei Ja/Nein-Fragen steht das Verb an Position 1, bei W-Fragen steht das Fragewort an Position 1. Imperativformen nutzen eine kurze Verbform. Konjunktionen wie und, oder, aber, denn verbinden Hauptsaetze ohne die Wortstellung zu veraendern.',
    examples: [
      'Ich lerne heute Deutsch.',
      'Heute lerne ich Deutsch.',
      'Kommst du morgen?',
      'Warum lernst du Deutsch?',
      'Komm bitte hierher!',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g2',
    title: 'Nomen & Artikel',
    level: 'A1',
    category: 'Artikel & Nomen',
    icon: '📘',
    rule: 'Artikel zeigen Genus und Numerus: der/die/das, im Plural die.',
    explanation:
        'Jedes Nomen hat ein Genus und bildet den Plural oft mit -e, -er, -n/-en oder -s (manchmal mit Umlaut). Der bestimmte Artikel wird genutzt, wenn etwas bekannt ist; der unbestimmte Artikel (ein/eine) fuer Neues. Kein verneint Nomen und dekliniert wie ein.',
    examples: [
      'Der Tisch ist neu.',
      'Eine Lampe steht im Zimmer.',
      'Die Kinder spielen draussen.',
      'Ich habe keine Zeit.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g3',
    title: 'Kasus Grundlagen',
    level: 'A1',
    category: 'Kasus',
    icon: '⚖️',
    rule: 'Nominativ = Subjekt, Akkusativ = direktes Objekt, Dativ = indirektes Objekt.',
    explanation:
        'Der Kasus zeigt die Rolle im Satz. Im Akkusativ aendert sich der Artikel (der -> den). Der Dativ wird oft mit Praepositionen wie mit, nach, aus, bei, von, zu verwendet.',
    examples: [
      'Der Mann sieht den Hund.',
      'Die Frau gibt dem Kind einen Apfel.',
      'Ich fahre mit dem Bus.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g4',
    title: 'Pronomen Grundlagen',
    level: 'A1',
    category: 'Pronomen',
    icon: '👤',
    rule: 'Pronomen ersetzen Nomen; ihre Form richtet sich nach dem Kasus.',
    explanation:
        'Personalpronomen: ich, du, er/sie/es, wir, ihr, sie. Possessivpronomen wie mein/dein zeigen Besitz und passen sich an das Nomen an. Fragepronomen wer/was werden je nach Kasus gebeugt.',
    examples: [
      'Ich sehe dich.',
      'Das ist mein Buch.',
      'Wen siehst du?',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g5',
    title: 'Verben im Praesens',
    level: 'A1',
    category: 'Verben',
    icon: '🔧',
    rule: 'Praesens: Verbstamm + Endungen (-e, -st, -t, -en).',
    explanation:
        'Regelmaessige Verben folgen den Standardendungen. Unregelmaessige Verben wie sein und haben haben eigene Formen. Modalverben stellen den Infinitiv ans Satzende, und bei trennbaren Verben steht die Vorsilbe am Ende.',
    examples: [
      'Ich arbeite, du arbeitest, er arbeitet.',
      'Ich bin muede und habe Zeit.',
      'Ich kann heute kommen.',
      'Ich stehe um 7 Uhr auf.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g6',
    title: 'Zeitformen A1',
    level: 'A1',
    category: 'Zeiten',
    icon: '⏰',
    rule: 'Perfekt = haben/sein + Partizip II.',
    explanation:
        'Das Praesens beschreibt Gegenwart und nahe Zukunft. Das Perfekt wird fuer die Vergangenheit im Gespraech genutzt. Bewegungsverben und Zustandswechsel nehmen oft sein.',
    examples: [
      'Ich lerne Deutsch.',
      'Ich habe Deutsch gelernt.',
      'Sie ist nach Berlin gefahren.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g7',
    title: 'Praepositionen A1',
    level: 'A1',
    category: 'Prapositionen',
    icon: '📍',
    rule: 'Einige Praepositionen verlangen Akkusativ oder Dativ.',
    explanation:
        'Akkusativ-Praepositionen: durch, fuer, ohne, gegen, um. Dativ-Praepositionen: mit, nach, aus, bei, von, zu. Der Kasus ist fest.',
    examples: [
      'Ich gehe durch den Park.',
      'Wir fahren mit dem Auto.',
      'Er kommt aus der Schule.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g8',
    title: 'Adjektive A1',
    level: 'A1',
    category: 'Adjektive',
    icon: '🎨',
    rule: 'Nach sein/werden/bleiben steht das Adjektiv ohne Endung.',
    explanation:
        'Praedikative Adjektive bleiben unveraendert. In einfachen Nominalphrasen erscheinen oft nur -e oder -en als Endung.',
    examples: [
      'Das Wetter ist gut.',
      'Der gute Kaffee schmeckt.',
      'Ich sehe einen guten Film.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g9',
    title: 'Zeitformen A2',
    level: 'A2',
    category: 'Zeiten',
    icon: '⏰',
    rule: 'A2 erweitert die Vergangenheit und Zukunft.',
    explanation:
        'Perfekt wird vollstaendig verwendet. Praeteritum nutzt man vor allem bei sein, haben und Modalverben. Futur I drueckt Plan oder Vermutung aus; Plusquamperfekt beschreibt Vorvergangenheit.',
    examples: [
      'Ich hatte gegessen, bevor er kam.',
      'Sie war gestern krank.',
      'Ich werde morgen arbeiten.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g10',
    title: 'Satzbau A2',
    level: 'A2',
    category: 'Satzbau',
    icon: '🧱',
    rule: 'Inversion setzt Zeit/Ort nach vorn, das Verb bleibt auf Position 2.',
    explanation:
        'Bei zwei Verbformen entsteht die Verbklammer: konjugiertes Verb vorne, Infinitiv/Partizip am Ende. Das gilt auch fuer Modalverben.',
    examples: [
      'Morgens trinke ich Kaffee.',
      'Ich kann heute nicht kommen.',
      'Ich habe den Film gesehen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g11',
    title: 'Nebensaetze A2',
    level: 'A2',
    category: 'Nebensatze',
    icon: '🔗',
    rule: 'Im Nebensatz steht das konjugierte Verb am Ende.',
    explanation:
        'Wichtige Konjunktionen: weil (Grund), dass (Inhalt), wenn (Bedingung/haeufig), obwohl (Gegensatz), waehrend (Zeit/Gegensatz), bevor/nachdem (Zeitfolge), als (einmalige Vergangenheit).',
    examples: [
      'Ich bleibe zu Hause, weil ich krank bin.',
      'Sie sagt, dass sie kommt.',
      'Als ich jung war, wohnte ich in Wien.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g12',
    title: 'Relativsaetze A2',
    level: 'A2',
    category: 'Relativsatze',
    icon: '🧵',
    rule: 'Relativpronomen der/die/das passen sich an Genus und Kasus an.',
    explanation:
        'Der Relativsatz erklaert ein Nomen. Der Kasus haengt von der Funktion im Relativsatz ab (Nominativ, Akkusativ, Dativ).',
    examples: [
      'Das ist der Mann, der dort steht.',
      'Ich sehe den Mann, den du kennst.',
      'Das ist die Frau, der ich helfe.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g13',
    title: 'Infinitivkonstruktionen A2',
    level: 'A2',
    category: 'Infinitivkonstruktionen',
    icon: '➰',
    rule: 'Zu-Infinitiv erweitert Verben, um/ohne/anstatt zu zeigen Zweck oder Alternative.',
    explanation:
        'Zu + Infinitiv folgt oft auf Verben wie versuchen, hoffen, planen. Um ... zu drueckt Zweck aus, ohne ... zu Verneinung, anstatt ... zu Alternative.',
    examples: [
      'Ich versuche, mehr zu lesen.',
      'Ich lerne, um die Pruefung zu bestehen.',
      'Er ging, ohne zu bezahlen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g14',
    title: 'Passiv A2',
    level: 'A2',
    category: 'Passiv',
    icon: '🏗️',
    rule: 'Passiv: werden + Partizip II.',
    explanation:
        'Im Perfekt Passiv steht: ist/hat + Partizip II + worden. Das Passiv betont die Handlung, nicht die handelnde Person.',
    examples: [
      'Der Vertrag wird unterschrieben.',
      'Die Aufgabe ist erledigt worden.',
      'Die Daten werden gespeichert.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g15',
    title: 'Verben A2',
    level: 'A2',
    category: 'Verben',
    icon: '🔧',
    rule: 'Reflexive Verben und Praepositionalverben fordern feste Formen.',
    explanation:
        'Reflexive Verben nutzen sich/mich/dich. Praepositionalverben bestimmen den Kasus. Trennbare und untrennbare Praefixe veraendern Bedeutung und Betonung.',
    examples: [
      'Ich interessiere mich fuer Musik.',
      'Wir warten auf den Bus.',
      'Er versteht den Text.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g16',
    title: 'Kasus & Wechselpraepositionen',
    level: 'A2',
    category: 'Kasus',
    icon: '⚖️',
    rule: 'Wechselpraepositionen: Akkusativ bei Bewegung, Dativ bei Lage.',
    explanation:
        'In, an, auf, ueber, unter, vor, hinter, neben, zwischen sind zweiwegig. Dativ wird ausserdem nach bestimmten Verben wie helfen, danken, gefallen genutzt.',
    examples: [
      'Ich lege das Buch auf den Tisch.',
      'Das Buch liegt auf dem Tisch.',
      'Ich helfe dem Freund.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g17',
    title: 'Adjektivdeklination',
    level: 'A2',
    category: 'Adjektive',
    icon: '🎨',
    rule: 'Die Adjektivendung zeigt Kasus, Genus und Numerus.',
    explanation:
        'Adjektivdeklination bedeutet: die Endung aendert sich je nach Kasus, Genus und Artikel.\n'
        '\n'
        'Beispiel:\n'
        'der schoene Garten\n'
        'einen schoenen Garten\n'
        'mit einem schoenen Garten\n'
        '\n'
        'Warum? Die grammatische Information steht teils im Artikel, teils am Adjektiv.\n'
        '\n'
        'Schwache Deklination (bestimmter Artikel):\n'
        'Nominativ: der schoene Mann / die schoene Frau / das schoene Haus / die schoenen Haeuser\n'
        'Akkusativ: den schoenen Mann / die schoene Frau / das schoene Haus / die schoenen Haeuser\n'
        'Dativ: dem schoenen Mann / der schoenen Frau / dem schoenen Haus / den schoenen Haeusern\n'
        'Genitiv: des schoenen Mannes / der schoenen Frau / des schoenen Hauses / der schoenen Haeuser\n'
        '\n'
        'Gemischte Deklination (ein/kein/mein/...):\n'
        'Nominativ: ein schoener Mann / eine schoene Frau / ein schoenes Haus / keine schoenen Haeuser\n'
        'Akkusativ: einen schoenen Mann / eine schoene Frau / ein schoenes Haus / keine schoenen Haeuser\n'
        'Dativ: einem schoenen Mann / einer schoenen Frau / einem schoenen Haus / keinen schoenen Haeusern\n'
        'Genitiv: eines schoenen Mannes / einer schoenen Frau / eines schoenen Hauses / keiner schoenen Haeuser\n'
        '\n'
        'Starke Deklination (ohne Artikel):\n'
        'Nominativ: schoener Mann / schoene Frau / schoenes Haus / schoene Haeuser\n'
        'Akkusativ: schoenen Mann / schoene Frau / schoenes Haus / schoene Haeuser\n'
        'Dativ: schoenem Mann / schoener Frau / schoenem Haus / schoenen Haeusern\n'
        'Genitiv: schoenen Mannes / schoener Frau / schoenen Hauses / schoener Haeuser\n'
        '\n'
        'Faustregel: Je weniger der Artikel zeigt, desto staerker die Adjektivendung.',
    examples: [
      'Der grosse Hund schlaeft.',
      'Ich sehe einen grossen Hund.',
      'Mit gutem Wein feiert man gern.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g18',
    title: 'Vergleichsformen',
    level: 'A2',
    category: 'Adjektive',
    icon: '🎨',
    rule: 'Komparativ: -er, Superlativ: am -sten / der/die/das -ste.',
    explanation:
        'Vergleiche nutzen den Komparativ (schneller) und den Superlativ (am schnellsten). Gleichheit und Ungleichheit werden mit genauso ... wie und nicht so ... wie ausgedrueckt.',
    examples: [
      'Berlin ist groesser als Hamburg.',
      'Das ist der beste Kaffee.',
      'Sie ist genauso schnell wie er.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g19',
    title: 'Pronomen A2',
    level: 'A2',
    category: 'Pronomen',
    icon: '👤',
    rule: 'Reflexiv-, Relativ- und Indefinitpronomen richten sich nach dem Kasus.',
    explanation:
        'Reflexivpronomen: mich, dich, sich. Indefinitpronomen wie jemand, niemand, etwas, nichts, man, alle/viele/einige stehen ohne klares Bezugswort.',
    examples: [
      'Ich erinnere mich an den Termin.',
      'Jemand hat angerufen.',
      'Das ist der Kollege, dem ich vertraue.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g20',
    title: 'Konjunktiv II Einfuehrung',
    level: 'A2',
    category: 'Konjunktiv',
    icon: '💭',
    rule: 'Wuerde + Infinitiv drueckt Wuensche, Hoeflichkeit und Irreales aus.',
    explanation:
        'Konjunktiv II wird oft mit wuerde gebildet. Haette/waere/koennte sind wichtige Sonderformen in der Hoeflichkeit.',
    examples: [
      'Ich wuerde gern mehr reisen.',
      'Koennten Sie mir helfen?',
      'Wenn ich Zeit haette, kaeme ich.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g21',
    title: 'Zeitformen B1',
    level: 'B1',
    category: 'Zeiten',
    icon: '⏰',
    rule: 'Plusquamperfekt und Futur II erweitern die Zeitfolge.',
    explanation:
        'Praesens, Perfekt und Praeteritum werden sicher genutzt. Plusquamperfekt beschreibt eine Handlung vor einer anderen Vergangenheit. Futur II zeigt eine abgeschlossene Zukunft oder eine Vermutung.',
    examples: [
      'Ich hatte gegessen, bevor du kamst.',
      'In zwei Stunden werde ich fertig sein.',
      'Er wird schon gegangen sein.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g22',
    title: 'Nebensaetze B1',
    level: 'B1',
    category: 'Nebensatze',
    icon: '🔗',
    rule: 'Neue Konjunktionen praezisieren Zweck, Folge und Zeit.',
    explanation:
        'Damit (Zweck), sodass (Folge), falls (Bedingung), seitdem/solange/sobald (Zeit) und je ... desto (Vergleich) erweitern die Satzverknuepfung.',
    examples: [
      'Ich erklaere es, damit du es verstehst.',
      'Es regnete, sodass wir zu Hause blieben.',
      'Je mehr ich lerne, desto sicherer werde ich.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g23',
    title: 'Konditionalsaetze',
    level: 'B1',
    category: 'Konditionalsaetze',
    icon: '⚙️',
    rule: 'Reale Bedingungen nutzen Indikativ, irreale Konjunktiv II.',
    explanation:
        'Reale Bedingungen beschreiben moegliche Situationen. Irreale Bedingungen beschreiben Hypothesen oder Unmoegliches in Gegenwart oder Vergangenheit.',
    examples: [
      'Wenn es regnet, bleibe ich zu Hause.',
      'Wenn ich Zeit haette, wuerde ich kommen.',
      'Wenn ich mehr gelernt haette, haette ich bestanden.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g24',
    title: 'Konjunktiv II B1',
    level: 'B1',
    category: 'Konjunktiv',
    icon: '💭',
    rule: 'Konjunktiv II beschreibt Wuensche, Hoeflichkeit und Hypothesen.',
    explanation:
        'Wuerde + Infinitiv ist haeufig, aber Formen wie waere, haette, koennte sind sehr wichtig. In der Vergangenheit nutzt man haette/waere + Partizip II.',
    examples: [
      'Ich haette gern einen Termin.',
      'Koennten Sie das wiederholen?',
      'Wenn ich reich waere, wuerde ich reisen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g25',
    title: 'Passiv B1',
    level: 'B1',
    category: 'Passiv',
    icon: '🏗️',
    rule: 'Passiv ist in allen Zeiten moeglich; Modalverben bleiben im Infinitiv.',
    explanation:
        'Passiv kombiniert werden + Partizip II mit dem jeweiligen Tempus. Bei Modalverben steht das Modal konjugiert und das Vollverb im Infinitiv.',
    examples: [
      'Der Bericht wird geschrieben.',
      'Der Bericht wurde geschrieben.',
      'Der Bericht muss geschrieben werden.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g26',
    title: 'Relativsaetze B1',
    level: 'B1',
    category: 'Relativsatze',
    icon: '🧵',
    rule: 'Relativsaetze mit Praepositionen und Genitiv erweitern Details.',
    explanation:
        'Praepositional-Relativsaetze: mit dem, fuer den, an dem. Genitiv-Relativpronomen: dessen/deren.',
    examples: [
      'Das ist die Kollegin, mit der ich arbeite.',
      'Der Mann, dessen Auto gestohlen wurde, ist veraergert.',
      'Die Firma, fuer die sie arbeitet, ist gross.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g27',
    title: 'Wortstellung & Adverbien',
    level: 'B1',
    category: 'Satzbau',
    icon: '🧱',
    rule: 'Im Mittelfeld steht oft Zeit vor Art und Ort.',
    explanation:
        'Bei komplexen Saetzen bleibt das Verb an Position 2 im Hauptsatz. Adverbien folgen haeufig der Reihenfolge: Zeit - Art - Ort. Satzverbinder wie deshalb oder trotzdem belegen Position 1.',
    examples: [
      'Ich habe gestern schnell zu Hause gelernt.',
      'Deshalb gehe ich heute frueh.',
      'Trotzdem bleibe ich noch kurz.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g28',
    title: 'Verben B1',
    level: 'B1',
    category: 'Verben',
    icon: '🔧',
    rule: 'Fortgeschrittene Verben haben feste Praepositionen und Kasus.',
    explanation:
        'Praepositionalverben verlangen oft Akkusativ oder Dativ. Reflexive Verben nutzen sich-Formen. Modalverben im Praeteritum sind sehr haeufig.',
    examples: [
      'Wir warten auf den Zug.',
      'Ich erinnere mich an das Meeting.',
      'Er musste gestern arbeiten.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g29',
    title: 'Partizipien B1',
    level: 'B1',
    category: 'Partizipien',
    icon: '🧩',
    rule: 'Partizip I und II koennen Adjektive ersetzen.',
    explanation:
        'Partizip I beschreibt eine laufende Handlung, Partizip II eine abgeschlossene. Beide koennen attributiv vor Nomen stehen.',
    examples: [
      'der lachende Mann',
      'die geoeffnete Tuer',
      'ein schlafendes Kind',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g30',
    title: 'Nominalisierung B1',
    level: 'B1',
    category: 'Nominalisierung',
    icon: '📝',
    rule: 'Verben und Adjektive koennen substantiviert werden.',
    explanation:
        'Substantivierte Verben und Adjektive werden grossgeschrieben und erhalten Artikel. Das macht Texte formeller.',
    examples: [
      'das Lernen, das Lesen',
      'etwas Gutes, etwas Neues',
      'Beim Arbeiten hoert er Musik.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g31',
    title: 'Indirekte Rede Einfuehrung',
    level: 'B1',
    category: 'Indirekte Rede',
    icon: '🗣️',
    rule: 'Konjunktiv I wird fuer indirekte Rede verwendet.',
    explanation:
        'In der indirekten Rede aendert sich die Verbform: er sagt, er komme; sie sagt, sie habe. Bei Unsicherheit kann auch Konjunktiv II verwendet werden.',
    examples: [
      'Er sagt, er komme spaeter.',
      'Sie meinte, sie habe keine Zeit.',
      'Laut Bericht sei das Problem geloest.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g32',
    title: 'Genitiv',
    level: 'B1',
    category: 'Kasus',
    icon: '⚖️',
    rule: 'Der Genitiv zeigt Besitz oder Zugehoerigkeit.',
    explanation:
        'Genitiv-Artikel: des (mask./neut.), der (fem./pl.). Adjektive und Nomen bekommen oft -s/-es. Praepositionen wie wegen oder trotz verlangen Genitiv.',
    examples: [
      'das Auto des Mannes',
      'die Farbe der Wand',
      'wegen des Wetters',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g33',
    title: 'Zeitformen B2',
    level: 'B2',
    category: 'Zeiten',
    icon: '⏰',
    rule: 'Die Zeitfolge steuert die Wahl der Zeiten im komplexen Satz.',
    explanation:
        'Futur II drueckt eine abgeschlossene Zukunft oder Vermutung aus. In komplexen Saetzen wird das Zeitverhaeltnis konsequent abgebildet.',
    examples: [
      'Bis morgen werde ich den Bericht geschrieben haben.',
      'Er sagte, er sei schon gegangen gewesen.',
      'Sie wird wohl angekommen sein.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g34',
    title: 'Konjunktiv I B2',
    level: 'B2',
    category: 'Konjunktiv',
    icon: '💭',
    rule: 'Konjunktiv I ist die Standardsprache der indirekten Rede.',
    explanation:
        'Im Berichts- und Nachrichtenton wird Konjunktiv I genutzt, um Distanz zu markieren. Wenn Konjunktiv I mit Indikativ identisch ist, nutzt man oft Konjunktiv II.',
    examples: [
      'Der Sprecher erklaerte, er sei bereit.',
      'Sie berichtete, sie habe alles geklaert.',
      'Er sagte, er wuerde spaeter kommen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g35',
    title: 'Konjunktiv II B2',
    level: 'B2',
    category: 'Konjunktiv',
    icon: '💭',
    rule: 'Irreales in der Vergangenheit: haette/waere + Partizip II.',
    explanation:
        'Komplexe Hypothesen nutzen Konjunktiv II in Gegenwart und Vergangenheit. Ersatzformen mit wuerde sind moeglich, sollten aber stilistisch sinnvoll eingesetzt werden.',
    examples: [
      'Wenn ich frueher gelernt haette, haette ich bestanden.',
      'Ich waere gegangen, aber ich war krank.',
      'Er wuerde es anders machen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g36',
    title: 'Passiv B2',
    level: 'B2',
    category: 'Passiv',
    icon: '🏗️',
    rule: 'Vorgangspassiv = werden, Zustandspassiv = sein.',
    explanation:
        'Vorgangspassiv beschreibt die Handlung, Zustandspassiv das Ergebnis. Modalverben lassen sich in allen Zeiten kombinieren.',
    examples: [
      'Der Vertrag wird unterschrieben.',
      'Der Vertrag ist unterschrieben.',
      'Die Aufgabe kann erledigt worden sein.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g37',
    title: 'Partizipialkonstruktionen B2',
    level: 'B2',
    category: 'Partizipien',
    icon: '🧩',
    rule: 'Partizipialsaetze verdichten Informationen.',
    explanation:
        'Partizip I/II koennen Nebensaetze ersetzen und stehen haeufig am Satzanfang. Sie sind typisch fuer schriftliche Texte.',
    examples: [
      'Vom Regen ueberrascht, blieb er zu Hause.',
      'Die laechelnde Frau begruesste uns.',
      'Die gestern eingereichten Dokumente fehlen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g38',
    title: 'Erweiterte Nebensaetze B2',
    level: 'B2',
    category: 'Nebensatze',
    icon: '🔗',
    rule: 'Komplexe Konjunktionen praezisieren Grund, Art und Folge.',
    explanation:
        'Indem beschreibt die Art und Weise, wodurch eine Folge, sodass eine direkte Folge, wobei einen Begleitumstand, insofern eine Einschraenkung. Waehren kann auch einen Gegensatz ausdruecken.',
    examples: [
      'Er loeste das Problem, indem er den Code refaktorierte.',
      'Sie verpasste den Zug, wodurch sie zu spaet kam.',
      'Er arbeitet, waehrend sie pausiert.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g39',
    title: 'Relativsaetze B2',
    level: 'B2',
    category: 'Relativsatze',
    icon: '🧵',
    rule: 'Komplexe Relativsaetze kombinieren Praepositionen und Genitiv.',
    explanation:
        'Fortgeschrittene Relativsaetze nutzen praepositionale Formen und deren/dessen. Mehrere Relativsaetze koennen kombiniert werden.',
    examples: [
      'Das ist der Kunde, mit dem wir ueber den Vertrag sprachen.',
      'Die Firma, deren Umsatz steigt, stellt ein.',
      'Der Bericht, den ich dir geschickt habe, der gestern kam, ist wichtig.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g40',
    title: 'Infinitivkonstruktionen B2',
    level: 'B2',
    category: 'Infinitivkonstruktionen',
    icon: '➰',
    rule: 'Mehrere Infinitive koennen in einem Satz kombiniert werden.',
    explanation:
        'Erweiterte um/ohne/anstatt zu-Konstruktionen enthalten eigene Angaben und Objekte. Mehrfachinfinitive treten oft mit Modalverben auf.',
    examples: [
      'Er versucht, den Vertrag unterschreiben zu lassen.',
      'Sie ging, ohne den Chef zu informieren.',
      'Statt zu warten, beschloss er zu gehen.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g41',
    title: 'Nominalstil B2',
    level: 'B2',
    category: 'Nominalisierung',
    icon: '📝',
    rule: 'Nominalstil verdichtet Aussagen in Substantiven.',
    explanation:
        'Formelle Texte nutzen Nominalisierungen, um Informationen kompakt darzustellen. Das fuehrt zu laengeren Satzgliedern und weniger Verben.',
    examples: [
      'Die Durchfuehrung der Analyse dauerte zwei Tage.',
      'Nach Abschluss der Pruefung erfolgt die Auswertung.',
      'Die Verbesserung der Prozesse ist notwendig.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g42',
    title: 'Praepositionen B2',
    level: 'B2',
    category: 'Prapositionen',
    icon: '📍',
    rule: 'Komplexe Praepositionalphrasen sind typisch fuer formelle Texte.',
    explanation:
        'Beispiele sind im Hinblick auf, in Bezug auf, aufgrund, gemaess, infolge. Diese Praepositionen haben feste Kasus (oft Genitiv).',
    examples: [
      'Im Hinblick auf die Kosten treffen wir eine Entscheidung.',
      'Aufgrund des Wetters faellt das Meeting aus.',
      'In Bezug auf das Angebot rufen wir an.',
    ],
    progress: 0,
  ),
  GrammarTopicView(
    id: 'g43',
    title: 'Textverknuepfung B2',
    level: 'B2',
    category: 'Textverknuepfung',
    icon: '🧲',
    rule: 'Konnektoren strukturieren Argumente und schaffen Kohaesion.',
    explanation:
        'Typische Konnektoren: allerdings, dennoch, hingegen, folglich, somit, ausserdem. Sie stellen Gegensatz, Folge oder Zusatz her.',
    examples: [
      'Er hat viel gelernt; dennoch fiel die Pruefung schwer.',
      'Die Zahlen steigen, folglich investieren wir.',
      'Ich bin muede; ausserdem regnet es.',
    ],
    progress: 0,
  ),
];

const grammarLevels = ['Alle', 'A1', 'A2', 'B1', 'B2'];
const grammarCategories = [
  'Alle',
  'Satzbau',
  'Artikel & Nomen',
  'Kasus',
  'Pronomen',
  'Verben',
  'Zeiten',
  'Prapositionen',
  'Adjektive',
  'Nebensatze',
  'Relativsatze',
  'Infinitivkonstruktionen',
  'Passiv',
  'Konjunktiv',
  'Partizipien',
  'Nominalisierung',
  'Indirekte Rede',
  'Konditionalsaetze',
  'Textverknuepfung',
];
