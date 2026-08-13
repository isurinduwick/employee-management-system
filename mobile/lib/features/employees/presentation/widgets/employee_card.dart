import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/employee.dart';

/// One row of the directory: who they are, where they sit, and whether they
/// are still active.
class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.employee, this.onTap});

  final Employee employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(fullName: employee.fullName, radius: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        employee.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    if (!employee.isActive) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const StatusPill(label: 'Inactive', tone: AppTone.danger),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  employee.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusPill(
                      label: employee.employeeCode,
                      tone: AppTone.neutral,
                      icon: Icons.badge_outlined,
                    ),
                    StatusPill(
                      label: employee.departmentName,
                      tone: AppTone.info,
                      icon: Icons.apartment_outlined,
                    ),
                    StatusPill(
                      label: employee.role.label,
                      tone: AppTone.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSubtle,
              ),
            ),
        ],
      ),
    );
  }
}
