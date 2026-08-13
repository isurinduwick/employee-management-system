/// Exceptions thrown by data sources.
///
/// Data sources throw, repositories catch and convert to a [Failure] via
/// `mapExceptionToFailure` — that boundary is the only place in the app where
/// an exception turns into a value.
library;

/// Secure storage refused a read/write, or held a malformed entry.
class CacheException implements Exception {
  const CacheException([this.message = 'Stored data could not be read.']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// A response arrived but did not match the shape the model expects.
class ParseException implements Exception {
  const ParseException([
    this.message = 'The server returned an unexpected response.',
  ]);

  final String message;

  @override
  String toString() => 'ParseException: $message';
}
