import 'package:mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile/features/auth/data/models/login_request_model.dart';
import 'package:mobile/features/auth/data/models/session_model.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';

/// A real local data source touches the platform keystore via a method
/// channel, which has no handler in the widget-test environment and hangs
/// forever. These fakes keep the same contracts entirely in memory, so tests
/// exercise the genuine repository, use cases and controllers above them.
class FakeAuthLocalDataSource implements AuthLocalDataSource {
  FakeAuthLocalDataSource([this._stored]);

  SessionModel? _stored;

  SessionModel? get stored => _stored;

  @override
  Future<SessionModel?> readSession() async => _stored;

  @override
  Future<void> writeSession(SessionModel session) async => _stored = session;

  @override
  Future<void> clearSession() async => _stored = null;
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({this.onLogin});

  /// Return a session to accept the credentials, or throw to reject them.
  final Future<SessionModel> Function(LoginRequestModel request)? onLogin;

  LoginRequestModel? lastRequest;

  @override
  Future<SessionModel> login(LoginRequestModel request) async {
    lastRequest = request;
    final handler = onLogin;
    if (handler == null) {
      throw StateError('FakeAuthRemoteDataSource.onLogin was not provided');
    }
    return handler(request);
  }
}

SessionModel sessionModelFor(
  Role role, {
  String fullName = 'Alex Manager',
  Duration validFor = const Duration(hours: 1),
}) {
  return SessionModel(
    token: 'test-token',
    expiresAt: DateTime.now().add(validFor),
    employeeId: 1,
    fullName: fullName,
    role: role,
  );
}
