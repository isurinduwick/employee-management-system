import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/providers/auth_providers.dart';
import 'app.dart';

/// Starts the app inside a guarded zone so nothing — framework errors,
/// unhandled async errors in a provider — dies silently.
///
/// [overrides] is the seam tests and demo builds use to swap real data sources
/// for fakes: `bootstrap(overrides: [apiClientProvider.overrideWithValue(...)])`.
Future<void> bootstrap({List<Override> overrides = const []}) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        debugPrint('Flutter error: ${details.exceptionAsString()}');
      };

      // Errors that escape the framework (platform channels, isolates).
      PlatformDispatcher.instance.onError = (error, stack) {
        debugPrint('Uncaught platform error: $error');
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [...authWiringOverrides, ...overrides],
          child: const EmsApp(),
        ),
      );
    },
    (error, stack) => debugPrint('Uncaught zone error: $error\n$stack'),
  );
}
