import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'status_pill.dart' show AppTone;

/// Tinted message block used for form errors and inline notices — the box the
/// login screen shows when credentials are rejected.
class InlineMessage extends StatelessWidget {
  const InlineMessage({
    super.key,
    required this.message,
    this.tone = AppTone.danger,
    this.icon,
  });

  const InlineMessage.error(String message, {Key? key})
    : this(key: key, message: message, tone: AppTone.danger);

  const InlineMessage.success(String message, {Key? key})
    : this(key: key, message: message, tone: AppTone.success);

  const InlineMessage.info(String message, {Key? key})
    : this(key: key, message: message, tone: AppTone.info);

  final String message;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: tone.foreground.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17, color: tone.foreground),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: tone.foreground, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}
