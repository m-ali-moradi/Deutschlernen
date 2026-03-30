import 'dart:convert';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/exercises/presentation/screens/exercise_screen.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_detail_models.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/widgets/grammar_rich_detail_view.dart';
import 'package:deutschmate_mobile/features/vocabulary/presentation/screens/vocabulary_screen.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<AppDatabase> _createTestDatabase() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());

  await db.customStatement('INSERT OR IGNORE INTO user_stats DEFAULT VALUES');
  await db.customStatement(
    'INSERT OR IGNORE INTO user_preferences DEFAULT VALUES',
  );

  return db;
}

Future<void> _pumpWithDatabase(
  WidgetTester tester,
  AppDatabase db,
  Widget child,
  {List<Override> overrides = const []}
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        ...overrides,
      ],
      child: MaterialApp(
        home: child,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

void _addDatabaseTearDown(WidgetTester tester, AppDatabase db) {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.idle();
    await db.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.idle();
  });
}

UserPreference _testPreferences([DateTime? now]) => UserPreference(
      id: 1,
      darkMode: false,
      nativeLanguage: 'en',
      displayLanguage: 'en',
      hasSeenOnboarding: true,
      autoSync: false,
      updatedAt: now ?? DateTime(2026, 3, 30),
    );

void main() {
  testWidgets('AppStateView exposes retry actions', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppStateView.error(
            message: 'Verbindung fehlgeschlagen',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Etwas ist schiefgelaufen'), findsOneWidget);
    expect(find.text('Erneut versuchen'), findsOneWidget);

    await tester.tap(find.text('Erneut versuchen'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets(
      'grammar rich detail page focuses on lesson content and exercises',
      (tester) async {
    final db = await _createTestDatabase();
    _addDatabaseTearDown(tester, db);

    final detail = GrammarDetailData(
      id: 'g-test',
      subtitle: 'Test subtitle',
      emoji: '🧪',
      gradient: const [Color(0xFF3B82F6), Color(0xFFA855F7)],
      levelBg: const Color(0xFFE0E7FF),
      levelText: const Color(0xFF1D4ED8),
      sections: [
        ConceptSection(title: 'Concept', text: 'Test text'),
      ],
    );

    await _pumpWithDatabase(
      tester,
      db,
      GrammarRichDetailView(
        topicId: 'g-test',
        topicTitle: 'Konjunktiv',
        topicCategory: 'Konjunktiv',
        topicLevel: 'B1',
        topicProgress: 50,
        detail: detail,
        onBack: () {},
        onResetExercises: () {},
        backLevel: 'Alle',
        backCategory: 'Alle',
        backShowFilters: false,
      ),
      overrides: [
        displayLanguageProvider.overrideWith((ref) => 'en'),
      ],
    );

    expect(find.text('Concept'), findsOneWidget);
    expect(find.text('Test text'), findsOneWidget);
    expect(find.text('Start exercises'), findsOneWidget);
    expect(find.text('Fortschritt'), findsNothing);
    expect(find.text('Als gelernt markieren'), findsNothing);
    expect(find.text('Fortschritt aktualisieren'), findsNothing);
  });

  testWidgets('vocabulary category flashcards stay focused and store reviews',
      (tester) async {
    final db = await _createTestDatabase();
    _addDatabaseTearDown(tester, db);

    await db.into(db.vocabularyWords).insert(
          VocabularyWordsCompanion.insert(
            id: 'word-1',
            german: 'fragen',
            english: 'to ask',
            dari: 'پرسیدن',
            category: 'application',
            tag: 'Verb',
            example: 'Ich frage nach dem Weg.',
            context: '',
            contextDari: '',
            difficulty: 'easy',
          ),
        );

    final word = VocabularyWord(
      id: 'word-1',
      german: 'fragen',
      english: 'to ask',
      dari: 'پرسیدن',
      category: 'application',
      tag: 'Verb',
      example: 'Ich frage nach dem Weg.',
      context: '',
      contextDari: '',
      level: 'A1',
      difficulty: 'easy',
      isFavorite: false,
      isDifficult: false,
      updatedAt: DateTime(2026, 3, 30),
    );
    final group = VocabularyGroupEntity(
      id: 'work_business',
      name: 'Work & Business',
      levelRange: 'A2-B2',
      sortOrder: 1,
      updatedAt: DateTime(2026, 3, 30),
    );
    final category = VocabularyCategoryEntity(
      id: 'application',
      groupId: 'work_business',
      name: 'Application & Career',
      icon: '💼',
      gradientColorsJson: jsonEncode(['0xFF1E40AF', '0xFF1D4ED8']),
      sortOrder: 1,
      wordCount: 1,
      isCached: true,
      updatedAt: DateTime(2026, 3, 30),
    );

    await _pumpWithDatabase(
      tester,
      db,
      const VocabularyScreen(initialCategory: 'application', initialTab: 'words'),
      overrides: [
        userPreferencesStreamProvider.overrideWith(
          (ref) => Stream.value(_testPreferences()),
        ),
        vocabularyWordsStreamProvider.overrideWith(
          (ref) => Stream.value([word]),
        ),
        vocabularyProgressStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyProgressData>[]),
        ),
        vocabularyGroupsStreamProvider.overrideWith(
          (ref) => Stream.value([group]),
        ),
        vocabularyCategoriesStreamProvider.overrideWith(
          (ref) => Stream.value([category]),
        ),
        vocabularyPendingCategoriesStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyPendingCategoryEntity>[]),
        ),
      ],
    );

    expect(find.text('fragen'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);

    await tester.tap(find.text('Flashcards'));
    await tester.pumpAndSettle();

    expect(find.text('Tap to flip'), findsOneWidget);
    expect(find.text('fragen'), findsOneWidget);

    await tester.tap(find.text('Tap to flip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('to ask'), findsOneWidget);

    await tester.tap(find.text('EASY'));
    await tester.pumpAndSettle();

    expect(find.text('fragen'), findsOneWidget);

    final progress = await db.select(db.vocabularyProgress).get();
    expect(progress, hasLength(1));
    expect(progress.single.wordId, 'word-1');
    expect(progress.single.leitnerBox, 2);
    expect(progress.single.status, 'learning');
    expect(progress.single.nextReviewAt, isNotNull);
  });

  testWidgets(
      'vocabulary word list stays focused without deprecated detail chrome',
      (tester) async {
    final db = await _createTestDatabase();
    _addDatabaseTearDown(tester, db);

    await db.into(db.vocabularyWords).insert(
          VocabularyWordsCompanion.insert(
            id: 'word-2',
            german: 'vereinbaren',
            english: 'to arrange',
            dari: 'هماهنگ کردن',
            category: 'meetings',
            tag: 'Verb',
            example: 'Wir vereinbaren einen Termin.',
            context: '',
            contextDari: '',
            difficulty: 'medium',
          ),
        );

    final word = VocabularyWord(
      id: 'word-2',
      german: 'vereinbaren',
      english: 'to arrange',
      dari: 'هماهنگ کردن',
      category: 'meetings',
      tag: 'Verb',
      example: 'Wir vereinbaren einen Termin.',
      context: '',
      contextDari: '',
      level: 'A1',
      difficulty: 'medium',
      isFavorite: false,
      isDifficult: false,
      updatedAt: DateTime(2026, 3, 30),
    );

    await _pumpWithDatabase(
      tester,
      db,
      const VocabularyScreen(initialCategory: 'meetings', initialTab: 'words'),
      overrides: [
        userPreferencesStreamProvider.overrideWith(
          (ref) => Stream.value(_testPreferences()),
        ),
        vocabularyWordsStreamProvider.overrideWith(
          (ref) => Stream.value([word]),
        ),
        vocabularyProgressStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyProgressData>[]),
        ),
        vocabularyGroupsStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyGroupEntity>[]),
        ),
        vocabularyCategoriesStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyCategoryEntity>[]),
        ),
        vocabularyPendingCategoriesStreamProvider.overrideWith(
          (ref) => Stream.value(const <VocabularyPendingCategoryEntity>[]),
        ),
      ],
    );

    expect(find.text('vereinbaren'), findsOneWidget);
    expect(find.text('to arrange'), findsOneWidget);
    expect(find.text('Meetings'), findsNothing);
    expect(find.text('Lernstatus'), findsNothing);
    expect(find.text('Business-Kontext'), findsNothing);
    expect(find.text('Verb'), findsWidgets);
    expect(find.text('Flashcards'), findsOneWidget);
  });

  testWidgets('exercise results persist attempts and show retry actions',
      (tester) async {
    final db = await _createTestDatabase();
    _addDatabaseTearDown(tester, db);

    await db.into(db.exercises).insert(
          ExercisesCompanion.insert(
            id: 'exercise-1',
            type: 'multiple-choice',
            question: 'Wähle die richtige Antwort',
            optionsJson: jsonEncode(['Antwort A', 'Antwort B']),
            correctAnswer: 0,
            topic: 'Konjunktiv',
            level: 'A1',
          ),
        );

    final exercise = Exercise(
      id: 'exercise-1',
      type: 'multiple-choice',
      question: 'Wähle die richtige Antwort',
      optionsJson: jsonEncode(['Antwort A', 'Antwort B']),
      correctAnswer: 0,
      topic: 'Konjunktiv',
      level: 'A1',
      updatedAt: DateTime(2026, 3, 30),
    );

    await _pumpWithDatabase(
      tester,
      db,
      const ExerciseScreen(),
      overrides: [
        userPreferencesStreamProvider.overrideWith(
          (ref) => Stream.value(_testPreferences()),
        ),
        exercisesStreamProvider.overrideWith(
          (ref) => Stream.value([exercise]),
        ),
        exerciseAttemptsStreamProvider.overrideWith(
          (ref) => Stream.value(const <ExerciseAttempt>[]),
        ),
        exerciseWeakAreasProvider.overrideWith((ref) => const <String>[]),
      ],
    );

    await tester.tap(find.text('All exercises').first);
    await tester.pumpAndSettle();

    expect(find.text('Wähle die richtige Antwort'), findsOneWidget);

    await tester.tap(find.text('Antwort B'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('FINISH'));
    await tester.pumpAndSettle();

    expect(find.text('TRY AGAIN'), findsOneWidget);
    expect(find.text('Back to exercise list'), findsOneWidget);

    final attempts = await db.select(db.exerciseAttempts).get();
    expect(attempts, hasLength(1));
    expect(attempts.single.exerciseId, 'exercise-1');
    expect(attempts.single.topic, 'Konjunktiv');
    expect(attempts.single.isCorrect, isFalse);

    await tester.tap(find.text('TRY AGAIN'));
    await tester.pumpAndSettle();

    expect(find.text('Wähle die richtige Antwort'), findsOneWidget);
  });
}
