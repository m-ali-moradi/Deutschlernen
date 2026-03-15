import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Grammatik 📘',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => showFilters = !showFilters),
                  icon: Icon(showFilters
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final level in grammarLevels)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(level),
                        selected: selectedLevel == level,
                        onSelected: (_) =>
                            setState(() => selectedLevel = level),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
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
                      ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) =>
                            setState(() => selectedCategory = category),
                      ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),
            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: const Text('🔍 Keine Themen gefunden'),
              )
            else
              for (final topic in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => context.go('/grammar/${topic.id}'),
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
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
                                    Expanded(child: Text(topic.title)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(topic.level,
                                          style: const TextStyle(fontSize: 11)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(topic.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: topic.progress / 100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded),
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
            colors: [Color(0xFF60A5FA), Color(0xFF2563EB)]);
      case 'Zeiten':
        return const LinearGradient(
            colors: [Color(0xFFFBBF24), Color(0xFFD97706)]);
      case 'Nebensatze':
        return const LinearGradient(
            colors: [Color(0xFF2DD4BF), Color(0xFF0F766E)]);
      case 'Prapositionen':
        return const LinearGradient(
            colors: [Color(0xFFF472B6), Color(0xFFDB2777)]);
      case 'Konjunktiv':
        return const LinearGradient(
            colors: [Color(0xFFC084FC), Color(0xFF7C3AED)]);
      default:
        return const LinearGradient(
            colors: [Color(0xFF9CA3AF), Color(0xFF4B5563)]);
    }
  }
}
