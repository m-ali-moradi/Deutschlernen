import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary, height: 1.5),
      ),
    );
  }
}

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
        if (showResult) {
          if (isCorrect) {
            bgColor = isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
            borderColor = const Color(0xFF10B981);
          } else if (isSelected) {
            bgColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
            borderColor = const Color(0xFFEF4444);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onOptionSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor ?? cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor ?? (isSelected ? const Color(0xFFFB923C) : Colors.transparent),
                  width: 2,
                ),
                boxShadow: [
                  if (!isSelected && !showResult)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFB923C) : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isSelected || (showResult && isCorrect) ? (isDark ? Colors.white : Colors.black) : textPrimary,
                      ),
                    ),
                  ),
                  if (showResult && isCorrect)
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22)
                  else if (showResult && isSelected && !isCorrect)
                    const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 22),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          constraints: const BoxConstraints(minHeight: 80),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userOrder.map((word) {
                return GestureDetector(
                  onTap: () => onWordRemoved(word),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFB923C),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFB923C).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      word,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Word pool
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: availableWords.map((word) {
            return GestureDetector(
              onTap: () => onWordAdded(word),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  word,
                  style: TextStyle(fontWeight: FontWeight.w500, color: textPrimary),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
