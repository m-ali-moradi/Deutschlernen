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
  ContentValidator.validate();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  runApp(const ProviderScope(child: DeutschMateApp()));
}
