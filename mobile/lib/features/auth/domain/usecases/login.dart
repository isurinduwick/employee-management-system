import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

/// Signs a user in and persists the resulting session.
class Login implements UseCase<Session, LoginParams> {
  const Login(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Session>> call(LoginParams params) {
    return _repository.login(
      email: params.email.trim(),
      password: params.password,
    );
  }
}
