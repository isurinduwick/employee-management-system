import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/department.dart';

/// One row of the department list: its name, how many employees sit in it,
/// and — for an Admin — edit/delete affordances.
class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.department,
    required this.canManage,
    this.onEdit,
    this.onDelete,
  });

  final Department department;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.apartment_outlined,
              size: 19,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  department.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                StatusPill(
                  label:
                      '${department.employeeCount} '
                      '${department.employeeCount == 1 ? 'employee' : 'employees'}',
                  tone: AppTone.neutral,
                  icon: Icons.people_outline,
                ),
              ],
            ),
          ),
          if (canManage) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 19),
              color: AppColors.textSubtle,
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 19),
              color: AppColors.danger,
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}
