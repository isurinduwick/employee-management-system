import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Semantic colour of a pill / inline message, mapped to the shared tokens.
enum AppTone {
  neutral(AppColors.textMuted, AppColors.surface3),
  accent(AppColors.accent, AppColors.accentSoft),
  success(AppColors.success, AppColors.successSoft),
  warning(AppColors.warning, AppColors.warningSoft),
  danger(AppColors.danger, AppColors.dangerSoft),
  info(AppColors.info, AppColors.infoSoft);

  const AppTone(this.foreground, this.background);

  final Color foreground;
  final Color background;
}

/// Compact status chip — attendance states, leave decisions, roles.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.tone = AppTone.neutral,
    this.icon,
  });

  final String label;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: tone.foreground),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tone.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
