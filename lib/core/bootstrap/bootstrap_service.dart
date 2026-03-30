import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../content/phrase_content_service.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/grammar_detail_map.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/grammar_seed.dart';
import '../database/database_providers.dart';

/// Represents the current state of the application's initialization process.
enum BootstrapStatus {
  /// The app is just starting and setting up basic services.
  initializing,
  /// Heavy assets like vocabulary and grammar maps are being loaded into memory.
  loadingAssets,
  /// All critical services are ready, and the app is prepared for user interaction.
  ready,
  /// An unexpected error occurred during the initialization sequence.
  error,
}

/// Data model for the bootstrap state, including status and optional progress/error info.
class BootstrapState {
  final BootstrapStatus status;
  final String? errorMessage;
  final double progress;

  BootstrapState({
    required this.status,
    this.errorMessage,
    this.progress = 0.0,
  });

  factory BootstrapState.initial() => BootstrapState(status: BootstrapStatus.initializing);
}

/// Orchestrates the asynchronous initialization of the application.
/// 
/// Moving preloading logic here prevents it from blocking the main widget tree's
/// initial frame, leading to a perceived faster startup time.
class BootstrapService extends StateNotifier<BootstrapState> {
  final Ref _ref;

  BootstrapService(this._ref) : super(BootstrapState.initial()) {
    _init();
  }

  /// Executes the initialization sequence.
  Future<void> _init() async {
    try {
      // Small artificial delay to ensure the splash screen is visible and smooth
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = BootstrapState(status: BootstrapStatus.loadingAssets, progress: 0.1);
      
      // Perform heavy IO and parsing operations in parallel
      await Future.wait([
        _preloadGrammar(),
        _preloadPhrases(),
        // Also wait for preferences to be loaded from local DB
        _ref.read(userPreferencesStreamProvider.future),
      ]);

      state = BootstrapState(status: BootstrapStatus.ready, progress: 1.0);
    } catch (e) {
      state = BootstrapState(status: BootstrapStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> _preloadGrammar() async {
    await preloadGrammarTopicsSeed();
    await preloadGrammarDetailMap();
  }

  Future<void> _preloadPhrases() async {
    await PhraseContentService.preload();
  }
}

/// Global provider for the bootstrap state.
final bootstrapProvider = StateNotifierProvider<BootstrapService, BootstrapState>((ref) {
  return BootstrapService(ref);
});

