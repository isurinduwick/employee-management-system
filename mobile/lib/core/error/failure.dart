/// The single error currency of the app.
///
/// Everything below the presentation layer returns `Either<Failure, T>` rather
/// than throwing, so a screen can only ever receive one of the cases below —
/// and the analyzer forces every `switch` over them to stay exhaustive.
sealed class Failure {
  const Failure(this.message);

  /// Ready to show to the user — never a raw exception string.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// The device could not reach the API at all (offline, wrong host, timeout).
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = "Couldn't reach the server. Is the API running?",
  ]);
}

/// 401 — the credentials were rejected, or the stored token is no longer valid.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid email or password.']);
}

/// 403 — signed in, but this role may not perform the action.
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([
    super.message = "You don't have access to this resource.",
  ]);
}

/// 404 — the resource is gone or never existed.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'That record could not be found.']);
}

/// 400/422 — the request was rejected, optionally per field.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  /// Field name -> messages, as ASP.NET's ProblemDetails returns them.
  final Map<String, List<String>> fieldErrors;
}

/// Any other non-2xx response.
final class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    this.statusCode,
  });

  final int? statusCode;
}

/// Secure storage could not be read or written.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Stored data could not be read.']);
}

/// The response did not look like what the client expected.
final class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'The server returned an unexpected response.',
  ]);
}

/// Nothing else matched — always carries a generic, user-safe message.
final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
