import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import '../models/dialogue_models.dart';

/// Provider for the [DialogueRepository] instance.
final dialogueRepositoryProvider = Provider((ref) => DialogueRepository(ref));

/// Handles data fetching and parsing for Practice Dialogue content.
///
/// Migrated from asset-based loading to database-backed loading to support
/// cloud synchronization and offline persistence.
class DialogueRepository {
  final Ref _ref;
  DialogueRepository(this._ref);

  /// Fetches a collection of all available dialogues from the local database.
  Future<List<DialogueInfo>> getAllDialogues() async {
    final db = _ref.read(appDatabaseProvider);
    try {
      final rows = await db.select(db.dialogues).get();
      return rows.map((row) => _mapRowToInfo(row)).toList();
    } catch (e) {
      debugPrint('Error fetching dialogues from DB: $e');
      return [];
    }
  }

  /// Loads a specific dialogue by its unique [id] from the local database.
  ///
  /// Returns null if the scenario is not found.
  Future<DialogueInfo?> getDialogueById(String id) async {
    final db = _ref.read(appDatabaseProvider);
    try {
      final query = db.select(db.dialogues)..where((t) => t.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) return null;
      return _mapRowToInfo(row);
    } catch (e) {
      debugPrint('Error fetching dialogue $id from DB: $e');
      return null;
    }
  }

  /// Helper to map a database [Dialogue] row to the [DialogueInfo] domain model.
  ///
  /// Decodes 'entriesJson' into a list of [DialogueEntry] objects.
  DialogueInfo _mapRowToInfo(Dialogue row) {
    final entriesRaw = jsonDecode(row.entriesJson) as List<dynamic>;
    final entries = entriesRaw.map((m) {
      return DialogueEntry(
        id: (m['id'] as num?)?.toInt() ?? 0,
        sender: m['sender'] ?? 'left',
        role: m['role'] ?? '',
        german: m['german'] ?? '',
        english: m['english'] ?? '',
        audioUrl: m['audio_url'] as String? ?? m['audioUrl'] as String?,
      );
    }).toList();

    return DialogueInfo(
      id: row.id,
      title: row.title,
      englishTitle: row.englishTitle,
      description: row.description,
      level: row.level,
      category: row.category,
      icon: row.icon,
      entries: entries,
    );
  }
}

/// A global stream provider for the unfiltered list of all available dialogues.
final dialoguesListProvider = FutureProvider<List<DialogueInfo>>((ref) async {
  final repo = ref.watch(dialogueRepositoryProvider);
  return repo.getAllDialogues();
});

/// A parameterized provider to fetch a single dialogue's detailed data.
final dialogueDetailProvider =
    FutureProvider.family<DialogueInfo?, String>((ref, id) async {
  final repo = ref.watch(dialogueRepositoryProvider);
  return repo.getDialogueById(id);
});
