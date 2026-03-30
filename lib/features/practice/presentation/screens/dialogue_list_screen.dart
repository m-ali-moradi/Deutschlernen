import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import '../../domain/models/dialogue_models.dart';
import '../../domain/dialogue_view_providers.dart';

/// Screen displaying a list of interactive dialogue scenarios.
/// 
/// It offers multilevel filtering by CEFR level and category.
/// The design follows the unified premium architecture used throughout the app.
class DialogueListScreen extends ConsumerStatefulWidget {
  const DialogueListScreen({super.key});

  @override
  ConsumerState<DialogueListScreen> createState() => _DialogueListScreenState();
}

class _DialogueListScreenState extends ConsumerState<DialogueListScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch relevant state providers for localized text, dialogues, and filtering status
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final dialoguesAsync = ref.watch(filteredDialoguesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showFilters = ref.watch(dialogueShowFiltersProvider);
    final selectedCategory = ref.watch(selectedDialogueCategoryProvider);
    final availableCategories = ref.watch(availableDialogueCategoriesProvider);

    return Scaffold(
      backgroundColor: AppTokens.background(isDark),
      body: Stack(
        children: [
          // Dynamic mesh background for a premium layered feel
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark, strings, showFilters),
                
                const SizedBox(height: 8),

                // 2. Category Filters - Toggled via the AppBar's filter icon
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: showFilters 
                      ? CrossFadeState.showFirst 
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableCategories.map((cat) {
                        final selected = selectedCategory == cat;
                        final label = cat == 'Alle' ? strings.filterAll() : cat;
                        return GestureDetector(
                          onTap: () => ref.read(selectedDialogueCategoryProvider.notifier).state = cat,
                          child: _CategoryPill(
                            label: label,
                            selected: selected,
                            isDark: isDark,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                const SizedBox(height: 8),

                // 3. Main List of Dialogues
                Expanded(
                  child: dialoguesAsync.when(
                    data: (dialogues) => dialogues.isEmpty
                        ? _buildEmptyState(context, isDark, strings)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: dialogues.length,
                            itemBuilder: (context, index) {
                              final dialogue = dialogues[index];
                              return _DialogueListItem(
                                dialogue: dialogue,
                                strings: strings,
                              );
                            },
                          ),
                    // Standard centralized loading indicator
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTokens.primary(isDark)),
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Text('Error: $err', style: TextStyle(color: AppTokens.textMuted(isDark))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the top-level app bar area with navigation and filter toggle icons.
  Widget _buildHeader(BuildContext context, bool isDark, AppUiText strings, bool showFilters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 2.0),
            child: AppIconButton(
              onPressed: () => context.pop(),
              icon: Icons.arrow_back_ios_new_rounded,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.dialogueSectionTitle(),
                  style: AppTokens.headingStyle(context, isDark),
                ),
                Text(
                  strings.dialogueSubtitle(),
                  style: AppTokens.subheadingStyle(context, isDark),
                ),
              ],
            ),
          ),
          // Toggle button for the category filter bar
          AppIconButton(
            icon: Icons.filter_list_rounded,
            active: showFilters,
            onPressed: () {
              ref.read(dialogueShowFiltersProvider.notifier).state = !showFilters;
            },
          ),
        ],
      ),
    );
  }

  /// Placeholder UI when no dialogues match the current filter selection.
  Widget _buildEmptyState(BuildContext context, bool isDark, AppUiText strings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: AppTokens.textMuted(isDark).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            strings.dialogueNoDialoguesFound(),
            style: TextStyle(
              color: AppTokens.textMuted(isDark),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact pill-styled toggle for category selection.
class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.isDark,
  });

  final String label;
  final bool selected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFA855F7) // Unified Purple Category highlight from Grammar
            : (isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected 
              ? Colors.transparent 
              : AppTokens.outline(isDark).withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : (isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF64748B)),
        ),
      ),
    );
  }
}

/// Represents an individual dialogue card within the list.
class _DialogueListItem extends StatelessWidget {
  const _DialogueListItem({
    required this.dialogue,
    required this.strings,
  });

  final DialogueInfo dialogue;
  final AppUiText strings;

  /// Map string-based icon names from JSON to official Material icons.
  IconData _getIconData(String name) {
    switch (name.toLowerCase()) {
      case 'app_registration':
      case 'registration':
      case 'bureaucracy':
        return Icons.app_registration_rounded;
      case 'home_rounded':
      case 'home_work':
      case 'house':
      case 'apartment':
      case 'housing':
        return Icons.home_rounded;
      case 'medical_services_rounded':
      case 'local_hospital':
      case 'doctor':
      case 'health':
        return Icons.medical_services_rounded;
      case 'account_balance_rounded':
      case 'account_balance':
      case 'bank':
      case 'finance':
        return Icons.account_balance_rounded;
      case 'shopping_cart_rounded':
      case 'shopping_cart':
      case 'supermarket':
      case 'shopping':
        return Icons.shopping_cart_rounded;
      case 'restaurant_rounded':
      case 'restaurant':
      case 'cafe':
      case 'food':
        return Icons.restaurant_rounded;
      case 'train_rounded':
      case 'train':
      case 'tram':
      case 'public_transport':
      case 'mobility':
        return Icons.train_rounded;
      case 'map_rounded':
      case 'map':
      case 'directions':
      case 'location':
        return Icons.map_rounded;
      case 'hotel_rounded':
      case 'hotel':
      case 'travel':
        return Icons.hotel_rounded;
      case 'phone_rounded':
      case 'phone':
      case 'call':
      case 'appointment':
        return Icons.phone_rounded;
      case 'local_post_office_rounded':
      case 'post_office':
      case 'post':
      case 'parcel':
        return Icons.local_post_office_rounded;
      case 'local_pharmacy_rounded':
      case 'pharmacy':
      case 'apotheke':
      case 'medicine':
        return Icons.local_pharmacy_rounded;
      case 'groups_rounded':
      case 'groups':
      case 'neighbors':
      case 'social':
        return Icons.groups_rounded;
      case 'school_rounded':
      case 'school':
      case 'teacher':
      case 'education':
        return Icons.school_rounded;
      case 'home_repair_service_rounded':
      case 'repair':
      case 'landlord':
      case 'maintenance':
        return Icons.home_repair_service_rounded;
      case 'work_history_rounded':
      case 'work_outline_rounded':
      case 'work':
      case 'office':
      case 'job':
      case 'interview':
        return Icons.work_outline_rounded;
      case 'emergency_rounded':
      case 'emergency':
      case 'notfall':
      case 'help':
        return Icons.emergency_rounded;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PremiumCard(
      onTap: () => context.push('/practice/dialogues/${dialogue.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      useGlass: true,
      blur: 15,
      borderOpacity: isDark ? 0.08 : 0.05,
      child: Row(
        children: [
          _buildIconBadge(dialogue, isDark),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dialogue.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppTokens.textPrimary(isDark),
                  ),
                ),
                if (dialogue.englishTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      dialogue.englishTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.textMuted(isDark).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  dialogue.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.secondaryColor(isDark),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppTokens.textMuted(isDark).withValues(alpha: 0.4),
            size: 24,
          ),
        ],
      ),
    );
  }

  /// Builds a glassmorphic icon badge with a subtle gradient background.
  Widget _buildIconBadge(DialogueInfo dialogue, bool isDark) {
    final primaryColor = AppTokens.primary(isDark);
    final secondaryColor = AppTokens.secondaryColor(isDark);
    final iconData = _getIconData(dialogue.icon);
 
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.12),
            secondaryColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          color: primaryColor,
          size: 28,
        ),
      ),
    );
  }
}
