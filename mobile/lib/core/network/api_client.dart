import 'package:dio/dio.dart';

/// The only thing in the app that talks to dio.
///
/// Remote data sources call these helpers and decode the returned JSON into
/// models; they never touch [Dio] directly, so swapping the HTTP client is a
/// one-file change. Errors are left as [DioException] on purpose — the
/// repository converts them with `mapExceptionToFailure`.
class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<dynamic>(path, queryParameters: query);
    return response.data;
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final response = await _dio.post<dynamic>(path, data: body);
    return response.data;
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final response = await _dio.put<dynamic>(path, data: body);
    return response.data;
  }

  Future<dynamic> delete(String path, {Object? body}) async {
    final response = await _dio.delete<dynamic>(path, data: body);
    return response.data;
  }
}
