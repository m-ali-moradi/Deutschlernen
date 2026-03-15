import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = <({String label, IconData icon, String path})>[
    (label: 'Home', icon: Icons.home_rounded, path: '/'),
    (label: 'Grammar', icon: Icons.menu_book_rounded, path: '/grammar'),
    (label: 'Vocab', icon: Icons.library_books_rounded, path: '/vocabulary'),
    (label: 'Exercise', icon: Icons.draw_rounded, path: '/exercises'),
    (label: 'Profile', icon: Icons.person_rounded, path: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = _tabs.indexWhere((tab) {
      if (tab.path == '/') return location == '/';
      return location.startsWith(tab.path);
    });

    return Scaffold(
      backgroundColor:
          isDark ? AppTokens.darkBackground : AppTokens.lightBackground,
      extendBody: true,
      body: Container(
        color: isDark ? AppTokens.darkBackground : AppTokens.lightBackground,
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppTokens.maxContentWidth),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: _BottomNav(
          currentIndex: currentIndex < 0 ? 0 : currentIndex,
          onTap: (index) => context.go(_tabs[index].path),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.92);
    final borderColor = isDark
        ? const Color(0xFF334155).withValues(alpha: 0.5)
        : const Color(0xFFE2E8F0).withValues(alpha: 0.6);
    final activeColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    final inactiveColor =
        isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppTokens.radius24,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppTokens.radius24,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(top: BorderSide(color: borderColor, width: 0.8)),
            ),
                  child: SizedBox(
              height: 64,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / AppShellScaffold._tabs.length;
                  const indicatorWidth = 32.0;
                  final left = itemWidth * currentIndex +
                      (itemWidth - indicatorWidth) / 2;

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        left: left,
                        top: 6,
                        child: Container(
                          width: indicatorWidth,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppTokens.gradientBluePurple,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0;
                              i < AppShellScaffold._tabs.length;
                              i++)
                            Expanded(
                              child: InkWell(
                                onTap: () => onTap(i),
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        AppShellScaffold._tabs[i].icon,
                                        size: 22,
                                        color: i == currentIndex
                                            ? activeColor
                                            : inactiveColor,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppShellScaffold._tabs[i].label,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: i == currentIndex
                                              ? activeColor
                                              : inactiveColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
