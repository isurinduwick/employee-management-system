import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Asks before a destructive action — the mobile stand-in for the web app's
/// `window.confirm`. Resolves to true only if the user taps the confirm
/// button.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = true,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive
                ? AppColors.danger
                : AppColors.accent,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  // A dismissed dialog (tap outside / back) means "no".
  return confirmed ?? false;
}
