import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

/// Coordinates the two data sources and converts everything they throw into a
/// [Failure]. Above this line, nothing throws.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remote, required this.local});

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await remote.login(
        LoginRequestModel(email: email, password: password),
      );
      await local.writeSession(session);
      return Right(session.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Session?>> restoreSession() async {
    try {
      final stored = await local.readSession();
      if (stored == null) return const Right(null);

      final session = stored.toEntity();
      if (session.isExpired) {
        // An expired token would only earn a 401 on the first call; drop it
        // now and let the user sign in again.
        await local.clearSession();
        return const Right(null);
      }
      return Right(session);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await local.clearSession();
      return const Right(unit);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
