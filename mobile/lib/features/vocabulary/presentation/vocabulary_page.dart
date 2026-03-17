import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'vocabulary_data.dart';

// ─── Category display config ──────────────────────────────────────────────────
class _CatConfig {
  const _CatConfig({required this.name, required this.icon, required this.colors});
  final String name, icon;
  final List<Color> colors;
}

const _catConfigs = [
  // ── Session 1 ──────────────────────────────────────────────────────────
  _CatConfig(name: 'Büro & Verwaltung',         icon: '🏢', colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
  _CatConfig(name: 'E-Mail & Korrespondenz',     icon: '📧', colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)]),
  _CatConfig(name: 'Meetings & Präsentationen',  icon: '🤝', colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
  _CatConfig(name: 'Bewerbung & Karriere',       icon: '💼', colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
  _CatConfig(name: 'Alltag Deutsch',             icon: '🌍', colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
  _CatConfig(name: 'Telefon & Kommunikation',    icon: '📞', colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
  // ── Session 2 ──────────────────────────────────────────────────────────
  _CatConfig(name: 'IT & Technik',               icon: '💻', colors: [Color(0xFF06B6D4), Color(0xFF0891B2)]),
  _CatConfig(name: 'Finanzen',                   icon: '💰', colors: [Color(0xFF10B981), Color(0xFF059669)]),
  _CatConfig(name: 'Verträge & Recht',           icon: '📋', colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
  _CatConfig(name: 'Marketing & Vertrieb',       icon: '📢', colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
  // ── Session 3 ──────────────────────────────────────────────────────────
  _CatConfig(name: 'Bildung & Schule',           icon: '🎓', colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)]),
  _CatConfig(name: 'Visum & Behörden',           icon: '🏛️', colors: [Color(0xFF475569), Color(0xFF1E293B)]),
  _CatConfig(name: 'Ausbildung & Praktikum',     icon: '🔧', colors: [Color(0xFFD97706), Color(0xFFB45309)]),
  _CatConfig(name: 'Jobsuche & Bewerbung',       icon: '🔍', colors: [Color(0xFF059669), Color(0xFF047857)]),
];

// ─── Riverpod state ───────────────────────────────────────────────────────────
// Simple in-memory state — replace with Drift-backed provider when ready
final _vocabProvider = StateNotifierProvider<_VocabNotifier, List<VocabWord>>(
  (ref) => _VocabNotifier(),
);

class _VocabNotifier extends StateNotifier<List<VocabWord>> {
  _VocabNotifier() : super(vocabularyData.map((w) => w.copyWith()).toList());

  void toggleFavorite(String id) {
    state = state.map((w) => w.id == id ? w.copyWith(isFavorite: !w.isFavorite) : w).toList();
  }

  void setDifficulty(String id, String difficulty) {
    state = state.map((w) => w.id == id ? w.copyWith(difficulty: difficulty) : w).toList();
  }
}

// ─── Phrases data ─────────────────────────────────────────────────────────────
const _phrases = [
  (german: 'Sehr geehrte Damen und Herren',     english: 'Dear Sir or Madam',                 dari: 'خانم‌ها و آقایان محترم',             tag: 'Formal'),
  (german: 'Mit freundlichen Grüßen',           english: 'Kind regards',                       dari: 'با احترام',                          tag: 'Formal'),
  (german: 'Könnten Sie mir bitte helfen?',     english: 'Could you please help me?',          dari: 'آیا می‌توانید کمکم کنید؟',           tag: 'Polite'),
  (german: 'Ich möchte mich vorstellen',        english: 'I would like to introduce myself',   dari: 'می‌خواهم خودم را معرفی کنم',         tag: 'Meeting'),
  (german: 'Wie besprochen...',                 english: 'As discussed...',                    dari: 'طوری که بحث شد...',                   tag: 'Email'),
  (german: 'Im Anhang finden Sie...',           english: 'Please find attached...',            dari: 'در پیوست می‌یابید...',                tag: 'Email'),
  (german: 'Ich bin für Rückfragen erreichbar', english: 'I am available for further questions',dari: 'من برای سوالات بیشتر در دسترس هستم', tag: 'Email'),
  (german: 'Vielen Dank für Ihre Nachricht',    english: 'Thank you for your message',         dari: 'تشکر از پیام شما',                    tag: 'Email'),
  (german: 'Ich würde gerne einen Termin vereinbaren', english: 'I\'d like to schedule an appointment', dari: 'می‌خواهم وقت ملاقات تعیین کنم', tag: 'Meeting'),
  (german: 'Darf ich kurz unterbrechen?',       english: 'May I briefly interrupt?',           dari: 'آیا می‌توانم کمی صحبت شما را قطع کنم؟', tag: 'Meeting'),
  (german: 'Was halten Sie davon?',             english: 'What do you think about it?',        dari: 'نظر شما چیست؟',                       tag: 'Meeting'),
  (german: 'Entschuldigung für die Verspätung', english: 'Sorry for the delay',                dari: 'ببخشید بخاطر تأخیر',                  tag: 'Polite'),
  (german: 'Ich bin damit einverstanden',       english: 'I agree with that',                  dari: 'من با این موافق هستم',                 tag: 'Meeting'),
  (german: 'Könnten wir das auf morgen verschieben?', english: 'Could we postpone to tomorrow?', dari: 'آیا می‌توانیم به فردا موکول کنیم؟', tag: 'Meeting'),
  (german: 'Ich melde mich so schnell wie möglich', english: 'I will get back to you ASAP',   dari: 'هر چه زودتر با شما تماس می‌گیرم',    tag: 'Email'),
  (german: 'Bezugnehmend auf unser Gespräch...', english: 'Referring to our conversation...', dari: 'با اشاره به گفتگوی ما...',             tag: 'Email'),
  (german: 'Ich freue mich auf die Zusammenarbeit', english: 'I look forward to collaborating', dari: 'من مشتاق همکاری هستم',              tag: 'Formal'),
  (german: 'Wann passt es Ihnen am besten?',   english: 'When suits you best?',               dari: 'چه وقت برای شما مناسب‌تر است؟',       tag: 'Polite'),
  (german: 'Für weitere Informationen stehe ich gerne zur Verfügung', english: 'For further info please contact me', dari: 'برای اطلاعات بیشتر در دسترس هستم', tag: 'Formal'),
  (german: 'Ich bestätige den Eingang Ihrer E-Mail', english: 'I confirm receipt of your email', dari: 'دریافت ایمیل شما را تأیید می‌کنم', tag: 'Email'),
];

// ─── VocabularyPage ───────────────────────────────────────────────────────────
class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({super.key});
  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends ConsumerState<VocabularyPage> {
  String _tab = 'words';
  String _search = '';
  String? _selectedCategory;
  bool _flashcardMode = false;
  VocabWord? _selectedWord;
  int _flashcardIndex = 0;
  bool _isFlipped = false;
  bool _isDari = false;

  final _tabs = const [
    ('words', 'Wörter'), ('phrases', 'Phrasen'),
    ('favorites', 'Favoriten'), ('difficult', 'Schwierig'),
  ];

  List<VocabWord> _filtered(List<VocabWord> words) {
    return words.where((w) {
      if (_tab == 'favorites' && !w.isFavorite) return false;
      if (_tab == 'difficult' && !w.isDifficult) return false;
      if (_selectedCategory != null && w.category != _selectedCategory) return false;
      if (_search.isNotEmpty) {
        final s = _search.toLowerCase();
        if (!w.german.toLowerCase().contains(s) &&
            !w.english.toLowerCase().contains(s) &&
            !w.dari.contains(s)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(_vocabProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_flashcardMode) return _buildFlashcard(isDark, words);
    if (_selectedWord != null) return _buildWordDetail(isDark, words);
    return _buildMain(isDark, words);
  }

  // ── MAIN VIEW ─────────────────────────────────────────────────────────────
  Widget _buildMain(bool isDark, List<VocabWord> allWords) {
    final tp   = isDark ? Colors.white : const Color(0xFF111827);
    final tm   = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final card = isDark ? const Color(0xFF0F172A) : Colors.white;
    final tabBg= isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final filtered = _filtered(allWords);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Header ──────────────────────────────────────────────────────
        Row(children: [
          _BackBtn(isDark: isDark, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Wortschatz 📚', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: tp)),
            Text('${allWords.length} Wörter · ${_catConfigs.length} Kategorien',
                style: TextStyle(fontSize: 12, color: tm)),
          ])),
          // Lang toggle
          _LangToggle(isDari: _isDari, isDark: isDark, card: card, tp: tp,
              onTap: () => setState(() => _isDari = !_isDari)),
        ]),

        const SizedBox(height: 14),

        // ── Search ──────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))]),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: TextStyle(fontSize: 14, color: isDark ? Colors.white : const Color(0xFF111827)),
            decoration: InputDecoration(
              hintText: 'Wort suchen auf Deutsch oder English...',
              hintStyle: TextStyle(color: tm, fontSize: 13),
              prefixIcon: Icon(Icons.search_rounded, color: tm, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Tabs ─────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: tabBg, borderRadius: BorderRadius.circular(16)),
          child: Row(children: _tabs.map((t) {
            final active = _tab == t.$1;
            final count = t.$1 == 'favorites' ? allWords.where((w) => w.isFavorite).length
                        : t.$1 == 'difficult' ? allWords.where((w) => w.isDifficult).length
                        : null;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() { _tab = t.$1; _selectedCategory = null; _search = ''; }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? card : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6, offset: const Offset(0, 2))] : null,
                  ),
                  child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(t.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                        color: active ? const Color(0xFF2563EB) : tm)),
                    if (count != null && count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFF2563EB) : tm,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text('$count', style: const TextStyle(fontSize: 9, color: Colors.white)),
                      ),
                    ],
                  ])),
                ),
              ),
            );
          }).toList()),
        ),

        const SizedBox(height: 16),

        // ── Phrases tab ──────────────────────────────────────────────────
        if (_tab == 'phrases')
          ..._buildPhrases(isDark, tp, tm, card)

        // ── Category grid (words home) ───────────────────────────────────
        else if (_tab == 'words' && _selectedCategory == null && _search.isEmpty)
          ..._buildCategoryGrid(isDark, allWords, tp, tm, card)

        // ── Word list ────────────────────────────────────────────────────
        else ...[
          // Category breadcrumb
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedCategory = null),
                  child: const Text('Alle Kategorien', style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6))),
                ),
                const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF94A3B8)),
                Expanded(child: Text(_selectedCategory!, style: TextStyle(fontSize: 13, color: tp),
                    overflow: TextOverflow.ellipsis)),
                Text('${filtered.length} Wörter', style: TextStyle(fontSize: 12, color: tm)),
              ]),
            ),

          if (_search.isNotEmpty && filtered.isEmpty)
            Center(child: Padding(padding: const EdgeInsets.only(top: 32),
              child: Text('Keine Wörter gefunden', style: TextStyle(fontSize: 14, color: tm))))
          else
            ..._buildWordList(filtered, isDark, allWords, tp, tm, card),
        ],

        const SizedBox(height: 8),
      ]),
    );
  }

  // ── Category grid ─────────────────────────────────────────────────────────
  List<Widget> _buildCategoryGrid(bool isDark, List<VocabWord> allWords, Color tp, Color tm, Color card) {
    return [
      // Flashcard CTA
      GestureDetector(
        onTap: () => setState(() { _flashcardMode = true; _flashcardIndex = 0; _isFlipped = false; }),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(children: [
            const Text('🎴', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Flashcard-Modus', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${allWords.length} Karten', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
            ])),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
          ]),
        ),
      ),

      const SizedBox(height: 20),

      Text('Kategorien', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: tp)),
      const SizedBox(height: 12),

      GridView.count(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: 1.45, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: _catConfigs.map((cat) {
          final count = wordCountForCategory(cat.name);
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat.name),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: cat.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: cat.colors.first.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(cat.icon, style: const TextStyle(fontSize: 22)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cat.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('$count Wörter', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7))),
                ]),
              ]),
            ),
          );
        }).toList(),
      ),
    ];
  }

  // ── Word list ──────────────────────────────────────────────────────────────
  List<Widget> _buildWordList(List<VocabWord> filtered, bool isDark, List<VocabWord> allWords, Color tp, Color tm, Color card) {
    return filtered.map((w) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedWord = w),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: card, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(w.german, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tp))),
                _DiffDot(w.difficulty),
              ]),
              const SizedBox(height: 2),
              Text(_isDari ? w.dari : w.english, style: TextStyle(fontSize: 12, color: tm),
                  textDirection: _isDari ? TextDirection.rtl : TextDirection.ltr),
              const SizedBox(height: 4),
              Row(children: [
                _TagPill(w.tag, isDark: isDark),
                const SizedBox(width: 6),
                _TagPill(w.category.split(' & ').first, isDark: isDark, muted: true),
              ]),
            ])),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref.read(_vocabProvider.notifier).toggleFavorite(w.id),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(w.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                    size: 20, color: w.isFavorite ? const Color(0xFFEF4444) : tm),
              ),
            ),
          ]),
        ),
      ),
    )).toList();
  }

  // ── Phrases ────────────────────────────────────────────────────────────────
  List<Widget> _buildPhrases(bool isDark, Color tp, Color tm, Color card) {
    return _phrases.map((p) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p.german, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tp))),
            _TagPill(p.tag, isDark: isDark),
          ]),
          const SizedBox(height: 5),
          Text(_isDari ? p.dari : p.english, style: TextStyle(fontSize: 12, color: tm),
              textDirection: _isDari ? TextDirection.rtl : TextDirection.ltr),
        ]),
      ),
    )).toList();
  }

  // ── WORD DETAIL ────────────────────────────────────────────────────────────
  Widget _buildWordDetail(bool isDark, List<VocabWord> allWords) {
    final w   = _selectedWord!;
    final tp  = isDark ? Colors.white : const Color(0xFF111827);
    final tm  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final card= isDark ? const Color(0xFF0F172A) : Colors.white;
    final cat = _catConfigs.firstWhere((c) => c.name == w.category, orElse: () => _catConfigs.first);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _BackBtn(isDark: isDark, onTap: () => setState(() => _selectedWord = null)),
          const Spacer(),
          GestureDetector(
            onTap: () => ref.read(_vocabProvider.notifier).toggleFavorite(w.id),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Icon(w.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  size: 18, color: w.isFavorite ? const Color(0xFFEF4444) : tm),
            ),
          ),
        ]),
        const SizedBox(height: 16),

        // Header card — uses category color
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: cat.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: [
            Text(w.german, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(w.phonetic, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.65))),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _PillWhite(w.tag),
              const SizedBox(width: 8),
              _PillWhite(w.category.split(' ').first),
            ]),
          ]),
        ),
        const SizedBox(height: 14),

        _DetailCard(card: card, title: _isDari ? 'دری' : 'English',
            child: Text(_isDari ? w.dari : w.english,
                style: TextStyle(fontSize: 15, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151)),
                textDirection: _isDari ? TextDirection.rtl : TextDirection.ltr)),
        const SizedBox(height: 10),

        _DetailCard(card: card, title: 'Beispielsatz', child:
            Text('"${w.example}"', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151)))),
        const SizedBox(height: 10),

        _DetailCard(card: card, title: 'Kontext', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_isDari ? w.contextDari : w.context,
              style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151)),
              textDirection: _isDari ? TextDirection.rtl : TextDirection.ltr),
        ])),
        const SizedBox(height: 10),

        // Difficulty selector
        _DetailCard(card: card, title: 'Schwierigkeit', child:
          Row(children: ['easy', 'medium', 'hard'].map((d) {
            final sel = w.difficulty == d;
            final label = d == 'easy' ? 'Leicht' : d == 'medium' ? 'Mittel' : 'Schwer';
            final color = d == 'easy' ? const Color(0xFF22C55E) : d == 'medium' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
            final bg    = d == 'easy'
                ? (isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4))
                : d == 'medium'
                ? (isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8))
                : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2));
            return Expanded(child: Padding(
              padding: EdgeInsets.only(right: d != 'hard' ? 8 : 0),
              child: GestureDetector(
                onTap: () => ref.read(_vocabProvider.notifier).setDifficulty(w.id, d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? color : bg,
                    borderRadius: BorderRadius.circular(12),
                    border: sel ? null : Border.all(color: color.withOpacity(0.3), width: 1.5),
                  ),
                  child: Center(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : color))),
                ),
              ),
            ));
          }).toList()),
        ),
        const SizedBox(height: 14),

        // Flashcard button
        GestureDetector(
          onTap: () => setState(() { _flashcardMode = true; _selectedWord = null; _flashcardIndex = 0; _isFlipped = false; }),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: cat.colors),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: cat.colors.first.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: const Center(child: Text('Flashcard starten',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ),
      ]),
    );
  }

  // ── FLASHCARD MODE ─────────────────────────────────────────────────────────
  Widget _buildFlashcard(bool isDark, List<VocabWord> allWords) {
    final words = _filtered(allWords).isNotEmpty ? _filtered(allWords) : allWords;
    if (words.isEmpty) return const Center(child: Text('Keine Wörter'));
    final w = words[_flashcardIndex % words.length];
    final cat = _catConfigs.firstWhere((c) => c.name == w.category, orElse: () => _catConfigs.first);
    final tm  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _BackBtn(isDark: isDark, onTap: () => setState(() { _flashcardMode = false; _flashcardIndex = 0; _isFlipped = false; })),
          Text('${(_flashcardIndex % words.length) + 1} / ${words.length}',
              style: TextStyle(fontSize: 13, color: tm)),
        ]),
        const SizedBox(height: 14),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: ((_flashcardIndex % words.length) + 1) / words.length,
            minHeight: 8,
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation(cat.colors.first),
          ),
        ),

        const SizedBox(height: 8),
        Text(w.category, style: TextStyle(fontSize: 11, color: tm), textAlign: TextAlign.center),
        const SizedBox(height: 20),

        // Card
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isFlipped = !_isFlipped),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => _FlipTransition(turns: anim, child: child),
              child: _isFlipped
                  ? _FlashBack(key: const ValueKey('b'), word: w, isDari: _isDari)
                  : _FlashFront(key: const ValueKey('f'), word: w, colors: cat.colors),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Difficulty buttons
        Row(children: [
          Expanded(child: _DiffBtn(label: 'Schwer', emoji: '❌',
              bg: isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2), fg: const Color(0xFFEF4444),
              onTap: () => _nextCard('hard', words))),
          const SizedBox(width: 10),
          Expanded(child: _DiffBtn(label: 'Mittel', emoji: '🤔',
              bg: isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8), fg: const Color(0xFFF59E0B),
              onTap: () => _nextCard('medium', words))),
          const SizedBox(width: 10),
          Expanded(child: _DiffBtn(label: 'Leicht', emoji: '✅',
              bg: isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4), fg: const Color(0xFF22C55E),
              onTap: () => _nextCard('easy', words))),
        ]),
        const SizedBox(height: 8),
      ]),
    );
  }

  void _nextCard(String difficulty, List<VocabWord> words) {
    final w = words[_flashcardIndex % words.length];
    ref.read(_vocabProvider.notifier).setDifficulty(w.id, difficulty);
    setState(() {
      _isFlipped = false;
      _flashcardIndex = (_flashcardIndex + 1) % words.length;
    });
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _BackBtn extends StatelessWidget {
  const _BackBtn({required this.isDark, required this.onTap});
  final bool isDark; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 16,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151)),
        ),
      );
}

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.isDari, required this.isDark, required this.card, required this.tp, required this.onTap});
  final bool isDari, isDark; final Color card, tp; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2))]),
          child: Row(children: [
            const Icon(Icons.translate_rounded, size: 15, color: Color(0xFF3B82F6)),
            const SizedBox(width: 5),
            Text(isDari ? 'دری' : 'EN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: tp)),
          ]),
        ),
      );
}

class _TagPill extends StatelessWidget {
  const _TagPill(this.label, {required this.isDark, this.muted = false});
  final String label; final bool isDark, muted;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: muted
              ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
              : (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(label, style: TextStyle(fontSize: 10,
            color: muted ? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)) : const Color(0xFF2563EB))),
      );
}

class _PillWhite extends StatelessWidget {
  const _PillWhite(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
        child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
      );
}

class _DiffDot extends StatelessWidget {
  const _DiffDot(this.d);
  final String d;
  @override
  Widget build(BuildContext context) {
    final c = d == 'easy' ? const Color(0xFF22C55E) : d == 'hard' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
    return Container(width: 8, height: 8, margin: const EdgeInsets.only(left: 6), decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.card, required this.title, required this.child});
  final Color card; final String title; final Widget child;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280))),
        const SizedBox(height: 6),
        child,
      ]),
    );
  }
}

class _DiffBtn extends StatelessWidget {
  const _DiffBtn({required this.label, required this.emoji, required this.bg, required this.fg, required this.onTap});
  final String label, emoji; final Color bg, fg; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg)),
          ]),
        ),
      );
}

// Flashcard widgets
class _FlashFront extends StatelessWidget {
  const _FlashFront({super.key, required this.word, required this.colors});
  final VocabWord word; final List<Color> colors;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: colors.first.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Deutsch', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 14),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(word.german, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center)),
          const SizedBox(height: 8),
          Text(word.phonetic, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 24),
          Text('Tippen zum Umdrehen', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4))),
        ]),
      );
}

class _FlashBack extends StatelessWidget {
  const _FlashBack({super.key, required this.word, required this.isDari});
  final VocabWord word; final bool isDari;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF0D9488)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(isDari ? 'دری' : 'English', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 14),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(isDari ? word.dari : word.english,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center,
                textDirection: isDari ? TextDirection.rtl : TextDirection.ltr)),
          const SizedBox(height: 16),
          Container(margin: const EdgeInsets.symmetric(horizontal: 28), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
              child: Text(word.example, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)), textAlign: TextAlign.center)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
              child: Text(word.tag, style: const TextStyle(fontSize: 11, color: Colors.white))),
        ]),
      );
}

class _FlipTransition extends AnimatedWidget {
  const _FlipTransition({required Animation<double> turns, required this.child}) : super(listenable: turns);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final v = (listenable as Animation<double>).value;
    return Transform(transform: Matrix4.rotationY((1 - v) * 3.14159), alignment: Alignment.center, child: child);
  }
}
