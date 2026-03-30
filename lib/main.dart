import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/deutschlernen_app.dart';
import 'core/content/content_validator.dart';
import 'core/content/phrase_content_service.dart';
import 'features/grammar/presentation/grammar_detail_map.dart';
import 'features/grammar/presentation/grammar_seed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  assert(() {
    ContentValidator.validate();
    return true;
  }());

  await preloadGrammarTopicsSeed();
  await preloadGrammarDetailMap();
  await PhraseContentService.preload();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Add logging/crash reporting here in production
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // Catch asynchronous errors
    return true;
  };

  runApp(const ProviderScope(child: DeutschLernenApp()));
}
