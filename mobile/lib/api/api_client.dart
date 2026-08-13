import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

// Thin fetch wrapper: attaches the bearer token to every request and turns
// non-2xx responses into an ApiException with a readable message, mirroring
// what the axios interceptors + extractErrorMessage() do on the web client.
class ApiClient {
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final session = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (session != null) 'Authorization': 'Bearer ${session.token}',
    };
  }

  Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$apiBaseUrl$path'), headers: await _headers());
    return _decode(res);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _decode(res);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$apiBaseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode == 401) {
      throw ApiException(401, 'Invalid email or password.');
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractMessage(res));
  }

  String _extractMessage(http.Response res) {
    if (res.body.isEmpty) return 'Something went wrong. Please try again.';
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['title'] is String) return decoded['title'] as String;
        if (decoded['message'] is String) return decoded['message'] as String;
      }
      if (decoded is String) return decoded;
    } catch (_) {
      return res.body;
    }
    return 'Something went wrong. Please try again.';
  }
}
