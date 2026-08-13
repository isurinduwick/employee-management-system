import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failure.dart';

/// Turns anything thrown below the repository into a [Failure].
///
/// This is the one place that knows how the backend reports errors, so screens
/// never parse a response body — mirrors `extractErrorMessage()` on the web
/// client (see frontend/src/api/client.ts).
Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    Failure() => error,
    DioException() => _fromDio(error),
    SocketException() => const NetworkFailure(),
    CacheException() => CacheFailure(error.message),
    ParseException() => ParseFailure(error.message),
    FormatException() => const ParseFailure(),
    TypeError() => const ParseFailure(),
    _ => const UnknownFailure(),
  };
}

Failure _fromDio(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const NetworkFailure('The server took too long to respond.');
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const UnknownFailure('The request was cancelled.');
    case DioExceptionType.badCertificate:
      return const NetworkFailure("The server's certificate was rejected.");
    case DioExceptionType.unknown:
      return error.error is SocketException
          ? const NetworkFailure()
          : const UnknownFailure();
    case DioExceptionType.badResponse:
      return _fromResponse(error.response);
  }
}

Failure _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  final message = _extractMessage(response?.data);

  return switch (status) {
    401 => const UnauthorizedFailure(),
    403 => ForbiddenFailure(message ?? const ForbiddenFailure().message),
    404 => NotFoundFailure(message ?? const NotFoundFailure().message),
    400 || 422 => ValidationFailure(
      message ?? 'Please check the details and try again.',
      fieldErrors: _extractFieldErrors(response?.data),
    ),
    _ => ServerFailure(
      message ?? const UnknownFailure().message,
      statusCode: status,
    ),
  };
}

/// ASP.NET ProblemDetails puts the summary in `title`; hand-rolled error
/// responses in this backend use `message`. Some endpoints return a bare
/// string.
String? _extractMessage(dynamic data) {
  if (data is String && data.trim().isNotEmpty) return data;
  if (data is Map) {
    for (final key in const ['message', 'title', 'detail', 'error']) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value;
    }
  }
  return null;
}

/// ProblemDetails validation payloads carry `errors: { field: [messages] }`.
Map<String, List<String>> _extractFieldErrors(dynamic data) {
  if (data is! Map) return const {};
  final errors = data['errors'];
  if (errors is! Map) return const {};

  return {
    for (final entry in errors.entries)
      if (entry.value is List)
        entry.key.toString(): [
          for (final message in entry.value as List) message.toString(),
        ],
  };
}
