import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/database/database_providers.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../shared/localization/app_ui_text.dart';
import '../core/bootstrap/bootstrap_service.dart';
import '../core/bootstrap/bootstrap_screen.dart';
import '../features/onboarding/presentation/onboarding_page.dart';

/// Entry point of the application.
///
/// It leverages a [BootstrapService] to handle heavy asset loading asynchronously,
/// showing a [BootstrapScreen] until the application is ready for interaction.
class DeutschMateApp extends ConsumerWidget {
  const DeutschMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapStatus = ref.watch(bootstrapProvider).status;
    final prefs = ref.watch(userPreferencesStreamProvider);
    final displayLanguage = ref.watch(displayLanguageProvider);

    final themeMode = prefs.maybeWhen(
      data: (value) => value.darkMode ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.system,
    );
    final appText = AppUiText(displayLanguage);
    final router = ref.watch(appRouterProvider);

    final hasSeenOnboarding = prefs.maybeWhen(
      data: (p) => p.hasSeenOnboarding,
      orElse: () =>
          true, // Defaulting to true for loading/error to avoid splash flashes for returning users
    );

    // If still bootstrapping OR user hasn't finished onboarding, show the initial flow
    if (bootstrapStatus != BootstrapStatus.ready || !hasSeenOnboarding) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: themeMode,
        // Onboarding takes precedence for new users, even during bootstrap
        home: !hasSeenOnboarding
            ? const OnboardingPage()
            : const BootstrapScreen(),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DeutschMate',
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
      builder: (context, child) => child!,
    );
  }
}
