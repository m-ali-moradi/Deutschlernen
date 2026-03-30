import 'package:flutter/material.dart';

/// Centralized repository for the application's design tokens and theme constants.
/// 
/// This class defines:
/// - A responsive color palette for both light and dark modes.
/// - Standardized typography styles.
/// - Reusable gradients and decorative backgrounds.
/// - Global layout constants like [maxContentWidth].
class AppTokens {
  const AppTokens._();

  /// Maximum recommended width for content areas (e.g., cards, lists) 
  /// to ensure readability on larger screens.
  static const double maxContentWidth = 430;

  // --- Background Colors ---
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);

  // --- Card / Surface Colors ---
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF1E293B);

  // --- Muted / Secondary Backgrounds ---
  static const Color lightMuted = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFF334155);

  // --- Text Colors ---
  static const Color lightText = Color(0xFF111827);
  static const Color lightTextMuted = Color(0xFF6B7280);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  /// Returns the primary brand color based on the current theme mode.
  static Color primary(bool isDark) =>
      isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

  /// Returns the secondary/accent brand color based on the current theme mode.
  static Color secondaryColor(bool isDark) =>
      isDark ? const Color(0xFFA855F7) : const Color(0xFF8B5CF6);

  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color surface(bool isDark) => isDark ? darkCard : lightCard;

  static Color surfaceMuted(bool isDark) => isDark ? darkMuted : lightMuted;

  static Color textPrimary(bool isDark) => isDark ? darkText : lightText;

  static Color textMuted(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;

  static Color outline(bool isDark) =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // --- Functional State Colors (Success, Warning, Info, Danger) ---
  static Color stateSuccessSurface(bool isDark) =>
      isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4);
  static Color stateSuccessForeground(bool isDark) =>
      isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);

  static Color stateWarningSurface(bool isDark) =>
      isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8);
  static Color stateWarningForeground(bool isDark) =>
      isDark ? const Color(0xFFFCD34D) : const Color(0xFFCA8A04);

  static Color stateInfoSurface(bool isDark) =>
      isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF);
  static Color stateInfoForeground(bool isDark) =>
      isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);

  static Color stateDangerSurface(bool isDark) =>
      isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2);
  static Color stateDangerForeground(bool isDark) =>
      isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);

  static Color accentSurface(bool isDark) =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

  // --- Radius Tokens ---
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radius24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radius28 = BorderRadius.all(Radius.circular(28));
  static const BorderRadius radius30 = BorderRadius.all(Radius.circular(30));

  // --- Premium Gradient Tokens ---
  static const List<Color> gradientBlue = [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
  static const List<Color> gradientPurple = [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
  static const List<Color> gradientOrange = [Color(0xFFFB923C), Color(0xFFEA580C)];
  static const List<Color> gradientBluePurple = [Color(0xFF3B82F6), Color(0xFFA855F7)];
  static const List<Color> gradientIndigoPurplePink = [
    Color(0xFF6366F1),
    Color(0xFFA855F7),
    Color(0xFFEC4899),
  ];
  static const List<Color> gradientOrangeDeep = [Color(0xFFF97316), Color(0xFFEA580C)];
  static const List<Color> gradientIndigo = [Color(0xFF6366F1), Color(0xFFA855F7)];

  // --- Typography Presets ---
  static TextStyle headingStyle(BuildContext context, bool isDark) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            color: textPrimary(isDark),
          );

  static TextStyle subheadingStyle(BuildContext context, bool isDark) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textMuted(isDark),
          );

  static TextStyle appBarTitleStyle(BuildContext context, bool isDark) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          );

  /// Builds a layered mesh background used for premium visuals across main screens.
  static Widget meshBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F172A),
                  const Color(0xFF1E293B),
                  const Color(0xFF0F172A),
                ]
              : [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFE2E8F0),
                ],
        ),
      ),
    );
  }
}
