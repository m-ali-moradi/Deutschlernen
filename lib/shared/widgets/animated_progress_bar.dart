import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.backgroundColor,
    this.progressColor,
    this.gradient,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 800),
  });

  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(999);
    final bg = backgroundColor ?? (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05));

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * animatedValue,
                    decoration: BoxDecoration(
                      color: gradient == null ? (progressColor ?? Theme.of(context).primaryColor) : null,
                      gradient: gradient,
                      borderRadius: radius,
                      boxShadow: [
                        if (animatedValue > 0.05)
                          BoxShadow(
                            color: (progressColor ?? (gradient?.colors.last ?? Theme.of(context).primaryColor))
                                .withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

