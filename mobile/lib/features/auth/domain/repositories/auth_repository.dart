import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/session.dart';

/// What the domain needs from the outside world to sign someone in.
///
/// The implementation lives in `data/`; use cases and providers depend only on
/// this interface, which is what makes the auth flow testable without dio or
/// secure storage.
abstract interface class AuthRepository {
  /// Exchanges credentials for a session and persists it.
  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  });

  /// The persisted session, or `Right(null)` when there is none / it expired.
  Future<Either<Failure, Session?>> restoreSession();

  /// Drops the persisted session.
  Future<Either<Failure, Unit>> logout();
}
