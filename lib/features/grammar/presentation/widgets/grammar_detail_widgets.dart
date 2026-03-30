/// A collection of reusable UI widgets for displaying grammar content.
///
/// Includes:
/// - `GrammarDetailBackButton`: A back button styled for the detail screen.
/// - `GrammarDetailCard`: A card with consistent styling for content.
/// - `GrammarExampleCard`: A card for displaying example sentences with numbering.
library;

import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';

/// A back button styled for the detail screen.
class GrammarDetailBackButton extends StatelessWidget {
  const GrammarDetailBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: Icons.arrow_back_ios_new_rounded,
      iconSize: 16,
      onPressed: onPressed,
    );
  }
}

/// A card with consistent styling for grammar content.
class GrammarDetailCard extends StatelessWidget {
  const GrammarDetailCard({
    super.key,
    required this.isDark,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTokens.background(isDark),
        borderRadius: AppTokens.radius24,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }
}

/// A card for displaying example sentences with numbering.
class GrammarExampleCard extends StatelessWidget {
  const GrammarExampleCard({
    super.key,
    required this.index,
    required this.text,
    required this.isDark,
    required this.textPrimary,
  });

  final int index;
  final String text;
  final bool isDark;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GrammarDetailCard(
        isDark: isDark,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                    colors: [Color(0xFF60A5FA), Color(0xFFA855F7)]),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: textPrimary, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



