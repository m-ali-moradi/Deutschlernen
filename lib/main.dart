import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/deutschmate_app.dart';
import 'core/content/content_validator.dart';

/// The main entry point for the DeutschMate application.
///
/// The app now boots directly into the local database and asset pipeline.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'PlatformDispatcher',
        context: ErrorDescription('during app startup/runtime'),
      ),
    );
    return false;
  };

  ContentValidator.validate();
  runApp(const ProviderScope(child: DeutschMateApp()));
}
