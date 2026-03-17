import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Exercise type model ─────────────────────────────────────────────────────
class _ExType {
  const _ExType({required this.type, required this.label, required this.icon, required this.gradient, required this.count});
  final String type, label, icon;
  final List<Color> gradient;
  final int count;
}

const _exTypes = [
  _ExType(type: 'all',             label: 'Alle Übungen',    icon: '📝', gradient: [Color(0xFF3B82F6), Color(0xFF9333EA)], count: 30),
  _ExType(type: 'multiple-choice', label: 'Multiple Choice', icon: '🔘', gradient: [Color(0xFF818CF8), Color(0xFF4F46E5)], count: 12),
  _ExType(type: 'fill-blank',      label: 'Lückentext',      icon: '✍️', gradient: [Color(0xFF2DD4BF), Color(0xFF0D9488)], count: 8),
  _ExType(type: 'sentence-order',  label: 'Satzordnung',     icon: '🔀', gradient: [Color(0xFFFBBF24), Color(0xFFD97706)], count: 5),
  _ExType(type: 'business-dialog', label: 'Business Dialog', icon: '💼', gradient: [Color(0xFFFB7185), Color(0xFFE11D48)], count: 5),
];

const _levels = ['Alle', 'A1', 'A2', 'B1', 'B2'];

// Simplified exercise model — connect to your actual provider
class _Exercise {
  const _Exercise({required this.id, required this.type, required this.level, required this.question, required this.options, required this.correctAnswer, required this.topic});
  final String id, type, level, question, topic;
  final List<String> options;
  final int correctAnswer;
}

final _sampleExercises = [
  const _Exercise(id: 'e1', type: 'multiple-choice', level: 'A1', topic: 'Artikel',
    question: 'Welcher Artikel ist richtig? ___ Mann arbeitet hier.',
    options: ['Der', 'Die', 'Das', 'Den'], correctAnswer: 0),
  const _Exercise(id: 'e2', type: 'multiple-choice', level: 'A1', topic: 'Verben',
    question: 'Was bedeutet "arbeiten"?',
    options: ['to eat', 'to work', 'to sleep', 'to walk'], correctAnswer: 1),
  const _Exercise(id: 'e3', type: 'multiple-choice', level: 'A2', topic: 'Perfekt',
    question: 'Perfekt von "gehen":',
    options: ['hat gegangen', 'ist gegangen', 'hat gegangt', 'ist gegangt'], correctAnswer: 1),
  const _Exercise(id: 'e4', type: 'multiple-choice', level: 'A2', topic: 'Dativ',
    question: 'Richtige Form: Ich gebe ___ Mann das Buch.',
    options: ['der', 'die', 'dem', 'den'], correctAnswer: 2),
  const _Exercise(id: 'e5', type: 'multiple-choice', level: 'B1', topic: 'Konjunktiv',
    question: 'Höfliche Bitte: ___ Sie mir bitte helfen?',
    options: ['Können', 'Könnten', 'Konnte', 'Kann'], correctAnswer: 1),
];

enum _ExState { select, playing, feedback, results }

// ─── ExercisePage ─────────────────────────────────────────────────────────────
class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});
  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  _ExState _state = _ExState.select;
  String _selectedLevel = 'Alle';
  List<_Exercise> _exercises = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;
  List<bool> _answers = [];

  void _startExercise(String type) {
    var filtered = _sampleExercises.toList();
    if (type != 'all') filtered = filtered.where((e) => e.type == type).toList();
    if (_selectedLevel != 'Alle') filtered = filtered.where((e) => e.level == _selectedLevel).toList();
    if (filtered.isEmpty) filtered = _sampleExercises.take(5).toList();
    filtered.shuffle();
    setState(() {
      _exercises = filtered;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _score = 0;
      _answers = [];
      _state = _ExState.playing;
    });
  }

  void _handleAnswer(int idx) {
    if (_selectedAnswer != null) return;
    final correct = idx == _exercises[_currentIndex].correctAnswer;
    setState(() {
      _selectedAnswer = idx;
      _isCorrect = correct;
      if (correct) _score++;
      _answers.add(correct);
      _state = _ExState.feedback;
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _exercises.length) {
      setState(() => _state = _ExState.results);
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isCorrect = null;
        _state = _ExState.playing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textMuted   = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final cardColor   = isDark ? const Color(0xFF0F172A) : Colors.white;
    final surfaceColor= isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    switch (_state) {
      case _ExState.select:
        return _buildSelect(isDark, textPrimary, textMuted, cardColor);
      case _ExState.playing:
      case _ExState.feedback:
        return _buildPlaying(isDark, textPrimary, textMuted, cardColor, surfaceColor);
      case _ExState.results:
        return _buildResults(isDark, textPrimary, textMuted, cardColor);
    }
  }

  // ── SELECT SCREEN ─────────────────────────────────────────────────────────
  Widget _buildSelect(bool isDark, Color textPrimary, Color textMuted, Color cardColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          _BackButton(isDark: isDark, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Übungen ✏️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary)),
            Text('Tests & Quiz', style: TextStyle(fontSize: 12, color: textMuted)),
          ]),
        ]),

        const SizedBox(height: 18),

        // Level filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _levels.map((lvl) {
            final sel = lvl == _selectedLevel;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedLevel = lvl),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? const LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)]) : null,
                    color: sel ? null : cardColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(sel ? 0.15 : 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Text(lvl, style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: sel ? Colors.white : textMuted,
                  )),
                ),
              ),
            );
          }).toList()),
        ),

        const SizedBox(height: 20),

        Text('Übungstypen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 12),

        // Exercise type cards
        ..._exTypes.map((et) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _startExercise(et.type),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: et.gradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: et.gradient.first.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 5))],
                  ),
                  child: Row(children: [
                    Text(et.icon, style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(et.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text('${et.count} Fragen', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
                    ])),
                    Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.6), size: 22),
                  ]),
                ),
              ),
            )),

        const SizedBox(height: 4),

        // Tips card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tipps', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 12),
            ...[
              (const Color(0xFFDBEAFE), const Color(0xFF3B82F6), '🎯', 'Lies die Frage sorgfältig durch'),
              (const Color(0xFFDCFCE7), const Color(0xFF22C55E), '⚡', 'Jede richtige Antwort = +10 XP'),
              (const Color(0xFFFEF3C7), const Color(0xFFF59E0B), '⚠️', '100% Score = Konfetti-Belohnung!'),
            ].asMap().entries.map((e) {
              final (bg, fg, icon, text) = e.value;
              return Padding(
                padding: EdgeInsets.only(top: e.key > 0 ? 10 : 0),
                child: Row(children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(icon, style: const TextStyle(fontSize: 15))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: textMuted))),
                ]),
              );
            }),
          ]),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ── PLAYING / FEEDBACK SCREEN ─────────────────────────────────────────────
  Widget _buildPlaying(bool isDark, Color textPrimary, Color textMuted, Color cardColor, Color surfaceColor) {
    final ex = _exercises[_currentIndex];
    final progress = (_currentIndex + 1) / _exercises.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(children: [
        // Top bar
        Row(children: [
          _BackButton(isDark: isDark, onTap: () => setState(() => _state = _ExState.select)),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFB923C)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('${_currentIndex + 1}/${_exercises.length}',
              style: TextStyle(fontSize: 12, color: textMuted)),
        ]),

        const SizedBox(height: 16),

        // Type/level badges
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(100)),
            child: Text(_typeLabel(ex.type), style: TextStyle(fontSize: 11, color: textMuted)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(ex.level, style: const TextStyle(fontSize: 11, color: Color(0xFF3B82F6))),
          ),
        ]),

        const SizedBox(height: 16),

        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Text(ex.question,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w500, color: textPrimary)),
        ),

        const SizedBox(height: 16),

        // Answer options
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ex.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, idx) {
              Color bg; Color textColor; Color circleBg; String circleLabel;

              if (_selectedAnswer == null) {
                bg = cardColor;
                textColor = textPrimary;
                circleBg = surfaceColor;
                circleLabel = String.fromCharCode(65 + idx);
              } else if (idx == ex.correctAnswer) {
                bg = isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4);
                textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);
                circleBg = const Color(0xFF22C55E);
                circleLabel = '✓';
              } else if (idx == _selectedAnswer && _isCorrect == false) {
                bg = isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2);
                textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
                circleBg = const Color(0xFFEF4444);
                circleLabel = '✗';
              } else {
                bg = cardColor;
                textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
                circleBg = surfaceColor;
                circleLabel = String.fromCharCode(65 + idx);
              }

              return GestureDetector(
                onTap: () => _handleAnswer(idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: idx == ex.correctAnswer && _selectedAnswer != null
                          ? const Color(0xFF22C55E)
                          : idx == _selectedAnswer && _isCorrect == false
                              ? const Color(0xFFEF4444)
                              : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: circleBg, borderRadius: BorderRadius.circular(100)),
                      child: Center(child: Text(circleLabel,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: _selectedAnswer != null && (idx == ex.correctAnswer || idx == _selectedAnswer)
                                  ? Colors.white : textMuted))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ex.options[idx],
                        style: TextStyle(fontSize: 14, color: textColor))),
                  ]),
                ),
              );
            },
          ),
        ),

        // Feedback + Next button
        if (_state == _ExState.feedback) ...[
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isCorrect == true
                  ? (isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4))
                  : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Text(_isCorrect == true ? '🎉' : '💡', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Text(
                _isCorrect == true
                    ? 'Richtig! Gut gemacht!'
                    : 'Die richtige Antwort ist: ${_exercises[_currentIndex].options[_exercises[_currentIndex].correctAnswer]}',
                style: TextStyle(fontSize: 13,
                    color: _isCorrect == true
                        ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
                        : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))),
              )),
            ]),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _nextQuestion,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  _currentIndex + 1 >= _exercises.length ? 'Ergebnis anzeigen' : 'Nächste Frage',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
              ]),
            ),
          ),
        ],
      ]),
    );
  }

  // ── RESULTS SCREEN ────────────────────────────────────────────────────────
  Widget _buildResults(bool isDark, Color textPrimary, Color textMuted, Color cardColor) {
    final pct = _exercises.isEmpty ? 0 : ((_score / _exercises.length) * 100).round();
    final wrong = _exercises.length - _score;
    final xpEarned = _score * 10;

    final ringColor = pct >= 80
        ? const Color(0xFF22C55E)
        : pct >= 50 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(children: [
        Row(children: [
          _BackButton(isDark: isDark, onTap: () => setState(() => _state = _ExState.select)),
          const SizedBox(width: 12),
          Text('Ergebnis', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary)),
        ]),

        const SizedBox(height: 24),

        // Score ring
        SizedBox(
          width: 160, height: 160,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 160, height: 160,
              child: CircularProgressIndicator(
                value: pct / 100,
                strokeWidth: 12,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation(ringColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$pct%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textPrimary)),
              Text('Ergebnis', style: TextStyle(fontSize: 12, color: textMuted)),
            ]),
          ]),
        ),

        const SizedBox(height: 20),

        Text(pct == 100 ? '🏆' : pct >= 80 ? '🎉' : pct >= 50 ? '👍' : '💪',
            style: const TextStyle(fontSize: 34)),
        const SizedBox(height: 6),
        Text(pct == 100 ? 'Perfekt! Unglaublich!' : pct >= 80 ? 'Sehr gut gemacht!' : pct >= 50 ? 'Gut! Weiter üben!' : 'Nicht aufgeben!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary)),

        const SizedBox(height: 20),

        // Stats row
        Row(children: [
          Expanded(child: _ResultStat(value: '$_score', label: 'Richtig',
              bg: isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4),
              fg: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))),
          const SizedBox(width: 10),
          Expanded(child: _ResultStat(value: '$wrong', label: 'Falsch',
              bg: isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2),
              fg: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))),
          const SizedBox(width: 10),
          Expanded(child: _ResultStat(value: '+$xpEarned', label: 'XP',
              bg: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
              fg: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))),
        ]),

        const SizedBox(height: 24),

        // Retry button
        GestureDetector(
          onTap: () => setState(() => _state = _ExState.select),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFFFB923C).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Nochmal versuchen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ]),
          ),
        ),

        const SizedBox(height: 12),

        // Home button
        GestureDetector(
          onTap: () => context.go('/'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Center(child: Text('Zurück zum Home',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary))),
          ),
        ),
      ]),
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'multiple-choice': return 'Multiple Choice';
      case 'fill-blank':      return 'Lückentext';
      case 'sentence-order':  return 'Satzordnung';
      case 'business-dialog': return 'Business Dialog';
      default:                return t;
    }
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;
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

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.value, required this.label, required this.bg, required this.fg});
  final String value, label;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: fg.withOpacity(0.7))),
        ]),
      );
}
