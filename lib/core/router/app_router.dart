import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/exercise_page.dart';
import '../../features/grammar/presentation/grammar_detail_page.dart';
import '../../features/grammar/presentation/grammar_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/vocabulary/presentation/vocabulary_page.dart';
import '../../shared/widgets/app_shell_scaffold.dart';
import '../database/database_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// This provider defines the navigation structure of the app.
///
/// It uses GoRouter to manage pages like Home, Vocabulary, Grammar, and Exercises.
/// It also handles redirects, such as showing the onboarding page to new users.
final appRouterProvider = Provider<GoRouter>((ref) {
  final prefsAsync = ref.watch(userPreferencesStreamProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final prefs = prefsAsync.valueOrNull;
      if (prefs == null) {
        return null;
      }

      final hasSeenOnboarding = prefs.hasSeenOnboarding;
      final isOnboardingPath = state.uri.path == '/onboarding';

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
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/grammar',
            builder: (context, state) {
              final q = state.uri.queryParameters;
              return GrammarPage(
                initialLevel: q['level'] ?? 'Alle',
                initialCategory: q['category'] ?? 'Alle',
                initialShowFilters: q['showFilters'] == '1',
              );
            },
          ),
          GoRoute(
            path: '/grammar/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              final q = state.uri.queryParameters;
              return GrammarDetailPage(
                topicId: id,
                backLevel: q['level'] ?? 'Alle',
                backCategory: q['category'] ?? 'Alle',
                backShowFilters: q['showFilters'] == '1',
              );
            },
          ),
          GoRoute(
              path: '/vocabulary',
              builder: (context, state) {
                final q = state.uri.queryParameters;
                return VocabularyPage(
                  initialCategory: q['category'],
                  initialTab: q['tab'] ?? 'words',
                  initialWordId: q['wordId'],
                );
              }),
          GoRoute(
            path: '/exercises',
            builder: (context, state) {
              final q = state.uri.queryParameters;
              return ExercisePage(
                initialLevel: q['level'] ?? 'Alle',
                initialTopic: q['topic'],
                initialCategory: q['category'],
                autoStart: q['autostart'] == '1',
              );
            },
          ),
          GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage()),
        ],
      ),
    ],
  );
});
