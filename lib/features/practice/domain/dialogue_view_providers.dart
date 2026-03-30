import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/features/practice/domain/models/dialogue_models.dart';
import 'package:deutschmate_mobile/features/practice/domain/repositories/dialogue_repository.dart';

/// The currently selected CEFR language level for filtering dialogues.
/// Default value is 'Alle' (All).
final selectedDialogueLevelProvider = StateProvider<String>((ref) => 'Alle');

/// The currently selected thematic category for filtering dialogues.
/// Default value is 'Alle' (All).
final selectedDialogueCategoryProvider = StateProvider<String>((ref) => 'Alle');

/// Whether the advanced category filter bar is currently expanded.
final dialogueShowFiltersProvider = StateProvider<bool>((ref) => false);

/// Available CEFR levels supported by the dialogue system.
const dialogueLevels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];

/// Dynamically discovers and caches all unique categories from the current dialogues.
/// This ensures the filter UI always displays available content categories.
final availableDialogueCategoriesProvider = Provider<List<String>>((ref) {
  final dialoguesAsync = ref.watch(dialoguesListProvider);
  return dialoguesAsync.whenData((list) {
    // Extract unique categories and sort alphabetically
    final cats = list.map((d) => d.category).toSet().toList();
    cats.sort();
    return ['Alle', ...cats];
  }).value ?? ['Alle'];
});

/// Reactive provider that returns the list of dialogues filtered by both 
/// [selectedDialogueLevelProvider] and [selectedDialogueCategoryProvider].
final filteredDialoguesProvider = Provider<AsyncValue<List<DialogueInfo>>>((ref) {
  final dialoguesAsync = ref.watch(dialoguesListProvider);
  final level = ref.watch(selectedDialogueLevelProvider);
  final category = ref.watch(selectedDialogueCategoryProvider);
  
  return dialoguesAsync.whenData((list) {
    var filtered = list;
    
    // Filter by Level if a specific one is selected
    if (level != 'Alle') {
      filtered = filtered.where((d) => d.level == level).toList();
    }
    
    // Filter by Category if a specific one is selected
    if (category != 'Alle') {
      filtered = filtered.where((d) => d.category == category).toList();
    }
    
    return filtered;
  });
});
