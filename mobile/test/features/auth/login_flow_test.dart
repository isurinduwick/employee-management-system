import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';

import '../../helpers/fake_auth_data_sources.dart';
import '../../helpers/pump_app.dart';

/// End-to-end through the real stack — form -> use case -> repository ->
/// controller -> router — with only the two data sources faked.
void main() {
  Future<void> signIn(
    WidgetTester tester, {
    String email = 'lead@company.com',
    String password = 'secret1',
  }) async {
    await tester.enterText(find.byType(TextFormField).first, email);
    await tester.enterText(find.byType(TextFormField).last, password);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
  }

  testWidgets('A successful sign-in lands on the shell and persists the '
      'session', (tester) async {
    final remote = FakeAuthRemoteDataSource(
      onLogin: (_) async => sessionModelFor(Role.admin),
    );
    final local = await pumpApp(tester, remote: remote);

    await signIn(tester);

    expect(find.text('Dashboard'), findsWidgets);
    expect(local.stored?.token, 'test-token');
    // The use case trims the email before it reaches the API.
    expect(remote.lastRequest?.email, 'lead@company.com');
  });

  testWidgets('Rejected credentials stay on the form with a message', (
    tester,
  ) async {
    final requestOptions = RequestOptions(path: '/auth/login');
    final remote = FakeAuthRemoteDataSource(
      onLogin: (_) async => throw DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      ),
    );
    await pumpApp(tester, remote: remote);

    await signIn(tester, password: 'wrong1');

    expect(find.text('Invalid email or password.'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('An unreachable API reports a network failure', (tester) async {
    final remote = FakeAuthRemoteDataSource(
      onLogin: (_) async => throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/auth/login'),
        reason: 'connection refused',
      ),
    );
    await pumpApp(tester, remote: remote);

    await signIn(tester);

    expect(
      find.text("Couldn't reach the server. Is the API running?"),
      findsOneWidget,
    );
  });

  testWidgets('Client-side validation blocks the request', (tester) async {
    final remote = FakeAuthRemoteDataSource(
      onLogin: (_) async => sessionModelFor(Role.admin),
    );
    await pumpApp(tester, remote: remote);

    await signIn(tester, email: 'not-an-email', password: '123');

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Password must be 6-12 characters.'), findsOneWidget);
    expect(remote.lastRequest, isNull, reason: 'the API should not be called');
  });
}
