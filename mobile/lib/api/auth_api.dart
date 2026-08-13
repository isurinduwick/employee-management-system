import '../models/auth.dart';
import 'api_client.dart';

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<LoginResponse> login(String email, String password) async {
    final json = await _client.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return LoginResponse.fromJson(json as Map<String, dynamic>);
  }
}
