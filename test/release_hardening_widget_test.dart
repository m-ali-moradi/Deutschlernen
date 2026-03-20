import 'dart:convert';

import 'package:deutschlernen_mobile/core/database/app_database.dart';
import 'package:deutschlernen_mobile/core/database/database_providers.dart';
import 'package:deutschlernen_mobile/features/exercises/presentation/exercise_page.dart';
import 'package:deutschlernen_mobile/features/grammar/presentation/grammar_rich_detail_page.dart';
import 'package:deutschlernen_mobile/features/grammar/presentation/grammar_section.dart';
import 'package:deutschlernen_mobile/features/vocabulary/presentation/vocabulary_page.dart';
import 'package:deutschlernen_mobile/shared/widgets/app_state_view.dart';
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
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

void _addDatabaseTearDown(WidgetTester tester, AppDatabase db) {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await db.close();
  });
}

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
    final detail = GrammarDetailData(
      id: 'g-test',
      subtitle: 'Test subtitle',
      emoji: '🧪',
      gradient: const [Color(0xFF3B82F6), Color(0xFFA855F7)],
      levelBg: const Color(0xFFE0E7FF),
      levelText: const Color(0xFF1D4ED8),
      sections: const [
        ConceptSection(title: 'Concept', text: 'Test text'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: GrammarRichDetailPage(
          topicTitle: 'Konjunktiv',
          topicCategory: 'Konjunktiv',
          topicLevel: 'B1',
          topicProgress: 50,
          detail: detail,
          onBack: () {},
          onResetExercises: () {},
        ),
      ),
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
            category: 'Bewerbung & Karriere',
            tag: 'Verb',
            example: 'Ich frage nach dem Weg.',
            context: '',
            contextDari: '',
            difficulty: 'easy',
          ),
        );

    await _pumpWithDatabase(
      tester,
      db,
      const VocabularyPage(initialTab: 'words'),
    );

    expect(find.text('Fällig'), findsNothing);
    expect(find.text('Neu'), findsNothing);
    expect(find.text('Gemeistert'), findsNothing);
    expect(find.text('fragen'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Bewerbung & Karriere').last,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Bewerbung & Karriere').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Flashcards'), findsOneWidget);

    await tester.tap(find.text('Flashcards'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tippen zum Umdrehen'), findsOneWidget);
    expect(find.text('fragen'), findsOneWidget);

    await tester.tap(find.text('Tippen zum Umdrehen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('to ask'), findsOneWidget);

    await tester.fling(find.text('to ask'), const Offset(500, 0), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Flashcards'), findsOneWidget);

    final progress = await db.select(db.vocabularyProgress).get();
    expect(progress, hasLength(1));
    expect(progress.single.wordId, 'word-1');
    expect(progress.single.leitnerBox, 2);
    expect(progress.single.status, 'learning');
    expect(progress.single.nextReviewAt, isNotNull);
  });

  testWidgets(
      'vocabulary detail removes learning status and keeps context tidy',
      (tester) async {
    final db = await _createTestDatabase();
    _addDatabaseTearDown(tester, db);

    await db.into(db.vocabularyWords).insert(
          VocabularyWordsCompanion.insert(
            id: 'word-2',
            german: 'vereinbaren',
            english: 'to arrange',
            dari: 'هماهنگ کردن',
            category: 'Meetings',
            tag: 'Verb',
            example: 'Wir vereinbaren einen Termin.',
            context: '',
            contextDari: '',
            difficulty: 'medium',
          ),
        );

    await _pumpWithDatabase(
      tester,
      db,
      const VocabularyPage(initialTab: 'words'),
    );

    await tester.scrollUntilVisible(
      find.text('vereinbaren'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('vereinbaren'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('vereinbaren'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Lernstatus'), findsNothing);
    expect(find.text('Business-Kontext'), findsOneWidget);
    expect(find.text('Verb'), findsWidgets);
    expect(find.text('Flashcard starten'), findsOneWidget);
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

    await _pumpWithDatabase(
      tester,
      db,
      const ExercisePage(),
    );

    await tester.scrollUntilVisible(
      find.text('Alle Übungen').first,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Alle Übungen').first);
    await tester.pumpAndSettle();

    expect(find.text('Wähle die richtige Antwort'), findsOneWidget);

    await tester.tap(find.text('Antwort B'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ergebnis anzeigen'));
    await tester.pumpAndSettle();

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Grammar List'), findsOneWidget);

    final attempts = await db.select(db.exerciseAttempts).get();
    expect(attempts, hasLength(1));
    expect(attempts.single.exerciseId, 'exercise-1');
    expect(attempts.single.topic, 'Konjunktiv');
    expect(attempts.single.isCorrect, isFalse);
  });
}
