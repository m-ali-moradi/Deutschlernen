import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Gradient helpers ────────────────────────────────────────────────────────
const _gradPurple   = [Color(0xFF8B5CF6), Color(0xFF6D28D9)]; // from-purple-500 to-purple-700
const _gradBlue     = [Color(0xFF3B82F6), Color(0xFF1D4ED8)]; // from-blue-500 to-blue-700
const _gradOrange   = [Color(0xFFFB923C), Color(0xFFEA580C)]; // from-orange-400 to-orange-600
const _gradChallenge = [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)]; // indigo→purple→pink

// ─── Section card data ───────────────────────────────────────────────────────
class _Section {
  const _Section({required this.route, required this.label, required this.subtitle, required this.icon, required this.gradient});
  final String route, label, subtitle, icon;
  final List<Color> gradient;
}

const _sections = [
  _Section(route: '/grammar',    label: 'Grammar',    subtitle: 'Regeln & Struktur',  icon: '📘', gradient: _gradPurple),
  _Section(route: '/vocabulary', label: 'Vocabulary', subtitle: 'Wörter & Business',  icon: '📚', gradient: _gradBlue),
  _Section(route: '/exercises',  label: 'Exercises',  subtitle: 'Tests & Quiz',        icon: '✏️', gradient: _gradOrange),
];

// ─── HomePage ────────────────────────────────────────────────────────────────
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isDark  = Theme.of(context).brightness == Brightness.dark;

    final cardColor  = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary   = isDark ? Colors.white : const Color(0xFF111827);
    final textMuted     = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final mutedBg       = isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB);

    // Mock stats — replace with Riverpod provider
    const streak = 7;
    const xp = 340;
    const weeklyProgress = 68;
    const wordsLearned = 42;
    const exercisesDone = 15;
    const level = 'A2';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lerne Deutsch 🇩🇪',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: textPrimary)),
                    const SizedBox(height: 2),
                    Text('Willkommen zurück!', style: TextStyle(fontSize: 13, color: textMuted)),
                  ],
                ),
              ),
              // Streak chip
              _Chip(
                icon: '🔥',
                label: '$streak',
                bg: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
                fg: const Color(0xFFEA580C),
              ),
              const SizedBox(width: 8),
              // XP chip
              _Chip(
                icon: '⚡',
                label: '$xp',
                bg: isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8),
                fg: const Color(0xFFCA8A04),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Weekly Progress Card ─────────────────────────────────────────
          _Card(
            color: cardColor,
            child: Row(
              children: [
                _ProgressRing(progress: weeklyProgress / 100, size: 96, label: '$weeklyProgress%', sublabel: 'Woche'),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wochenfortschritt',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _StatMini(label: 'Wörter', value: '$wordsLearned',
                            bg: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                            fg: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))),
                        const SizedBox(width: 8),
                        Expanded(child: _StatMini(label: 'Übungen', value: '$exercisesDone',
                            bg: isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4),
                            fg: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Daily Challenge Card ─────────────────────────────────────────
          _GradCard(
            gradient: _gradChallenge,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('🏆', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text('Tägliche Herausforderung',
                            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
                      ]),
                      const SizedBox(height: 6),
                      const Text('5 Business-Wörter lernen',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('+50 XP Belohnung', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.go('/vocabulary'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(children: [
                      Text('Start', style: TextStyle(fontSize: 13, color: Colors.white)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Colors.white),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Section Cards ────────────────────────────────────────────────
          Text('Lernbereiche',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary)),
          const SizedBox(height: 12),

          ..._sections.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GradCard(
                  gradient: s.gradient,
                  onTap: () => context.go(s.route),
                  child: Row(children: [
                    Text(s.icon, style: const TextStyle(fontSize: 34)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(s.subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                      ],
                    )),
                    Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.6), size: 22),
                  ]),
                ),
              )),

          const SizedBox(height: 4),

          // ── Achievements Preview ─────────────────────────────────────────
          _Card(
            color: cardColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Erfolge', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
                    GestureDetector(
                      onTap: () => context.go('/profile'),
                      child: const Text('Alle anzeigen', style: TextStyle(fontSize: 12, color: Color(0xFF3B82F6))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [
                  ...['🎯', '📚', '🔥', '💎'].asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: e.key < 3
                                ? (isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8))
                                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: e.key < 3 ? 1.0 : 0.4,
                              child: Text(e.value, style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                        ),
                      )),
                  const Spacer(),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('3/6', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
                    Text('freigeschaltet', style: TextStyle(fontSize: 10, color: textMuted)),
                  ]),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Level Badge ──────────────────────────────────────────────────
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Aktuelles Level:', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                const SizedBox(width: 6),
                const Text(level, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ]),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.color});
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: child,
      );
}

class _GradCard extends StatelessWidget {
  const _GradCard({required this.gradient, required this.child, this.onTap});
  final List<Color> gradient;
  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: child,
        ),
      );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.bg, required this.fg});
  final String icon, label;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        ]),
      );
}

class _StatMini extends StatelessWidget {
  const _StatMini({required this.label, required this.value, required this.bg, required this.fg});
  final String label, value;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: fg)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: fg)),
        ]),
      );
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress, required this.size, required this.label, required this.sublabel});
  final double progress;
  final double size;
  final String label, sublabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: size, height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827))),
          Text(sublabel, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ]),
      ]),
    );
  }
}
