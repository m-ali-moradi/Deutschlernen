import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

class HomeChip extends StatelessWidget {
  const HomeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? bg.withValues(alpha: 0.15) : bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: fg.withValues(alpha: isDark ? 0.2 : 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: fg.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeGradCard extends StatelessWidget {
  const HomeGradCard({
    super.key,
    required this.gradient,
    required this.child,
    this.onTap,
  });

  final List<Color> gradient;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradient,
      ),
      borderRadius: BorderRadius.circular(22),
      shadowOpacity: 0.12,
      child: Stack(
        children: [
          // Subtle inner highlight circles for that premium depth
          Positioned(
            top: -15,
            left: -15,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.child,
    required this.color,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      color: color,
      child: child,
    );
  }
}

class HomeStatMini extends StatelessWidget {
  const HomeStatMini({
    super.key,
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
    this.icon,
  });

  final String label;
  final String value;
  final Color bg;
  final Color fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: isDark ? 0.4 : 1.0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fg.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: fg.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: fg.withValues(alpha: 0.8),
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeProgressRing extends StatelessWidget {
  const HomeProgressRing({
    super.key,
    required this.progress,
    required this.size,
    required this.label,
    required this.sublabel,
  });

  final double progress;
  final double size;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The actual ring custom painter
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              progress: progress,
              isDark: isDark,
              strokeWidth: 9,
            ),
          ),
          // Inner content
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textMuted(isDark),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.progress,
    required this.isDark,
    required this.strokeWidth,
  });

  final double progress;
  final bool isDark;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw Background Track
    final trackPaint = Paint()
      ..color = isDark 
          ? Colors.white.withValues(alpha: 0.05) 
          : const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, trackPaint);

    // 1b. Draw Inner Circle Background (Premium look)
    final innerRadius = radius - (strokeWidth / 2);
    final innerPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, innerPaint);

    if (isDark) {
      // Subtle inner border for dark mode depth
      final innerBorderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, innerRadius, innerBorderPaint);
    }

    if (progress <= 0) return;

    // 2. Draw Progress Arc with Gradient
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Color(0xFF3B82F6), // Blue
          Color(0xFF9333EA), // Purple
        ],
        transform: const GradientRotation(-1.5708), // Start at top
        tileMode: TileMode.clamp,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the main arc
    canvas.drawArc(
      rect,
      -1.5708, // Start angle (top)
      3.14159 * 2 * progress, // Sweep angle
      false,
      arcPaint,
    );
    
    // 3. Optional: Subtle Glow (Shadow) localized to the arc
    // Currently omitted for maximum clarity as requested by the user's focus on duplicates and visual artifacts
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}



