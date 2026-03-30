import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 10,
    this.backgroundColor,
    this.gradient,
    this.child,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final normalized = progress.clamp(0, 100) / 100;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: normalized),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  progress: value,
                  strokeWidth: strokeWidth,
                  backgroundColor: backgroundColor ??
                      (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE5E7EB)),
                  gradient: gradient ??
                      const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                      ),
                ),
              );
            },
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.gradient,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final background = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foreground = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, background);

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient;
  }
}

