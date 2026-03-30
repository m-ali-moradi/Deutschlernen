import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/localization/app_ui_text.dart';
import '../../../../core/database/database_providers.dart';
import '../../domain/grammar_providers.dart';
import '../../domain/grammar_view_providers.dart';

/// A sleek text input field for filtering grammar topics.
///
/// This widget automatically disappears if `grammarIsSearchingProvider` is false.
/// When visible, it immediately captures focus and updates the global
/// `grammarSearchQueryProvider` on every keystroke, enabling real-time filtering.
class GrammarSearchBar extends ConsumerStatefulWidget {
  const GrammarSearchBar({super.key});

  @override
  ConsumerState<GrammarSearchBar> createState() => _GrammarSearchBarState();
}

class _GrammarSearchBarState extends ConsumerState<GrammarSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current query value so it doesn't
    // blank out if the widget rebuilds.
    _controller =
        TextEditingController(text: ref.read(grammarSearchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(grammarIsSearchingProvider);
    if (!isSearching) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: _controller,
        onChanged: (val) =>
            ref.read(grammarSearchQueryProvider.notifier).state = val,
        autofocus: true,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: strings.translate(
            de: 'Suchen...',
            en: 'Search...',
            fa: 'جستجو...',
          ),
          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
          prefixIcon: Icon(Icons.search,
              color: isDark ? Colors.white54 : Colors.black54),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
