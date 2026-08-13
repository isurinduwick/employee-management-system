import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/domain/entities/session.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/nav_item.dart';
import '../providers/shell_providers.dart';
import 'nav_tile.dart';

/// Mobile counterpart of the web sidebar: the same grouped, role-filtered
/// links, plus the user chip and Log out that the web app keeps in its top
/// bar.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.currentLocation});

  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final items = ref.watch(visibleNavItemsProvider);
    if (session == null) return const Drawer(child: SizedBox.shrink());

    // Only sections that still have a link for this role get a heading.
    final sections = [
      for (final group in navGroupOrder)
        (
          group: group,
          items: items.where((item) => item.group == group).toList(),
        ),
    ].where((section) => section.items.isNotEmpty);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(session: session),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  for (final section in sections) ...[
                    SectionHeader(label: section.group.label),
                    for (final item in section.items)
                      NavTile(
                        item: item,
                        isActive: item.path == currentLocation,
                        onTap: () {
                          Navigator.of(context).pop();
                          if (item.path != currentLocation) {
                            context.go(item.path);
                          }
                        },
                      ),
                  ],
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 20,
                color: AppColors.textMuted,
              ),
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              // Closing first avoids leaving an orphaned drawer over the login
              // screen once the redirect fires.
              onTap: () {
                Navigator.of(context).pop();
                ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        18,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const BrandMark(size: 38),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  session.role.label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
