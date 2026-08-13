import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/department.dart';
import '../providers/department_form_provider.dart';
import '../providers/department_providers.dart';
import '../widgets/department_card.dart';
import '../widgets/department_form_sheet.dart';

/// The team directory. Reads are open to any signed-in role; the create,
/// edit and delete affordances only appear for Admins, matching
/// `[Authorize(Roles = "Admin")]` on the API's write endpoints.
class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departments = ref.watch(departmentsProvider);
    final canManage = ref.watch(canManageDepartmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _openForm(context, ref),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.accentContrast,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('New department'),
            )
          : null,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => ref.read(departmentsProvider.notifier).refresh(),
        child: AsyncValueView<List<Department>>(
          value: departments,
          loading: const ShimmerList(rows: 5, rowHeight: 84),
          errorTitle: "Couldn't load departments",
          onRetry: () => ref.invalidate(departmentsProvider),
          data: (list) => list.isEmpty
              ? _EmptyDirectory(canManage: canManage)
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    // Clears the FAB so the last row stays tappable.
                    canManage ? 88 : AppSpacing.lg,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final department = list[index];
                    return DepartmentCard(
                      department: department,
                      canManage: canManage,
                      onEdit: () =>
                          _openForm(context, ref, department: department),
                      onDelete: () => _delete(context, ref, department),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Department? department,
  }) async {
    // Clears any error left from a previous save before the sheet opens.
    ref.read(departmentFormControllerProvider.notifier).reset();

    final saved = await showAppBottomSheet<Department>(
      context: context,
      child: DepartmentFormSheet(department: department),
    );

    if (saved == null || !context.mounted) return;
    showAppSnackBar(
      context,
      department == null
          ? 'Department "${saved.name}" created.'
          : 'Department "${saved.name}" updated.',
      tone: AppTone.success,
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Department department,
  ) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete "${department.name}"?',
      message: "This can't be undone.",
      confirmLabel: 'Delete',
    );
    if (!confirmed || !context.mounted) return;

    final result = await ref
        .read(departmentsProvider.notifier)
        .delete(department.id);
    if (!context.mounted) return;

    result.match(
      (failure) =>
          showAppSnackBar(context, failure.message, tone: AppTone.danger),
      (_) => showAppSnackBar(
        context,
        'Department "${department.name}" deleted.',
        tone: AppTone.success,
      ),
    );
  }
}

class _EmptyDirectory extends StatelessWidget {
  const _EmptyDirectory({required this.canManage});

  final bool canManage;

  @override
  Widget build(BuildContext context) {
    // ListView (rather than a bare Center) keeps pull-to-refresh working when
    // there is nothing to scroll.
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        EmptyView(
          icon: Icons.apartment_outlined,
          title: 'No departments yet',
          message: canManage
              ? 'Create your first department to start grouping employees.'
              : null,
        ),
      ],
    );
  }
}
