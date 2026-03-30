import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/learning/learning_progress_service.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_logic.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('grammar progress helpers clamp and label completion', () {
    expect(clampGrammarProgress(-10), 0);
    expect(clampGrammarProgress(110), 100);
    expect(advanceGrammarProgress(95), 100);
    expect(isGrammarTopicCompleted(99), isFalse);
    expect(isGrammarTopicCompleted(100), isTrue);
    expect(grammarProgressStateLabel(100, isEnglish: false), 'Abgeschlossen');
    expect(grammarProgressStateLabel(40, isEnglish: false),
        'In Bearbeitung (40%)');
  });

  test('updateGrammarProgress persists and completes a grammar topic',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.customStatement('''
INSERT INTO grammar_topics (
  id,
  title,
  level,
  category,
  icon,
  rule,
  explanation,
  examples_json,
  progress
) VALUES (
  'g-test',
  'Konjunktiv',
  'B1',
  'Konjunktiv',
  '💭',
  'Regel',
  'Erklärung',
  '[]',
  20
)
''');

    await LearningProgressService(db).updateGrammarProgress('g-test', 100);

    final topic = await (db.select(db.grammarTopics)
          ..where((t) => t.id.equals('g-test')))
        .getSingle();

    expect(topic.progress, 100);
    expect(isGrammarTopicCompleted(topic.progress), isTrue);
  });
}
