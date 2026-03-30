import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';

/// A shared icon button with a stylized container, used for headers and actions.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.active = false,
    this.size = 36,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool active;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius12,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius12,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: active
                ? AppTokens.stateInfoForeground(isDark)
                : AppTokens.surface(isDark),
            borderRadius: AppTokens.radius12,
            border: Border.all(
              color: isDark
                  ? AppTokens.outline(isDark).withValues(alpha: 0.35)
                  : AppTokens.outline(isDark).withValues(alpha: 0.8),
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              size: iconSize ?? (size * 0.5),
              color: active
                  ? Colors.white
                  : AppTokens.textPrimary(isDark).withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

