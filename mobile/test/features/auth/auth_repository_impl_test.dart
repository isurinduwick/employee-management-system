import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/auth/data/models/session_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';

import '../../helpers/fake_auth_data_sources.dart';

/// The repository is the layer that turns thrown exceptions into [Failure]
/// values, so these tests pin down that mapping — everything above it depends
/// on the result.
void main() {
  final requestOptions = RequestOptions(path: '/auth/login');

  AuthRepositoryImpl repositoryWith({
    required FakeAuthRemoteDataSource remote,
    required FakeAuthLocalDataSource local,
  }) => AuthRepositoryImpl(remote: remote, local: local);

  group('login', () {
    test('persists the session and returns the entity', () async {
      final local = FakeAuthLocalDataSource();
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(
          onLogin: (_) async => sessionModelFor(Role.manager),
        ),
        local: local,
      );

      final result = await repository.login(
        email: 'lead@company.com',
        password: 'secret1',
      );

      final session = result.getOrElse((failure) => fail('got $failure'));
      expect(session.role, Role.manager);
      expect(session.fullName, 'Alex Manager');
      expect(local.stored, isA<SessionModel>());
    });

    test('maps a 401 to UnauthorizedFailure and stores nothing', () async {
      final local = FakeAuthLocalDataSource();
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(
          onLogin: (_) async => throw DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: requestOptions,
              statusCode: 401,
            ),
          ),
        ),
        local: local,
      );

      final result = await repository.login(
        email: 'wrong@company.com',
        password: 'nope123',
      );

      expect(result.getLeft().toNullable(), isA<UnauthorizedFailure>());
      expect(local.stored, isNull);
    });

    test('maps a connection error to NetworkFailure', () async {
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(
          onLogin: (_) async => throw DioException.connectionError(
            requestOptions: requestOptions,
            reason: 'refused',
          ),
        ),
        local: FakeAuthLocalDataSource(),
      );

      final result = await repository.login(
        email: 'lead@company.com',
        password: 'secret1',
      );

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('restoreSession', () {
    test('returns null when nothing is stored', () async {
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(),
        local: FakeAuthLocalDataSource(),
      );

      final result = await repository.restoreSession();

      expect(result.getOrElse((failure) => fail('got $failure')), isNull);
    });

    test('drops an expired session instead of returning it', () async {
      final local = FakeAuthLocalDataSource(
        sessionModelFor(Role.admin, validFor: const Duration(minutes: -5)),
      );
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(),
        local: local,
      );

      final result = await repository.restoreSession();

      expect(result.getOrElse((failure) => fail('got $failure')), isNull);
      expect(local.stored, isNull);
    });

    test('returns a still-valid session', () async {
      final repository = repositoryWith(
        remote: FakeAuthRemoteDataSource(),
        local: FakeAuthLocalDataSource(sessionModelFor(Role.employee)),
      );

      final result = await repository.restoreSession();

      final session = result.getOrElse((failure) => fail('got $failure'));
      expect(session?.role, Role.employee);
    });
  });

  test('logout clears the stored session', () async {
    final local = FakeAuthLocalDataSource(sessionModelFor(Role.admin));
    final repository = repositoryWith(
      remote: FakeAuthRemoteDataSource(),
      local: local,
    );

    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    expect(local.stored, isNull);
  });
}
