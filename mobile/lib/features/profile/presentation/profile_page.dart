import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Achievement model ────────────────────────────────────────────────────────
class _Achievement {
  const _Achievement({required this.id, required this.icon, required this.title, required this.description, required this.unlocked});
  final String id, icon, title, description;
  final bool unlocked;
}

const _achievements = [
  _Achievement(id: 'a1', icon: '🎯', title: 'Erste Schritte',    description: '10 Wörter gelernt',        unlocked: true),
  _Achievement(id: 'a2', icon: '📚', title: 'Wortschatz-Profi', description: '50 Wörter gelernt',         unlocked: true),
  _Achievement(id: 'a3', icon: '🔥', title: 'Streak-Meister',   description: '7 Tage in Folge',           unlocked: true),
  _Achievement(id: 'a4', icon: '💎', title: 'Grammatik-Guru',   description: '10 Grammatikthemen',        unlocked: false),
  _Achievement(id: 'a5', icon: '🏆', title: 'Perfektionist',    description: '100% in einem Test',        unlocked: false),
  _Achievement(id: 'a6', icon: '⭐', title: 'Business-Experte', description: 'Alle Business-Wörter',      unlocked: false),
];

// ─── ProfilePage ──────────────────────────────────────────────────────────────
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _darkMode = false;
  String _language = 'en';
  String _nativeLang = 'en';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textMuted   = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final cardColor   = isDark ? const Color(0xFF0F172A) : Colors.white;

    // Mock stats — replace with Riverpod provider
    const xp = 340;
    const streak = 7;
    const wordsLearned = 42;
    const exercisesDone = 15;
    const grammarDone = 8;
    const weeklyProgress = 68;
    const level = 'A2';
    const weakAreas = ['Dativ', 'Konjunktiv II'];

    final statCards = [
      (label: 'XP Punkte',  value: '$xp',            icon: '⚡', bg: isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8), fg: const Color(0xFFCA8A04)),
      (label: 'Streak',     value: '$streak Tage',    icon: '🔥', bg: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED), fg: const Color(0xFFEA580C)),
      (label: 'Wörter',     value: '$wordsLearned',   icon: '📚', bg: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF), fg: const Color(0xFF2563EB)),
      (label: 'Übungen',    value: '$exercisesDone',  icon: '🎯', bg: isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4), fg: const Color(0xFF16A34A)),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Header ────────────────────────────────────────────────────────
        Row(children: [
          _BackButton(isDark: isDark, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Profil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary)),
            Text('Deine Lernstatistik', style: TextStyle(fontSize: 12, color: textMuted)),
          ]),
        ]),

        const SizedBox(height: 20),

        // ── Level Card (blue→purple→pink gradient) ──────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFFA855F7), Color(0xFFEC4899)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFFA855F7).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(children: [
            // Progress ring (white)
            SizedBox(
              width: 110, height: 110,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 110, height: 110,
                  child: CircularProgressIndicator(
                    value: weeklyProgress / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(level, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text('Level', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7))),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            const Text('Deutsch Lerner', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 4),
            Text('$weeklyProgress% Wochenfortschritt', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _GlassStat(label: 'XP', value: '$xp'),
              const SizedBox(width: 12),
              _GlassStat(label: 'Streak', value: '$streak 🔥'),
              const SizedBox(width: 12),
              _GlassStat(label: 'Grammatik', value: '$grammarDone'),
            ]),
          ]),
        ),

        const SizedBox(height: 20),

        // ── Stats Grid ───────────────────────────────────────────────────
        Text('Statistiken', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.6,
          children: statCards.map((s) => Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(s.label, style: TextStyle(fontSize: 11, color: s.fg.withOpacity(0.8))),
              ]),
              const SizedBox(height: 6),
              Text(s.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: s.fg)),
            ]),
          )).toList(),
        ),

        const SizedBox(height: 20),

        // ── Weak Areas ───────────────────────────────────────────────────
        if (weakAreas.isNotEmpty) ...[
          _SectionCard(
            cardColor: cardColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Text('⚠️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Schwache Bereiche', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
              ]),
              const SizedBox(height: 12),
              ...weakAreas.map((area) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => context.go('/grammar'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF422006) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(child: Text('📘', style: TextStyle(fontSize: 14))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(area, style: TextStyle(fontSize: 14,
                              color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E)))),
                          Icon(Icons.chevron_right_rounded, size: 16,
                              color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFD97706)),
                        ]),
                      ),
                    ),
                  )),
            ]),
          ),
          const SizedBox(height: 16),
        ],

        // ── Achievements ────────────────────────────────────────────────
        _SectionCard(
          cardColor: cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('🏆', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(child: Text('Erfolge', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary))),
              Text('${_achievements.where((a) => a.unlocked).length}/${_achievements.length}',
                  style: TextStyle(fontSize: 12, color: textMuted)),
            ]),
            const SizedBox(height: 12),
            ..._achievements.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Opacity(
                    opacity: a.unlocked ? 1.0 : 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: a.unlocked
                            ? (isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8))
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            gradient: a.unlocked
                                ? const LinearGradient(
                                    colors: [Color(0xFFFDE047), Color(0xFFF59E0B)],
                                    begin: Alignment.topLeft, end: Alignment.bottomRight)
                                : null,
                            color: a.unlocked ? null : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(child: Text(a.icon, style: const TextStyle(fontSize: 20))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text(a.description, style: TextStyle(fontSize: 11, color: textMuted)),
                        ])),
                        if (a.unlocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text('Fertig',
                                style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A))),
                          ),
                      ]),
                    ),
                  ),
                )),
          ]),
        ),

        const SizedBox(height: 16),

        // ── Settings ────────────────────────────────────────────────────
        _SectionCard(
          cardColor: cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Einstellungen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 8),

            // Dark mode toggle
            GestureDetector(
              onTap: () => setState(() => _darkMode = !_darkMode),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  Icon(_darkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      size: 20, color: _darkMode ? const Color(0xFF818CF8) : const Color(0xFFF59E0B)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_darkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(fontSize: 14, color: textPrimary))),
                  // Toggle pill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48, height: 28,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _darkMode ? const Color(0xFF6366F1) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _darkMode ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 4)]),
                      ),
                    ),
                  ),
                ]),
              ),
            ),

            Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),

            // Language
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                const Icon(Icons.language_rounded, size: 20, color: Color(0xFF3B82F6)),
                const SizedBox(width: 12),
                Expanded(child: Text('Sprache', style: TextStyle(fontSize: 14, color: textPrimary))),
                _DropdownSelect(
                  value: _language,
                  items: const {'en': 'English', 'de': 'Deutsch', 'tr': 'Türkçe', 'ar': 'العربية'},
                  isDark: isDark,
                  onChanged: (v) => setState(() => _language = v),
                ),
              ]),
            ),

            Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),

            // Native language
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                const Icon(Icons.translate_rounded, size: 20, color: Color(0xFFA855F7)),
                const SizedBox(width: 12),
                Expanded(child: Text('Muttersprache', style: TextStyle(fontSize: 14, color: textPrimary))),
                _DropdownSelect(
                  value: _nativeLang,
                  items: const {'en': 'English', 'dari': 'دری (Dari)'},
                  isDark: isDark,
                  onChanged: (v) => setState(() => _nativeLang = v),
                ),
              ]),
            ),
          ]),
        ),

        const SizedBox(height: 16),

        // ── App version ──────────────────────────────────────────────────
        const Center(child: Column(children: [
          Text('Deutsch Lernen App v1.0', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          SizedBox(height: 4),
          Text('Made with ❤️ for German learners', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
        ])),
        const SizedBox(height: 8),
      ]),
    );
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

class _GlassStat extends StatelessWidget {
  const _GlassStat({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        ]),
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.cardColor, required this.child});
  final Color cardColor;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: child,
      );
}

class _DropdownSelect extends StatelessWidget {
  const _DropdownSelect({required this.value, required this.items, required this.isDark, required this.onChanged});
  final String value;
  final Map<String, String> items;
  final bool isDark;
  final void Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final fg = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: TextStyle(fontSize: 13, color: fg),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}
