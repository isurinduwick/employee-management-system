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

  @override
  Future<LoginResponse?> read() async => _stored;

  @override
  Future<void> save(LoginResponse session) async => _stored = session;

  @override
  Future<void> clear() async => _stored = null;
}

void main() {
  testWidgets('Unauthenticated session lands on the login screen', (WidgetTester tester) async {
    final authState = AuthState(tokenStorage: FakeTokenStorage());

    await tester.pumpWidget(EmsApp(authState: authState));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
  });
}
