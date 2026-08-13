import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/attendance/presentation/screens/team_attendance_screen.dart';
import '../../features/auth/domain/entities/session.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/departments/presentation/screens/departments_screen.dart';
import '../../features/employees/presentation/screens/employees_screen.dart';
import '../../features/leave/presentation/screens/leave_approvals_screen.dart';
import '../../features/leave/presentation/screens/leave_screen.dart';
import '../../features/shell/presentation/screens/app_shell.dart';
import 'app_routes.dart';

/// The app's single [GoRouter], rebuilt never — only its redirect re-runs.
///
/// Auth navigation lives here rather than in the screens: sign in, sign out
/// and session-restore all just change `authControllerProvider`, and the
/// redirect below decides where that leaves the user.
final routerProvider = Provider<GoRouter>((ref) {
  // go_router needs a Listenable; this bridges Riverpod's auth state to it.
  final refresh = ValueNotifier<AsyncValue<Session?>>(const AsyncLoading());
  ref.listen<AsyncValue<Session?>>(
    authControllerProvider,
    (_, next) => refresh.value = next,
    fireImmediately: true,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      // Still reading the keystore — hold on the splash screen.
      if (auth.isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // A gate, not a security boundary: the API still enforces
      // [Authorize(Roles=...)] on every request. This only avoids showing a
      // screen the user could not use.
      final isSignedIn = auth.valueOrNull != null;
      if (!isSignedIn) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }

      final isOnEntryRoute =
          location == AppRoutes.login || location == AppRoutes.splash;
      return isOnEntryRoute ? AppRoutes.dashboard : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.employees,
            builder: (context, state) => const EmployeesScreen(),
          ),
          GoRoute(
            path: AppRoutes.departments,
            builder: (context, state) => const DepartmentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.attendance,
            builder: (context, state) => const AttendanceScreen(),
            routes: [
              GoRoute(
                // Nested paths are relative, so this is /attendance/team.
                path: 'team',
                builder: (context, state) => const TeamAttendanceScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.leave,
            builder: (context, state) => const LeaveScreen(),
            routes: [
              GoRoute(
                path: 'approvals',
                builder: (context, state) => const LeaveApprovalsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // Same fallback as the web app's `*` route: an unknown location sends the
    // user to the dashboard rather than a router error page.
    onException: (context, state, router) => router.go(AppRoutes.dashboard),
  );
});
