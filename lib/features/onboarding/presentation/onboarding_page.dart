import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../shared/localization/app_ui_text.dart';

/// This page introduces the app to new users.
///
/// It shows the main features like grammar lessons, vocabulary, and tracking progress.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onFinish() async {
    await ref.read(appSettingsActionsProvider).markOnboardingAsSeen();
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final slides = [
      _OnboardingSlide(
        title: strings.either(
          german: 'Willkommen bei Deutschlernen!',
          english: 'Welcome to Deutschlernen!',
        ),
        description: strings.either(
          german: 'Dein professioneller Begleiter zum Meistern der deutschen Sprache.',
          english: 'Your professional companion for mastering the German language.',
        ),
        icon: '🇩🇪',
        gradient: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Grammatik meistern',
          english: 'Master Grammar',
        ),
        description: strings.either(
          german: 'Lerne Regeln durch interaktive Übungen von A1 bis C1.',
          english: 'Learn rules through interactive exercises from A1 to C1.',
        ),
        icon: '📚',
        gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Wortschatz aufbauen',
          english: 'Build Vocabulary',
        ),
        description: strings.either(
          german: 'Nutze Flashcards und das Leitner-System für langfristigen Erfolg.',
          english: 'Use flashcards and the Leitner system for long-term success.',
        ),
        icon: '🧠',
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Fortschritt verfolgen',
          english: 'Track Progress',
        ),
        description: strings.either(
          german: 'Verdiene XP, steige im Level auf und sieh deine wöchentlichen Erfolge.',
          english: 'Earn XP, level up, and see your weekly achievements.',
        ),
        icon: '📈',
        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: slides.length,
                itemBuilder: (context, idx) => slides[idx],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      slides.length,
                      (idx) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == idx ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == idx
                              ? const Color(0xFF3B82F6)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < slides.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      } else {
                        _onFinish();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < slides.length - 1
                          ? strings.either(german: 'Weiter', english: 'Next')
                          : strings.either(german: 'Starten', english: 'Get Started'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget builds the UI for an onboarding slide with an icon and description.
class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String description;
  final String icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              icon,
              style: const TextStyle(fontSize: 80),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
