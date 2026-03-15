# UX/UI Audit Findings

Date: 2026-03-15
Project: DeutschLernen Flutter app
Scope: mobile/lib

## Executive Summary

Top critical UX/UI issues:

1. Vocabulary tab container uses dark styling in light mode, breaking readability and navigation clarity.
2. Selected tab state in vocabulary is visually inconsistent because selected color logic is duplicated incorrectly.
3. Exercise option selection state is too subtle, so users cannot confidently tell which answer is selected.
4. Results CTA in exercises uses hardcoded white/black colors, causing theme inconsistency and potential contrast issues.
5. Multiple pages use fixed gray text and weak error states, reducing readability and recovery UX.

## Findings by Severity

## Critical

### C1. Vocabulary tab strip background is dark in both modes
- File: lib/features/vocabulary/presentation/vocabulary_page.dart
- Lines: ~209-210
- Symptom: Light mode still shows dark tab background.
- Root cause: Hardcoded dark palette in both branches.
- Why it matters: Core navigation feels broken and visually inconsistent.
- Suggested fix: Use Theme color tokens such as colorScheme.surfaceContainer.

### C2. Vocabulary selected tab color logic duplicated
- File: lib/features/vocabulary/presentation/vocabulary_page.dart
- Lines: ~526-527
- Symptom: Selected visual state is not distinct enough.
- Root cause: Same selected color returned for both light/dark branches.
- Why it matters: State recognition is weakened.
- Suggested fix: Use colorScheme.primary for selected and onSurfaceVariant for unselected.

### C3. Exercise selected option lacks strong visual feedback
- File: lib/features/exercises/presentation/exercise_page.dart
- Lines: ~582-594
- Symptom: Users struggle to see selected answer.
- Root cause: Low-contrast hardcoded selected fill/border colors.
- Why it matters: Primary quiz interaction is ambiguous.
- Suggested fix: Use semantic selected colors from theme and add stronger affordance (check icon/strong border).

### C4. Exercise results button hardcoded white/black
- File: lib/features/exercises/presentation/exercise_page.dart
- Lines: ~760-761
- Symptom: CTA can look disconnected or weak in different themes.
- Root cause: Hardcoded foreground/background colors.
- Why it matters: End-of-flow action lacks theme consistency.
- Suggested fix: Use colorScheme.primaryContainer and onPrimaryContainer.

### C5. Fixed gray helper text across multiple screens
- Files:
  - lib/features/exercises/presentation/exercise_page.dart (~570)
  - lib/features/vocabulary/presentation/vocabulary_page.dart (~337, ~410)
  - lib/features/grammar/presentation/grammar_page.dart (~151)
  - lib/features/grammar/presentation/grammar_detail_page.dart (~55)
  - lib/features/profile/presentation/profile_page.dart (~40, ~165)
  - lib/features/home/presentation/home_page.dart (~132)
- Symptom: Reduced readability in dark/light contexts.
- Root cause: Repeated use of fixed grays.
- Why it matters: Accessibility and legibility degrade.
- Suggested fix: Replace with colorScheme.onSurfaceVariant.

### C6. Error states are non-recoverable
- Files:
  - lib/features/exercises/presentation/exercise_page.dart (~137)
  - lib/features/vocabulary/presentation/vocabulary_page.dart (~36)
  - lib/features/profile/presentation/profile_page.dart (~20)
  - lib/features/home/presentation/home_page.dart (~20)
- Symptom: Simple error text without retry path.
- Root cause: Minimal placeholder error handling.
- Why it matters: Users get stuck on transient failures.
- Suggested fix: Add shared error view with retry action.

## Major

### M1. White text on gradients used without contrast safeguards
- Files: multiple feature pages (exercise, vocabulary, grammar detail, home)
- Symptom: Potential low contrast depending on gradient stops.
- Root cause: Hardcoded white/white70 text on decorative gradients.
- Why it matters: Text legibility is not guaranteed.
- Suggested fix: Introduce contrast-aware foreground selection or fixed accessible gradient set.

### M2. Disabled submit state in exercises is unclear
- File: lib/features/exercises/presentation/exercise_page.dart
- Lines: ~606
- Symptom: Disabled button can look like a rendering issue.
- Root cause: Generic disabled style without guidance.
- Why it matters: Users may not understand required action.
- Suggested fix: Change label to instruction when no option is selected.

### M3. Loading states are sparse and inconsistent
- Files: main feature pages
- Symptom: Bare spinner/placeholder without context.
- Root cause: No shared loading UI pattern.
- Why it matters: Lower perceived quality and clarity.
- Suggested fix: Shared loading state component with text and layout stability.

### M4. Theme drift from hardcoded shell and section palettes
- Files: shared/widgets and feature pages
- Symptom: Visual language varies by screen.
- Root cause: Page-level hardcoded gradients/colors instead of semantic tokens.
- Why it matters: Inconsistent brand and harder maintenance.
- Suggested fix: Centralize semantic surfaces/gradients in theme extension.

## Minor

### N1. Repeated one-off badge and chip color logic
- Files: vocabulary, grammar, home, profile
- Symptom: Similar components render differently.
- Root cause: Local ad-hoc color rules.
- Why it matters: Design inconsistency and duplication.
- Suggested fix: Extract shared badge/chip widgets with theme-driven variants.

### N2. Typography hierarchy inconsistencies
- Files: multiple features
- Symptom: Similar semantics use different weight/contrast patterns.
- Root cause: Frequent local copyWith overrides.
- Why it matters: Scanability and polish are reduced.
- Suggested fix: Standardize text styles in AppTheme and reuse.

## Hardcoded Color Hotspots

Notable examples to replace with theme tokens:

- lib/features/vocabulary/presentation/vocabulary_page.dart: 0xFF17233A, 0xFF1E3354, 0xFF60A5FA
- lib/features/exercises/presentation/exercise_page.dart: 0xFF1E3A5F, 0xFFDBEAFE, 0xFF3B82F6, Colors.white, Colors.black
- Multiple files: Colors.grey.shade600

## Recommended Quick-Win Order

1. Fix exercise option selected-state visibility and submit affordance.
2. Fix vocabulary tab strip + selected tab colors.
3. Replace fixed gray helper text with onSurfaceVariant.
4. Replace hardcoded results CTA colors.
5. Add retry-enabled shared error state for feature pages.

## Notes

This report is focused on UX/UI consistency, readability, and interaction clarity across dark and light modes.
