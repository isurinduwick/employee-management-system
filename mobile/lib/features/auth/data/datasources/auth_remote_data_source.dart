import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/session_model.dart';

/// The auth endpoints on the API.
abstract interface class AuthRemoteDataSource {
  /// Throws [DioException] on any non-2xx response; the repository maps it.
  Future<SessionModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<SessionModel> login(LoginRequestModel request) async {
    final json = await _client.post('/auth/login', body: request.toJson());
    if (json is! Map<String, dynamic>) {
      throw const ParseException('The login response was not a JSON object.');
    }
    return SessionModel.fromJson(json);
  }
}
