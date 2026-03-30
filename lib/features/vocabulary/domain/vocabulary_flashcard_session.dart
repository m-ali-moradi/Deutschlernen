import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';

/// Represents the state of the vocabulary flashcard session.
///
/// This class holds the current state of the flashcard session, including
/// whether it is active, the current card index, whether the card is flipped,
/// and the list of vocabulary words in the session.
///
/// This class is immutable and should be used with the [VocabularyFlashcardSessionNotifier].
class VocabularyFlashcardSessionState {
  const VocabularyFlashcardSessionState({
    this.isActive = false,
    this.index = 0,
    this.isFlipped = false,
    this.entries = const [],
  });

  final bool isActive;
  final int index;
  final bool isFlipped;
  final List<VocabularyWord> entries;

  /// Gets the current vocabulary word in the session.
  ///
  /// Returns `null` if the session is not active or if there are no entries.
  VocabularyWord? get currentEntry {
    if (!isActive || entries.isEmpty) {
      return null;
    }

    return entries[index % entries.length];
  }

  /// Creates a copy of the current state with optional updates.
  ///
  /// This method is used to create a new state object with updated values,
  /// ensuring immutability.
  VocabularyFlashcardSessionState copyWith({
    bool? isActive,
    int? index,
    bool? isFlipped,
    List<VocabularyWord>? entries,
  }) {
    return VocabularyFlashcardSessionState(
      isActive: isActive ?? this.isActive,
      index: index ?? this.index,
      isFlipped: isFlipped ?? this.isFlipped,
      entries: entries ?? this.entries,
    );
  }
}

/// A notifier that manages the state of the vocabulary flashcard session.
class VocabularyFlashcardSessionNotifier
    extends Notifier<VocabularyFlashcardSessionState> {
  @override
  VocabularyFlashcardSessionState build() {
    return const VocabularyFlashcardSessionState();
  }

  /// Starts a new flashcard session with the given vocabulary entries.
  ///
  /// This method initializes the session state with the provided entries,
  /// sets the index to 0, and marks the session as active.
  void start(List<VocabularyWord> entries) {
    state = VocabularyFlashcardSessionState(
      isActive: true,
      index: 0,
      isFlipped: false,
      entries: List<VocabularyWord>.unmodifiable(entries),
    );
  }

  /// Resets the session state and marks it as inactive.
  ///
  /// This is called when the user manually leaves the flashcard screen or completing the queue.
  void exit() {
    state = const VocabularyFlashcardSessionState();
  }

  /// Toggles the visual state of the current card between 'Front' (German) and 'Back' (Translation).
  void toggleFlip() {
    if (!state.isActive) return;
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  /// Advances to the next card in the current session's queue.
  ///
  /// If the current card is the last one in the sequence, the session is
  /// automatically closed via [exit].
  void next() {
    if (!state.isActive || state.entries.isEmpty) return;

    if (state.index >= state.entries.length - 1) {
      exit();
      return;
    }

    state = state.copyWith(
      index: state.index + 1,
      isFlipped: false,
    );
  }

  /// Reverts to the previous card in the sequence.
  ///
  /// This operation is only valid if the current index is greater than zero and
  /// the session is active.
  void previous() {
    if (!state.isActive || state.entries.isEmpty || state.index == 0) return;

    state = state.copyWith(
      index: state.index - 1,
      isFlipped: false,
    );
  }
}

/// A provider that manages the state of the vocabulary flashcard session.
final vocabularyFlashcardSessionProvider = NotifierProvider<
    VocabularyFlashcardSessionNotifier, VocabularyFlashcardSessionState>(
  VocabularyFlashcardSessionNotifier.new,
);
