import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/api/token_storage.dart';
import 'package:mobile/main.dart';
import 'package:mobile/models/auth.dart';
import 'package:mobile/state/auth_state.dart';

// A real TokenStorage touches the platform keystore via a method channel,
// which has no handler in the widget-test environment and hangs forever.
// This fake keeps the same read/save/clear contract entirely in memory.
class FakeTokenStorage implements TokenStorage {
  LoginResponse? _stored;

  FakeTokenStorage([this._stored]);

  @override
  Future<LoginResponse?> read() async => _stored;

  @override
  Future<void> save(LoginResponse session) async => _stored = session;

  @override
  Future<void> clear() async => _stored = null;
}

LoginResponse sessionFor(Role role) => LoginResponse(
      token: 'test-token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      employeeId: 1,
      fullName: 'Alex Manager',
      role: role,
    );

/// Boots the app already signed in as [role] and opens the nav drawer.
Future<void> pumpShellWithDrawerOpen(WidgetTester tester, Role role) async {
  final authState = AuthState(tokenStorage: FakeTokenStorage(sessionFor(role)));

  await tester.pumpWidget(EmsApp(authState: authState));
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Unauthenticated session lands on the login screen', (WidgetTester tester) async {
    final authState = AuthState(tokenStorage: FakeTokenStorage());

    await tester.pumpWidget(EmsApp(authState: authState));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('Restored session lands on the app shell', (WidgetTester tester) async {
    final authState = AuthState(tokenStorage: FakeTokenStorage(sessionFor(Role.employee)));

    await tester.pumpWidget(EmsApp(authState: authState));
    await tester.pumpAndSettle();

    // Dashboard is the default route, shown in both the app bar and the body.
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('Admin sees every nav item', (WidgetTester tester) async {
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

  testWidgets('Employee only sees self-service nav items', (WidgetTester tester) async {
    await pumpShellWithDrawerOpen(tester, Role.employee);

    for (final label in ['Dashboard', 'Attendance', 'Leave']) {
      expect(find.text(label), findsWidgets, reason: 'Employee should see $label');
    }

    // Admin-only and manager-only routes must not leak into an employee's nav.
    for (final label in ['Employees', 'Departments', 'Team Attendance', 'Leave Approvals']) {
      expect(find.text(label), findsNothing, reason: 'Employee should not see $label');
    }
  });

  testWidgets('Manager sees team views but not the admin-only ones', (WidgetTester tester) async {
    await pumpShellWithDrawerOpen(tester, Role.manager);

    expect(find.text('Team Attendance'), findsWidgets);
    expect(find.text('Leave Approvals'), findsWidgets);

    expect(find.text('Employees'), findsNothing);
    expect(find.text('Departments'), findsNothing);
  });

  testWidgets('Tapping a nav item switches the visible page', (WidgetTester tester) async {
    await pumpShellWithDrawerOpen(tester, Role.admin);

    await tester.tap(find.text('Departments'));
    await tester.pumpAndSettle();

    expect(find.text('Departments'), findsWidgets);
    expect(find.text('This screen is coming next.'), findsOneWidget);
  });
}
