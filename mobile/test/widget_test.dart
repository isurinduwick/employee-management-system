import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/presentation/providers/department_providers.dart';

import 'helpers/fake_auth_data_sources.dart';
import 'helpers/fake_employee_data_sources.dart';
import 'helpers/pump_app.dart';

void main() {
  testWidgets('Unauthenticated session lands on the login screen', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Restored session lands on the app shell', (tester) async {
    await pumpApp(tester, session: sessionModelFor(Role.employee));

    // Dashboard is the default route, shown in both the app bar and the body.
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('An expired stored session falls back to login', (tester) async {
    final local = await pumpApp(
      tester,
      session: sessionModelFor(
        Role.admin,
        validFor: const Duration(hours: -1),
      ),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    // The dead session is cleared rather than left to earn a 401 later.
    expect(local.stored, isNull);
  });

  testWidgets('Admin sees every nav item', (tester) async {
    await pumpShellWithDrawerOpen(tester, Role.admin);

    for (final label in [
      'Dashboard',
      'Employees',
      'Departments',
      'Attendance',
      'Team Attendance',
      'Leave',
      'Leave Approvals',
    ]) {
      expect(find.text(label), findsWidgets, reason: 'Admin should see $label');
    }
  });

  testWidgets('Employee only sees self-service nav items', (tester) async {
    await pumpShellWithDrawerOpen(tester, Role.employee);

    for (final label in ['Dashboard', 'Attendance', 'Leave']) {
      expect(
        find.text(label),
        findsWidgets,
        reason: 'Employee should see $label',
      );
    }

    // Admin-only and manager-only routes must not leak into an employee's nav.
    for (final label in [
      'Employees',
      'Departments',
      'Team Attendance',
      'Leave Approvals',
    ]) {
      expect(
        find.text(label),
        findsNothing,
        reason: 'Employee should not see $label',
      );
    }
  });

  testWidgets('Manager sees team views but not the admin-only ones', (
    tester,
  ) async {
    await pumpShellWithDrawerOpen(tester, Role.manager);

    expect(find.text('Team Attendance'), findsWidgets);
    expect(find.text('Leave Approvals'), findsWidgets);

    expect(find.text('Employees'), findsNothing);
    expect(find.text('Departments'), findsNothing);
  });

  testWidgets('Tapping a nav item switches the visible page', (tester) async {
    // The real Departments screen fetches on mount, so its data source needs
    // faking now too — unlike its placeholder predecessor.
    await pumpShellWithDrawerOpen(
      tester,
      Role.admin,
      overrides: [
        departmentRemoteDataSourceProvider.overrideWithValue(
          FakeDepartmentRemoteDataSource(),
        ),
      ],
    );

    await tester.tap(find.text('Departments'));
    await tester.pumpAndSettle();

    // The FAB is Admin-only and specific to the real Departments screen.
    expect(find.text('New department'), findsOneWidget);
  });

  testWidgets('Logging out returns to the login screen', (tester) async {
    final local = await pumpApp(tester, session: sessionModelFor(Role.admin));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(local.stored, isNull);
  });
}
