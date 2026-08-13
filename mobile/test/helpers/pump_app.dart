import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/data/models/session_model.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

import 'fake_auth_data_sources.dart';

/// Boots the real app — router, providers and all — with the auth data
/// sources faked out. Pass [overrides] to fake another feature's data sources
/// too.
Future<FakeAuthLocalDataSource> pumpApp(
  WidgetTester tester, {
  SessionModel? session,
  FakeAuthRemoteDataSource? remote,
  List<Override> overrides = const [],
}) async {
  final local = FakeAuthLocalDataSource(session);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Same wiring bootstrap() applies in production.
        ...authWiringOverrides,
        authLocalDataSourceProvider.overrideWithValue(local),
        authRemoteDataSourceProvider.overrideWithValue(
          remote ?? FakeAuthRemoteDataSource(),
        ),
        ...overrides,
      ],
      child: const EmsApp(),
    ),
  );
  await tester.pumpAndSettle();

  return local;
}

/// Boots the app signed in as [role] and opens the nav drawer.
Future<void> pumpShellWithDrawerOpen(
  WidgetTester tester,
  Role role, {
  List<Override> overrides = const [],
}) async {
  await pumpApp(tester, session: sessionModelFor(role), overrides: overrides);

  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

/// Mounts a single screen, signed in as [role], without the router or shell.
///
/// Use this for states the drawer can't navigate to — a Manager, for example,
/// has no Employees entry, but the screen still has to behave if it is
/// reached (deep link, or the route being opened to more roles later).
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required Role as,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...authWiringOverrides,
        authLocalDataSourceProvider.overrideWithValue(
          FakeAuthLocalDataSource(sessionModelFor(as)),
        ),
        authRemoteDataSourceProvider.overrideWithValue(
          FakeAuthRemoteDataSource(),
        ),
        ...overrides,
      ],
      child: MaterialApp(theme: AppTheme.light(), home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

/// Boots the app signed in as [role] and navigates to a drawer destination by
/// its label, exercising the real router rather than pushing a screen
/// directly.
Future<void> pumpAppAt(
  WidgetTester tester,
  Role role,
  String navLabel, {
  List<Override> overrides = const [],
}) async {
  await pumpShellWithDrawerOpen(tester, role, overrides: overrides);

  await tester.tap(find.text(navLabel));
  await tester.pumpAndSettle();
}
