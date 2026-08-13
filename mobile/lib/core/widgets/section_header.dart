import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Small uppercase label that introduces a group of rows (drawer sections,
/// form sections, list groupings).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      14,
      AppSpacing.xl,
      6,
    ),
    this.trailing,
  });

  final String label;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.06,
                color: AppColors.textSubtle,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
