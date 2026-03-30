import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/bootstrap/bootstrap_service.dart';

/// The entry-point screen for first-time users, providing a high-impact overview of the application.
/// 
/// It features:
/// - A multi-slide feature carousel.
/// - Synchronization with [bootstrapProvider] to ensure backend readiness.
/// - Premium design elements like mesh backgrounds and glassmorphic icon containers.
/// - Language-aware content that adapts to the user's system locale immediately.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  /// Handles the transition from onboarding to the main application state.
  /// 
  /// Only permits finishing if the [BootstrapStatus] is [BootstrapStatus.ready].
  /// On success, persists the 'onboarding seen' flag to local settings.
  void _onFinish() async {
    final status = ref.read(bootstrapProvider).status;
    final strings = AppUiText(ref.read(displayLanguageProvider));

    if (status != BootstrapStatus.ready) {
      // Prevents the user from entering an uninitialized app state.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.either(
            german: 'Wir bereiten alles vor. Bitte warte einen Moment...',
            english: 'Almost ready. Just finishing setup...',
          )),
          backgroundColor: const Color(0xFF4F46E5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await ref.read(appSettingsActionsProvider).markOnboardingAsSeen();
    // Re-navigating is handled by the root DeutschMateApp which listens to settings state.
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final slides = [
      _OnboardingSlide(
        title: strings.either(
          german: 'Willkommen bei DeutschMate!',
          english: 'Welcome to DeutschMate!',
        ),
        description: strings.either(
          german:
              'Dein professioneller Begleiter zum Meistern der deutschen Sprache.',
          english:
              'Your professional companion for mastering the German language.',
        ),
        imagePath: 'assets/images/icon.png',
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
        iconData: Icons.menu_book_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Wortschatz aufbauen',
          english: 'Build Vocabulary',
        ),
        description: strings.either(
          german:
              'Nutze Flashcards und das Leitner-System für langfristigen Erfolg.',
          english:
              'Use flashcards and the Leitner system for long-term success.',
        ),
        iconData: Icons.psychology_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Dialoge führen',
          english: 'Practice Dialogues',
        ),
        description: strings.either(
          german: 'Meistere reale Gespräche – vom Arztbesuch bis zum Vorstellungsgespräch.',
          english: 'Master real-world conversations – from doctor visits to job interviews.',
        ),
        iconData: Icons.chat_bubble_rounded,
        gradient: const [Color(0xFFEC4899), Color(0xFFDB2777)],
      ),
      _OnboardingSlide(
        title: strings.either(
          german: 'Fortschritt verfolgen',
          english: 'Track Progress',
        ),
        description: strings.either(
          german:
              'Verdiene XP, steige im Level auf und sieh deine wöchentlichen Erfolge.',
          english: 'Earn XP, level up, and see your weekly achievements.',
        ),
        iconData: Icons.insights_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Layer
          Positioned.fill(
            child: Container(color: AppTokens.background(isDark)),
          ),
          Positioned.fill(
            child: AppTokens.meshBackground(isDark),
          ),
          // Circular Highlight (Top-Right)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.08 : 0.05),
              ),
            ),
          ),
          
          SafeArea(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Progressive Pagination Dots
                      Row(
                        children: List.generate(
                          slides.length,
                          (idx) => AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == idx ? 32 : 8,
                            decoration: BoxDecoration(
                              gradient: _currentPage == idx
                                  ? const LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                    )
                                  : null,
                              color: _currentPage == idx
                                  ? null
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.1)),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: _currentPage == idx
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      // Navigation Action Button (Next / Get Started)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < slides.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                              );
                            } else {
                              _onFinish();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage < slides.length - 1
                                    ? strings.either(german: 'Weiter', english: 'Next')
                                    : strings.either(
                                        german: 'Starten', english: 'Get Started'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage < slides.length - 1
                                    ? Icons.arrow_forward_rounded
                                    : Icons.bolt_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A presentational widget for a single onboarding slide.
///
/// Combines a large visual element (Icon or Image) within a 
/// premium gradient container, followed by semantic title and description text.
class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.description,
    this.iconData,
    this.imagePath,
    required this.gradient,
  });

  final String title;
  final String description;
  final IconData? iconData;
  final String? imagePath;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adaptive Visual Container
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              children: [
                // Inner Graphic Plate
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(44),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: -2,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: gradient.last.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(8, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: imagePath != null
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(imagePath!, fit: BoxFit.cover),
                          ),
                        )
                      : Icon(
                          iconData,
                          size: 72,
                          color: Colors.white,
                        ),
                ),
                // Reflection Overlay for Glassmorphic Depth
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 160,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(44)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          // Slide Typography
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppTokens.textPrimary(isDark),
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: AppTokens.textMuted(isDark),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
