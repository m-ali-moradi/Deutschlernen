import 'package:flutter/material.dart';
import '../../../../shared/localization/app_ui_text.dart';

class ExerciseTypeInfo {
  const ExerciseTypeInfo({
    required this.type,
    required this.label,
    required this.icon,
    required this.gradient,
  });

  final String type;
  final String label;
  final String icon;
  final List<Color> gradient;
}

const exerciseTypes = [
  ExerciseTypeInfo(
    type: 'all',
    label: 'Alle Übungen',
    icon: '📝',
    gradient: [Color(0xFF3B82F6), Color(0xFF9333EA)],
  ),
  ExerciseTypeInfo(
    type: 'multiple-choice',
    label: 'Multiple Choice',
    icon: '🔘',
    gradient: [Color(0xFF818CF8), Color(0xFF4F46E5)],
  ),
  ExerciseTypeInfo(
    type: 'fill-blank',
    label: 'Lückentext',
    icon: '✍️',
    gradient: [Color(0xFF2DD4BF), Color(0xFF0D9488)],
  ),
  ExerciseTypeInfo(
    type: 'sentence-order',
    label: 'Satzordnung',
    icon: '🔀',
    gradient: [Color(0xFFFBBF24), Color(0xFFD97706)],
  ),
  ExerciseTypeInfo(
    type: 'business-dialog',
    label: 'Business Dialog',
    icon: '💼',
    gradient: [Color(0xFFFB7185), Color(0xFFE11D48)],
  ),
];

const exerciseLevels = ['Alle', 'A1', 'A2', 'B1', 'B2'];

String getExerciseTypeLabel(AppUiText strings, String type) {
  switch (type) {
    case 'all':
      return strings.either(german: 'Alle Übungen', english: 'All exercises');
    case 'multiple-choice':
      return strings.either(german: 'Multiple Choice', english: 'Multiple choice');
    case 'fill-blank':
      return strings.either(german: 'Lückentext', english: 'Fill in the blanks');
    case 'sentence-order':
      return strings.either(german: 'Satzordnung', english: 'Sentence order');
    case 'business-dialog':
      return strings.either(german: 'Business Dialog', english: 'Business dialog');
    default:
      return type;
  }
}

enum ExerciseSessionState { select, playing, feedback, results }
