import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue_models.freezed.dart';
part 'dialogue_models.g.dart';

/// Represents a single message entry in a dialogue session.
@freezed
abstract class DialogueEntry with _$DialogueEntry {
  const factory DialogueEntry({
    /// Unique identifier for the entry within the dialogue.
    required int id,

    /// Position of the sender: 'left' (AI/Tutor) or 'right' (User).
    required String sender,

    /// Display role name (e.g., "Kassierer", "Arzt").
    required String role,

    /// The dialogue content in German.
    required String german,

    /// The dialogue content translated to English.
    required String english,

    /// Optional URL for a pre-recorded audio file.
    /// If null, the app uses Text-to-Speech (TTS).
    String? audioUrl,
  }) = _DialogueEntry;

  factory DialogueEntry.fromJson(Map<String, dynamic> json) =>
      _$DialogueEntryFromJson(json);
}

/// Contains metadata and content for a complete dialogue scenario.
@freezed
abstract class DialogueInfo with _$DialogueInfo {
  const factory DialogueInfo({
    /// Unique identifier for the dialogue scenario (e.g., "supermarket").
    required String id,

    /// Primary title in German.
    required String title,

    /// Secondary title in English.
    @Default('') String englishTitle,

    /// Brief pedagogical description or scenario context.
    @Default('') String description,

    /// CEFR level (A1, A2, B1, etc.).
    required String level,

    /// Category for filtering (e.g., "Einkaufen", "Arbeit").
    required String category,

    /// Icon identifier used for visual mapping in the list UI.
    @Default('') String icon,

    /// The sequence of messages forming the dialogue.
    required List<DialogueEntry> entries,
  }) = _DialogueInfo;

  factory DialogueInfo.fromJson(Map<String, dynamic> json) =>
      _$DialogueInfoFromJson(json);
}
