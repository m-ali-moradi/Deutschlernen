import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/database/database_providers.dart';
import '../core/content/sync/sync_service.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../shared/localization/app_ui_text.dart';

/// Entry point of the application.
/// It is a ConsumerWidget which means it can watch providers.
/// It is a MaterialApp.router which means it uses the router for navigation.
/// It uses the AppTheme for theming.
/// It uses the AppUiText for localization.

class DeutschLernenApp extends ConsumerWidget {
  const DeutschLernenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesStreamProvider);
    final displayLanguage = ref.watch(displayLanguageProvider);
    ref.watch(vocabularyCatalogSyncCoordinatorProvider);
    final themeMode = prefs.maybeWhen(
      data: (value) => value.darkMode ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.system,
    );
    final appText = AppUiText(displayLanguage);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DeutschLernen',
      locale: Locale(appText.isEnglish ? 'en' : 'de'),
      supportedLocales: const [Locale('en'), Locale('de')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
