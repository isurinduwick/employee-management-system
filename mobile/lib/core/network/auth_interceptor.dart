import 'package:dio/dio.dart';

/// Reads the current bearer token, or null when signed out.
typedef TokenReader = Future<String?> Function();

/// Called when the API rejects the stored token, so the app can drop it.
typedef UnauthorizedCallback = Future<void> Function();

/// Attaches `Authorization: Bearer <token>` to every outgoing request.
///
/// It takes plain callbacks rather than the auth feature's data source, which
/// keeps `core/` free of any dependency on `features/` — the wiring happens in
/// `core/di/providers.dart`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, this.onUnauthorized});

  final TokenReader readToken;
  final UnauthorizedCallback? onUnauthorized;

  /// Requests that must go out unauthenticated (sending a stale token to the
  /// login endpoint would only invite a confusing 401).
  static const _anonymousPaths = {'/auth/login'};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_anonymousPaths.contains(options.path)) {
      final token = await readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isExpiredSession =
        err.response?.statusCode == 401 &&
        !_anonymousPaths.contains(err.requestOptions.path);
    if (isExpiredSession) {
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}
