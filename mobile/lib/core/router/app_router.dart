import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/exercise_page.dart';
import '../../features/grammar/presentation/grammar_detail_page.dart';
import '../../features/grammar/presentation/grammar_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/vocabulary/presentation/vocabulary_page.dart';
import '../../shared/widgets/app_shell_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShellScaffold(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
            path: '/grammar', builder: (context, state) => const GrammarPage()),
        GoRoute(
          path: '/grammar/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return GrammarDetailPage(topicId: id);
          },
        ),
        GoRoute(
            path: '/vocabulary',
            builder: (context, state) => const VocabularyPage()),
        GoRoute(
            path: '/exercises',
            builder: (context, state) => const ExercisePage()),
        GoRoute(
            path: '/profile', builder: (context, state) => const ProfilePage()),
      ],
    ),
  ],
);
