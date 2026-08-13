import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/today_status_banner.dart';

/// Landing screen: today's attendance state, the numbers this role is
/// responsible for, and shortcuts into the rest of the app.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static String greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final summary = ref.watch(dashboardProvider);
    final firstName = session?.fullName.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => ref.invalidate(dashboardProvider),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              '${greeting(DateTime.now())}, $firstName',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormatting.date(DateTime.now()),
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            AsyncValueView(
              value: summary,
              errorTitle: "Couldn't load your dashboard",
              onRetry: () => ref.invalidate(dashboardProvider),
              loading: Column(
                children: [
                  const ShimmerBox(height: 132, radius: AppRadius.lg),
                  const SizedBox(height: AppSpacing.xl),
                  ...List.generate(
                    2,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: ShimmerBox(height: 84, radius: AppRadius.lg),
                    ),
                  ),
                ],
              ),
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TodayStatusBanner(status: data.todayStatus),
                  const SizedBox(height: AppSpacing.xl),
                  // The list already supplies the horizontal padding.
                  const SectionHeader(label: 'At a glance', padding: EdgeInsets.zero),
                  const SizedBox(height: AppSpacing.md),
                  for (final stat in data.stats)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: DashboardStatCard(stat: stat),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(label: 'Quick actions', padding: EdgeInsets.zero),
                  const SizedBox(height: AppSpacing.md),
                  QuickActions(role: session?.role ?? Role.employee),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
