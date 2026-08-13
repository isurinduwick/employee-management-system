import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/domain/entities/role.dart';

/// Shortcuts into the screens this role actually has. Built from the role
/// rather than shown-and-disabled, so nothing here leads to a 403.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key, required this.role});

  final Role role;

  @override
  Widget build(BuildContext context) {
    final canReview = role == Role.admin || role == Role.manager;

    final actions = <({String title, String hint, String route})>[
      (
        title: 'Attendance',
        hint: 'Check in, check out, view history',
        route: AppRoutes.attendance,
      ),
      (
        title: 'Request leave',
        hint: 'Submit a new leave request',
        route: AppRoutes.leave,
      ),
      if (canReview)
        (
          title: 'Review approvals',
          hint: 'Decide on pending requests',
          route: AppRoutes.leaveApprovals,
        ),
      if (role == Role.admin)
        (
          title: 'Manage people',
          hint: 'Add or update employees',
          route: AppRoutes.employees,
        ),
    ];

    return Column(
      children: [
        for (final action in actions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard(
              onTap: () => context.go(action.route),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(action.title, style: _titleStyle),
                        const SizedBox(height: 2),
                        Text(action.hint, style: _hintStyle),
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
            ),
          ),
      ],
    );
  }

  static const _titleStyle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const _hintStyle = TextStyle(fontSize: 13, color: AppColors.textMuted);
}
