import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Nav item model ───────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem({required this.path, required this.label, required this.icon, required this.activeIcon});
  final String path, label;
  final IconData icon, activeIcon;
}

const _navItems = [
  _NavItem(path: '/',          label: 'Home',     icon: Icons.home_outlined,        activeIcon: Icons.home_rounded),
  _NavItem(path: '/grammar',   label: 'Grammar',  icon: Icons.menu_book_outlined,   activeIcon: Icons.menu_book_rounded),
  _NavItem(path: '/vocabulary',label: 'Vocab',    icon: Icons.library_books_outlined,activeIcon: Icons.library_books_rounded),
  _NavItem(path: '/exercises', label: 'Übungen',  icon: Icons.edit_outlined,        activeIcon: Icons.edit_rounded),
  _NavItem(path: '/profile',   label: 'Profil',   icon: Icons.person_outline_rounded,activeIcon: Icons.person_rounded),
];

// ─── AppShellScaffold ─────────────────────────────────────────────────────────
/// Wrap page content in this widget. It provides the bottom nav bar.
/// Usage in router: place this as the shell for all top-level routes.
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: child,
      extendBody: true,
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

// ─── BottomNav ────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark   = Theme.of(context).brightness == Brightness.dark;

    // bg: white/90 dark:slate-900/90, backdrop blur effect via ClipRect
    final navBg   = isDark ? const Color(0xE60F172A) : const Color(0xE6FFFFFF); // ~90% opacity
    final borderC = isDark ? const Color(0x26334155) : const Color(0x26E2E8F0); // border-gray-200/15

    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(top: BorderSide(color: borderC, width: 1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.map((item) {
                final isActive = location == item.path ||
                    (item.path != '/' && location.startsWith(item.path));
                return _NavButton(item: item, isActive: isActive);
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

    final activeColor   = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB); // blue-400 / blue-600
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF); // slate-500 / gray-400

    return GestureDetector(
      onTap: () => context.go(item.path),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator — animated blue-purple gradient pill at top
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: isActive ? 32 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 22,
              color: isActive ? activeColor : inactiveColor,
            ),

            const SizedBox(height: 3),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
              child: Text(item.label),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
