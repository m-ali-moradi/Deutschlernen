import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

import 'package:deutschmate_mobile/core/learning/review_logic.dart';

class DifficultyDot extends StatelessWidget {
  const DifficultyDot(this.result, {super.key});
  final ReviewResult? result;

  @override
  Widget build(BuildContext context) {
    // Hard = Red, Medium = Orange, Easy = Green. New = Grayish.
    final color = switch (result) {
      ReviewResult.hard => const Color(0xFFEF4444),
      ReviewResult.medium => const Color(0xFFF59E0B),
      ReviewResult.easy => const Color(0xFF22C55E),
      null => Colors.grey.withValues(alpha: 0.5),
    };

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.cardColor,
    required this.title,
    required this.child,
  });

  final Color cardColor;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      useGlass: true,
      blur: 2,
      borderOpacity: isDark ? 0.08 : 0.04,
      shadowOpacity: isDark ? 0.1 : 0.02,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppTokens.textMuted(isDark).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class ListHeading extends StatelessWidget {
  const ListHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppTokens.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTokens.textMuted(isDark),
          ),
        ),
      ],
    );
  }
}

class MetaPill extends StatelessWidget {
  const MetaPill({
    super.key,
    required this.label,
    required this.dark,
    required this.icon,
    this.onTap,
  });

  final String label;
  final bool dark;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.primary(dark).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTokens.primary(dark).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTokens.primary(dark)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTokens.primary(dark),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}

class FloatingFlashcardsButton extends StatelessWidget {
  const FloatingFlashcardsButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      useGlass: true,
      blur: 8,
      borderOpacity: 0.2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTokens.primary(isDark),
                  const Color(0xFF9333EA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTokens.primary(isDark).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.style_rounded, size: 18, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Flashcards',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



