import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';
import '../../database/database_providers.dart';
import 'connectivity_service.dart';
import 'firebase_content_repository.dart';
import 'sync_state.dart';

/// Represents a content item (Grammar, Vocab, or Exercise) that can be either
/// stored locally, available on the cloud, or both.
class SyncEntry<T> {
  final String id;
  final T? localData;
  final Map<String, dynamic>? cloudMetadata;
  final bool isDownloaded;

  SyncEntry({
    required this.id,
    this.localData,
    this.cloudMetadata,
    required this.isDownloaded,
  });

  /// The title or primary text for display.
  String get displayTitle {
    if (localData is GrammarTopic) {
      return (localData as GrammarTopic).title;
    }
    if (localData is VocabularyWord) {
      return (localData as VocabularyWord).german;
    }
    if (localData is Exercise) {
      return (localData as Exercise).question;
    }

    return cloudMetadata?['title'] ??
        cloudMetadata?['german'] ??
        cloudMetadata?['question'] ??
        'Unknown';
  }

  /// The level (A1-C1) for display.
  String get displayLevel {
    if (localData is GrammarTopic) {
      return (localData as GrammarTopic).level;
    }
    if (localData is VocabularyWord) {
      return (localData as VocabularyWord).difficulty;
    }
    if (localData is Exercise) {
      return (localData as Exercise).level;
    }

    return cloudMetadata?['level'] ?? cloudMetadata?['difficulty'] ?? '';
  }

  /// English title for display if available.
  String? get displayEnglishTitle {
    if (localData is GrammarTopic) return null;
    return cloudMetadata?['english_title'] ?? cloudMetadata?['english'];
  }
}

/// A provider that fetches all grammar entries (Local + Cloud).
final hybridGrammarProvider =
    FutureProvider<List<SyncEntry<GrammarTopic>>>((ref) async {
  final localTopics = await ref.watch(localizedGrammarTopicsProvider.future);
  final prefs = ref.watch(userPreferencesStreamProvider).valueOrNull;
  final syncState = ref.watch(syncStateProvider);
  final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;
  final isAutoSync = prefs?.autoSync ?? false;
  final shouldSync = isAutoSync || syncState.manualSyncTriggered;

  if (!isOnline || !shouldSync) {
    return localTopics
        .map((t) => SyncEntry<GrammarTopic>(
              id: t.id,
              localData: t,
              isDownloaded: true,
            ))
        .toList();
  }

  try {
    final cloudMetadata = await ref
        .read(firebaseContentRepositoryProvider)
        .getGrammarTopicsMetadata();

    final Map<String, SyncEntry<GrammarTopic>> merged = {};

    // Add local first
    for (final t in localTopics) {
      merged[t.id] = SyncEntry(id: t.id, localData: t, isDownloaded: true);
    }

    // Merge cloud
    for (final cm in cloudMetadata) {
      final id = cm['id'] as String;
      if (merged.containsKey(id)) {
        // Already local, update metadata if needed
        merged[id] = SyncEntry(
          id: id,
          localData: merged[id]!.localData,
          cloudMetadata: cm,
          isDownloaded: true,
        );
      } else {
        // Cloud only
        merged[id] = SyncEntry(
          id: id,
          cloudMetadata: cm,
          isDownloaded: false,
        );
      }
    }

    return merged.values.toList();
  } catch (e) {
    // If cloud fails, just return local
    return localTopics
        .map((t) => SyncEntry<GrammarTopic>(
              id: t.id,
              localData: t,
              isDownloaded: true,
            ))
        .toList();
  }
});

/// A provider that handles the download action.
final syncServiceProvider = Provider((ref) => SyncService(ref));

/// Keeps vocabulary catalog discovery in sync with manual and auto sync events.
final vocabularyCatalogSyncCoordinatorProvider = Provider<void>((ref) {
  final service = ref.read(syncServiceProvider);
  DateTime? lastManualSyncAt;
  bool autoSyncHasRun = false;
  bool isRunning = false;

  Future<void> runDiscovery() async {
    if (isRunning) return;
    isRunning = true;
    try {
      await service.discoverVocabularyCatalog();
    } finally {
      isRunning = false;
    }
  }

  void maybeRunAutoSync() {
    final autoSync =
        ref.read(userPreferencesStreamProvider).valueOrNull?.autoSync ?? false;
    final isOnline = ref.read(connectivityProvider).valueOrNull ?? false;
    if (autoSync && isOnline && !autoSyncHasRun) {
      autoSyncHasRun = true;
      unawaited(runDiscovery());
    }
    if (!autoSync) {
      autoSyncHasRun = false;
    }
  }

  ref.listen(syncStateProvider, (previous, next) {
    if (next.lastManualSyncAt != null &&
        next.lastManualSyncAt != lastManualSyncAt) {
      lastManualSyncAt = next.lastManualSyncAt;
      if (ref.read(connectivityProvider).valueOrNull ?? false) {
        unawaited(runDiscovery());
      }
    }
  });

  ref.listen(userPreferencesStreamProvider, (previous, next) {
    maybeRunAutoSync();
  });

  ref.listen(connectivityProvider, (previous, next) {
    maybeRunAutoSync();
  });
});

class SyncService {
  final Ref _ref;
  SyncService(this._ref);

  String _normalizeVocabularyGroupId(String groupId) {
    switch (groupId) {
      case 'daily_life_basic':
        return 'daily_life_basics';
      default:
        return groupId;
    }
  }

  Future<void> downloadGrammarTopic(String id, {String languageCode = 'en'}) async {
    final repo = _ref.read(firebaseContentRepositoryProvider);
    final db = _ref.read(appDatabaseProvider);

    final fullData = await repo.getGrammarTopic(id);
    if (fullData == null) return;
    
    final detailData = await repo.getGrammarTopicDetailMap(id, languageCode);

    await db.transaction(() async {
      // Insert base metadata into Drift
      await db.into(db.grammarTopics).insertOnConflictUpdate(
            GrammarTopicsCompanion.insert(
              id: id,
              title: fullData['title'] ?? '',
              level: fullData['level'] ?? '',
              category: fullData['category'] ?? '',
              icon: fullData['icon'] ?? 'book',
              rule: fullData['rule'] ?? '',
              explanation: fullData['explanation'] ?? '',
              examplesJson: fullData['examples_json'] ?? '[]',
            ),
          );

      // Insert translated metadata and payload into GrammarDetails
      if (detailData != null) {
        await db.into(db.grammarDetails).insertOnConflictUpdate(
              GrammarDetailsCompanion.insert(
                topicId: id,
                languageCode: languageCode,
                title: Value(detailData['title'] as String?),
                category: Value(detailData['category'] as String?),
                rule: Value(detailData['rule'] as String?),
                explanation: Value(detailData['explanation'] as String?),
                examplesJson: Value(detailData['examples_json'] as String?),
                detailJson: Value(detailData['detail_json'] as String?),
              ),
            );
      }
    });
  }

  Future<void> downloadVocabularyWord(String id) async {
    final repo = _ref.read(firebaseContentRepositoryProvider);
    final db = _ref.read(appDatabaseProvider);

    final fullData = await repo.getVocabularyWord(id);
    if (fullData == null) return;

    await db.into(db.vocabularyWords).insertOnConflictUpdate(
          VocabularyWordsCompanion.insert(
            id: id,
            german: fullData['german'] ?? '',
            english: fullData['english'] ?? '',
            dari: fullData['dari'] ?? '',
            category: fullData['category'] ?? '',
            tag: fullData['tag'] ?? '',
            example: fullData['example'] ?? '',
            context: fullData['context'] ?? '',
            contextDari: fullData['context_dari'] ?? '',
            difficulty: fullData['difficulty'] ?? 'new',
          ),
        );
  }

  Future<void> discoverVocabularyCatalog() async {
    final isOnline = _ref.read(connectivityProvider).valueOrNull ?? false;
    if (!isOnline) {
      return;
    }

    final repo = _ref.read(firebaseContentRepositoryProvider);
    final db = _ref.read(appDatabaseProvider);

    final remoteGroups = await repo.getVocabularyGroupsMetadata();
    final remoteCategories = await repo.getVocabularyCategoriesMetadata();

    await db.transaction(() async {
      for (final row in remoteGroups) {
        final groupId = _normalizeVocabularyGroupId(
          row['id']?.toString() ?? '',
        );
        if (groupId.isEmpty) continue;
        await db.into(db.vocabularyGroups).insertOnConflictUpdate(
              VocabularyGroupsCompanion.insert(
                id: groupId,
                name: row['name']?.toString() ?? '',
                levelRange: row['levelRange']?.toString() ?? '',
                sortOrder: Value((row['sortOrder'] as num?)?.toInt() ?? 0),
              ),
            );
      }

      final localCategories = await db.select(db.vocabularyCategories).get();
      final localCategoriesById = {
        for (final row in localCategories) row.id: row,
      };
      final pendingCategories =
          await db.select(db.vocabularyPendingCategories).get();
      final pendingCategoriesById = {
        for (final row in pendingCategories) row.id: row,
      };

      for (final row in remoteCategories) {
        final categoryId = row['id']?.toString() ?? '';
        if (categoryId.isEmpty) continue;
        final groupId = _normalizeVocabularyGroupId(
          row['groupId']?.toString() ?? '',
        );

        final int wordCount = (row['wordCount'] as num?)?.toInt() ??
            await repo
                .getVocabularyWordsByCategoryMetadata(categoryId)
                .then((words) => words.length);

        final localCategory = localCategoriesById[categoryId];
        if (localCategory != null) {
          await db.into(db.vocabularyCategories).insertOnConflictUpdate(
                VocabularyCategoriesCompanion.insert(
                  id: categoryId,
                  groupId: localCategory.groupId,
                  name: localCategory.name,
                  icon: localCategory.icon,
                  gradientColorsJson: localCategory.gradientColorsJson,
                  sortOrder: Value(localCategory.sortOrder),
                  wordCount: Value(wordCount),
                  isCached: Value(localCategory.isCached),
                ),
              );
          continue;
        }

        final pendingCategory = pendingCategoriesById[categoryId];
        if (pendingCategory != null) {
          await db.into(db.vocabularyPendingCategories).insertOnConflictUpdate(
                VocabularyPendingCategoriesCompanion.insert(
                  id: categoryId,
                  groupId: pendingCategory.groupId,
                  name: pendingCategory.name,
                  icon: pendingCategory.icon,
                  gradientColorsJson: pendingCategory.gradientColorsJson,
                  sortOrder: Value(pendingCategory.sortOrder),
                  wordCount: Value(wordCount),
                ),
              );
          continue;
        }

        await db.into(db.vocabularyPendingCategories).insertOnConflictUpdate(
              VocabularyPendingCategoriesCompanion.insert(
                id: categoryId,
                groupId: groupId,
                name: row['name']?.toString() ?? '',
                icon: row['icon']?.toString() ?? '',
                gradientColorsJson:
                    jsonEncode(row['colors'] ?? const <dynamic>[]),
                sortOrder: Value((row['sortOrder'] as num?)?.toInt() ?? 0),
                wordCount: Value(wordCount),
              ),
            );
      }
    });

    await _updateVocabularySyncStatus();
  }

  Future<void> downloadVocabularyCategoryGroup(String groupId) async {
    final db = _ref.read(appDatabaseProvider);

    final pendingRows = await (db.select(db.vocabularyPendingCategories)
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .get();

    if (pendingRows.isEmpty) {
      await _updateVocabularySyncStatus();
      return;
    }

    await db.transaction(() async {
      for (final row in pendingRows) {
        await db.into(db.vocabularyCategories).insertOnConflictUpdate(
              VocabularyCategoriesCompanion.insert(
                id: row.id,
                groupId: row.groupId,
                name: row.name,
                icon: row.icon,
                gradientColorsJson: row.gradientColorsJson,
                sortOrder: Value(row.sortOrder),
                wordCount: Value(row.wordCount),
                isCached: const Value(false),
              ),
            );
      }

      await (db.delete(db.vocabularyPendingCategories)
            ..where((tbl) => tbl.groupId.equals(groupId)))
          .go();
    });

    await _updateVocabularySyncStatus();
  }

  Future<void> downloadVocabularyCategory(String categoryId) async {
    final repo = _ref.read(firebaseContentRepositoryProvider);
    final db = _ref.read(appDatabaseProvider);

    final fullData =
        await repo.getVocabularyWordsByCategoryMetadata(categoryId);
    if (fullData.isEmpty) {
      await _updateVocabularySyncStatus();
      return;
    }

    await db.transaction(() async {
      for (final row in fullData) {
        await db.into(db.vocabularyWords).insertOnConflictUpdate(
              VocabularyWordsCompanion.insert(
                id: row['id']?.toString() ?? '',
                german: row['german']?.toString() ?? '',
                english: row['english']?.toString() ?? '',
                dari: row['dari']?.toString() ?? '',
                category: row['category']?.toString() ?? '',
                tag: row['tag']?.toString() ?? '',
                example: row['example']?.toString() ?? '',
                context: row['context']?.toString() ?? '',
                contextDari: row['context_dari']?.toString() ?? '',
                difficulty: row['difficulty']?.toString() ?? 'medium',
                isFavorite: const Value(false),
                isDifficult: Value((row['isDifficult'] as bool?) ?? false),
                level: Value(row['level']?.toString() ?? 'A1'),
              ),
            );
      }

      await (db.update(db.vocabularyCategories)
            ..where((tbl) => tbl.id.equals(categoryId)))
          .write(const VocabularyCategoriesCompanion(
        isCached: Value(true),
      ));
    });

    await _updateVocabularySyncStatus();
  }

  Future<void> _updateVocabularySyncStatus() async {
    final db = _ref.read(appDatabaseProvider);
    final pendingCount = await (db.select(db.vocabularyPendingCategories)
          ..limit(1))
        .get()
        .then((rows) => rows.isEmpty ? 0 : 1);

    _ref.read(syncStateProvider.notifier).setStatus(
          pendingCount > 0 ? SyncStatus.updatesAvailable : SyncStatus.synced,
        );
  }

  Future<void> downloadExercise(String id) async {
    final repo = _ref.read(firebaseContentRepositoryProvider);
    final db = _ref.read(appDatabaseProvider);

    final fullData = await repo.getExercise(id);
    if (fullData == null) return;

    await db.into(db.exercises).insertOnConflictUpdate(
          ExercisesCompanion.insert(
            id: id,
            type: fullData['type'] ?? '',
            question: fullData['question'] ?? '',
            optionsJson: fullData['options_json'] ?? '[]',
            correctAnswer: (fullData['correct_answer'] as num?)?.toInt() ?? 0,
            topic: fullData['topic'] ?? '',
            level: fullData['level'] ?? '',
          ),
        );
  }
}

/// A provider that fetches all vocabulary entries (Local + Cloud).
final hybridVocabularyProvider =
    FutureProvider<List<SyncEntry<VocabularyWord>>>((ref) async {
  final localWords = await ref.watch(vocabularyStreamProvider.future);
  final prefs = ref.watch(userPreferencesStreamProvider).valueOrNull;
  final syncState = ref.watch(syncStateProvider);
  final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;
  final isAutoSync = prefs?.autoSync ?? false;
  final shouldSync = isAutoSync || syncState.manualSyncTriggered;

  if (!isOnline || !shouldSync) {
    return localWords
        .map((t) => SyncEntry<VocabularyWord>(
              id: t.id,
              localData: t,
              isDownloaded: true,
            ))
        .toList();
  }

  try {
    final cloudMetadata = await ref
        .read(firebaseContentRepositoryProvider)
        .getVocabularyWordsMetadata();
    final Map<String, SyncEntry<VocabularyWord>> merged = {};
    for (final t in localWords) {
      merged[t.id] = SyncEntry(id: t.id, localData: t, isDownloaded: true);
    }
    for (final cm in cloudMetadata) {
      final id = cm['id'] as String;
      if (!merged.containsKey(id)) {
        merged[id] = SyncEntry(id: id, cloudMetadata: cm, isDownloaded: false);
      }
    }
    return merged.values.toList();
  } catch (e) {
    return localWords
        .map((t) => SyncEntry<VocabularyWord>(
            id: t.id, localData: t, isDownloaded: true))
        .toList();
  }
});

/// A provider that fetches all exercise entries (Local + Cloud).
final hybridExercisesProvider =
    FutureProvider<List<SyncEntry<Exercise>>>((ref) async {
  final localEx = await ref.watch(exercisesStreamProvider.future);
  final prefs = ref.watch(userPreferencesStreamProvider).valueOrNull;
  final syncState = ref.watch(syncStateProvider);
  final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;
  final isAutoSync = prefs?.autoSync ?? false;
  final shouldSync = isAutoSync || syncState.manualSyncTriggered;

  if (!isOnline || !shouldSync) {
    return localEx
        .map((t) => SyncEntry<Exercise>(
              id: t.id,
              localData: t,
              isDownloaded: true,
            ))
        .toList();
  }

  try {
    final cloudMetadata = await ref
        .read(firebaseContentRepositoryProvider)
        .getExercisesMetadata();
    final Map<String, SyncEntry<Exercise>> merged = {};
    for (final t in localEx) {
      merged[t.id] = SyncEntry(id: t.id, localData: t, isDownloaded: true);
    }
    for (final cm in cloudMetadata) {
      final id = cm['id'] as String;
      if (!merged.containsKey(id)) {
        merged[id] = SyncEntry(id: id, cloudMetadata: cm, isDownloaded: false);
      }
    }
    return merged.values.toList();
  } catch (e) {
    return localEx
        .map((t) =>
            SyncEntry<Exercise>(id: t.id, localData: t, isDownloaded: true))
        .toList();
  }
});
