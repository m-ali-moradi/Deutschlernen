import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';

/// A reusable component that implements the "Premium" design language.
///
/// Features:
/// - Glassmorphism (blur effect)
/// - Inner highlighting (subtle top border)
/// - Multi-layered shadows
/// - Support for light/dark modes
/// - Optional gradient background
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10,
    this.borderOpacity = 0.1,
    this.highlightOpacity = 0.05,
    this.shadowOpacity = 0.06,
    this.gradient,
    this.color,
    this.useGlass = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double borderOpacity;
  final double highlightOpacity;
  final double shadowOpacity;
  final Gradient? gradient;
  final Color? color;
  final bool useGlass;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = borderRadius ?? AppTokens.radius24;
    final effectiveColor = color ?? (isDark ? const Color(0xFF1E293B) : Colors.white);
    
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: content,
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: [
          // Main Shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          // Ambient Occlusion Shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity * 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: useGlass ? blur : 0,
            sigmaY: useGlass ? blur : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: gradient == null ? effectiveColor.withValues(alpha: useGlass ? 0.7 : 1.0) : null,
              gradient: gradient,
              borderRadius: effectiveRadius,
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: borderOpacity),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Inner Highlight (Top Edge Light)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: highlightOpacity),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

