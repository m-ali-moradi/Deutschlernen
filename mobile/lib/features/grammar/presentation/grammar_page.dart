import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import 'grammar_seed.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  String selectedLevel = 'Alle';
  String selectedCategory = 'Alle';
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
    final filtered = grammarTopicsSeed.where((topic) {
      if (selectedLevel != 'Alle' && topic.level != selectedLevel) {
        return false;
      }
      if (selectedCategory != 'Alle' && topic.category != selectedCategory) {
        return false;
      }
      return true;
    }).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              showFilters: showFilters,
              onBack: () => context.go('/'),
              onToggleFilters: () => setState(() => showFilters = !showFilters),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final level in grammarLevels)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: level,
                        selected: selectedLevel == level,
                        activeGradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
                        ),
                        onTap: () => setState(() => selectedLevel = level),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              crossFadeState: showFilters
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in grammarCategories)
                      _FilterChip(
                        label: category,
                        selected: selectedCategory == category,
                        activeColor: const Color(0xFFA855F7),
                        onTap: () =>
                            setState(() => selectedCategory = category),
                      ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                alignment: Alignment.center,
                child: Text(
                  '🔍 Keine Themen gefunden',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppTokens.darkTextMuted
                            : AppTokens.lightTextMuted,
                      ),
                ),
              )
            else
              for (final topic in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => context.go('/grammar/${topic.id}'),
                    borderRadius: AppTokens.radius20,
                    child: Ink(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
                        borderRadius: AppTokens.radius20,
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.18)
                                : const Color(0xFFE2E8F0)
                                    .withValues(alpha: 0.7),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: _categoryGradient(topic.category),
                            ),
                            child: Text(topic.icon,
                                style: const TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        topic.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: isDark
                                                  ? AppTokens.darkText
                                                  : AppTokens.lightText,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1E3A8A)
                                                .withValues(alpha: 0.35)
                                            : const Color(0xFFDBEAFE),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        topic.level,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? const Color(0xFFBFDBFE)
                                              : const Color(0xFF1D4ED8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  topic.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isDark
                                            ? AppTokens.darkTextMuted
                                            : AppTokens.lightTextMuted,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: topic.progress / 100,
                                    backgroundColor: isDark
                                        ? const Color(0xFF1F2937)
                                        : const Color(0xFFE5E7EB),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _categoryGradient(topic.category)
                                          .colors
                                          .last,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: isDark
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5F5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  LinearGradient _categoryGradient(String category) {
    switch (category) {
      case 'Artikel':
        return const LinearGradient(
          colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
        );
      case 'Zeiten':
        return const LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
        );
      case 'Nebensatze':
        return const LinearGradient(
          colors: [Color(0xFF2DD4BF), Color(0xFF0F766E)],
        );
      case 'Prapositionen':
        return const LinearGradient(
          colors: [Color(0xFFF472B6), Color(0xFFDB2777)],
        );
      case 'Konjunktiv':
        return const LinearGradient(
          colors: [Color(0xFFC084FC), Color(0xFF7C3AED)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF9CA3AF), Color(0xFF4B5563)],
        );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showFilters,
    required this.onBack,
    required this.onToggleFilters,
  });

  final bool showFilters;
  final VoidCallback onBack;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    return Row(
      children: [
        _IconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: onBack,
          backgroundColor: buttonColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grammatik 📘',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          isDark ? AppTokens.darkText : AppTokens.lightText,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'Regeln & Struktur',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTokens.darkTextMuted
                          : AppTokens.lightTextMuted,
                    ),
              ),
            ],
          ),
        ),
        _IconButton(
          icon: Icons.filter_alt_rounded,
          onPressed: onToggleFilters,
          backgroundColor:
              showFilters ? const Color(0xFF3B82F6) : buttonColor,
          iconColor: showFilters ? Colors.white : null,
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius16,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius16,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppTokens.radius16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.activeGradient,
    this.activeColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final LinearGradient? activeGradient;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: selected && activeGradient == null ? activeColor : baseColor,
            gradient: selected ? activeGradient : null,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: (activeColor ?? const Color(0xFF3B82F6))
                          .withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected
                  ? Colors.white
                  : (isDark
                      ? const Color(0xFFCBD5F5)
                      : const Color(0xFF64748B)),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
