import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

/// Reads the session saved on the device at startup, so a returning user skips
/// the login screen.
class RestoreSession implements UseCase<Session?, NoParams> {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Session?>> call(NoParams params) =>
      _repository.restoreSession();
}
