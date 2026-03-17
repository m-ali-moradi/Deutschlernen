import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import 'grammar_seed.dart';

// ─── Category gradient colors matching Figma ─────────────────────────────────

List<Color> _categoryGradient(String category) {
  switch (category) {
    case 'Artikel':
    case 'Artikel & Nomen':
      return const [Color(0xFF60A5FA), Color(0xFF2563EB)];
    case 'Satzbau':
      return const [Color(0xFF22D3EE), Color(0xFF0891B2)];
    case 'Fälle':
    case 'Kasus':
      return const [Color(0xFFA78BFA), Color(0xFF7C3AED)];
    case 'Pronomen':
      return const [Color(0xFF2DD4BF), Color(0xFF0D9488)];
    case 'Zeiten':
      return const [Color(0xFFFBBF24), Color(0xFFD97706)];
    case 'Verben':
      return const [Color(0xFF4ADE80), Color(0xFF16A34A)];
    case 'Prapositionen':
    case 'Präpositionen':
      return const [Color(0xFFF472B6), Color(0xFFDB2777)];
    case 'Adjektive':
      return const [Color(0xFFE879F9), Color(0xFFA21CAF)];
    case 'Nebensatze':
    case 'Nebensätze':
      return const [Color(0xFF2DD4BF), Color(0xFF0F766E)];
    case 'Konjunktiv':
      return const [Color(0xFFC084FC), Color(0xFF7C3AED)];
    case 'Partikeln':
      return const [Color(0xFFFB7185), Color(0xFFE11D48)];
    case 'Relativsatze':
    case 'Relativsätze':
      return const [Color(0xFF818CF8), Color(0xFF6366F1)];
    case 'Infinitivkonstruktionen':
      return const [Color(0xFF34D399), Color(0xFF059669)];
    case 'Passiv':
      return const [Color(0xFFFB923C), Color(0xFFEA580C)];
    case 'Indirekte Rede':
      return const [Color(0xFF06B6D4), Color(0xFF0E7490)];
    case 'Konditionalsatze':
    case 'Konditionalsätze':
      return const [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
    case 'Partizipien':
      return const [Color(0xFF6366F1), Color(0xFF4338CA)];
    case 'Nominalisierung':
      return const [Color(0xFFEC4899), Color(0xFFBE185D)];
    case 'Textverknupfung':
    case 'Textverknüpfung':
      return const [Color(0xFF3B82F6), Color(0xFF6366F1)];
    default:
      return const [Color(0xFF9CA3AF), Color(0xFF4B5563)];
  }
}

// ─── GrammarPage ─────────────────────────────────────────────────────────────

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  String _selectedLevel = 'Alle';
  String _selectedCategory = 'Alle';
  bool _showFilters = false;

  static const _levels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];
  static const _categories = ['Alle', 'Artikel', 'Satzbau', 'Fälle', 'Pronomen', 'Zeiten', 'Verben', 'Präpositionen', 'Adjektive', 'Nebensätze', 'Konjunktiv', 'Partikeln'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = grammarTopicsSeed.where((t) {
      if (_selectedLevel != 'Alle' && t.level != _selectedLevel) return false;
      if (_selectedCategory != 'Alle') {
        final cat = _selectedCategory.toLowerCase();
        final tCat = t.category.toLowerCase();
        if (!tCat.contains(cat) && !cat.contains(tCat.split(' ').first)) return false;
      }
      return true;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(children: [
              _IconButton(icon: Icons.arrow_back_rounded, onPressed: () => context.go('/'), isDark: isDark),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Grammatik 📘', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText)),
                const SizedBox(height: 2),
                Text('Regeln & Struktur', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
              ])),
              _IconButton(
                icon: Icons.filter_alt_rounded,
                onPressed: () => setState(() => _showFilters = !_showFilters),
                isDark: isDark,
                active: _showFilters,
              ),
            ]),
            const SizedBox(height: 16),

            // ── Level Filter ──
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _levels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final level = _levels[i];
                  final selected = _selectedLevel == level;
                  return _LevelChip(
                    label: level, selected: selected,
                    onTap: () => setState(() => _selectedLevel = level),
                    isDark: isDark,
                  );
                },
              ),
            ),

            // ── Category Filter (animated) ──
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              crossFadeState: _showFilters ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _categories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFA855F7) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(cat, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: selected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)))),
                      ),
                    );
                  }).toList(),
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // ── Grammar Cards ──
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 48),
                alignment: Alignment.center,
                child: Column(children: [
                  const Text('🔍', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text('Keine Themen gefunden', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
                ]),
              )
            else
              for (final topic in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GrammarCard(topic: topic, isDark: isDark),
                ),
          ],
        ),
      ),
    );
  }
}

// ─── Grammar Card ─────────────────────────────────────────────────────────────

class _GrammarCard extends StatelessWidget {
  const _GrammarCard({required this.topic, required this.isDark});
  final GrammarTopicView topic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final gradient = _categoryGradient(topic.category);
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius20,
      child: InkWell(
        onTap: () => context.go('/grammar/${topic.id}'),
        borderRadius: AppTokens.radius20,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: AppTokens.radius20,
            boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFE2E8F0).withValues(alpha: 0.8), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            // Icon with category gradient
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: gradient.last.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: Text(topic.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(topic.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                // Level badge — blue pill matching Figma
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(topic.level, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1D4ED8))),
                ),
              ]),
              const SizedBox(height: 3),
              Text(topic.category, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
              const SizedBox(height: 8),
              // Progress bar with category gradient
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: topic.progress / 100,
                  minHeight: 5,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation<Color>(gradient.last),
                ),
              ),
            ])),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1), size: 20),
          ]),
        ),
      ),
    );
  }
}

// ─── Level Chip ──────────────────────────────────────────────────────────────

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.label, required this.selected, required this.onTap, required this.isDark});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: selected ? const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFFA855F7)]) : null,
          color: selected ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
          boxShadow: selected
              ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)))),
      ),
    );
  }
}

// ─── Icon Button ─────────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onPressed, required this.isDark, this.active = false});
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius16,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius16,
        child: Ink(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: AppTokens.radius16,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Icon(icon, size: 20, color: active ? Colors.white : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B))),
        ),
      ),
    );
  }
}
