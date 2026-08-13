import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Label/value pair for read-only detail views. [value] falls back to an em
/// dash so an empty field still occupies its row instead of collapsing.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
  });

  final String label;
  final String? value;

  /// Rendered instead of [value] — a [StatusPill], for instance.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child:
                trailing ??
                Text(
                  (value == null || value!.trim().isEmpty) ? '—' : value!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
