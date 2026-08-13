import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'status_pill.dart' show AppTone;

/// Transient confirmation / error message — the mobile counterpart of the web
/// app's Toast.
void showAppSnackBar(
  BuildContext context,
  String message, {
  AppTone tone = AppTone.neutral,
}) {
  final isNeutral = tone == AppTone.neutral;

  ScaffoldMessenger.of(context)
    // Queued snack bars would otherwise stack up after a burst of actions.
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isNeutral ? AppColors.text : tone.foreground,
        duration: const Duration(seconds: 3),
      ),
    );
}
