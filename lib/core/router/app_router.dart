import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/features/exercises/presentation/screens/exercise_screen.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/screens/grammar_topic_exercise_screen.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/screens/grammar_detail_screen.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/screens/grammar_screen.dart';
import 'package:deutschmate_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:deutschmate_mobile/features/onboarding/presentation/onboarding_page.dart';
import 'package:deutschmate_mobile/features/profile/presentation/profile_page.dart';
import 'package:deutschmate_mobile/features/vocabulary/presentation/screens/vocabulary_screen.dart';
import 'package:deutschmate_mobile/features/practice/presentation/screens/practice_screen.dart';
import 'package:deutschmate_mobile/features/exams/presentation/screens/exams_screen.dart';
import 'package:deutschmate_mobile/features/exams/presentation/screens/exam_detail_screen.dart';
import 'package:deutschmate_mobile/features/exams/domain/models/exam_models.dart';
// Removed redundant app_state_view.dart import
import 'package:deutschmate_mobile/shared/widgets/app_shell_scaffold.dart';
import 'package:deutschmate_mobile/features/practice/presentation/screens/dialogue_list_screen.dart';
import 'package:deutschmate_mobile/features/practice/presentation/screens/dialogue_session_screen.dart';
import '../database/database_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Final cleaning: removed _StartupGatePage as it is replaced by BootstrapScreen in DeutschMateApp.

/// Builds a page with a fade transition.
Page<void> _buildSectionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: child,
      );
    },
  );
}

/// Builds a page with a slide transition.
Page<void> _buildDetailPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final offset = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).animate(curved);

      return FadeTransition(
        opacity: Tween<double>(begin: 0.92, end: 1).animate(curved),
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}

/// This provider defines the navigation structure of the app.
///
/// It uses GoRouter to manage pages like Home, Vocabulary, Grammar, and Exercises.
/// It also handles redirects, such as showing the onboarding page to new users.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final prefsAsync = ref.read(userPreferencesStreamProvider);
      final prefs = prefsAsync.valueOrNull;
      final isOnboardingPath = state.uri.path == '/onboarding';

      if (prefsAsync.isLoading || prefs == null) {
        return null; // The outer BootstrapScreen handles this via DeutschMateApp.
      }

      final hasSeenOnboarding = prefs.hasSeenOnboarding;

      if (hasSeenOnboarding) {
        return null; // Proceed to intended path.
      } else if (!isOnboardingPath) {
        return '/onboarding';
      }

      if (!hasSeenOnboarding && !isOnboardingPath) {
        return '/onboarding';
      }
      if (hasSeenOnboarding && isOnboardingPath) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _buildSectionPage(state, const OnboardingPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                _buildSectionPage(state, const HomeScreen()),
            routes: [
              GoRoute(
                path: 'grammar',
                pageBuilder: (context, state) {
                  final q = state.uri.queryParameters;
                  return _buildSectionPage(
                    state,
                    GrammarScreen(
                      initialLevel: q['level'] ?? 'Alle',
                      initialCategory: q['category'] ?? 'Alle',
                      initialShowFilters: q['showFilters'] == '1',
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      final q = state.uri.queryParameters;
                      return _buildDetailPage(
                        state,
                        GrammarDetailScreen(
                          topicId: id,
                          backLevel: q['level'] ?? 'Alle',
                          backCategory: q['category'] ?? 'Alle',
                          backShowFilters: q['showFilters'] == '1',
                        ),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'vocabulary',
                pageBuilder: (context, state) {
                  final q = state.uri.queryParameters;
                  return _buildSectionPage(
                    state,
                    VocabularyScreen(
                      initialCategory: q['category'],
                      initialTab: q['tab'] ?? 'words',
                      initialWordId: q['wordId'],
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'practice',
                pageBuilder: (context, state) =>
                    _buildSectionPage(state, const PracticeScreen()),
                routes: [
                  GoRoute(
                    path: 'exercises',
                    pageBuilder: (context, state) {
                      final q = state.uri.queryParameters;
                      return _buildSectionPage(
                        state,
                        ExerciseScreen(
                          initialLevel: q['level'] ?? 'Alle',
                          initialTopic: q['topic'],
                          initialCategory: q['category'],
                          autoStart: q['autostart'] == '1',
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'exams',
                    pageBuilder: (context, state) =>
                        _buildDetailPage(state, const ExamsScreen()),
                    routes: [
                      GoRoute(
                        path: ':id',
                        pageBuilder: (context, state) {
                          final exam = state.extra as ExamInfo;
                          return _buildDetailPage(
                            state,
                            ExamDetailScreen(exam: exam),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'dialogues',
                    pageBuilder: (context, state) =>
                        _buildSectionPage(state, const DialogueListScreen()),
                    routes: [
                      GoRoute(
                        path: ':id',
                        pageBuilder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return _buildDetailPage(
                            state,
                            DialogueSessionScreen(dialogueId: id),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'grammar-exercises',
                pageBuilder: (context, state) {
                  final q = state.uri.queryParameters;
                  return _buildDetailPage(
                    state,
                    GrammarTopicExerciseScreen(
                      topicId: q['topicId'] ?? '',
                      topicTitle: q['topic'] ?? '',
                      topicCategory: q['category'] ?? '',
                      topicLevel: q['level'] ?? 'Alle',
                      backLevel: q['backLevel'] ?? 'Alle',
                      backCategory: q['backCategory'] ?? 'Alle',
                      backShowFilters: q['backShowFilters'] == '1',
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'profile',
                pageBuilder: (context, state) =>
                    _buildSectionPage(state, const ProfilePage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.listen(userPreferencesStreamProvider, (_, __) => router.refresh());

  return router;
});

