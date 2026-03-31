import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';

part 'vocabulary_dao.g.dart';

@DriftAccessor(tables: [
  VocabularyWords,
  VocabularyProgress,
  VocabularyGroups,
  VocabularyCategories,
  VocabularyPendingCategories,
])
class VocabularyDao extends DatabaseAccessor<AppDatabase>
    with _$VocabularyDaoMixin {
  VocabularyDao(super.db);

  /// Toggles the 'favorite' status for a specific vocabulary word.
  Future<void> toggleFavorite(String wordId) async {
    await transaction(() async {
      final word = await (select(vocabularyWords)
            ..where((t) => t.id.equals(wordId)))
          .getSingleOrNull();
      if (word != null) {
        await (update(vocabularyWords)..where((t) => t.id.equals(wordId)))
            .write(
          VocabularyWordsCompanion(
            isFavorite: Value(!word.isFavorite),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }

  /// Updates the user's perceived difficulty for a specific word.
  Future<void> setWordDifficulty(String wordId, String difficulty) {
    final normalizedDifficulty = difficulty.toLowerCase();
    return (update(vocabularyWords)..where((t) => t.id.equals(wordId))).write(
      VocabularyWordsCompanion(
        difficulty: Value(normalizedDifficulty),
        isDifficult: Value(normalizedDifficulty == 'hard' ||
            normalizedDifficulty == 'difficult'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Processes the outcome of a vocabulary review and schedules the next session.
  Future<void> recordVocabularyReview({
    required String wordId,
    required ReviewResult result,
  }) async {
    await transaction(() async {
      final current = await (select(vocabularyProgress)
            ..where((t) => t.wordId.equals(wordId)))
          .getSingleOrNull();

      final now = DateTime.now();
      final update = calculateReviewUpdate(
        result: result,
        now: now,
        current: current == null
            ? null
            : ReviewSnapshot(
                leitnerBox: current.leitnerBox,
                reviewCount: current.reviewCount,
                lapseCount: current.lapseCount,
              ),
      );

      await into(vocabularyProgress).insertOnConflictUpdate(
        VocabularyProgressCompanion.insert(
          wordId: wordId,
          leitnerBox: Value(update.leitnerBox),
          status: Value(update.status.value),
          lastResult: Value(update.lastResult.value),
          reviewCount: Value(update.reviewCount),
          lapseCount: Value(update.lapseCount),
          lastReviewedAt: Value(update.lastReviewedAt),
          nextReviewAt: Value(update.nextReviewAt),
          masteredAt: Value(update.masteredAt),
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Internal helper to sync vocabulary group definitions.
  Future<void> upsertVocabularyGroups(List<Map<String, dynamic>> rows) async {
    for (final row in rows) {
      await customStatement(
        '''
INSERT INTO vocabulary_groups (id, name, level_range, sort_order)
VALUES (?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  name = excluded.name,
  level_range = excluded.level_range,
  sort_order = excluded.sort_order
''',
        [
          (row['id'] ?? '').toString(),
          (row['name'] ?? '').toString(),
          (row['levelRange'] ?? '').toString(),
          (row['sortOrder'] as num?)?.toInt() ?? 0,
        ],
      );
    }
  }

  /// Internal helper to sync vocabulary categories.
  Future<void> upsertVocabularyCategories(
    List<Map<String, dynamic>> rows, {
    bool isCached = true,
  }) async {
    for (final row in rows) {
      await customStatement(
        '''
INSERT INTO vocabulary_categories (id, group_id, name, icon, gradient_colors_json, sort_order, is_cached)
VALUES (?, ?, ?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  group_id = excluded.group_id,
  name = excluded.name,
  icon = excluded.icon,
  gradient_colors_json = excluded.gradient_colors_json,
  sort_order = excluded.sort_order,
  is_cached = excluded.is_cached
''',
        [
          (row['id'] ?? '').toString(),
          (row['groupId'] ?? '').toString(),
          (row['name'] ?? '').toString(),
          (row['icon'] ?? '').toString(),
          jsonEncode(row['colors'] ?? []),
          (row['sortOrder'] as num?)?.toInt() ?? 0,
          isCached ? 1 : 0,
        ],
      );
    }
  }

  /// Internal helper to sync actual word content from assets.
  Future<void> upsertVocabularyContent(List<Map<String, dynamic>> rows) async {
    for (final row in rows) {
      final category = (row['category'] ?? '').toString();
      final tag = (row['tag'] ?? '').toString();
      final mappedCategory = mapLegacyCategory(category, tag);

      await customStatement(
        '''
INSERT INTO vocabulary_words (
  id,
  german,
  english,
  dari,
  category,
  tag,
  example,
  context,
  context_dari,
  difficulty,
  is_favorite,
  is_difficult,
  level
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  german = excluded.german,
  english = excluded.english,
  dari = excluded.dari,
  category = excluded.category,
  tag = excluded.tag,
  example = excluded.example,
  context = excluded.context,
  context_dari = excluded.context_dari,
  difficulty = excluded.difficulty,
  level = excluded.level,
  updated_at = (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
''',
        [
          (row['id'] ?? '').toString(),
          (row['german'] ?? '').toString(),
          (row['english'] ?? '').toString(),
          (row['dari'] ?? '').toString(),
          mappedCategory,
          (row['tag'] ?? '').toString(),
          (row['example'] ?? '').toString(),
          (row['context'] ?? '').toString(),
          (row['contextDari'] ?? '').toString(),
          (row['difficulty'] ?? 'medium').toString(),
          ((row['isFavorite'] as bool?) ?? false) ? 1 : 0,
          ((row['isDifficult'] as bool?) ?? false) ? 1 : 0,
          (row['level'] ?? 'A1').toString(),
        ],
      );
    }
  }

  /// Resolves legacy category names to the current taxonomy based on tags.
  String mapLegacyCategory(String category, String tag) {
    switch (category) {
      case 'Unternehmensführung':
        return 'Company';
      case 'Meetings':
        return 'Meetings';
      case 'Akademischer Diskurs':
        return 'University';
      case 'Abstrakte Konzepte':
        return 'Opinions & Arguments';
      case 'Bildung':
        return 'School';
      case 'Bildung & Schule':
        switch (tag) {
          case 'University':
            return 'University';
          case 'Exams':
            return 'Exams & Homework';
          default:
            return 'School';
        }
      case 'Bewerbung':
        return 'Application & Career';
      case 'Finanzen':
        return 'Finance & Accounting';
      case 'Marketing & Vertrieb':
        return 'Marketing & Sales';
      case 'Personalwesen':
        return 'Human Resources';
      case 'Visa & Behörden':
        return 'Authorities & Visa';
      case 'IT & Technologie':
      case 'IT & Technik':
        return 'Software & App';
      case 'Telekommunikation':
        return 'Software & App';
      case 'Berufe':
        return 'Application & Career';
      case 'Gesundheit':
        return 'Doctor & Pharmacy';
      case 'Alltag & Basics':
        return 'Greetings';
      case 'Office':
        return 'Office & Tasks';
      default:
        return category;
    }
  }

  /// Batch migrates all existing database words to the new category structure.
  Future<void> migrateLegacyCategories() async {
    final mapping = {
      'Unternehmensführung': 'Company',
      'Meetings': 'Meetings',
      'Verträge': 'Contracts',
      'Vertrage': 'Contracts',
      'Akademischer Diskurs': 'University',
      'Abstrakte Konzepte': 'Opinions & Arguments',
      'Bildung': 'School',
      'Bildung & Schule': 'School',
      'Bewerbung': 'Application & Career',
      'Finanzen': 'Finance & Accounting',
      'Marketing & Vertrieb': 'Marketing & Sales',
      'Personalwesen': 'Human Resources',
      'Visa & Behörden': 'Authorities & Visa',
      'IT & Technologie': 'Software & App',
      'IT & Technik': 'Software & App',
      'Telekommunikation': 'Software & App',
      'Berufe': 'Application & Career',
      'Gesundheit': 'Doctor & Pharmacy',
      'Alltag & Basics': 'Greetings',
      'Office': 'Office & Tasks',
      'Verträge & Recht': 'Government & Law',
    };

    await transaction(() async {
      for (final entry in mapping.entries) {
        await customStatement(
          'UPDATE vocabulary_words SET category = ? WHERE category = ?',
          [entry.value, entry.key],
        );
      }
    });
  }
}
