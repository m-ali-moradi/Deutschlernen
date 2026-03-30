import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';


/// This widget shows a single statistic with a semi-transparent "glass" look.
class GlassStat extends StatelessWidget {
  const GlassStat(
      {super.key, required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// This card is used to group related settings or information.
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard(
      {super.key, required this.cardColor, required this.child});

  final Color cardColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      color: cardColor,
      child: child,
    );
  }
}

/// This card shows a summary of a specific learning metric.
class CompactStatCard extends StatelessWidget {
  const CompactStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      color: isDark ? bg.withValues(alpha: 0.2) : bg,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: fg.withValues(alpha: 0.9)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: fg.withValues(alpha: 0.8),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: fg,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// This tile shows a support option with an icon and label.
class SupportTile extends StatelessWidget {
  const SupportTile({
    super.key,
    required this.icon,
    required this.title,
    required this.textPrimary,
    required this.textMuted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color textPrimary;
  final Color textMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final infoColor = AppTokens.stateInfoForeground(
        Theme.of(context).brightness == Brightness.dark);
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: infoColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, color: textPrimary),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: textMuted,
              ),
            ],
          ),
        ),
    );
  }
}

/// This widget allows users to select an option from a list.
class ProfileDropdownSelect extends StatelessWidget {
  const ProfileDropdownSelect({
    super.key,
    required this.value,
    required this.items,
    required this.isDark,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> items;
  final bool isDark;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTokens.surface(isDark) : const Color(0xFFF1F5F9);
    final fg = isDark ? AppTokens.textMuted(isDark) : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.containsKey(value) ? value : items.keys.first,
          isDense: true,
          style: TextStyle(fontSize: 13, color: fg),
          dropdownColor: isDark ? AppTokens.surface(isDark) : Colors.white,
          items: items.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (nextValue) {
            if (nextValue != null) {
              onChanged(nextValue);
            }
          },
        ),
      ),
    );
  }
}

/// A custom switch widget that matches the app's design system.
class ProfileCustomSwitch extends StatelessWidget {
  const ProfileCustomSwitch(
      {super.key, required this.value, required this.activeColor});

  final bool value;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 28,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: value ? activeColor : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



