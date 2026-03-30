import 'package:flutter/material.dart';

import 'app_tokens.dart';

const _appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
  },
);

/// This function builds the light theme for the app.
ThemeData buildLightTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
    brightness: Brightness.light,
  );
  final colorScheme = base.copyWith(
    primary: const Color(0xFF3B82F6),
    onPrimary: Colors.white,
    secondary: const Color(0xFFA855F7),
    onSecondary: Colors.white,
    surface: AppTokens.lightCard,
    onSurface: AppTokens.lightText,
    onSurfaceVariant: AppTokens.lightTextMuted,
    surfaceContainerHighest: AppTokens.lightMuted,
    outline: const Color(0xFFE2E8F0),
    outlineVariant: const Color(0xFFE5E7EB),
    primaryContainer: const Color(0xFFDBEAFE),
    onPrimaryContainer: const Color(0xFF1E3A8A),
    secondaryContainer: const Color(0xFFEDE9FE),
    onSecondaryContainer: const Color(0xFF4C1D95),
    error: const Color(0xFFEF4444),
    onError: Colors.white,
  );

  const baseTextTheme = TextTheme(
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    bodySmall: TextStyle(fontSize: 12.5, height: 1.35),
    labelMedium: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppTokens.lightBackground,
    textTheme: baseTextTheme.apply(
      bodyColor: AppTokens.lightText,
      displayColor: AppTokens.lightText,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    pageTransitionsTheme: _appPageTransitionsTheme,
  );
}

/// This function builds the dark theme for the app.
ThemeData buildDarkTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
    brightness: Brightness.dark,
  );
  final colorScheme = base.copyWith(
    primary: const Color(0xFF60A5FA),
    onPrimary: const Color(0xFF0F172A),
    secondary: const Color(0xFFA855F7),
    onSecondary: Colors.white,
    surface: AppTokens.darkCard,
    onSurface: AppTokens.darkText,
    onSurfaceVariant: AppTokens.darkTextMuted,
    surfaceContainerHighest: AppTokens.darkMuted,
    outline: const Color(0xFF334155),
    outlineVariant: const Color(0xFF1F2937),
    primaryContainer: const Color(0xFF1E3A8A),
    onPrimaryContainer: const Color(0xFFDBEAFE),
    secondaryContainer: const Color(0xFF4C1D95),
    onSecondaryContainer: const Color(0xFFEDE9FE),
    error: const Color(0xFFF87171),
    onError: const Color(0xFF0F172A),
  );

  const baseTextTheme = TextTheme(
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 14.5, height: 1.35),
    labelMedium: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppTokens.darkBackground,
    textTheme: baseTextTheme.apply(
      bodyColor: AppTokens.darkText,
      displayColor: AppTokens.darkText,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F172A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF1E293B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    pageTransitionsTheme: _appPageTransitionsTheme,
  );
}

