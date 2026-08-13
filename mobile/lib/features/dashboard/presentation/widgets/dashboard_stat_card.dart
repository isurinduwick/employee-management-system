import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/dashboard_summary.dart';

/// One headline number, tappable through to the screen it summarises.
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({super.key, required this.stat});

  final DashboardStat stat;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.go(stat.route),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(_icon, size: 19, color: AppColors.accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${stat.value}', style: _valueStyle),
                Text(stat.label, style: _labelStyle),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: AppColors.textSubtle,
          ),
        ],
      ),
    );
  }

  IconData get _icon => switch (stat.route) {
    AppRoutes.employees => Icons.person_outline,
    AppRoutes.departments => Icons.apartment_outlined,
    _ => Icons.inbox_outlined,
  };

  static const _valueStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    height: 1.15,
  );
  static const _labelStyle = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );
}
