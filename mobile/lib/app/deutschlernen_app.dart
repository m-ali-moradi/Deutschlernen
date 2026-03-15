import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database_providers.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

class DeutschLernenApp extends ConsumerWidget {
  const DeutschLernenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesStreamProvider);
    final themeMode = prefs.maybeWhen(
      data: (value) => value.darkMode ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.system,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DeutschLernen',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
