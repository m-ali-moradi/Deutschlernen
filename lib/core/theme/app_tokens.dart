import 'package:flutter/material.dart';

/// This class contains all the shared colors and design tokens for the app.
///
/// It defines colors for both light and dark modes, as well as common spacing.
class AppTokens {
  const AppTokens._();

  static const double maxContentWidth = 430;

  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color darkBackground = Color(0xFF020617);

  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF0F172A);

  static const Color lightMuted = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFF1E293B);

  static const Color lightText = Color(0xFF111827);
  static const Color lightTextMuted = Color(0xFF6B7280);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  static Color surface(bool isDark) => isDark ? darkCard : lightCard;

  static Color surfaceMuted(bool isDark) => isDark ? darkMuted : lightMuted;

  static Color textPrimary(bool isDark) => isDark ? darkText : lightText;

  static Color textMuted(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;

  static Color outline(bool isDark) =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  static Color stateSuccessSurface(bool isDark) =>
      isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4);

  static Color stateSuccessForeground(bool isDark) =>
      isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);

  static Color stateWarningSurface(bool isDark) =>
      isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8);

  static Color stateWarningForeground(bool isDark) =>
      isDark ? const Color(0xFFFCD34D) : const Color(0xFFF59E0B);

  static Color stateInfoSurface(bool isDark) =>
      isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF);

  static Color stateInfoForeground(bool isDark) =>
      isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB);

  static Color stateDangerSurface(bool isDark) =>
      isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2);

  static Color stateDangerForeground(bool isDark) =>
      isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);

  static Color accentSurface(bool isDark) =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radius24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radius28 = BorderRadius.all(Radius.circular(28));
  static const BorderRadius radius30 = BorderRadius.all(Radius.circular(30));

  static const List<Color> gradientBluePurple = [
    Color(0xFF3B82F6),
    Color(0xFFA855F7),
  ];
  static const List<Color> gradientIndigoPurplePink = [
    Color(0xFF6366F1),
    Color(0xFFA855F7),
    Color(0xFFEC4899),
  ];
  static const List<Color> gradientOrange = [
    Color(0xFFFB923C),
    Color(0xFFF97316),
  ];
  static const List<Color> gradientOrangeDeep = [
    Color(0xFFF97316),
    Color(0xFFEA580C),
  ];
  static const List<Color> gradientIndigo = [
    Color(0xFF6366F1),
    Color(0xFFA855F7),
  ];
}
