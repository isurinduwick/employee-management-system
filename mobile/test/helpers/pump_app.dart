import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/features/auth/data/models/session_model.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

import 'fake_auth_data_sources.dart';

/// Boots the real app — router, providers and all — with the two auth data
/// sources faked out.
Future<FakeAuthLocalDataSource> pumpApp(
  WidgetTester tester, {
  SessionModel? session,
  FakeAuthRemoteDataSource? remote,
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
      ],
      child: const EmsApp(),
    ),
  );
  await tester.pumpAndSettle();

  return local;
}

/// Boots the app signed in as [role] and opens the nav drawer.
Future<void> pumpShellWithDrawerOpen(WidgetTester tester, Role role) async {
  await pumpApp(tester, session: sessionModelFor(role));

  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}
