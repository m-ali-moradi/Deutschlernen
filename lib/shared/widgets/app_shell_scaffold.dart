import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';

import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import '../localization/app_ui_text.dart';

// ─── Nav item model ───────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem(
      {required this.path,
      required this.label,
      required this.icon,
      required this.activeIcon});
  final String path, label;
  final IconData icon, activeIcon;
}

/// The primary layout wrapper for top-level application screens.
///
/// This scaffold provides:
/// *   **Persistent Navigation**: A bottom navigation bar integrated with GoRouter.
/// *   **Back-Button Management**: A [PopScope] that intercepts system back gestures
///     to ensure users cycle back to the Home screen ('/') before exiting the app.
/// *   **Content Selection**: A [SelectionArea] wrapper to support text selection 
///     across the entire child widget tree.
class AppShellScaffold extends ConsumerWidget {
  const AppShellScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final navItems = [
      _NavItem(
          path: '/',
          label: strings.either(german: 'Startseite', english: 'Home'),
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded),
      _NavItem(
          path: '/grammar',
          label: strings.either(german: 'Grammatik', english: 'Grammar'),
          icon: Icons.menu_book_outlined,
          activeIcon: Icons.menu_book_rounded),
      _NavItem(
          path: '/vocabulary',
          label: strings.either(german: 'Wortschatz', english: 'Vocab'),
          icon: Icons.library_books_outlined,
          activeIcon: Icons.library_books_rounded),
      _NavItem(
          path: '/practice',
          label: strings.practiceSectionTitle(),
          icon: Icons.edit_note_rounded,
          activeIcon: Icons.edit_note_rounded),
      _NavItem(
          path: '/profile',
          label: strings.either(german: 'Profil', english: 'Profile'),
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final state = GoRouterState.of(context);
        final location = state.uri.path;

        if (location != '/') {
          context.go('/');
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBody: false,
        body: SelectionArea(child: child),
        bottomNavigationBar: _BottomNav(navItems: navItems),
      ),
    );
  }
}

// ─── BottomNav ────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.navItems});

  final List<_NavItem> navItems;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // bg: white/90 dark:slate-900/90, backdrop blur effect via ClipRect
    final navBg = isDark
        ? const Color(0xE60F172A)
        : const Color(0xE6FFFFFF); // ~90% opacity
    final borderC = isDark
        ? AppTokens.outline(true).withValues(alpha: 0.25)
        : AppTokens.outline(false).withValues(alpha: 0.55);

    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(top: BorderSide(color: borderC, width: 1)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems.map((item) {
                final isActive = _isActiveLocation(location, item.path);
                return Expanded(
                    child: _NavButton(item: item, isActive: isActive));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── NavButton ────────────────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.isActive});
  final _NavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF2563EB); // blue-400 / blue-600
    final inactiveColor = AppTokens.textMuted(isDark);

    return Semantics(
      selected: isActive,
      button: true,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(item.path),
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: isActive ? 28 : 18,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                          )
                        : null,
                    color: isActive ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 22,
                  color: isActive ? activeColor : inactiveColor,
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  child: Text(item.label,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _isActiveLocation(String location, String path) {
  if (path == '/') {
    return location == '/';
  }

  return location == path || location.startsWith('$path/');
}

