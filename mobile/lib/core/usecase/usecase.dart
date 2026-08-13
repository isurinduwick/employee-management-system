import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

/// One business action, callable like a function: `await login(params)`.
///
/// Keeping each action behind this interface is what lets the presentation
/// layer depend on the domain alone — it never sees a repository
/// implementation, a data source, or dio.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Same contract for actions that need no I/O (pure, in-memory rules).
abstract interface class SyncUseCase<T, Params> {
  Either<Failure, T> call(Params params);
}

/// Placeholder for use cases that take no arguments.
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}
