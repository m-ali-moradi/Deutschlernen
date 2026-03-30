import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import '../../domain/repositories/dialogue_repository.dart';
import '../../domain/models/dialogue_models.dart';

/// Active gameplay/learning screen for a specific dialogue scenario.
///
/// It features:
/// - A turn-based chat interface.
/// - Text-to-Speech (TTS) integration.
/// - Bilingual message display (German with optional English subtitle).
/// - Scenario metadata display (Info Box).
/// - Muted-by-default audio with persistent session controls.
class DialogueSessionScreen extends ConsumerStatefulWidget {
  const DialogueSessionScreen({
    super.key,
    required this.dialogueId,
  });

  /// The unique identifier of the dialogue to load.
  final String dialogueId;

  @override
  ConsumerState<DialogueSessionScreen> createState() =>
      _DialogueSessionScreenState();
}

class _DialogueSessionScreenState extends ConsumerState<DialogueSessionScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  bool _showEnglish = false;
  bool _isAudioEnabled =
      false; // Sessions start muted by default (user request)
  int _currentVisibleIndex = 0;
  final List<DialogueEntry> _visibleEntries = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  /// Configures Text-to-Speech settings for German pronunciation.
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("de-DE");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  /// Triggers the next message in the dialogue sequence with a premium typing delay.
  void _nextMessage(List<DialogueEntry> allEntries) async {
    if (_currentVisibleIndex >= allEntries.length || _isTyping) return;

    setState(() {
      _isTyping = true;
    });

    // Simulated network/thought delay for immersion (750ms)
    await Future.delayed(const Duration(milliseconds: 750));

    if (!mounted) return;

    final entry = allEntries[_currentVisibleIndex];
    setState(() {
      _visibleEntries.add(entry);
      _currentVisibleIndex++;
      _isTyping = false;
    });

    // Auto-scroll logic: ensures the latest message or typing indicator is visible
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });

    // Play TTS if unmuted
    if (_isAudioEnabled) {
      await _flutterTts.speak(entry.german);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final dialogueAsync = ref.watch(dialogueDetailProvider(widget.dialogueId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTokens.background(isDark),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0),
          child: AppIconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close_rounded,
          ),
        ),
        centerTitle: true,
        title: dialogueAsync.when(
          data: (d) => Text(
            d?.title.toUpperCase() ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: AppTokens.textPrimary(isDark).withValues(alpha: 0.9),
            ),
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
        actions: [
          // Audio Mute/Unmute Toggle
          AppIconButton(
            onPressed: () => setState(() => _isAudioEnabled = !_isAudioEnabled),
            icon: _isAudioEnabled
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            active: _isAudioEnabled,
          ),
          const SizedBox(width: 8),
          // Translation Subtitles Toggle
          AppIconButton(
            onPressed: () => setState(() => _showEnglish = !_showEnglish),
            icon: _showEnglish
                ? Icons.subtitles_rounded
                : Icons.subtitles_off_rounded,
            active: _showEnglish,
          ),
          const SizedBox(width: 12),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          dialogueAsync.when(
            data: (dialogue) {
              if (dialogue == null) {
                return Center(child: Text(strings.dialogueNoDialoguesFound()));
              }

              final hasDescription = dialogue.description.isNotEmpty;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      // Large Top padding to account for transparent AppBar + Title space
                      padding: EdgeInsets.fromLTRB(
                          16, MediaQuery.of(context).padding.top + 70, 16, 20),
                      itemCount: _visibleEntries.length +
                          (_isTyping ? 1 : 0) +
                          (hasDescription ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Priority 1: Scenario Information
                        if (hasDescription && index == 0) {
                          return _buildDescriptionBox(
                              dialogue.description, isDark);
                        }

                        // Recalculate index if description occupied the first slot
                        final dataIndex = hasDescription ? index - 1 : index;

                        // Priority 2: Animated Typing Indicator (at the very bottom)
                        if (dataIndex == _visibleEntries.length && _isTyping) {
                          final nextEntry =
                              _currentVisibleIndex < dialogue.entries.length
                                  ? dialogue.entries[_currentVisibleIndex]
                                  : null;
                          final nextIsUser =
                              nextEntry?.sender.toLowerCase() == 'right';
                          return _buildTypingIndicator(isDark, nextIsUser);
                        }

                        // Priority 3: Confirmed Messages
                        final entry = _visibleEntries[dataIndex];
                        return _ChatBubble(
                          entry: entry,
                          showEnglish: _showEnglish,
                          isDark: isDark,
                          onPlay: () => _flutterTts.speak(entry.german),
                        );
                      },
                    ),
                  ),
                  _buildControls(context, dialogue.entries, isDark, strings),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  /// Builds a glassmorphic info panel describing the scenario's pedagogical context.
  Widget _buildDescriptionBox(String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 8, right: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14, color: AppTokens.textMuted(isDark)),
                const SizedBox(width: 6),
                Text(
                  "SCENARIO INFO",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: AppTokens.textMuted(isDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTokens.textPrimary(isDark).withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the animated chat bubbles indicating that a response is being 'typed'.
  Widget _buildTypingIndicator(bool isDark, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe
              ? AppTokens.primary(isDark).withValues(alpha: 0.1)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              3,
              (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _TypingDot(isDark: isDark, index: i),
                  )),
        ),
      ),
    );
  }

  /// Combined progress button. Tap to proceed; becomes a finish button at the end.
  Widget _buildControls(BuildContext context, List<DialogueEntry> allEntries,
      bool isDark, AppUiText strings) {
    final bool isDone = _currentVisibleIndex >= allEntries.length;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.of(context).padding.bottom + 10),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDone
                ? AppTokens.gradientBluePurple
                : [
                    AppTokens.primary(isDark),
                    AppTokens.primary(isDark).withValues(alpha: 0.8)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  (isDone ? const Color(0xFF6366F1) : AppTokens.primary(isDark))
                      .withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDone
                ? () => Navigator.of(context).pop()
                : () => _nextMessage(allEntries),
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDone
                        ? Icons.check_circle_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    (isDone ? strings.exerciseFinish() : strings.exerciseNext())
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single dot in the 3-dot typing animation.
class _TypingDot extends StatefulWidget {
  final bool isDark;
  final int index;
  const _TypingDot({required this.isDark, required this.index});

  @override
  _TypingDotState createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Stagger dots for wave effect
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.white70 : Colors.black45,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// A specialized chat bubble widget supporting bilingual text and TTS playback.
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.entry,
    required this.showEnglish,
    required this.isDark,
    required this.onPlay,
  });

  final DialogueEntry entry;
  final bool showEnglish;
  final bool isDark;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final bool isMe = entry.sender.toLowerCase() == 'right';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Role Badge Label
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Text(
              entry.role.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppTokens.textMuted(isDark),
                letterSpacing: 1.0,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) _buildPlayButton(isDark),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppTokens.primary(isDark)
                            .withValues(alpha: isDark ? 0.2 : 0.1)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22),
                      topRight: const Radius.circular(22),
                      bottomLeft:
                          isMe ? const Radius.circular(22) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : const Radius.circular(22),
                    ),
                    border: Border.all(
                      color: isMe
                          ? AppTokens.primary(isDark).withValues(alpha: 0.2)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05)),
                    ),
                    boxShadow: isMe
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // High-emphasis German text
                      Text(
                        entry.german,
                        style: TextStyle(
                          color: AppTokens.textPrimary(isDark),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.45,
                          letterSpacing: -0.2,
                        ),
                      ),
                      // Conditional English subtitle
                      if (showEnglish) ...[
                        const SizedBox(height: 8),
                        Text(
                          entry.english,
                          style: TextStyle(
                            color: AppTokens.textMuted(isDark),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isMe) _buildPlayButton(isDark),
            ],
          ),
        ],
      ),
    );
  }

  /// Tiny playback button for individual message TTS.
  Widget _buildPlayButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPlay,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.volume_up_rounded,
              size: 20,
              color: AppTokens.primary(isDark),
            ),
          ),
        ),
      ),
    );
  }
}
