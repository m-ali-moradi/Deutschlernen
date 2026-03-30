import 'package:flutter/material.dart';

import 'package:deutschmate_mobile/core/theme/app_tokens.dart';

class AppStateView extends StatelessWidget {
  const AppStateView.loading({
    super.key,
    this.title = 'Lade Inhalte',
    this.message = 'Bitte einen Moment warten.',
  })  : icon = null,
        actionLabel = null,
        onAction = null,
        isError = false;

  const AppStateView.error({
    super.key,
    this.title = 'Etwas ist schiefgelaufen',
    required this.message,
    this.actionLabel = 'Erneut versuchen',
    this.onAction,
  })  : icon = Icons.error_outline_rounded,
        isError = true;

  const AppStateView.empty({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_rounded,
  }) : isError = false;

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isError ? colorScheme.error : AppTokens.textPrimary(isDark);
    final messageColor = AppTokens.textMuted(isDark);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: isError ? 40 : 36,
                color:
                    isError ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 14),
            ] else ...[
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: messageColor,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              AppActionButton.primary(
                label: actionLabel!,
                onPressed: onAction!,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum AppActionButtonVariant { primary, secondary, inverse }

class AppActionButton extends StatelessWidget {
  const AppActionButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  })  : variant = AppActionButtonVariant.primary,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        iconTrailing = true;

  const AppActionButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  })  : variant = AppActionButtonVariant.secondary,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        iconTrailing = true;

  const AppActionButton.inverse({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  })  : variant = AppActionButtonVariant.inverse,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        iconTrailing = true;

  const AppActionButton.custom({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    required this.variant,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.fullWidth = false,
    this.iconTrailing = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final AppActionButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool fullWidth;
  final bool iconTrailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Color resolvedBackground;
    Color resolvedForeground;
    Color resolvedBorder;

    switch (variant) {
      case AppActionButtonVariant.primary:
        resolvedBackground = backgroundColor ?? scheme.primary;
        resolvedForeground = foregroundColor ?? scheme.onPrimary;
        resolvedBorder = borderColor ?? Colors.transparent;
      case AppActionButtonVariant.secondary:
        resolvedBackground = backgroundColor ?? scheme.secondaryContainer;
        resolvedForeground = foregroundColor ?? scheme.onSecondaryContainer;
        resolvedBorder = borderColor ?? Colors.transparent;
      case AppActionButtonVariant.inverse:
        resolvedBackground = backgroundColor ?? AppTokens.accentSurface(isDark);
        resolvedForeground = foregroundColor ?? AppTokens.textPrimary(isDark);
        resolvedBorder = borderColor ??
            (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !iconTrailing) ...[
          Icon(icon, size: 18, color: resolvedForeground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: resolvedForeground,
            ),
          ),
        ),
        if (icon != null && iconTrailing) ...[
          const SizedBox(width: 6),
          Icon(icon, size: 18, color: resolvedForeground),
        ],
      ],
    );

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: resolvedBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: resolvedBorder),
          ),
          child: content,
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

