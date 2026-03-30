import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'grammar_dao.g.dart';

@DriftAccessor(tables: [
  GrammarTopics,
  GrammarDetails,
])
class GrammarDao extends DatabaseAccessor<AppDatabase> with _$GrammarDaoMixin {
  GrammarDao(super.db);

  /// Upserts a grammar topic, preserving existing progress if present.
  Future<void> upsertGrammarTopic({
    required String id,
    required String title,
    required String level,
    required String category,
    required String icon,
    required String rule,
    required String explanation,
    required String examplesJson,
  }) async {
    await customStatement(
      '''
INSERT INTO grammar_topics (id, title, level, category, icon, rule, explanation, examples_json, progress)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
ON CONFLICT(id) DO UPDATE SET
  title = excluded.title,
  level = excluded.level,
  category = excluded.category,
  icon = excluded.icon,
  rule = excluded.rule,
  explanation = excluded.explanation,
  examples_json = excluded.examples_json,
  updated_at = (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
''',
      [id, title, level, category, icon, rule, explanation, examplesJson],
    );
  }
}

