import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

/// This widget displays the question to the user.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.isDark,
    required this.textPrimary,
    required this.cardColor,
  });

  final String question;
  final bool isDark;
  final Color textPrimary;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.6,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

/// This widget displays the multiple choice options to the user.
class MultipleChoiceOptions extends StatelessWidget {
  const MultipleChoiceOptions({
    super.key,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.onOptionSelected,
    required this.isDark,
    required this.textPrimary,
    required this.cardColor,
  });

  final List<String> options;
  final int? selectedAnswer;
  final int correctAnswer;
  final ValueChanged<int> onOptionSelected;
  final bool isDark;
  final Color textPrimary;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final isSelected = selectedAnswer == index;
        final isCorrect = index == correctAnswer;
        final showResult = selectedAnswer != null;

        Color? bgColor;
        Color? borderColor;
        Color? iconColor;

        if (showResult) {
          if (isCorrect) {
            bgColor = isDark 
                ? const Color(0xFF064E3B).withValues(alpha: 0.4) 
                : const Color(0xFFD1FAE5).withValues(alpha: 0.6);
            borderColor = const Color(0xFF10B981);
            iconColor = const Color(0xFF10B981);
          } else if (isSelected) {
            bgColor = isDark 
                ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) 
                : const Color(0xFFFEE2E2).withValues(alpha: 0.6);
            borderColor = const Color(0xFFEF4444);
            iconColor = const Color(0xFFEF4444);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: PremiumCard(
            onTap: showResult ? null : () => onOptionSelected(index),
            useGlass: true,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor ??
                      (isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: isSelected || (showResult && isCorrect)
                            ? FontWeight.w800
                            : FontWeight.w600,
                        letterSpacing: -0.3,
                        color: isSelected || (showResult && isCorrect)
                            ? (isDark ? Colors.white : Colors.black)
                            : textPrimary.withValues(alpha: showResult ? 0.6 : 1.0),
                      ),
                    ),
                  ),
                  if (showResult && isCorrect)
                    Icon(Icons.check_circle_rounded, color: iconColor, size: 24)
                  else if (showResult && isSelected && !isCorrect)
                    Icon(Icons.cancel_rounded, color: iconColor, size: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// This widget displays the sentence order options to the user.
class SentenceOrderWidget extends StatelessWidget {
  const SentenceOrderWidget({
    super.key,
    required this.userOrder,
    required this.availableWords,
    required this.onWordAdded,
    required this.onWordRemoved,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
  });

  final List<String> userOrder;
  final List<String> availableWords;
  final ValueChanged<String> onWordAdded;
  final ValueChanged<String> onWordRemoved;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User's current sentence
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 100),
          child: PremiumCard(
            padding: const EdgeInsets.all(16),
            useGlass: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: userOrder.map((word) {
                return _buildWordChip(
                  context,
                  word,
                  isUserWord: true,
                  onTap: () => onWordRemoved(word),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Word pool
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: availableWords.map((word) {
            return _buildWordChip(
              context,
              word,
              isUserWord: false,
              onTap: () => onWordAdded(word),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWordChip(BuildContext context, String word,
      {required bool isUserWord, required VoidCallback onTap}) {
    final primary = Theme.of(context).colorScheme.primary;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isUserWord ? primary : (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUserWord 
                ? primary 
                : (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.08)),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isUserWord 
                  ? primary.withValues(alpha: 0.25) 
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          word,
          style: TextStyle(
            color: isUserWord ? Colors.white : (isDark ? Colors.white : Colors.black.withValues(alpha: 0.9)),
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}



