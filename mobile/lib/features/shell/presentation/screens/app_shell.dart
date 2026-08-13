import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/shell_providers.dart';
import '../widgets/app_drawer.dart';

/// Chrome shared by every authenticated route: app bar, user chip and drawer.
///
/// go_router builds this once via its `ShellRoute` and swaps [child] as the
/// location changes, so switching screens never rebuilds the drawer.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final current = ref.watch(navItemForLocationProvider(location));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(current?.label ?? 'Employee MS'),
        actions: [
          if (session != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: UserAvatar(fullName: session.fullName),
            ),
        ],
      ),
      drawer: AppDrawer(currentLocation: location),
      body: child,
    );
  }
}
