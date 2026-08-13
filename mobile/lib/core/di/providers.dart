import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/api_client.dart';
import '../network/api_host.dart';
import '../network/auth_interceptor.dart';
import '../storage/token_storage.dart';

/// App-wide infrastructure. Feature providers build on these; nothing here
/// knows about a feature, so `core/` never imports `features/`.

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

/// What to do when the API rejects a stored token. Defaults to nothing so
/// `core/` stays independent of the auth feature; `app/bootstrap.dart`
/// overrides it with the real sign-out (see `authWiringOverrides`).
final unauthorizedHandlerProvider = Provider<UnauthorizedCallback>(
  (ref) => () async {},
);

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final onUnauthorized = ref.watch(unauthorizedHandlerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiHost.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      // Non-2xx should surface as a DioException so the repository can map it.
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      readToken: tokenStorage.read,
      onUnauthorized: onUnauthorized,
    ),
  );

  if (kDebugMode) {
    // Method, path and status only: bodies carry passwords and headers carry
    // the bearer token, neither of which belongs in a log.
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);
